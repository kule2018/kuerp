import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TableService } from '../kuerp/table/table.service';
import { Tool } from './tool.decorator';

/**
 * 业务 AI 工具集：把进销存核心经营数据包装成 Agent 可调用的 Function Calling 工具。
 *
 * 设计原则：
 * 1. 全部复用 TableService（虚拟报表引擎），不重复写脆弱的原始 SQL，与前端报表口径 1:1；
 * 2. 每个工具都做 try/catch，失败时返回结构化错误信息（Agent 会据此自我纠正，不会整体崩溃）；
 * 3. 返回做“摘要化”（count + 限量样例），避免把整张表塞进模型上下文，省 token 也更准。
 *
 * 注册方式：在 ai.module.ts 的 providers 加 BizAiTools，并在 tool-bootstrap.ts 注入本类，
 * 即可被 Agent（/ai/agent）自动发现并调用。
 */
@Injectable()
export class BizAiTools {
  constructor(private readonly table: TableService, private readonly ds: DataSource) {}

  /** 内部：调用通用表接口取报表/列表，返回 { count, list(限量) } */
  private async report(table: string, q: Record<string, any>) {
    const limit = Math.min(Number(q.limit) || 20, 50);
    const r: any = await this.table.index(table, { page: 1, limit, ...q });
    return { count: r?.count ?? 0, list: (r?.list || []).slice(0, limit) };
  }

  @Tool({
    name: 'query_business_overview',
    description:
      '经营概览：一次性返回销售、采购、利润、低库存、往来欠款的汇总与 Top 项。适合回答“经营情况怎么样 / 给我一份经营概览 / 本月有没有异常”。',
    parameters: {
      type: 'object',
      properties: {
        starttime: { type: 'number', description: '起始时间戳(秒)，不传则不限时间' },
        endtime: { type: 'number', description: '截止时间戳(秒)' },
        limit: { type: 'number', description: '每类返回条数，默认 5' },
      },
      required: [],
    },
  })
  async overview(a: { starttime?: number; endtime?: number; limit?: number }) {
    try {
      const lim = a.limit || 5;
      const base = { starttime: a.starttime, endtime: a.endtime, limit: lim };
      const [sales, purchase, profit, warn, intercourse] = await Promise.all([
        this.report('goods-sales-summary', base),
        this.report('goods-purchase-summary', base),
        this.report('profit', base),
        this.report('goods-stock-warning', { limit: lim }),
        this.report('intercourse', { limit: lim }),
      ]);
      return { sales, purchase, profit, stock_warning: warn, intercourse };
    } catch (e: any) {
      return { error: '经营概览查询失败: ' + (e?.message || e) };
    }
  }

  @Tool({
    name: 'query_sales_ranking',
    description: '按销量或销售额排名的商品榜单（畅销/滞销分析）。适合回答“哪些商品卖得最好 / 滞销有哪些”。',
    parameters: {
      type: 'object',
      properties: {
        starttime: { type: 'number', description: '起始时间戳(秒)' },
        endtime: { type: 'number', description: '截止时间戳(秒)' },
        limit: { type: 'number', description: '返回条数，默认 10' },
      },
      required: [],
    },
  })
  async salesRanking(a: { starttime?: number; endtime?: number; limit?: number }) {
    try {
      return await this.report('goods-sales-ranking', {
        starttime: a.starttime,
        endtime: a.endtime,
        limit: a.limit || 10,
      });
    } catch (e: any) {
      return { error: '销售排行查询失败: ' + (e?.message || e) };
    }
  }

  @Tool({
    name: 'query_stock_warning',
    description: '库存预警：低于安全库存或库存为 0 的商品清单。适合回答“哪些商品库存告急 / 有没有缺货风险”。',
    parameters: {
      type: 'object',
      properties: { limit: { type: 'number', description: '返回条数，默认 20' } },
      required: [],
    },
  })
  async stockWarning(a: { limit?: number }) {
    try {
      return await this.report('goods-stock-warning', { limit: a.limit || 20 });
    } catch (e: any) {
      return { error: '库存预警查询失败: ' + (e?.message || e) };
    }
  }

  @Tool({
    name: 'query_intercourse',
    description: '往来单位欠款：客户应收款、供应商应付款明细。适合回答“谁还欠我们钱 / 我们欠供应商多少 / 催收提醒”。',
    parameters: {
      type: 'object',
      properties: { limit: { type: 'number', description: '返回条数，默认 20' } },
      required: [],
    },
  })
  async intercourse(a: { limit?: number }) {
    try {
      return await this.report('intercourse', { limit: a.limit || 20 });
    } catch (e: any) {
      return { error: '往来欠款查询失败: ' + (e?.message || e) };
    }
  }

  @Tool({
    name: 'query_profit',
    description: '按期间查询利润表（销售收入 / 成本 / 毛利 / 净利）。适合回答“这个月赚了多少 / 利润率怎么样”。',
    parameters: {
      type: 'object',
      properties: {
        starttime: { type: 'number', description: '起始时间戳(秒)' },
        endtime: { type: 'number', description: '截止时间戳(秒)' },
      },
      required: ['starttime', 'endtime'],
    },
  })
  async profit(a: { starttime: number; endtime: number }) {
    try {
      return await this.report('profit', { starttime: a.starttime, endtime: a.endtime, limit: 50 });
    } catch (e: any) {
      return { error: '利润查询失败: ' + (e?.message || e) };
    }
  }

  @Tool({
    name: 'query_sales_summary',
    description: '按期间查询销售汇总（销售额、成本、毛利、销量）。适合回答“这个月卖了多少”。',
    parameters: {
      type: 'object',
      properties: {
        starttime: { type: 'number', description: '起始时间戳(秒)' },
        endtime: { type: 'number', description: '截止时间戳(秒)' },
        limit: { type: 'number', description: '返回条数，默认 20' },
      },
      required: ['starttime', 'endtime'],
    },
  })
  async salesSummary(a: { starttime: number; endtime: number; limit?: number }) {
    try {
      return await this.report('goods-sales-summary', {
        starttime: a.starttime,
        endtime: a.endtime,
        limit: a.limit || 20,
      });
    } catch (e: any) {
      return { error: '销售汇总查询失败: ' + (e?.message || e) };
    }
  }

  @Tool({
    name: 'query_purchase_summary',
    description: '按期间查询采购汇总（采购额、成本、采购量）。适合回答“这个月进了多少货”。',
    parameters: {
      type: 'object',
      properties: {
        starttime: { type: 'number', description: '起始时间戳(秒)' },
        endtime: { type: 'number', description: '截止时间戳(秒)' },
        limit: { type: 'number', description: '返回条数，默认 20' },
      },
      required: ['starttime', 'endtime'],
    },
  })
  async purchaseSummary(a: { starttime: number; endtime: number; limit?: number }) {
    try {
      return await this.report('goods-purchase-summary', {
        starttime: a.starttime,
        endtime: a.endtime,
        limit: a.limit || 20,
      });
    } catch (e: any) {
      return { error: '采购汇总查询失败: ' + (e?.message || e) };
    }
  }

  /**
   * 私有：取某商品的默认采购单价与推荐供应商。
   * 推荐供应商口径 = 该商品“最近一次采购单”的供应商（kuerp_goods_purchase_order + _info 关联）。
   * 无采购记录则供应商为空。
   */
  private async supplierInfoForGoods(goodsCode: string) {
    try {
      const goods: any[] = await this.ds.query(
        `SELECT goods_name, purchase_price FROM kuerp_goods WHERE goods_code = ? LIMIT 1`,
        [goodsCode],
      );
      const g = goods[0] || {};
      let supplier: { code: string; name: string } | null = null;
      try {
        const sp: any[] = await this.ds.query(
          `SELECT po.supplyer_code
             FROM kuerp_goods_purchase_order po
             JOIN kuerp_goods_purchase_order_info pi ON pi.purchase_code = po.purchase_code
            WHERE pi.goods_code = ? AND po.supplyer_code IS NOT NULL AND po.supplyer_code <> ''
            ORDER BY po.purchase_time DESC LIMIT 1`,
          [goodsCode],
        );
        if (sp[0]?.supplyer_code) {
          const name: any[] = await this.ds.query(
            `SELECT supplyer_name FROM kuerp_suppliers WHERE supplyer_code = ? LIMIT 1`,
            [sp[0].supplyer_code],
          );
          supplier = { code: sp[0].supplyer_code, name: name[0]?.supplyer_name || sp[0].supplyer_code };
        }
      } catch {
        /* 无采购记录时忽略供应商 */
      }
      return {
        goods_name: g.goods_name || '',
        purchase_price: Number(g.purchase_price) || 0,
        supplier,
      };
    } catch {
      return { goods_name: '', purchase_price: 0, supplier: null };
    }
  }

  @Tool({
    name: 'query_supplier_by_goods',
    description:
      '根据商品编号查询其默认采购单价与推荐供应商（取最近一次采购单的供应商）。适合回答“这个商品一般从哪家进、进价多少”。',
    parameters: {
      type: 'object',
      properties: { goods_code: { type: 'string', description: '商品编号' } },
      required: ['goods_code'],
    },
  })
  async querySupplierByGoods(a: { goods_code: string }) {
    const info = await this.supplierInfoForGoods(a.goods_code);
    return info.supplier
      ? {
          goods_code: a.goods_code,
          goods_name: info.goods_name,
          unit_price: info.purchase_price,
          recommended_supplier_code: info.supplier.code,
          recommended_supplier_name: info.supplier.name,
        }
      : {
          goods_code: a.goods_code,
          goods_name: info.goods_name,
          unit_price: info.purchase_price,
          recommended_supplier: null,
        };
  }

  /**
   * 供 replenish-advice 批量使用：给补货清单每项附上默认采购单价与推荐供应商。
   * @param items 看板行 [{ goods_code, goods_name, sale_number, stock, suggest_number }]
   * @returns 同结构并附加 unit_price / recommended_supplier_code / recommended_supplier_name
   */
  async enrichReplenish(items: any[]) {
    const out: any[] = [];
    for (const it of items) {
      const info = await this.supplierInfoForGoods(it.goods_code);
      out.push({
        ...it,
        unit_price: info.purchase_price,
        recommended_supplier_code: info.supplier?.code || null,
        recommended_supplier_name: info.supplier?.name || null,
      });
    }
    return out;
  }
}
