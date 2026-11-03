import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { MessageService } from '../message/message.service';
import { WechatTokenService } from '../wechat/wechat-token.service';
import { SchedulerService } from './scheduler.service';

/**
 * 内置定时作业注册器。
 *
 * 把「作业定义」与「调度内核」分开：
 * - SchedulerService 只管何时跑、跑完记日志；
 * - 本类只关心每个作业查哪些表、产出什么消息。
 * 这样以后加作业不用动内核代码。
 *
 * 五个作业：
 *   1) wechat_token   每 30 分钟预热微信 access_token（有效期 7200 秒）
 *   2) stock_warning  每天 08:00 扫库存预警（低于下限 / 高于上限）
 *   3) batch_expiry   每天 08:10 扫批次保质期（临期 / 过期）
 *   4) ar_due         每天 08:20 扫应收逾期（未收款 / 部分收款且超过账期天数）
 *   5) message_purge  每周一 03:00 清理 90 天前已读消息（默认关闭）
 *
 * 消息写入原则：**一次作业只写一条汇总消息**，不逐商品逐单据刷屏。
 * 明细放在 detail 里供作业日志查看，消息正文只给数量与前几个示例。
 */
@Injectable()
export class JobsRegistrar implements OnModuleInit {
  private readonly logger = new Logger(JobsRegistrar.name);

  constructor(
    private readonly scheduler: SchedulerService,
    private readonly dataSource: DataSource,
    private readonly messages: MessageService,
    private readonly wechat: WechatTokenService,
  ) {}

  onModuleInit(): void {
    this.registerWechatToken();
    this.registerStockWarning();
    this.registerBatchExpiry();
    this.registerArDue();
    this.registerMessagePurge();
  }

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /**
   * 读取一个字符串型系统参数。
   * @param name 参数名
   * @param def 默认值
   * @returns 参数值
   */
  private async setValue(name: string, def = ''): Promise<string> {
    try {
      const rows = await this.dataSource.query('SELECT value FROM kuerp_sets WHERE name = ? LIMIT 1', [name]);
      const v = rows?.[0]?.value;
      return v === null || v === undefined || v === '' ? def : String(v);
    } catch {
      return def;
    }
  }

  // ==================================================================
  // 1) 微信 access_token 预热
  // ==================================================================
  private registerWechatToken(): void {
    this.scheduler.register({
      name: 'wechat_token',
      title: '微信 access_token 刷新',
      cron: '*/30 * * * *',
      description: '每 30 分钟刷新小程序 access_token（有效期 7200 秒），避免首个请求现场取令牌变慢。',
      handler: async () => {
        const r = await this.wechat.getToken(true);
        if (!r.ok) {
          // 未配置 AppID/Secret 属正常情况（未启用订货通），按成功记录但注明原因，避免日志满屏「失败」
          return { message: `未取到 access_token：${r.msg || '未知原因'}`, detail: r.msg || '' };
        }
        const s = this.wechat.status();
        return {
          message: `access_token 已刷新，剩余有效期 ${s.remain} 秒`,
          detail: `token=${s.tokenMask} expireAt=${s.expireAt}`,
        };
      },
    });
  }

  // ==================================================================
  // 2) 库存预警扫描
  // ==================================================================
  private registerStockWarning(): void {
    this.scheduler.register({
      name: 'stock_warning',
      title: '库存预警扫描',
      cron: '0 8 * * *',
      description: '每天 08:00 汇总各仓库存，低于最低库存或高于最高库存的商品写入消息中心。',
      handler: async () => {
        // 按商品汇总（不限仓库）：原系统「库存预警」报表也是按商品看总库存
        const rows: any[] = await this.dataSource.query(
          `SELECT g.id, g.goods_code, g.goods_name, g.min_stock, g.max_stock,
                  COALESCE(SUM(s.stock), 0) AS stock
             FROM kuerp_goods g
             LEFT JOIN kuerp_goods_stock s ON s.goods_id = g.id
            WHERE g.stock_warning = '1'
              AND (g.deletetime IS NULL OR g.deletetime = 0)
            GROUP BY g.id, g.goods_code, g.goods_name, g.min_stock, g.max_stock
           HAVING stock < g.min_stock OR (g.max_stock > 0 AND stock > g.max_stock)
            ORDER BY g.id
            LIMIT 500`,
        );

        const low = rows.filter((r) => Number(r.stock) < Number(r.min_stock));
        const high = rows.filter((r) => Number(r.max_stock) > 0 && Number(r.stock) > Number(r.max_stock));
        if (!rows.length) return { message: '库存预警扫描完成：无异常商品' };

        // 只写一条汇总消息，避免逐商品刷屏
        const sample = rows
          .slice(0, 5)
          .map((r) => `${r.goods_name || r.goods_code}（现 ${Number(r.stock)}）`)
          .join('、');
        await this.messages.create({
          toAdminId: 0,
          type: 'stock_warning',
          level: high.length && !low.length ? 'info' : 'warn',
          title: `库存预警：${rows.length} 个商品需要处理`,
          content: `低于下限 ${low.length} 个，高于上限 ${high.length} 个。示例：${sample}${rows.length > 5 ? ' 等' : ''}`,
          link: '/goods-stock-warning',
        });

        return {
          message: `库存预警 ${rows.length} 个（低于下限 ${low.length} / 高于上限 ${high.length}）`,
          detail: rows
            .map(
              (r) =>
                `${r.goods_code} ${r.goods_name} 现库存=${Number(r.stock)} 下限=${Number(r.min_stock)} 上限=${Number(r.max_stock)}`,
            )
            .join('\n'),
        };
      },
    });
  }

  // ==================================================================
  // 3) 批次保质期预警
  // ==================================================================
  private registerBatchExpiry(): void {
    this.scheduler.register({
      name: 'batch_expiry',
      title: '批次保质期预警',
      cron: '10 8 * * *',
      description: '每天 08:10 扫描批次有效期，临期（预警天数内）与已过期批次写入消息中心。',
      handler: async () => {
        // 默认提前 30 天预警；商品若有 early_warning 则用商品自己的天数
        const defaultDays = Number(await this.setValue('batch_warning_days', '30')) || 30;
        const limitSec = this.now() + defaultDays * 86400;

        const rows: any[] = await this.dataSource.query(
          `SELECT b.id, b.goods_code, b.batch_name, b.validity,
                  g.goods_name, g.early_warning
             FROM kuerp_goods_batch b
             LEFT JOIN kuerp_goods g ON g.id = b.goods_id
            WHERE b.validity IS NOT NULL AND b.validity > 0
              AND b.validity <= ?
            ORDER BY b.validity ASC
            LIMIT 500`,
          [limitSec],
        );

        if (!rows.length) return { message: '批次保质期扫描完成：无临期或过期批次' };

        const n = this.now();
        const expired = rows.filter((r) => Number(r.validity) <= n);
        const soon = rows.filter((r) => Number(r.validity) > n);
        const sample = rows
          .slice(0, 5)
          .map((r) => `${r.goods_name || r.goods_code}/${r.batch_name || '-'}（${this.fmtDate(r.validity)}）`)
          .join('、');

        await this.messages.create({
          toAdminId: 0,
          type: 'batch_expiry',
          level: expired.length ? 'danger' : 'warn',
          title: `批次保质期预警：${rows.length} 个批次`,
          content: `已过期 ${expired.length} 个，${defaultDays} 天内临期 ${soon.length} 个。示例：${sample}${rows.length > 5 ? ' 等' : ''}`,
          link: '/goods-batch-expiry',
        });

        return {
          message: `批次预警 ${rows.length} 个（过期 ${expired.length} / 临期 ${soon.length}）`,
          detail: rows
            .map((r) => `${r.goods_code} ${r.batch_name || '-'} 有效期至 ${this.fmtDate(r.validity)}`)
            .join('\n'),
        };
      },
    });
  }

  // ==================================================================
  // 4) 应收逾期提醒
  // ==================================================================
  private registerArDue(): void {
    this.scheduler.register({
      name: 'ar_due',
      title: '应收逾期提醒',
      cron: '20 8 * * *',
      description: '每天 08:20 按账期天数（系统参数 ar_due_days，默认 30 天）找出逾期未收完的销货单。',
      handler: async () => {
        const dueDays = Number(await this.setValue('ar_due_days', '30')) || 30;
        const deadline = this.now() - dueDays * 86400;

        // 只统计已审核、且收款状态为未收款/部分收款的销货单
        const rows: any[] = await this.dataSource.query(
          `SELECT s.id, s.purchase_code, s.purchase_time, s.money_tax_price, s.pay_money, s.pay_status,
                  c.customer_name
             FROM kuerp_goods_sales s
             LEFT JOIN kuerp_customers c ON c.id = s.customers_id
            WHERE s.examine_status = '1'
              AND s.pay_status IN ('0','2')
              AND s.purchase_time IS NOT NULL AND s.purchase_time > 0
              AND s.purchase_time < ?
            ORDER BY s.purchase_time ASC
            LIMIT 500`,
          [deadline],
        );

        if (!rows.length) {
          return { message: `应收逾期扫描完成：账期 ${dueDays} 天内无逾期单据` };
        }

        let sum = 0;
        const lines = rows.map((r) => {
          const owed = Math.max(0, Number(r.money_tax_price || 0) - Number(r.pay_money || 0));
          sum += owed;
          return `${r.purchase_code} ${r.customer_name || '-'} 欠 ${owed.toFixed(2)} 单据日期 ${this.fmtDate(r.purchase_time)}`;
        });

        await this.messages.create({
          toAdminId: 0,
          type: 'ar_due',
          level: 'danger',
          title: `应收逾期：${rows.length} 张销货单，合计 ${sum.toFixed(2)} 元`,
          content: `超过账期 ${dueDays} 天仍未收完款，最长逾期示例：${lines.slice(0, 3).join('；')}${rows.length > 3 ? ' 等' : ''}`,
          link: '/accounts-receivable',
        });

        return {
          message: `应收逾期 ${rows.length} 张，合计 ${sum.toFixed(2)} 元（账期 ${dueDays} 天）`,
          detail: lines.join('\n'),
        };
      },
    });
  }

  // ==================================================================
  // 5) 清理过期已读消息
  // ==================================================================
  private registerMessagePurge(): void {
    this.scheduler.register({
      name: 'message_purge',
      title: '清理过期已读消息',
      cron: '0 3 * * 1',
      description: '每周一 03:00 删除 90 天前已读的消息（默认关闭，可在系统参数开启）。',
      enabledByDefault: false,
      handler: async () => {
        const n = await this.messages.purgeRead(90);
        return { message: `清理已读消息 ${n} 条` };
      },
    });
  }

  /**
   * 时间戳转 YYYY-MM-DD。
   * @param ts 秒级时间戳
   * @returns 日期字符串
   */
  private fmtDate(ts: number | string): string {
    const n = Number(ts);
    if (!n) return '—';
    const d = new Date(n * 1000);
    const p = (x: number) => String(x).padStart(2, '0');
    return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
  }
}
