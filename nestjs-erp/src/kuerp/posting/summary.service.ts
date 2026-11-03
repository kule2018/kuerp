import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { nowSec } from '../../common/bigint.transformer';

/**
 * 单据明细 -> 业务汇总表 同步服务。
 *
 * 背景（原系统行为核对）：
 * 原 FastAdmin/Kuerp 中「采购汇总表（商品/供应商）」「销售汇总表（按商品/客户/销售员）」
 * 「销售利润表」「利润表」等页面 **不是** 基于明细表实时 GROUP BY，而是读取
 * `kuerp_goods_purchase_summary` / `kuerp_goods_sales_summary` / `kuerp_goods_sales_profit`
 * 三张**物理汇总表**（见 GoodsPurchase.php:1561、GoodsSales.php:1793、GoodsExchange.php:1758
 * 在审核时 insertAll；反审时按 purchase_code 删除）。
 * 若审核不写这三张表，上述报表将永远为空——本服务即补齐该链路。
 *
 * 汇总表字段与明细表字段同名（汇总表是明细表的镜像，仅去掉 id / 退货专属字段），
 * 因此本服务采用「列交集复制」策略动态对齐，避免硬编码字段漂移。
 */
@Injectable()
export class SummaryService {
  constructor(private readonly dataSource: DataSource) {}

  /** 安全数值化 */
  private n(v: any): number {
    const x = Number(v);
    return isNaN(x) ? 0 : x;
  }

  /**
   * 单据 -> 汇总表映射配置。
   *   info    明细表（数据来源）
   *   summary 汇总表（写入目标）
   *   type    写入汇总表的 purchase_type：1=正向单据，2=退货单据
   *   ret     是否退货单（退货数量/金额取负，数量取 retreat_number）
   *   profit  是否同时写销售利润表（仅销货/销货退货）
   */
  private readonly MAP: Record<
    string,
    { info: string; summary: string; type: 1 | 2; ret: boolean; profit: boolean }
  > = {
    goods_purchase: {
      info: 'kuerp_goods_purchase_info',
      summary: 'kuerp_goods_purchase_summary',
      type: 1, ret: false, profit: false,
    },
    goods_exchange: {
      info: 'kuerp_goods_exchange_info',
      summary: 'kuerp_goods_purchase_summary',
      type: 2, ret: true, profit: false,
    },
    goods_sales: {
      info: 'kuerp_goods_sales_info',
      summary: 'kuerp_goods_sales_summary',
      type: 1, ret: false, profit: true,
    },
    goods_sales_exchange: {
      info: 'kuerp_goods_sales_exchange_info',
      summary: 'kuerp_goods_sales_summary',
      type: 2, ret: true, profit: true,
    },
  };

  /** 物理表名 -> 配置键（剥离 kuerp_ 前缀） */
  private docKey(table: string): string {
    return table.replace(/^kuerp_/, '');
  }

  /**
   * 读取目标表的真实列名集合（用于明细行 -> 汇总行的列交集过滤）。
   * @param table 物理表名
   * @returns 列名数组
   */
  private async columnsOf(table: string): Promise<string[]> {
    const rows: any[] = await this.dataSource.query(
      `SELECT COLUMN_NAME AS name FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?`,
      [table],
    );
    return rows.map((r) => r.name);
  }

  /**
   * 审核过账后同步汇总数据（购货/购货退货 -> 采购汇总表；销货/销货退货 -> 销售汇总表 + 销售利润表）。
   * @param table 物理单据表名（带 kuerp_ 前缀）
   * @param head  单据表头行（含 purchase_code / customers_id / sale_user 等）
   * @param adminId 当前审核人ID
   * @returns 写入的汇总行数（含利润表行）
   */
  async syncOnPost(table: string, head: any, adminId?: number): Promise<number> {
    const def = this.MAP[this.docKey(table)];
    if (!def) return 0;

    // 1. 取明细行（退货单明细表的 purchase_code 即退货单号）
    const code = head.purchase_code;
    if (!code) return 0;
    const rows: any[] = await this.dataSource.query(
      `SELECT * FROM \`${def.info}\` WHERE purchase_code = ?`,
      [code],
    );
    if (!rows.length) return 0;

    // 2. 汇总表列集合（列交集过滤，天然剔除 retreat_* / purchase_id 等明细专属列）
    const cols = new Set(await this.columnsOf(def.summary));
    const now = nowSec();
    const payload: any[] = [];
    // 退货单需要取负的金额/数量字段（与原系统 GoodsExchange.php:1745 一致）
    const negFields = ['number', 'basic_nmber', 'all_money', 'tax_money', 'money_tax_price', 'real_money', 'pay_money'];

    for (const r of rows) {
      const row: any = {};
      for (const k of Object.keys(r)) {
        if (k === 'id' || !cols.has(k)) continue;
        row[k] = r[k];
      }
      // 退货单：数量取 retreat_number（已退数量），并整体取负冲减原单汇总
      if (def.ret) {
        row.number = -this.n(r.retreat_number ?? r.number);
        for (const f of negFields) {
          if (f === 'number') continue;
          row[f] = -this.n(r[f]);
        }
      }
      row.purchase_type = def.type;
      row.createtime = now;
      row.updatetime = now;
      payload.push(row);
    }

    let written = 0;
    for (const row of payload) {
      const keys = Object.keys(row);
      await this.dataSource.query(
        `INSERT INTO \`${def.summary}\` (${keys.map((k) => `\`${k}\``).join(', ')})
         VALUES (${keys.map(() => '?').join(', ')})`,
        keys.map((k) => row[k]),
      );
      written++;
    }

    // 3. 销货类单据同步写销售利润表（销售利润表 / 利润表 的数据源）
    if (def.profit) {
      await this.writeSalesProfit(def, head, rows, adminId);
      written++;
    }
    return written;
  }

  /**
   * 写入（或重算）销售利润表行 kuerp_goods_sales_profit。
   * 字段口径对齐原系统 GoodsSales.php:1657 / GoodsSalesExchange.php:1731：
   *   amount=折扣额合计、need_money=应收金额、sales_cost 取自本单收发明细的实际出库成本。
   * @param def 单据映射配置
   * @param head 单据表头
   * @param rows 明细行
   * @param adminId 审核人
   */
  private async writeSalesProfit(
    def: { info: string; type: 1 | 2; ret: boolean },
    head: any,
    rows: any[],
    adminId?: number,
  ): Promise<void> {
    const code = head.purchase_code;
    const sign = def.ret ? -1 : 1;

    // 折扣额合计（原系统：sum(dis_money)，>0 才记）
    const disSum = rows.reduce((s, r) => s + this.n(r.dis_money), 0);
    const amount = disSum > 0 ? disSum : null;

    // 数量：销货=Σnumber；退货=Σretreat_number
    const number = def.ret
      ? rows.reduce((s, r) => s + this.n(r.retreat_number), 0)
      : rows.reduce((s, r) => s + this.n(r.number), 0);

    // 销售成本 = 本单收发明细的实际出库成本（goods_log.out_cost 合计），
    // 过账已先于本服务执行，故此处能读到真实移动平均成本。
    const logRows: any[] = await this.dataSource.query(
      `SELECT IFNULL(SUM(out_cost),0) AS oc, IFNULL(SUM(enter_cost),0) AS ec
       FROM kuerp_goods_log WHERE purchase_code = ?`,
      [code],
    );
    const salesCost = this.n(logRows[0]?.oc) - this.n(logRows[0]?.ec);

    const allMoney = this.n(head.all_money);
    const taxMoney = this.n(head.tax_money);
    const moneyTaxPrice = this.n(head.money_tax_price);
    const preferentialMoney = this.n(head.preferential_money);
    const purchaseMoney = this.n(head.purchase_money);
    const realMoney = this.n(head.real_money);
    const customersMoney = this.n(head.customers_money);
    const payMoney = this.n(head.pay_money);

    await this.dataSource.query(
      `INSERT INTO kuerp_goods_sales_profit
        (purchase_type, purchase_code, purchase_time, customers_id, sale_user, preparation_id,
         examine_id, number, amount, all_money, tax_money, money_tax_price, sales_cost,
         preferential_money, purchase_money, real_money, customers_money, need_money, pay_money, remark)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        def.type, code, head.purchase_time, head.customers_id ?? null, head.sale_user ?? null,
        head.preparation_id ?? null, adminId ?? head.examine_id ?? null,
        sign * number, amount === null ? null : sign * amount,
        sign * allMoney, sign * taxMoney, sign * moneyTaxPrice, sign * salesCost,
        sign * preferentialMoney, sign * purchaseMoney, sign * realMoney,
        customersMoney, sign * realMoney + customersMoney, sign * payMoney,
        head.note ?? head.remark ?? '',
      ],
    );
  }

  /**
   * 反审冲转：删除该单据已写入的汇总行与利润行（按单据编号反向定位）。
   * @param table 物理单据表名
   * @param code 单据编号
   * @returns 删除的汇总表数量（0/1/2：是否含利润表）
   */
  async removeOnUnpost(table: string, code: string): Promise<{ cleared: string[] }> {
    const def = this.MAP[this.docKey(table)];
    const cleared: string[] = [];
    if (!def || !code) return { cleared };

    await this.dataSource.query(
      `DELETE FROM \`${def.summary}\` WHERE purchase_code = ? AND purchase_type = ?`,
      [code, def.type],
    );
    cleared.push(def.summary);

    if (def.profit) {
      await this.dataSource.query(
        `DELETE FROM kuerp_goods_sales_profit WHERE purchase_code = ? AND purchase_type = ?`,
        [code, def.type],
      );
      cleared.push('kuerp_goods_sales_profit');
    }
    return { cleared };
  }
}
