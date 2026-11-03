import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CronSpec, cronMatches, minuteKey, nextRunAt, parseCron } from './cron.util';

/** 作业执行结果 */
export interface JobResult {
  /** 一句话摘要（写入 kuerp_job_log.message） */
  message: string;
  /** 详细信息（可选，截断后落 detail） */
  detail?: string;
}

/** 作业定义 */
export interface JobDefinition {
  /** 唯一标识（与 kuerp_sets 的 job_<name> 开关对应） */
  name: string;
  /** 中文名 */
  title: string;
  /** 五段式 cron */
  cron: string;
  /** 说明 */
  description?: string;
  /** 是否默认启用（系统参数未配置时使用） */
  enabledByDefault?: boolean;
  /** 执行体 */
  handler: () => Promise<JobResult>;
}

/** 运行时作业状态 */
interface JobRuntime extends JobDefinition {
  /** 解析后的 cron */
  spec: CronSpec;
  /** 上次执行的分钟键（防同分钟重复触发） */
  lastMinute: string;
  /** 上次执行时间（秒级时间戳） */
  lastRunAt: number;
  /** 上次执行结果摘要 */
  lastMessage: string;
  /** 上次是否成功 */
  lastSuccess: boolean;
  /** 是否正在执行 */
  running: boolean;
}

/**
 * 轻量定时任务内核。
 *
 * 工作方式：每 20 秒轮询一次系统时间，命中 cron 的作业在本分钟内执行一次（按分钟去重）。
 * 为什么不用「按 cron 计算下一次精确 setTimeout」：
 * 系统时间可能被 NTP 校正、进程可能被挂起，轮询方式即使漂移也能在 20 秒内自动纠正；
 * 20 秒粒度对「每天定点 / 每 N 分钟」这类作业完全够用，且实现简单不引入依赖。
 *
 * 执行记录统一写入 kuerp_job_log，供管理页查看历史（成功/失败/耗时/摘要）。
 * 开关存放在 kuerp_sets 的 job_<name> 行（'0' 停用，其余启用），60 秒缓存。
 */
@Injectable()
export class SchedulerService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(SchedulerService.name);

  /** 已注册作业 */
  private readonly jobs = new Map<string, JobRuntime>();

  /** 轮询定时器 */
  private timer: NodeJS.Timeout | null = null;

  /** 开关缓存：name -> { enabled, at } */
  private readonly switchCache = new Map<string, { enabled: boolean; at: number }>();

  /** 首次扫描延迟（毫秒）：等各模块 onModuleInit 注册完作业后再开始 */
  private readonly bootDelay = 3000;

  /** 轮询间隔（毫秒） */
  private readonly interval = 20000;

  constructor(private readonly dataSource: DataSource) {}

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  onModuleInit(): void {
    setTimeout(() => {
      this.timer = setInterval(() => this.tick(), this.interval);
      // 启动后先跑一次扫描：进程若在作业时刻之外重启，不会因此漏掉当天作业的下一次命中，
      // 但若恰好在命中分钟内重启则能立刻补跑（lastMinute 为空）
      this.tick();
      this.logger.log(`定时任务内核已启动，已注册 ${this.jobs.size} 个作业，轮询间隔 ${this.interval / 1000}s`);
    }, this.bootDelay);
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
  }

  /**
   * 注册一个作业。
   * @param def 作业定义
   * @returns 无
   */
  register(def: JobDefinition): void {
    if (this.jobs.has(def.name)) {
      this.logger.warn(`作业 ${def.name} 重复注册，已忽略后者`);
      return;
    }
    let spec: CronSpec;
    try {
      spec = parseCron(def.cron);
    } catch (e: any) {
      this.logger.error(`作业 ${def.name} 的 cron 表达式非法：${e?.message || e}`);
      return;
    }
    this.jobs.set(def.name, {
      ...def,
      spec,
      lastMinute: '',
      lastRunAt: 0,
      lastMessage: '',
      lastSuccess: true,
      running: false,
    });
    this.logger.log(`注册作业 ${def.name}（${def.title}）：${def.cron}`);
  }

  /**
   * 读取作业开关。
   * @param name 作业标识
   * @param def 默认值
   * @returns 是否启用
   */
  private async isEnabled(name: string, def = true): Promise<boolean> {
    const hit = this.switchCache.get(name);
    if (hit && this.now() - hit.at < 60) return hit.enabled;

    let enabled = def;
    try {
      const rows = await this.dataSource.query('SELECT value, is_checked FROM kuerp_sets WHERE name = ? LIMIT 1', [
        `job_${name}`,
      ]);
      if (rows?.length) {
        const v = String(rows[0].value ?? '').trim();
        // 约定：'0' 停用；'1' 或空启用；is_checked=0 也视为停用（系统参数页取消勾选）
        enabled = v !== '0' && Number(rows[0].is_checked ?? 1) !== 0;
      }
    } catch {
      // 表不存在（尚未导入扩展 schema）时按默认值处理
    }
    this.switchCache.set(name, { enabled, at: this.now() });
    return enabled;
  }

  /** 轮询：命中即执行 */
  private async tick(): Promise<void> {
    const d = new Date();
    const key = minuteKey(d);
    for (const job of this.jobs.values()) {
      try {
        if (!cronMatches(job.spec, d)) continue;
        if (job.lastMinute === key) continue;
        if (job.running) continue;
        const enabled = await this.isEnabled(job.name, job.enabledByDefault !== false);
        if (!enabled) {
          // 记住本分钟已判定，避免同分钟内反复查开关
          job.lastMinute = key;
          continue;
        }
        job.lastMinute = key;
        // 不 await：避免一个慢作业挡住其它作业的判定
        void this.run(job.name, 'cron');
      } catch (e: any) {
        this.logger.warn(`作业 ${job.name} 调度异常：${e?.message || e}`);
      }
    }
  }

  /**
   * 执行指定作业（定时触发或手动触发）。
   * @param name 作业标识
   * @param trigger 触发方式：cron / manual
   * @returns 执行结果；作业不存在或正在执行时返回 null
   */
  async run(name: string, trigger: 'cron' | 'manual' = 'manual'): Promise<JobResult | null> {
    const job = this.jobs.get(name);
    if (!job) return null;
    if (job.running) {
      this.logger.warn(`作业 ${name} 正在执行中，本次跳过（${trigger}）`);
      return null;
    }

    job.running = true;
    const started = Date.now();
    let result: JobResult = { message: '未产出结果' };
    let success = true;
    try {
      result = await job.handler();
      success = true;
      this.logger.log(`作业 ${name} 执行完成：${result.message}（${Date.now() - started}ms）`);
    } catch (e: any) {
      success = false;
      result = { message: `执行失败：${e?.message || e}` };
      this.logger.error(`作业 ${name} 执行失败：${e?.stack || e}`);
    } finally {
      job.running = false;
      job.lastRunAt = this.now();
      job.lastMessage = result.message;
      job.lastSuccess = success;
      await this.writeLog(job, success, Date.now() - started, result, trigger);
    }
    return result;
  }

  /**
   * 写作业执行日志（失败不影响作业本身）。
   * @param job 作业
   * @param success 是否成功
   * @param costMs 耗时
   * @param result 结果
   * @param trigger 触发方式
   * @returns 无
   */
  private async writeLog(
    job: JobRuntime,
    success: boolean,
    costMs: number,
    result: JobResult,
    trigger: string,
  ): Promise<void> {
    try {
      await this.dataSource.query(
        `INSERT INTO kuerp_job_log (job_name, job_title, success, cost_ms, message, detail, createtime)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [
          job.name,
          job.title,
          success ? 1 : 0,
          Math.min(2147483647, costMs),
          `${trigger === 'manual' ? '[手动] ' : ''}${(result.message || '').slice(0, 480)}`,
          (result.detail || '').slice(0, 60000),
          this.now(),
        ],
      );
    } catch (e: any) {
      this.logger.warn(`写作业日志失败：${e?.message || e}`);
    }
  }

  /**
   * 作业清单（供管理页展示）。
   * @returns 作业状态数组
   */
  async list() {
    const out: any[] = [];
    for (const job of this.jobs.values()) {
      const enabled = await this.isEnabled(job.name, job.enabledByDefault !== false);
      const next = nextRunAt(job.spec);
      out.push({
        name: job.name,
        title: job.title,
        cron: job.cron,
        description: job.description || '',
        enabled,
        running: job.running,
        lastRunAt: job.lastRunAt,
        lastMessage: job.lastMessage,
        lastSuccess: job.lastSuccess,
        nextRunAt: next ? Math.floor(next.getTime() / 1000) : 0,
      });
    }
    return out;
  }

  /**
   * 作业执行历史。
   * @param q { name, page, limit }
   * @returns { list, count }
   */
  async logs(q: { name?: string; page?: number; limit?: number }) {
    const page = Math.max(1, Number(q.page) || 1);
    const limit = Math.min(200, Math.max(1, Number(q.limit) || 20));
    const where: string[] = ['1=1'];
    const params: any[] = [];
    if (q.name) {
      where.push('job_name = ?');
      params.push(q.name);
    }
    const rows = await this.dataSource.query(
      `SELECT id, job_name, job_title, success, cost_ms, message, createtime
         FROM kuerp_job_log
        WHERE ${where.join(' AND ')}
        ORDER BY id DESC
        LIMIT ? OFFSET ?`,
      [...params, limit, (page - 1) * limit],
    );
    const cnt = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM kuerp_job_log WHERE ${where.join(' AND ')}`,
      params,
    );
    return { list: rows || [], count: Number(cnt?.[0]?.c || 0) };
  }

  /**
   * 清空开关缓存（系统参数保存后调用，让开关立即生效）。
   * @returns 无
   */
  clearSwitchCache(): void {
    this.switchCache.clear();
  }
}
