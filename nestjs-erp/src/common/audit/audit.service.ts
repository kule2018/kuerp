import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';

/** 一条待落库的操作日志 */
export interface AuditEntry {
  /** 操作人ID */
  adminId: number;
  /** 操作人账号 */
  username: string;
  /** 业务模块（表名，如 goods；框架接口为 system/ai 等） */
  module: string;
  /** 动作：add/edit/del/examine/import/export/other */
  action: string;
  /** HTTP 方法 */
  method: string;
  /** 请求路径 */
  path: string;
  /** 受影响记录ID（尽力而为，取自 body.id） */
  rowId: string;
  /** 请求参数（已脱敏 + 截断） */
  params: string;
  /** 是否成功 */
  success: boolean;
  /** 结果消息 */
  msg: string;
  /** 客户端 IP */
  ip: string;
  /** User-Agent */
  ua: string;
  /** 耗时毫秒 */
  costMs: number;
}

/** 日志查询条件 */
export interface AuditQuery {
  page?: number;
  limit?: number;
  /** 关键字：账号 / 路径 / 消息 */
  search?: string;
  /** 模块过滤 */
  module?: string;
  /** 动作过滤 */
  action?: string;
  /** 仅看失败 */
  failed?: boolean;
  /** 起止时间（秒级时间戳） */
  starttime?: number;
  endtime?: number;
}

/**
 * 操作审计服务。
 *
 * 为什么直接用 DataSource 跑原生 SQL 而不建 Entity：
 * 1. 日志表只写不读（除查询页），不需要 ORM 的关联与钩子；
 * 2. 避免与 `synchronize` 混用时把日志表结构纳入自动同步范围；
 * 3. 写日志是热路径，原生 INSERT 比 EntityManager.save 开销小。
 */
@Injectable()
export class AuditService {
  private readonly logger = new Logger(AuditService.name);
  /** 表是否已就绪：缺表时静默跳过，避免老库升级窗口期每个请求都报错 */
  private ready = false;

  constructor(private readonly dataSource: DataSource) {
    this.checkReady();
  }

  /**
   * 探测审计表是否存在（异步，不阻塞启动）。
   * @returns Promise<void>
   */
  private async checkReady(): Promise<void> {
    try {
      await this.dataSource.query('SELECT 1 FROM kuerp_admin_log LIMIT 1');
      this.ready = true;
    } catch {
      this.ready = false;
      this.logger.warn('未检测到 kuerp_admin_log，操作日志暂不落库（请执行 db/extension-schema.sql）');
    }
  }

  /**
   * 写入一条操作日志。
   * 设计上「记日志失败绝不影响业务」：所有异常都被吞掉并降级为应用日志。
   * @param e 日志内容
   * @returns Promise<void>
   */
  async write(e: AuditEntry): Promise<void> {
    if (!this.ready) return;
    try {
      await this.dataSource.query(
        `INSERT INTO kuerp_admin_log
           (admin_id, username, module, action, method, path, row_id, params, success, msg, ip, ua, cost_ms, createtime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
        [
          e.adminId || 0,
          cut(e.username, 50),
          cut(e.module, 60),
          cut(e.action, 30),
          cut(e.method, 10),
          cut(e.path, 255),
          cut(e.rowId, 60),
          cut(e.params, 2000),
          e.success ? 1 : 0,
          cut(e.msg, 500),
          cut(e.ip, 60),
          cut(e.ua, 300),
          Math.max(0, Math.round(e.costMs || 0)),
          Math.floor(Date.now() / 1000),
        ],
      );
    } catch (err: any) {
      this.logger.warn(`操作日志写入失败：${err?.message || err}`);
    }
  }

  /**
   * 分页查询操作日志（供「操作日志」页面使用）。
   * @param q 查询条件
   * @returns { list, count }
   */
  async list(q: AuditQuery): Promise<{ list: any[]; count: number }> {
    const page = Math.max(1, Number(q.page) || 1);
    const limit = Math.min(200, Math.max(1, Number(q.limit) || 20));
    const where: string[] = ['1=1'];
    const params: any[] = [];

    if (q.module) {
      where.push('module = ?');
      params.push(q.module);
    }
    if (q.action) {
      where.push('action = ?');
      params.push(q.action);
    }
    if (q.failed) where.push('success = 0');
    if (q.starttime) {
      where.push('createtime >= ?');
      params.push(Number(q.starttime));
    }
    if (q.endtime) {
      where.push('createtime <= ?');
      params.push(Number(q.endtime));
    }
    if (q.search) {
      where.push('(username LIKE ? OR path LIKE ? OR msg LIKE ?)');
      const kw = `%${q.search}%`;
      params.push(kw, kw, kw);
    }

    const sqlWhere = where.join(' AND ');
    const list = await this.dataSource.query(
      `SELECT * FROM kuerp_admin_log WHERE ${sqlWhere} ORDER BY id DESC LIMIT ? OFFSET ?`,
      [...params, limit, (page - 1) * limit],
    );
    const cnt = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM kuerp_admin_log WHERE ${sqlWhere}`,
      params,
    );
    return { list, count: Number(cnt?.[0]?.c || 0) };
  }

  /**
   * 操作日志的模块/动作去重清单（供前端筛选下拉）。
   * @returns { modules: string[], actions: string[] }
   */
  async facets(): Promise<{ modules: string[]; actions: string[] }> {
    const mods = await this.dataSource.query(
      "SELECT DISTINCT module FROM kuerp_admin_log WHERE module <> '' ORDER BY module",
    );
    const acts = await this.dataSource.query(
      "SELECT DISTINCT action FROM kuerp_admin_log WHERE action <> '' ORDER BY action",
    );
    return {
      modules: (mods || []).map((r: any) => r.module),
      actions: (acts || []).map((r: any) => r.action),
    };
  }
}

/**
 * 按最大长度截断字符串（防超长参数撑爆 varchar）。
 * @param v 原值
 * @param max 最大长度
 * @returns 截断结果
 */
function cut(v: string, max: number): string {
  const s = String(v ?? '');
  return s.length > max ? `${s.slice(0, max - 1)}…` : s;
}
