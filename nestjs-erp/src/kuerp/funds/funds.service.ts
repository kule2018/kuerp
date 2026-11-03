import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { nowSec } from '../../common/bigint.transformer';
import { runInTx, txQuery } from '../../common/tx/tx-context';

/**
 * 账户流水待插入行（kuerp_accounts_log）。
 * income/expenditure 二者有且仅有一个非空，与原系统语义一致。
 */
interface AccountLogRow {
  accountId: number;      // 账户ID（用于聚合余额，不落库到 log 表）
  accountCoding: string;  // 账户编号
  accountName: string;    // 账户名称
  balance: number;        // 变动后余额（快照）
  income: number | null;  // 收入金额
  expenditure: number | null; // 支出金额
  payTime: number;        // 业务日期
  billCode: string;       // 关联单据编号
  businessType: number;   // 业务类型 1期初/2采购/3购货付款/4购货退货/5销货/6销货退货/7收款/8付款/9其他收入/10其他支出/11转入/12转出
  supplyerCode?: string;  // 供应商编号
  customersId?: number;   // 客户ID
  payment?: number;       // 收/付款人
  remark?: string;        // 备注
}

/**
 * 资金过账引擎：审核单据时联动资金域数据，反审时冲转恢复。
 *
 * 整体思路（对齐原酷柚易汛 Kuerp 各控制器 examine 逻辑，1:1 还原）：
 *   一、资金单据（审核即过账）：
 *     1. 收款单 collection：结算账户加钱 + 账户流水(bt=7) + 应收明细(bt=9) +
 *        销货收款一览表 + 客户应收余额扣减 + 源销货单收款状态 + 预收生成核销源单。
 *     2. 付款单 payment：结算账户扣钱 + 账户流水(bt=8) + 应付明细(bt=9) +
 *        采购付款一览表 + 供应商应付余额扣减 + 源购货单付款状态 + 预付生成核销源单。
 *     3. 核销单 writeoff：五种业务类型（预收冲应收/预付冲应付/应收冲应付/应收转应收/应付转应付），
 *        更新源单收付款状态并写入双向流水。
 *     4. 转账单 accounts_transfer：转出账户扣钱(bt=12)、转入账户加钱(bt=11)。
 *     5. 其他收入单 income：账户加钱(bt=9)，欠款部分生成应收明细(bt=8)，联动采购销售费用。
 *     6. 其他支出单 expenditure：账户扣钱(bt=10)，欠款部分生成应付明细(bt=8)，联动采购销售费用。
 *   二、库存类单据（过账库存的同时联动资金侧，由 examine 与 PostingService 协同触发）：
 *     1. 购货单：采购付款一览表(bt=1) + 采购开票表 + 应付明细(bt=6) + 核销源单(应付) +
 *        供应商应付款余额 + 即时付款账户扣减(bt=2) + 采购销售费用。
 *     2. 购货退货：流水(bt=2，金额取负) + 开票表(status+3) + 应付明细(bt=7) + 核销源单(应付退货)。
 *     3. 销货单：销货收款一览表(bt=1) + 销货开票表 + 应收明细(bt=6) + 核销源单(应收) +
 *        客户应收款余额 + 即时收款账户加钱(bt=5) + 采购销售费用 + 销售利润表。
 *     4. 销货退货：流水(bt=2，金额取负) + 开票表(status+3) + 应收明细(bt=7) + 核销源单(应收退货)。
 *   三、冲转（反审）：按单据号删除派生记录、按 old_money/old_status 恢复源单状态、
 *       按账户流水反向恢复余额、按公式恢复往来单位余额。
 *
 * 说明：各方法均为「单张单据」维度；批量审核由调用方循环触发。
 */
@Injectable()
export class FundsService {
  constructor(private readonly dataSource: DataSource) {}

  /** 日志（非阻断类信息，如汇总同步失败） */
  private readonly logger = new Logger(FundsService.name);

  /**
   * 执行一条 SQL：优先走当前异步上下文的事务连接（post/unpost 内），否则走连接池。
   *
   * 这样资金过账把上百处查询自动纳入同一事务，而无需改每个私有方法的签名。
   *
   * @param sql SQL 语句
   * @param params 参数化绑定值
   * @returns 查询结果
   */
  private async q(sql: string, params?: any[]): Promise<any[]> {
    const rows = await txQuery(sql, params);
    if (rows !== null) return rows;
    return await this.dataSource.query(sql, params);
  }

  /** 安全数值化：null/undefined/非数字统一归 0 */
  private n(v: any): number {
    const x = Number(v);
    return isNaN(x) ? 0 : x;
  }

  /** 四舍五入到 4 位小数（与原系统 round(...,4) 一致） */
  private r4(v: number): number {
    return Math.round(v * 10000) / 10000;
  }

  /**
   * 资金单据表配置：审核这些表时触发资金过账。
   * 键为不含 kuerp_ 前缀的裸表名。
   */
  private readonly FUND_DOCS = [
    'collection', // 收款单
    'payment', // 付款单
    'writeoff', // 核销单
    'accounts_transfer', // 资金转账单
    'income', // 其他收入单
    'expenditure', // 其他支出单
  ];

  /**
   * 库存类单据配置：这些表审核时除库存过账外，还需联动资金侧数据。
   * kind 决定资金联动的具体口径（购货/销货/购货退货/销货退货）。
   */
  private readonly STOCK_FUND_DOCS: Record<
    string,
    { kind: 'buy' | 'sell' | 'buyReturn' | 'sellReturn' }
  > = {
    goods_purchase: { kind: 'buy' },
    goods_exchange: { kind: 'buyReturn' },
    goods_sales: { kind: 'sell' },
    goods_sales_exchange: { kind: 'sellReturn' },
  };

  /**
   * 是否资金单据表（审核即过账资金）。
   * @param table 物理表名或裸表名
   */
  isFundTable(table: string): boolean {
    return this.FUND_DOCS.includes(this.docKey(table));
  }

  /**
   * 是否库存类单据的资金联动表。
   * @param table 物理表名或裸表名
   */
  isStockFundTable(table: string): boolean {
    return Object.prototype.hasOwnProperty.call(
      this.STOCK_FUND_DOCS,
      this.docKey(table),
    );
  }

  /**
   * 归一化表名：物理表名带 kuerp_ 前缀（kuerp_collection），配置键不带，统一剥离。
   * @param table 物理表名或裸表名
   */
  private docKey(table: string): string {
    return table.replace(/^kuerp_/, '');
  }

  /**
   * 审核过账入口：按表路由到对应资金逻辑。
   *
   * 整体包在一个事务里：收付款过账会同时改「单据已收/已付金额、账户余额、
   * 账户流水、应收应付」，任一步失败都会让账面金额错位，因此必须原子提交。
   *
   * @param table 单据物理表名
   * @param id 单据主键
   * @returns 过账的记录条数（0=该表无资金联动或已过账）
   */
  async post(table: string, id: number): Promise<{ posted: number }> {
    const key = this.docKey(table);
    const touched = this.FUND_DOCS.includes(key) || this.isStockFundTable(table);
    if (!touched) return { posted: 0 };
    return await runInTx(this.dataSource, () => this.postInner(table, id));
  }

  /**
   * 资金过账主体（须在事务内执行，见 post）。
   * @param table 单据物理表名
   * @param id 单据主键
   * @returns 过账的记录条数
   */
  private async postInner(table: string, id: number): Promise<{ posted: number }> {
    const key = this.docKey(table);
    if (this.FUND_DOCS.includes(key)) {
      switch (key) {
        case 'collection':
          return this.postCollection(id);
        case 'payment':
          return this.postPayment(id);
        case 'writeoff':
          return this.postWriteoff(id);
        case 'accounts_transfer':
          return this.postTransfer(id);
        case 'income':
          return this.postIncome(id);
        case 'expenditure':
          return this.postExpenditure(id);
      }
    }
    if (this.isStockFundTable(table)) {
      return this.postStockFunds(table, id);
    }
    return { posted: 0 };
  }

  /**
   * 反审冲转入口：按表路由到对应冲转逻辑。
   *
   * 同样包事务：冲转要先撤账户流水、再回退单据已收/已付金额与往来余额，
   * 中途失败会留下「账户余额已变但单据金额没回退」的错账。
   *
   * @param table 单据物理表名
   * @param id 单据主键
   * @returns 冲转的记录条数
   */
  async unpost(table: string, id: number): Promise<{ reversed: number }> {
    const key = this.docKey(table);
    const touched = this.FUND_DOCS.includes(key) || this.isStockFundTable(table);
    if (!touched) return { reversed: 0 };
    return await runInTx(this.dataSource, () => this.unpostInner(table, id));
  }

  /**
   * 资金冲转主体（须在事务内执行，见 unpost）。
   * @param table 单据物理表名
   * @param id 单据主键
   * @returns 冲转的记录条数
   */
  private async unpostInner(table: string, id: number): Promise<{ reversed: number }> {
    const key = this.docKey(table);
    if (this.FUND_DOCS.includes(key)) {
      switch (key) {
        case 'collection':
          return this.unpostCollection(id);
        case 'payment':
          return this.unpostPayment(id);
        case 'writeoff':
          return this.unpostWriteoff(id);
        case 'accounts_transfer':
          return this.unpostTransfer(id);
        case 'income':
          return this.unpostIncome(id);
        case 'expenditure':
          return this.unpostExpenditure(id);
      }
    }
    if (this.isStockFundTable(table)) {
      return this.unpostStockFunds(table, id);
    }
    return { reversed: 0 };
  }

  // =====================================================================
  // 通用辅助
  // =====================================================================

  /**
   * 批量应用账户余额增减（同一账户多笔自动聚合后一次更新，避免覆盖）。
   * @param deltas 账户ID -> 余额增减量（正=加钱，负=扣钱）
   */
  private async applyAccountDeltas(deltas: Map<number, number>) {
    for (const [accountId, delta] of deltas) {
      if (!accountId || delta === 0) continue;
      await this.q(
        `UPDATE kuerp_accounts SET balance = balance + ?, updatetime = ? WHERE id = ?`,
        [this.r4(delta), nowSec(), accountId],
      );
    }
  }

  /**
   * 批量插入账户流水（kuerp_accounts_log）。
   * @param logs 待插入的账户流水行
   */
  private async insertAccountLogs(logs: AccountLogRow[]) {
    for (const l of logs) {
      await this.q(
        `INSERT INTO kuerp_accounts_log
         (admin_id, account_coding, account_name, balance, income, expenditure, pay_time, bill_code,
          business_type, supplyer_code, customers_id, payment, remark, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
        [
          null,
          l.accountCoding,
          l.accountName,
          this.r4(l.balance),
          l.income === null ? null : this.r4(l.income),
          l.expenditure === null ? null : this.r4(l.expenditure),
          l.payTime,
          l.billCode,
          l.businessType,
          l.supplyerCode ?? null,
          l.customersId ?? null,
          l.payment ?? null,
          l.remark ?? null,
          nowSec(),
          nowSec(),
        ],
      );
    }
  }

  /**
   * 读取单行账户信息。
   * @param id 账户ID
   */
  private async getAccount(id: number): Promise<any> {
    const rows: any[] = await this.q(
      `SELECT * FROM kuerp_accounts WHERE id = ? LIMIT 1`,
      [id],
    );
    return rows[0] || null;
  }

  /**
   * 解析采购销售费用原始数据（cost_data）。
   * 原系统为 PHP serialize 串，重构版前端存 JSON 串或数组，此处统一解析为对象数组。
   * @param raw 表头 cost_data 字段值
   */
  private parseCostData(raw: any): any[] {
    if (!raw) return [];
    if (Array.isArray(raw)) return raw;
    if (typeof raw === 'string') {
      try {
        const v = JSON.parse(raw);
        return Array.isArray(v) ? v : [];
      } catch {
        return [];
      }
    }
    return [];
  }

  /**
   * 读取系统参数开关（kuerp_sets.is_checked）。
   * @param name 参数名（如 discount=整单折扣是否含税开票）
   */
  private async getSetChecked(name: string): Promise<number> {
    const rows: any[] = await this.q(
      `SELECT is_checked FROM kuerp_sets WHERE name = ? LIMIT 1`,
      [name],
    );
    return rows.length ? this.n(rows[0].is_checked) : 0;
  }

  // =====================================================================
  // 一、资金单据：收款单
  // =====================================================================

  /**
   * 收款单审核过账。
   * 流程：结算账户加钱 → 账户流水(bt=7) → 预收单生成核销源单 → 逐源单核销
   * （销货/销货退货 收款状态 + 销货收款一览表 + 开票状态）→ 应收明细(bt=9) →
   * 客户应收余额扣减。
   * @param id 收款单ID
   */
  private async postCollection(id: number): Promise<{ posted: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_collection WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { posted: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) === 1) return { posted: 0 }; // 已过账

    // 1. 结算账户明细：逐账户加钱并生成账户流水
    const accRows: any[] = await this.q(
      `SELECT * FROM kuerp_collection_account WHERE collection_id = ?`,
      [id],
    );
    const deltas = new Map<number, number>();
    const logs: AccountLogRow[] = [];
    for (const acc of accRows) {
      const account = await this.getAccount(this.n(acc.accounts_id));
      if (!account) {
        throw new BadRequestException(
          `收款单 ${doc.purchase_code} 的结算账户不存在`,
        );
      }
      const money = this.n(acc.money);
      deltas.set(account.id, (deltas.get(account.id) || 0) + money);
      logs.push({
        accountId: account.id,
        accountCoding: account.account_coding,
        accountName: account.account_name,
        balance: this.n(account.balance) + money,
        income: money,
        expenditure: null,
        payTime: this.n(doc.purchase_time),
        billCode: acc.purchase_code || doc.purchase_code,
        businessType: 7, // 收款单
        customersId: this.n(doc.customers_id) || null,
        payment: this.n(doc.staff_member_id) || null,
        remark: doc.remarks,
      });
    }

    // 2. 核销源单明细（本次收的钱对应冲抵的应收单据）
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_collection_sale WHERE collection_id = ?`,
      [id],
    );

    // 3. 预收单（无核销源单）生成预收核销源单，供后续核销单冲应收
    if (this.n(doc.business_type) === 1) {
      await this.q(
        `INSERT INTO kuerp_writeoff_source
         (admin_id, purchase_type, type, customers_id, purchase_code, purchase_time, price, money, write_off, remark)
         VALUES (?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          1, // 预收单
          1,
          this.n(doc.customers_id) || null,
          doc.purchase_code,
          this.n(doc.purchase_time),
          this.n(doc.advance),
          0,
          this.n(doc.advance),
          doc.remarks,
        ],
      );
    }

    // 4. 逐源单核销：更新源单收款状态、写收款流水、同步开票状态
    for (const info of infoRows) {
      if (this.n(info.business_type) !== 3) continue; // 3=应收源单
      const pay = this.n(info.write_off_price);
      if (this.n(info.type) === 1) {
        // 普通销货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_sales WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          const allMoney = this.n(o.real_money) + this.n(o.customers_money);
          const newPay = this.n(o.pay_money) + pay;
          if (allMoney < newPay) {
            throw new BadRequestException(
              `${info.purchase_number} 核销金额不能大于未核销金额`,
            );
          }
          const status = allMoney - newPay <= 0 ? 1 : 2;
          await this.q(
            `INSERT INTO kuerp_sales_payment_log
             (admin_id, customers_id, business_type, bill_time, bill_code, bill_codes, pay_money, reamrk, createtime)
             VALUES (?,?,?,?,?,?,?,?,?)`,
            [
              this.n(doc.admin_id) || null,
              this.n(o.customers_id) || null,
              3, // 收款
              nowSec(),
              o.purchase_code,
              info.purchase_code,
              pay,
              doc.remarks,
              nowSec(),
            ],
          );
          await this.q(
            `UPDATE kuerp_goods_sales SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
            [newPay, status, info.purchase_number],
          );
          const invRows1: any[] = await this.q(
            `SELECT status FROM kuerp_sales_invoicing WHERE bill_code = ? LIMIT 1`,
            [info.purchase_number],
          );
          const oldStatusI1 = invRows1.length ? this.n(invRows1[0].status) : 0;
          await this.q(
            `UPDATE kuerp_collection_sale SET old_money = ?, old_status = ?, old_status_i = ? WHERE id = ?`,
            [this.n(o.pay_money), this.n(o.pay_status), oldStatusI1, info.id],
          );
          await this.syncInvoiceStatus(
            'kuerp_sales_invoicing',
            'kuerp_sales_invoicing_log',
            info.purchase_number,
            status,
            0,
          );
        }
      } else if (this.n(info.type) === 2) {
        // 销货退货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_sales_exchange WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          const allMoney = this.n(o.real_money);
          const newRetreat = this.n(o.retreat_money) - pay;
          if (allMoney < this.n(o.retreat_money) - pay) {
            throw new BadRequestException(
              `${info.purchase_number} 核销金额不能大于未核销金额`,
            );
          }
          const status = allMoney + pay - this.n(o.retreat_money) === 0 ? 1 : 2;
          await this.q(
            `INSERT INTO kuerp_sales_payment_log
             (admin_id, customers_id, business_type, bill_time, bill_code, bill_codes, pay_money, reamrk, createtime)
             VALUES (?,?,?,?,?,?,?,?,?)`,
            [
              this.n(doc.admin_id) || null,
              this.n(o.customers_id) || null,
              4, // 退款
              nowSec(),
              o.purchase_code,
              info.purchase_code,
              pay,
              doc.remarks,
              nowSec(),
            ],
          );
          await this.q(
            `UPDATE kuerp_goods_sales_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
            [newRetreat, status, info.purchase_number],
          );
          const invRows2: any[] = await this.q(
            `SELECT status FROM kuerp_sales_invoicing WHERE bill_code = ? LIMIT 1`,
            [info.purchase_number],
          );
          const oldStatusI2 = invRows2.length ? this.n(invRows2[0].status) : 0;
          await this.q(
            `UPDATE kuerp_collection_sale SET old_money = ?, old_status = ?, old_status_i = ? WHERE id = ?`,
            [this.n(o.retreat_money), this.n(o.retreat_status), oldStatusI2, info.id],
          );
          await this.syncInvoiceStatus(
            'kuerp_sales_invoicing',
            'kuerp_sales_invoicing_log',
            info.purchase_number,
            status,
            3, // 退货类开票状态 +3
          );
        }
      }
    }

    // 5. 应收明细（客户对账单）：无源单=预收增加，有源单=应收减少
    if (this.n(doc.customers_id) > 0) {
      const hasSource = infoRows.length > 0;
      await this.q(
        `INSERT INTO kuerp_accounts_receivable
         (admin_id, customers_id, purchase_time, purchase_code, business_type, receivable, advance, remark, real_money, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          this.n(doc.customers_id),
          this.n(doc.purchase_time),
          doc.purchase_code,
          9, // 收款单
          hasSource ? -this.n(doc.money) : 0,
          hasSource ? 0 : this.n(doc.money),
          doc.remarks,
          this.n(doc.money),
          nowSec(),
          nowSec(),
        ],
      );
    }

    // 6. 应用账户余额与流水
    await this.applyAccountDeltas(deltas);
    await this.insertAccountLogs(logs);

    // 7. 客户应收余额扣减（本次收款全额冲减）
    if (this.n(doc.customers_id) > 0) {
      await this.q(
        `UPDATE kuerp_customers SET need_receive_account = need_receive_account - ? WHERE id = ?`,
        [this.n(doc.money), this.n(doc.customers_id)],
      );
    }
    return { posted: 1 };
  }

  /**
   * 收款单反审冲转：删除派生记录、恢复源单状态/开票状态、反向恢复账户余额与客户余额。
   * @param id 收款单ID
   */
  private async unpostCollection(id: number): Promise<{ reversed: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_collection WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { reversed: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) !== 1) return { reversed: 0 }; // 未审核无需冲转

    const accRows: any[] = await this.q(
      `SELECT * FROM kuerp_collection_account WHERE collection_id = ?`,
      [id],
    );
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_collection_sale WHERE collection_id = ?`,
      [id],
    );

    // 1. 删除派生记录（按单据号定位）
    await this.q(
      `DELETE FROM kuerp_accounts_receivable WHERE purchase_code = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_sales_payment_log WHERE bill_codes = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_writeoff_source WHERE purchase_code = ? AND purchase_type = 1 AND type = 1`,
      [doc.purchase_code],
    );
    const billCodes = accRows.map((a) => a.purchase_code).filter(Boolean);
    billCodes.push(doc.purchase_code);
    await this.q(
      `DELETE FROM kuerp_accounts_log WHERE bill_code IN (?) AND business_type = 7`,
      [billCodes],
    );

    // 2. 恢复源单收付款状态与开票状态（用 old_money/old_status 快照）
    for (const info of infoRows) {
      if (this.n(info.business_type) !== 3) continue;
      if (this.n(info.type) === 1) {
        await this.q(
          `UPDATE kuerp_goods_sales SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
        await this.restoreInvoiceStatus(
          'kuerp_sales_invoicing',
          'kuerp_sales_invoicing_log',
          info.purchase_number,
          this.n(info.old_status_i),
        );
      } else if (this.n(info.type) === 2) {
        await this.q(
          `UPDATE kuerp_goods_sales_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
        await this.restoreInvoiceStatus(
          'kuerp_sales_invoicing',
          'kuerp_sales_invoicing_log',
          info.purchase_number,
          this.n(info.old_status_i),
        );
      }
    }

    // 3. 反向恢复账户余额
    const deltas = new Map<number, number>();
    for (const acc of accRows) {
      deltas.set(
        this.n(acc.accounts_id),
        (deltas.get(this.n(acc.accounts_id)) || 0) - this.n(acc.money),
      );
    }
    await this.applyAccountDeltas(deltas);

    // 4. 恢复客户应收余额
    if (this.n(doc.customers_id) > 0) {
      await this.q(
        `UPDATE kuerp_customers SET need_receive_account = need_receive_account + ? WHERE id = ?`,
        [this.n(doc.money), this.n(doc.customers_id)],
      );
    }
    return { reversed: 1 };
  }

  // =====================================================================
  // 一、资金单据：付款单
  // =====================================================================

  /**
   * 付款单审核过账。
   * 流程：结算账户扣钱 → 账户流水(bt=8) → 预付单生成核销源单 → 逐源单核销
   * （购货/购货退货 付款状态 + 采购付款一览表 + 开票状态）→ 应付明细(bt=9) →
   * 供应商应付余额扣减。
   * @param id 付款单ID
   */
  private async postPayment(id: number): Promise<{ posted: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_payment WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { posted: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) === 1) return { posted: 0 };

    // 1. 结算账户明细：逐账户扣钱并生成账户流水
    // 付款单的 customers_id 字段实际存放供应商ID（与原系统数据库设计一致），
    // 这里反查供应商编号写入账户流水的 supplyer_code（往来单位），保证现金银行报表可按供应商筛选。
    const paySupplierCode = await this.getSupplierCode(this.n(doc.customers_id));
    const accRows: any[] = await this.q(
      `SELECT * FROM kuerp_payment_account WHERE collection_id = ?`,
      [id],
    );
    const deltas = new Map<number, number>();
    const logs: AccountLogRow[] = [];
    for (const acc of accRows) {
      const account = await this.getAccount(this.n(acc.accounts_id));
      if (!account) {
        throw new BadRequestException(
          `付款单 ${doc.purchase_code} 的结算账户不存在`,
        );
      }
      const money = this.n(acc.money);
      deltas.set(account.id, (deltas.get(account.id) || 0) - money);
      logs.push({
        accountId: account.id,
        accountCoding: account.account_coding,
        accountName: account.account_name,
        balance: this.n(account.balance) - money,
        income: null,
        expenditure: money,
        payTime: this.n(doc.purchase_time),
        billCode: acc.purchase_code || doc.purchase_code,
        businessType: 8, // 付款单
        supplyerCode: paySupplierCode || null,
        payment: this.n(doc.staff_member_id) || null,
        remark: doc.remarks,
      });
    }

    // 2. 核销源单明细
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_payment_sale WHERE collection_id = ?`,
      [id],
    );

    // 3. 预付单（无核销源单）生成预付核销源单
    if (this.n(doc.business_type) === 1) {
      // customers_id 字段在付款单中实际存供应商ID（与原系统一致）
      const supplierCode = await this.getSupplierCode(
        this.n(doc.customers_id),
      );
      await this.q(
        `INSERT INTO kuerp_writeoff_source
         (admin_id, purchase_type, type, suppliers_code, purchase_code, purchase_time, price, money, write_off, remark)
         VALUES (?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          2, // 预付单
          1,
          supplierCode,
          doc.purchase_code,
          this.n(doc.purchase_time),
          this.n(doc.advance),
          0,
          this.n(doc.advance),
          doc.remarks,
        ],
      );
    }

    // 4. 逐源单核销
    for (const info of infoRows) {
      if (this.n(info.business_type) !== 4) continue; // 4=应付源单
      const pay = this.n(info.write_off_price);
      if (this.n(info.type) === 1) {
        // 普通购货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_purchase WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          const allMoney = this.n(o.real_money);
          const newPay = this.n(o.pay_money) + pay;
          if (allMoney < newPay) {
            throw new BadRequestException(
              `${info.purchase_number} 核销金额不能大于未核销金额`,
            );
          }
          const status = allMoney - newPay <= 0 ? 1 : 2;
          await this.q(
            `INSERT INTO kuerp_payment_log
             (admin_id, suppliers_code, business_type, bill_time, bill_code, bill_codes, pay_money, reamrk, createtime)
             VALUES (?,?,?,?,?,?,?,?,?)`,
            [
              this.n(doc.admin_id) || null,
              o.supplyer_code,
              3, // 付款
              nowSec(),
              o.purchase_code,
              info.purchase_code,
              pay,
              doc.remarks,
              nowSec(),
            ],
          );
          await this.q(
            `UPDATE kuerp_goods_purchase SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
            [newPay, status, info.purchase_number],
          );
          const invRows3: any[] = await this.q(
            `SELECT status FROM kuerp_invoicing WHERE bill_code = ? LIMIT 1`,
            [info.purchase_number],
          );
          const oldStatusI3 = invRows3.length ? this.n(invRows3[0].status) : 0;
          await this.q(
            `UPDATE kuerp_payment_sale SET old_money = ?, old_status = ?, old_status_i = ? WHERE id = ?`,
            [this.n(o.pay_money), this.n(o.pay_status), oldStatusI3, info.id],
          );
          await this.syncInvoiceStatus(
            'kuerp_invoicing',
            'kuerp_invoicing_log',
            info.purchase_number,
            status,
            0,
          );
        }
      } else if (this.n(info.type) === 2) {
        // 购货退货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_exchange WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          const allMoney = this.n(o.real_money);
          const newRetreat = this.n(o.retreat_money) - pay;
          if (allMoney < this.n(o.retreat_money) - pay) {
            throw new BadRequestException(
              `${info.purchase_number} 核销金额不能大于未核销金额`,
            );
          }
          const status = allMoney + pay - this.n(o.retreat_money) === 0 ? 1 : 2;
          await this.q(
            `INSERT INTO kuerp_payment_log
             (admin_id, suppliers_code, business_type, bill_time, bill_code, bill_codes, pay_money, reamrk, createtime)
             VALUES (?,?,?,?,?,?,?,?,?)`,
            [
              this.n(doc.admin_id) || null,
              o.supplyer_code,
              4, // 退款
              nowSec(),
              o.purchase_code,
              info.purchase_code,
              pay,
              doc.remarks,
              nowSec(),
            ],
          );
          await this.q(
            `UPDATE kuerp_goods_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
            [newRetreat, status, info.purchase_number],
          );
          const invRows4: any[] = await this.q(
            `SELECT status FROM kuerp_invoicing WHERE bill_code = ? LIMIT 1`,
            [info.purchase_number],
          );
          const oldStatusI4 = invRows4.length ? this.n(invRows4[0].status) : 0;
          await this.q(
            `UPDATE kuerp_payment_sale SET old_money = ?, old_status = ?, old_status_i = ? WHERE id = ?`,
            [this.n(o.retreat_money), this.n(o.retreat_status), oldStatusI4, info.id],
          );
          await this.syncInvoiceStatus(
            'kuerp_invoicing',
            'kuerp_invoicing_log',
            info.purchase_number,
            status,
            3,
          );
        }
      }
    }

    // 5. 应付明细（供应商对账单）
    if (this.n(doc.customers_id) > 0) {
      const hasSource = infoRows.length > 0;
      await this.q(
        `INSERT INTO kuerp_accounts_copewith
         (admin_id, suppliers_id, purchase_time, purchase_code, business_type, receivable, advance, remark, real_money, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          this.n(doc.customers_id),
          this.n(doc.purchase_time),
          doc.purchase_code,
          9, // 付款单
          hasSource ? -this.n(doc.money) : 0,
          hasSource ? 0 : this.n(doc.money),
          doc.remarks,
          this.n(doc.money),
          nowSec(),
          nowSec(),
        ],
      );
    }

    // 6. 应用账户余额与流水
    await this.applyAccountDeltas(deltas);
    await this.insertAccountLogs(logs);

    // 7. 供应商应付余额扣减
    if (this.n(doc.customers_id) > 0) {
      await this.q(
        `UPDATE kuerp_suppliers SET need_give_account = need_give_account - ? WHERE id = ?`,
        [this.n(doc.money), this.n(doc.customers_id)],
      );
    }
    return { posted: 1 };
  }

  /**
   * 付款单反审冲转。
   * @param id 付款单ID
   */
  private async unpostPayment(id: number): Promise<{ reversed: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_payment WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { reversed: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) !== 1) return { reversed: 0 };

    const accRows: any[] = await this.q(
      `SELECT * FROM kuerp_payment_account WHERE collection_id = ?`,
      [id],
    );
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_payment_sale WHERE collection_id = ?`,
      [id],
    );

    // 1. 删除派生记录
    await this.q(
      `DELETE FROM kuerp_accounts_copewith WHERE purchase_code = ? AND business_type = 9`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_payment_log WHERE bill_codes = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_writeoff_source WHERE purchase_code = ? AND purchase_type = 2 AND type = 1`,
      [doc.purchase_code],
    );
    const billCodes = accRows.map((a) => a.purchase_code).filter(Boolean);
    billCodes.push(doc.purchase_code);
    await this.q(
      `DELETE FROM kuerp_accounts_log WHERE bill_code IN (?) AND business_type = 8`,
      [billCodes],
    );

    // 2. 恢复源单付款状态与开票状态
    for (const info of infoRows) {
      if (this.n(info.business_type) !== 4) continue;
      if (this.n(info.type) === 1) {
        await this.q(
          `UPDATE kuerp_goods_purchase SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
        await this.restoreInvoiceStatus(
          'kuerp_invoicing',
          'kuerp_invoicing_log',
          info.purchase_number,
          this.n(info.old_status_i),
        );
      } else if (this.n(info.type) === 2) {
        await this.q(
          `UPDATE kuerp_goods_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
        await this.restoreInvoiceStatus(
          'kuerp_invoicing',
          'kuerp_invoicing_log',
          info.purchase_number,
          this.n(info.old_status_i),
        );
      }
    }

    // 3. 反向恢复账户余额
    const deltas = new Map<number, number>();
    for (const acc of accRows) {
      deltas.set(
        this.n(acc.accounts_id),
        (deltas.get(this.n(acc.accounts_id)) || 0) + this.n(acc.money),
      );
    }
    await this.applyAccountDeltas(deltas);

    // 4. 恢复供应商应付余额
    if (this.n(doc.customers_id) > 0) {
      await this.q(
        `UPDATE kuerp_suppliers SET need_give_account = need_give_account + ? WHERE id = ?`,
        [this.n(doc.money), this.n(doc.customers_id)],
      );
    }
    return { reversed: 1 };
  }

  // =====================================================================
  // 一、资金单据：核销单
  // =====================================================================

  /**
   * 核销单审核过账：五种业务类型（1预收冲应收/2预付冲应付/3应收冲应付/4应收转应收/5应付转应付）。
   * 流程：逐源单更新收付款状态与双向流水 → 按业务类型插入应收/应付明细并调整往来余额 →
   * 转账类业务为转入方生成新核销源单。
   * @param id 核销单ID
   */
  private async postWriteoff(id: number): Promise<{ posted: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_writeoff WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { posted: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) === 1) return { posted: 0 };
    const bizType = this.n(doc.business_type);
    const amount = this.n(doc.write_off);

    // 1. 逐源单处理：更新源单收/付款状态并写入流水
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_writeoff_info WHERE collection_id = ?`,
      [id],
    );
    for (const info of infoRows) {
      const pay = this.n(info.write_off_price);
      const pt = this.n(info.purchase_type); // 3=应收 4=应付
      const tp = this.n(info.type); // 1=销货/购货 2=退货
      let oldMoney = 0;
      let oldStatus = 0;
      if (pt === 3 && tp === 1) {
        // 销货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_sales WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          oldMoney = this.n(o.pay_money);
          oldStatus = this.n(o.pay_status);
          const allMoney = this.n(o.money_tax_price);
          const newPay = oldMoney + pay;
          const status = allMoney - newPay <= 0 ? 1 : 2;
          await this.q(
            `UPDATE kuerp_goods_sales SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
            [newPay, status, info.purchase_number],
          );
        }
      } else if (pt === 3 && tp === 2) {
        // 销货退货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_sales_exchange WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          oldMoney = this.n(o.retreat_money);
          oldStatus = this.n(o.retreat_status);
          const allMoney = this.n(o.money_tax_price);
          const newRetreat = oldMoney - pay;
          const status = allMoney + pay - oldMoney === 0 ? 1 : 2;
          await this.q(
            `UPDATE kuerp_goods_sales_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
            [newRetreat, status, info.purchase_number],
          );
        }
      } else if (pt === 4 && tp === 1) {
        // 购货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_purchase WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          oldMoney = this.n(o.pay_money);
          oldStatus = this.n(o.pay_status);
          const allMoney = this.n(o.all_money) + this.n(o.tax_money);
          const newPay = oldMoney + pay;
          const status = allMoney - newPay <= 0 ? 1 : 2;
          await this.q(
            `UPDATE kuerp_goods_purchase SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
            [newPay, status, info.purchase_number],
          );
        }
      } else if (pt === 4 && tp === 2) {
        // 购货退货单
        const order: any[] = await this.q(
          `SELECT * FROM kuerp_goods_exchange WHERE purchase_code = ? LIMIT 1`,
          [info.purchase_number],
        );
        if (order.length) {
          const o = order[0];
          oldMoney = this.n(o.retreat_money);
          oldStatus = this.n(o.retreat_status);
          const allMoney = this.n(o.all_money) + this.n(o.tax_money);
          const newRetreat = oldMoney - pay;
          const status = allMoney + pay - oldMoney === 0 ? 1 : 2;
          await this.q(
            `UPDATE kuerp_goods_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
            [newRetreat, status, info.purchase_number],
          );
        }
      }
      // 记录源单快照供反审恢复
      if ((pt === 3 || pt === 4) && (tp === 1 || tp === 2)) {
        await this.q(
          `UPDATE kuerp_writeoff_info SET old_money = ?, old_status = ? WHERE id = ?`,
          [oldMoney, oldStatus, info.id],
        );
      }

      // 2. 双向流水（top=1 现付类 / top=2 期初类）
      const source: any[] = await this.q(
        `SELECT * FROM kuerp_writeoff_source WHERE id = ? LIMIT 1`,
        [info.source_id],
      );
      const src = source[0] || {};
      const top = this.n(info.top);
      const infoBiz = this.n(info.business_type);
      if (top === 1) {
        if (infoBiz === 1 && tp === 3) {
          // 预收冲应收：客户应收流水 +
          await this.insertSalesPaymentLog(
            doc,
            this.n(src.customers_id) || null,
            7,
            info,
            pay,
          );
        } else if (infoBiz === 2 && tp === 3) {
          // 预付冲应付：供应商应付流水 +
          await this.insertPaymentLog(
            doc,
            src.suppliers_code,
            7,
            info,
            pay,
          );
        } else if (infoBiz === 3 && tp < 4) {
          // 应收冲应付：客户应收流水 +
          await this.insertSalesPaymentLog(
            doc,
            this.n(src.customers_id) || null,
            7,
            info,
            pay,
          );
        } else if (infoBiz === 4 && tp < 4) {
          // 应收转应收：转出 -、转入 +
          await this.insertSalesPaymentLog(
            doc,
            this.n(doc.customers_out_id) || null,
            7,
            info,
            -pay,
          );
          await this.insertSalesPaymentLog(
            doc,
            this.n(doc.customers_enter_id) || null,
            7,
            info,
            pay,
          );
        } else if (infoBiz === 5 && tp < 4) {
          // 应付转应付：转出 +、转入 -
          const outCode = await this.getSupplierCode(
            this.n(doc.suppliers_out_id),
          );
          const enterCode = await this.getSupplierCode(
            this.n(doc.suppliers_enter_id),
          );
          await this.insertPaymentLog(doc, outCode, 7, info, pay);
          await this.insertPaymentLog(doc, enterCode, 7, info, -pay);
        }
      } else if (top === 2) {
        if (infoBiz === 1 && (pt === 3 || pt === 5)) {
          await this.insertSalesPaymentLog(
            doc,
            this.n(src.customers_id) || null,
            7,
            info,
            pay,
          );
        } else if (infoBiz === 2 && (pt === 4 || pt === 5)) {
          await this.insertPaymentLog(doc, src.suppliers_code, 7, info, pay);
        } else if (infoBiz === 3 && (pt === 4 || pt === 5)) {
          await this.insertPaymentLog(doc, src.suppliers_code, 7, info, pay);
        }
      }
    }

    // 3. 按业务类型插入应收/应付明细并调整往来余额
    const receivableRow = (
      customersId: number,
      biz: number,
      receivable: number,
      advance: number,
    ) =>
      this.q(
        `INSERT INTO kuerp_accounts_receivable
         (admin_id, customers_id, purchase_time, purchase_code, business_type, receivable, advance, remark, receivable_money, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          customersId,
          this.n(doc.purchase_time),
          doc.purchase_code,
          biz,
          receivable,
          advance,
          doc.remarks,
          receivable,
          nowSec(),
          nowSec(),
        ],
      );
    const copewithRow = (
      suppliersId: number,
      biz: number,
      receivable: number,
      advance: number,
    ) =>
      this.q(
        `INSERT INTO kuerp_accounts_copewith
         (admin_id, suppliers_id, purchase_time, purchase_code, business_type, receivable, advance, remark, receivable_money, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          suppliersId,
          this.n(doc.purchase_time),
          doc.purchase_code,
          biz,
          receivable,
          advance,
          doc.remarks,
          receivable,
          nowSec(),
          nowSec(),
        ],
      );

    switch (bizType) {
      case 1:
        // 预收冲应收：预收与应收同时减少
        await receivableRow(this.n(doc.customers_id), 1, -amount, -amount);
        break;
      case 2:
        // 预付冲应付：预付与应付同时减少
        await copewithRow(this.n(doc.suppliers_id), 2, -amount, -amount);
        break;
      case 3: {
        // 应收冲应付：两侧应收/应付同时减少
        await receivableRow(this.n(doc.customers_id), 3, -amount, 0);
        await copewithRow(this.n(doc.suppliers_id), 3, -amount, 0);
        await this.q(
          `UPDATE kuerp_customers SET need_receive_account = need_receive_account - ? WHERE id = ?`,
          [amount, this.n(doc.customers_id)],
        );
        await this.q(
          `UPDATE kuerp_suppliers SET need_give_account = need_give_account - ? WHERE id = ?`,
          [amount, this.n(doc.suppliers_id)],
        );
        break;
      }
      case 4: {
        // 应收转应收：转出客户减、转入客户加，为转入方生成新核销源单
        await receivableRow(this.n(doc.customers_out_id), 4, -amount, 0);
        await this.q(
          `UPDATE kuerp_customers SET need_receive_account = need_receive_account - ? WHERE id = ?`,
          [amount, this.n(doc.customers_out_id)],
        );
        await receivableRow(this.n(doc.customers_enter_id), 4, amount, 0);
        await this.q(
          `UPDATE kuerp_customers SET need_receive_account = need_receive_account + ? WHERE id = ?`,
          [amount, this.n(doc.customers_enter_id)],
        );
        await this.q(
          `INSERT INTO kuerp_writeoff_source
           (admin_id, purchase_type, type, customers_id, purchase_code, purchase_time, price, money, write_off)
           VALUES (?,?,?,?,?,?,?,?,?)`,
          [
            this.n(doc.admin_id) || null,
            3,
            4, // 核销产生
            this.n(doc.customers_enter_id) || null,
            doc.purchase_code,
            this.n(doc.purchase_time),
            amount,
            0,
            amount,
          ],
        );
        break;
      }
      case 5: {
        // 应付转应付：转出供应商减、转入供应商加，为转入方生成新核销源单
        await copewithRow(this.n(doc.suppliers_out_id), 5, -amount, 0);
        await this.q(
          `UPDATE kuerp_suppliers SET need_give_account = need_give_account - ? WHERE id = ?`,
          [amount, this.n(doc.suppliers_out_id)],
        );
        await copewithRow(this.n(doc.suppliers_enter_id), 5, amount, 0);
        await this.q(
          `UPDATE kuerp_suppliers SET need_give_account = need_give_account + ? WHERE id = ?`,
          [amount, this.n(doc.suppliers_enter_id)],
        );
        const enterCode = await this.getSupplierCode(
          this.n(doc.suppliers_enter_id),
        );
        await this.q(
          `INSERT INTO kuerp_writeoff_source
           (admin_id, purchase_type, type, suppliers_code, purchase_code, purchase_time, price, money, write_off)
           VALUES (?,?,?,?,?,?,?,?,?)`,
          [
            this.n(doc.admin_id) || null,
            4,
            4,
            enterCode,
            doc.purchase_code,
            this.n(doc.purchase_time),
            amount,
            0,
            amount,
          ],
        );
        break;
      }
    }
    return { posted: 1 };
  }

  /**
   * 核销单反审冲转：删除派生明细与流水、恢复源单状态、反向调整往来余额、
   * 删除转账类业务生成的新核销源单。
   * @param id 核销单ID
   */
  private async unpostWriteoff(id: number): Promise<{ reversed: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_writeoff WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { reversed: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) !== 1) return { reversed: 0 };
    const bizType = this.n(doc.business_type);
    const amount = this.n(doc.write_off);

    // 1. 删除派生明细与流水
    await this.q(
      `DELETE FROM kuerp_accounts_receivable WHERE purchase_code = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_accounts_copewith WHERE purchase_code = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_sales_payment_log WHERE bill_codes = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_payment_log WHERE bill_codes = ?`,
      [doc.purchase_code],
    );
    // 删除转账类业务生成的新核销源单
    await this.q(
      `DELETE FROM kuerp_writeoff_source WHERE purchase_code = ? AND type = 4`,
      [doc.purchase_code],
    );

    // 2. 恢复源单收/付款状态
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_writeoff_info WHERE collection_id = ?`,
      [id],
    );
    for (const info of infoRows) {
      const pt = this.n(info.purchase_type);
      const tp = this.n(info.type);
      if (pt === 3 && tp === 1) {
        await this.q(
          `UPDATE kuerp_goods_sales SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
      } else if (pt === 3 && tp === 2) {
        await this.q(
          `UPDATE kuerp_goods_sales_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
      } else if (pt === 4 && tp === 1) {
        await this.q(
          `UPDATE kuerp_goods_purchase SET pay_money = ?, pay_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
      } else if (pt === 4 && tp === 2) {
        await this.q(
          `UPDATE kuerp_goods_exchange SET retreat_money = ?, retreat_status = ? WHERE purchase_code = ?`,
          [this.n(info.old_money), this.n(info.old_status), info.purchase_number],
        );
      }
    }

    // 3. 反向调整往来余额
    if (bizType === 3) {
      await this.q(
        `UPDATE kuerp_customers SET need_receive_account = need_receive_account + ? WHERE id = ?`,
        [amount, this.n(doc.customers_id)],
      );
      await this.q(
        `UPDATE kuerp_suppliers SET need_give_account = need_give_account + ? WHERE id = ?`,
        [amount, this.n(doc.suppliers_id)],
      );
    } else if (bizType === 4) {
      await this.q(
        `UPDATE kuerp_customers SET need_receive_account = need_receive_account + ? WHERE id = ?`,
        [amount, this.n(doc.customers_out_id)],
      );
      await this.q(
        `UPDATE kuerp_customers SET need_receive_account = need_receive_account - ? WHERE id = ?`,
        [amount, this.n(doc.customers_enter_id)],
      );
    } else if (bizType === 5) {
      await this.q(
        `UPDATE kuerp_suppliers SET need_give_account = need_give_account + ? WHERE id = ?`,
        [amount, this.n(doc.suppliers_out_id)],
      );
      await this.q(
        `UPDATE kuerp_suppliers SET need_give_account = need_give_account - ? WHERE id = ?`,
        [amount, this.n(doc.suppliers_enter_id)],
      );
    }
    return { reversed: 1 };
  }

  // =====================================================================
  // 一、资金单据：转账单 / 其他收入单 / 其他支出单
  // =====================================================================

  /**
   * 资金转账单审核过账：转出账户扣钱(bt=12)、转入账户加钱(bt=11)。
   * @param id 转账单ID
   */
  private async postTransfer(id: number): Promise<{ posted: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_accounts_transfer WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { posted: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) === 1) return { posted: 0 };

    const infos: any[] = await this.q(
      `SELECT * FROM kuerp_accounts_transfer_info WHERE purchase_id = ?`,
      [id],
    );
    const deltas = new Map<number, number>();
    const logs: AccountLogRow[] = [];
    for (const info of infos) {
      const money = this.n(info.money);
      // 转出账户
      const out = await this.getAccount(this.n(info.accounts_out_id));
      if (!out) {
        throw new BadRequestException(
          `转账单 ${doc.purchase_code} 转出账户不存在`,
        );
      }
      deltas.set(out.id, (deltas.get(out.id) || 0) - money);
      logs.push({
        accountId: out.id,
        accountCoding: out.account_coding,
        accountName: out.account_name,
        balance: this.n(out.balance) - money,
        income: null,
        expenditure: money,
        payTime: this.n(doc.purchase_time),
        billCode: doc.purchase_code,
        businessType: 12, // 转出
        remark: info.remark || doc.remark,
      });
      // 转入账户
      const enter = await this.getAccount(this.n(info.accounts_enter_id));
      if (!enter) {
        throw new BadRequestException(
          `转账单 ${doc.purchase_code} 转入账户不存在`,
        );
      }
      deltas.set(enter.id, (deltas.get(enter.id) || 0) + money);
      logs.push({
        accountId: enter.id,
        accountCoding: enter.account_coding,
        accountName: enter.account_name,
        balance: this.n(enter.balance) + money,
        income: money,
        expenditure: null,
        payTime: this.n(doc.purchase_time),
        billCode: doc.purchase_code,
        businessType: 11, // 转入
        remark: info.remark || doc.remark,
      });
    }
    await this.applyAccountDeltas(deltas);
    await this.insertAccountLogs(logs);
    return { posted: 1 };
  }

  /**
   * 转账单反审冲转：反向恢复两账户余额并删除账户流水。
   * @param id 转账单ID
   */
  private async unpostTransfer(id: number): Promise<{ reversed: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_accounts_transfer WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { reversed: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) !== 1) return { reversed: 0 };

    const infos: any[] = await this.q(
      `SELECT * FROM kuerp_accounts_transfer_info WHERE purchase_id = ?`,
      [id],
    );
    const deltas = new Map<number, number>();
    for (const info of infos) {
      const money = this.n(info.money);
      deltas.set(
        this.n(info.accounts_out_id),
        (deltas.get(this.n(info.accounts_out_id)) || 0) + money,
      );
      deltas.set(
        this.n(info.accounts_enter_id),
        (deltas.get(this.n(info.accounts_enter_id)) || 0) - money,
      );
    }
    await this.applyAccountDeltas(deltas);
    await this.q(
      `DELETE FROM kuerp_accounts_log WHERE bill_code = ? AND business_type IN (11,12)`,
      [doc.purchase_code],
    );
    return { reversed: 1 };
  }

  /**
   * 其他收入单审核过账：账户加钱(bt=9)，欠款部分生成应收明细(bt=8)，联动采购销售费用。
   * @param id 其他收入单ID
   */
  private async postIncome(id: number): Promise<{ posted: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_income WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { posted: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) === 1) return { posted: 0 };

    const account = await this.getAccount(this.n(doc.accounts_id));
    if (!account) {
      throw new BadRequestException(
        `其他收入单 ${doc.purchase_code} 的结算账户不存在`,
      );
    }
    const payMoney = this.n(doc.pay_money);
    const money = this.n(doc.money);

    // 1. 欠款部分生成应收明细（bt=8）
    if (payMoney < money && this.n(doc.customers_id) > 0) {
      await this.q(
        `INSERT INTO kuerp_accounts_receivable
         (admin_id, customers_id, purchase_time, purchase_code, business_type, receivable, sale_money, receivable_money, real_money, remark, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          this.n(doc.customers_id),
          this.n(doc.purchase_time),
          doc.purchase_code,
          8, // 其他收入
          this.n(doc.arrears),
          money,
          money,
          payMoney,
          doc.remark,
          nowSec(),
          nowSec(),
        ],
      );
    }

    // 2. 联动采购销售费用：该费用单的已收金额累加
    if (this.n(doc.cost_id) > 0) {
      await this.q(
        `UPDATE kuerp_cost SET pay_money = pay_money - ?, updatetime = ? WHERE id = ?`,
        [payMoney, nowSec(), this.n(doc.cost_id)],
      );
    }

    // 3. 账户加钱 + 流水
    const deltas = new Map<number, number>();
    deltas.set(account.id, (deltas.get(account.id) || 0) + payMoney);
    await this.applyAccountDeltas(deltas);
    await this.insertAccountLogs([
      {
        accountId: account.id,
        accountCoding: account.account_coding,
        accountName: account.account_name,
        balance: this.n(account.balance) + payMoney,
        income: payMoney,
        expenditure: null,
        payTime: this.n(doc.purchase_time),
        billCode: doc.purchase_code,
        businessType: 9, // 其他收入
        customersId: this.n(doc.customers_id) || null,
        remark: doc.remark,
      },
    ]);
    return { posted: 1 };
  }

  /**
   * 其他收入单反审冲转。
   * @param id 其他收入单ID
   */
  private async unpostIncome(id: number): Promise<{ reversed: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_income WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { reversed: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) !== 1) return { reversed: 0 };

    await this.q(
      `DELETE FROM kuerp_accounts_receivable WHERE purchase_code = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_accounts_log WHERE bill_code = ? AND business_type = 9`,
      [doc.purchase_code],
    );
    const account = await this.getAccount(this.n(doc.accounts_id));
    if (account) {
      const deltas = new Map<number, number>();
      deltas.set(account.id, (deltas.get(account.id) || 0) - this.n(doc.pay_money));
      await this.applyAccountDeltas(deltas);
    }
    if (this.n(doc.cost_id) > 0) {
      await this.q(
        `UPDATE kuerp_cost SET pay_money = pay_money + ?, updatetime = ? WHERE id = ?`,
        [this.n(doc.pay_money), nowSec(), this.n(doc.cost_id)],
      );
    }
    return { reversed: 1 };
  }

  /**
   * 其他支出单审核过账：账户扣钱(bt=10)，欠款部分生成应付明细(bt=8)，联动采购销售费用。
   * @param id 其他支出单ID
   */
  private async postExpenditure(id: number): Promise<{ posted: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_expenditure WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { posted: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) === 1) return { posted: 0 };

    const account = await this.getAccount(this.n(doc.accounts_id));
    if (!account) {
      throw new BadRequestException(
        `其他支出单 ${doc.purchase_code} 的结算账户不存在`,
      );
    }
    const payMoney = this.n(doc.pay_money);
    const money = this.n(doc.money);

    // 1. 欠款部分生成应付明细（bt=8）
    if (payMoney < money && this.n(doc.suppliers_id) > 0) {
      await this.q(
        `INSERT INTO kuerp_accounts_copewith
         (admin_id, suppliers_id, purchase_time, purchase_code, business_type, receivable, sale_money, receivable_money, real_money, remark, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          this.n(doc.suppliers_id),
          this.n(doc.purchase_time),
          doc.purchase_code,
          8, // 其他支出
          this.n(doc.arrears),
          money,
          money,
          payMoney,
          doc.remark,
          nowSec(),
          nowSec(),
        ],
      );
    }

    // 2. 联动采购销售费用：明细行中引用的费用单已付金额累加
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_expenditure_info WHERE purchase_id = ?`,
      [id],
    );
    for (const info of infoRows) {
      if (this.n(info.cost_id) > 0) {
        // GREATEST(0, ...) 兜底：防止同一费用被多张支出单重复核销导致未结金额为负
        await this.q(
          `UPDATE kuerp_cost SET pay_money = GREATEST(0, pay_money - ?), updatetime = ? WHERE id = ?`,
          [this.n(info.money), nowSec(), this.n(info.cost_id)],
        );
      }
    }

    // 3. 账户扣钱 + 流水
    const deltas = new Map<number, number>();
    deltas.set(account.id, (deltas.get(account.id) || 0) - payMoney);
    await this.applyAccountDeltas(deltas);
    await this.insertAccountLogs([
      {
        accountId: account.id,
        accountCoding: account.account_coding,
        accountName: account.account_name,
        balance: this.n(account.balance) - payMoney,
        income: null,
        expenditure: payMoney,
        payTime: this.n(doc.purchase_time),
        billCode: doc.purchase_code,
        businessType: 10, // 其他支出
        // 往来单位：其他支出单表头 suppliers_id（供应商），反查编号写入 supplyer_code
        supplyerCode: (await this.getSupplierCode(this.n(doc.suppliers_id))) || null,
        remark: doc.remark,
      },
    ]);
    return { posted: 1 };
  }

  /**
   * 其他支出单反审冲转。
   * @param id 其他支出单ID
   */
  private async unpostExpenditure(id: number): Promise<{ reversed: number }> {
    const head: any[] = await this.q(
      `SELECT * FROM kuerp_expenditure WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { reversed: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) !== 1) return { reversed: 0 };

    await this.q(
      `DELETE FROM kuerp_accounts_copewith WHERE purchase_code = ?`,
      [doc.purchase_code],
    );
    await this.q(
      `DELETE FROM kuerp_accounts_log WHERE bill_code = ? AND business_type = 10`,
      [doc.purchase_code],
    );
    const account = await this.getAccount(this.n(doc.accounts_id));
    if (account) {
      const deltas = new Map<number, number>();
      deltas.set(account.id, (deltas.get(account.id) || 0) + this.n(doc.pay_money));
      await this.applyAccountDeltas(deltas);
    }
    const infoRows: any[] = await this.q(
      `SELECT * FROM kuerp_expenditure_info WHERE purchase_id = ?`,
      [id],
    );
    for (const info of infoRows) {
      if (this.n(info.cost_id) > 0) {
        await this.q(
          `UPDATE kuerp_cost SET pay_money = pay_money + ?, updatetime = ? WHERE id = ?`,
          [this.n(info.money), nowSec(), this.n(info.cost_id)],
        );
      }
    }
    return { reversed: 1 };
  }

  // =====================================================================
  // 二、库存类单据的资金联动
  // =====================================================================

  /**
   * 库存类单据审核时的资金联动入口。
   * @param table 单据物理表名
   * @param id 单据主键
   */
  private async postStockFunds(
    table: string,
    id: number,
  ): Promise<{ posted: number }> {
    const kind = this.STOCK_FUND_DOCS[this.docKey(table)].kind;
    const tableName = `kuerp_${this.docKey(table)}`;
    const head: any[] = await this.q(
      `SELECT * FROM \`${tableName}\` WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { posted: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) === 1) return { posted: 0 };

    // 采购销售费用（cost_data）：四类单据通用，先落库
    await this.postCostData(doc, kind);

    switch (kind) {
      case 'buy':
        await this.postPurchaseFunds(doc);
        break;
      case 'buyReturn':
        await this.postPurchaseReturnFunds(doc);
        break;
      case 'sell':
        await this.postSalesFunds(doc);
        break;
      case 'sellReturn':
        await this.postSalesReturnFunds(doc);
        break;
    }
    return { posted: 1 };
  }

  /**
   * 购货单资金联动：
   * 应付款余额 + 即时付款账户扣减(bt=2) + 采购付款一览表(bt=1) + 采购开票表 +
   * 应付明细(bt=6) + 应付核销源单。
   * @param doc 购货单表头
   */
  private async postPurchaseFunds(doc: any) {
    const arrears = this.n(doc.arrears);
    const payMoney = this.n(doc.pay_money);
    const realMoney = this.n(doc.real_money);
    const preferential = this.n(doc.preferential_money);

    // 1. 即时付款：账户扣钱 + 流水(bt=2)
    if (payMoney > 0 && this.n(doc.account) > 0) {
      const account = await this.getAccount(this.n(doc.account));
      if (account) {
        const deltas = new Map<number, number>();
        deltas.set(account.id, (deltas.get(account.id) || 0) - payMoney);
        await this.applyAccountDeltas(deltas);
        await this.insertAccountLogs([
          {
            accountId: account.id,
            accountCoding: account.account_coding,
            accountName: account.account_name,
            balance: this.n(account.balance) - payMoney,
            income: null,
            expenditure: payMoney,
            payTime: this.n(doc.purchase_time),
            billCode: doc.purchase_code,
            businessType: 2, // 普通采购
            supplyerCode: doc.supplyer_code,
            remark: doc.note,
          },
        ]);
      }
    }

    // 2. 采购付款一览表（bt=1 普通采购）
    await this.q(
      `INSERT INTO kuerp_payment_log
       (admin_id, suppliers_code, business_type, bill_time, bill_code, bill_codes, purchase_money, money_tax_price, discount_money, real_money, pay_money, give_money, reamrk, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        doc.supplyer_code,
        1,
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        this.n(doc.all_money),
        this.n(doc.all_money) - preferential,
        preferential,
        realMoney,
        payMoney,
        arrears,
        doc.note,
        nowSec(),
      ],
    );

    // 3. 采购开票表
    await this.q(
      `INSERT INTO kuerp_invoicing
       (admin_id, suppliers_code, status, bill_time, bill_code, bill_codes, money, tax, real_money, pay_money, give_money, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        doc.supplyer_code,
        this.n(doc.pay_status),
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        realMoney - this.n(doc.tax_money),
        this.n(doc.tax_money),
        realMoney,
        0,
        realMoney,
        nowSec(),
      ],
    );

    // 4. 应付明细（bt=6 普通采购）
    const supplierId = await this.getSupplierId(doc.supplyer_code);
    await this.q(
      `INSERT INTO kuerp_accounts_copewith
       (admin_id, suppliers_id, purchase_time, purchase_code, business_type, receivable, remark, sale_money, receivable_money, amount, real_money, createtime, updatetime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        supplierId,
        this.n(doc.purchase_time),
        doc.purchase_code,
        6,
        arrears,
        doc.note,
        this.r4(realMoney + preferential),
        realMoney,
        preferential,
        payMoney,
        nowSec(),
        nowSec(),
      ],
    );

    // 5. 应付款余额 + 应付核销源单
    if (arrears > 0 && supplierId) {
      await this.q(
        `UPDATE kuerp_suppliers SET need_give_account = need_give_account + ? WHERE id = ?`,
        [arrears, supplierId],
      );
      await this.q(
        `INSERT INTO kuerp_writeoff_source
         (admin_id, purchase_type, type, suppliers_code, purchase_code, purchase_time, price, money, write_off, remark)
         VALUES (?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          4, // 应付
          1, // 购货
          doc.supplyer_code,
          doc.purchase_code,
          this.n(doc.purchase_time),
          realMoney,
          payMoney,
          arrears,
          doc.note,
        ],
      );
    }
  }

  /**
   * 购货退货单资金联动：应付款余额扣减 + 采购付款一览表(bt=2 取负) + 开票表(status+3) +
   * 应付明细(bt=7) + 应付退货核销源单。
   * @param doc 购货退货单表头
   */
  private async postPurchaseReturnFunds(doc: any) {
    const arrears = this.n(doc.arrears);
    const retreatMoney = this.n(doc.retreat_money);
    const realMoney = this.n(doc.real_money);
    const preferential = this.n(doc.preferential_money);

    // 1. 采购付款一览表（bt=2 采购退回，金额取负）
    await this.q(
      `INSERT INTO kuerp_payment_log
       (admin_id, suppliers_code, business_type, bill_time, bill_code, bill_codes, purchase_money, money_tax_price, discount_money, real_money, pay_money, give_money, reamrk, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        doc.supplyer_code,
        2,
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        -this.n(doc.all_money),
        -this.n(doc.all_money) + preferential,
        preferential,
        -realMoney,
        -retreatMoney,
        -arrears,
        doc.note,
        nowSec(),
      ],
    );

    // 2. 采购开票表（退货状态 +3）
    await this.q(
      `INSERT INTO kuerp_invoicing
       (admin_id, suppliers_code, status, bill_time, bill_code, bill_codes, money, tax, real_money, pay_money, give_money, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        doc.supplyer_code,
        this.n(doc.retreat_status) + 3,
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        realMoney - this.n(doc.tax_money),
        this.n(doc.tax_money),
        realMoney,
        0,
        realMoney,
        nowSec(),
      ],
    );

    // 3. 应付明细（bt=7 采购退回）
    const supplierId = await this.getSupplierId(doc.supplyer_code);
    await this.q(
      `INSERT INTO kuerp_accounts_copewith
       (admin_id, suppliers_id, purchase_time, purchase_code, business_type, receivable, remark, sale_money, receivable_money, amount, real_money, createtime, updatetime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        supplierId,
        this.n(doc.purchase_time),
        doc.purchase_code,
        7,
        -arrears,
        doc.note,
        this.r4(realMoney + preferential),
        realMoney,
        preferential,
        this.n(doc.pay_money),
        nowSec(),
        nowSec(),
      ],
    );

    // 4. 应付款余额扣减 + 应付退货核销源单
    if (arrears > 0 && supplierId) {
      await this.q(
        `UPDATE kuerp_suppliers SET need_give_account = need_give_account - ? WHERE id = ?`,
        [arrears, supplierId],
      );
      await this.q(
        `INSERT INTO kuerp_writeoff_source
         (admin_id, purchase_type, type, suppliers_code, purchase_code, purchase_time, price, money, write_off, remark)
         VALUES (?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          4,
          2, // 退货
          doc.supplyer_code,
          doc.purchase_code,
          this.n(doc.purchase_time),
          -realMoney,
          -this.n(doc.pay_money),
          -arrears,
          doc.note,
        ],
      );
    }
  }

  /**
   * 销货单资金联动：应收款余额 + 即时收款账户加钱(bt=5) + 销货收款一览表(bt=1) +
   * 销货开票表 + 应收明细(bt=6) + 应收核销源单 + 销售利润表。
   * @param doc 销货单表头
   */
  private async postSalesFunds(doc: any) {
    const arrears = this.n(doc.arrears);
    const payMoney = this.n(doc.pay_money);
    const realMoney = this.n(doc.real_money);
    const moneyTaxPrice = this.n(doc.money_tax_price);
    const customersMoney = this.n(doc.customers_money);
    const customersId = this.n(doc.customers_id);

    // 1. 即时收款：账户加钱 + 流水(bt=5)
    if (payMoney > 0 && this.n(doc.account) > 0) {
      const account = await this.getAccount(this.n(doc.account));
      if (account) {
        const deltas = new Map<number, number>();
        deltas.set(account.id, (deltas.get(account.id) || 0) + payMoney);
        await this.applyAccountDeltas(deltas);
        await this.insertAccountLogs([
          {
            accountId: account.id,
            accountCoding: account.account_coding,
            accountName: account.account_name,
            balance: this.n(account.balance) + payMoney,
            income: payMoney,
            expenditure: null,
            payTime: this.n(doc.purchase_time),
            billCode: doc.purchase_code,
            businessType: 5, // 销货
            customersId: customersId || null,
            remark: doc.note,
          },
        ]);
      }
    }

    // 2. 销货收款一览表（bt=1 销货）
    await this.q(
      `INSERT INTO kuerp_sales_payment_log
       (admin_id, customers_id, sale_user, business_type, bill_time, bill_code, bill_codes, purchase_money, discount_money, real_money, money_tax_price, pay_money, give_money, reamrk, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        customersId || null,
        this.n(doc.sale_user) || null,
        1,
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        this.n(doc.all_money),
        this.n(doc.preferential_money),
        realMoney,
        moneyTaxPrice,
        payMoney,
        arrears,
        doc.note,
        nowSec(),
      ],
    );

    // 3. 销货开票表（整单折扣开关决定开票金额口径）
    const setDiscount = await this.getSetChecked('discount');
    const invoiceMoney = setDiscount === 1 ? realMoney : moneyTaxPrice;
    await this.q(
      `INSERT INTO kuerp_sales_invoicing
       (admin_id, customers_id, status, bill_time, bill_code, bill_codes, money, tax, real_money, customers_money, pay_money, give_money, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        customersId || null,
        this.n(doc.pay_status),
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        realMoney,
        this.n(doc.tax_money),
        invoiceMoney,
        customersMoney,
        0,
        invoiceMoney,
        nowSec(),
      ],
    );

    // 4. 应收明细（bt=6 销货）
    await this.q(
      `INSERT INTO kuerp_accounts_receivable
       (admin_id, customers_id, purchase_time, purchase_code, business_type, receivable, staff_member_id, remark, sale_money, receivable_money, amount, cost, real_money, createtime, updatetime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        customersId,
        this.n(doc.purchase_time),
        doc.purchase_code,
        6,
        arrears,
        this.n(doc.sale_user) || null,
        doc.note,
        moneyTaxPrice,
        this.r4(realMoney + customersMoney),
        this.n(doc.preferential_money),
        customersMoney,
        payMoney,
        nowSec(),
        nowSec(),
      ],
    );

    // 5. 应收款余额 + 应收核销源单
    if (arrears > 0 && customersId > 0) {
      await this.q(
        `UPDATE kuerp_customers SET need_receive_account = need_receive_account + ? WHERE id = ?`,
        [arrears, customersId],
      );
      await this.q(
        `INSERT INTO kuerp_writeoff_source
         (admin_id, purchase_type, type, customers_id, purchase_code, purchase_time, price, money, write_off, remark)
         VALUES (?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          3, // 应收
          1, // 销货
          customersId,
          doc.purchase_code,
          this.n(doc.purchase_time),
          realMoney,
          payMoney,
          arrears,
          doc.note,
        ],
      );
    }

    // 6. 销售利润表
    const disRows: any[] = await this.q(
      `SELECT COALESCE(SUM(dis_money),0) AS amount FROM kuerp_goods_sales_info WHERE purchase_code = ?`,
      [doc.purchase_code],
    );
    const amount = this.n(disRows[0]?.amount) || null;
    await this.q(
      `INSERT INTO kuerp_goods_sales_profit
       (admin_id, purchase_time, customers_id, sale_user, preparation_id, purchase_code, purchase_type, number, amount, all_money, tax_money, money_tax_price, preferential_money, purchase_money, real_money, customers_money, need_money, pay_money, remark)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        this.n(doc.purchase_time),
        customersId || null,
        this.n(doc.sale_user) || null,
        this.n(doc.preparation_id) || null,
        doc.purchase_code,
        1,
        this.n(doc.number) || null,
        amount,
        this.n(doc.all_money),
        this.n(doc.tax_money),
        moneyTaxPrice,
        this.n(doc.preferential_money),
        this.n(doc.purchase_money),
        realMoney,
        customersMoney,
        this.r4(realMoney + customersMoney),
        payMoney,
        doc.note,
      ],
    );
  }

  /**
   * 销货退货单资金联动：应收款余额扣减 + 销货收款一览表(bt=2 取负) + 开票表(status+3) +
   * 应收明细(bt=7) + 应收退货核销源单。
   * @param doc 销货退货单表头
   */
  private async postSalesReturnFunds(doc: any) {
    const arrears = this.n(doc.arrears);
    const retreatMoney = this.n(doc.retreat_money);
    const realMoney = this.n(doc.real_money);
    const moneyTaxPrice = this.n(doc.money_tax_price);
    const customersMoney = this.n(doc.customers_money);
    const customersId = this.n(doc.customers_id);

    // 1. 销货收款一览表（bt=2 销货退回，金额取负）
    await this.q(
      `INSERT INTO kuerp_sales_payment_log
       (admin_id, customers_id, sale_user, business_type, bill_time, bill_code, bill_codes, purchase_money, discount_money, real_money, money_tax_price, pay_money, give_money, reamrk, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        customersId || null,
        this.n(doc.sale_user) || null,
        2,
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        -this.n(doc.all_money),
        this.n(doc.preferential_money),
        -realMoney,
        -moneyTaxPrice,
        -retreatMoney,
        -arrears,
        doc.note,
        nowSec(),
      ],
    );

    // 2. 销货开票表（退货状态 +3）
    const setDiscount = await this.getSetChecked('discount');
    const invoiceMoney = setDiscount === 1 ? realMoney : moneyTaxPrice;
    await this.q(
      `INSERT INTO kuerp_sales_invoicing
       (admin_id, customers_id, status, bill_time, bill_code, bill_codes, money, tax, real_money, customers_money, pay_money, give_money, createtime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        customersId || null,
        this.n(doc.retreat_status) + 3,
        this.n(doc.purchase_time),
        doc.purchase_code,
        doc.purchase_code,
        realMoney,
        this.n(doc.tax_money),
        invoiceMoney,
        customersMoney,
        0,
        invoiceMoney,
        nowSec(),
      ],
    );

    // 3. 应收明细（bt=7 销货退回）
    await this.q(
      `INSERT INTO kuerp_accounts_receivable
       (admin_id, customers_id, purchase_time, purchase_code, business_type, receivable, staff_member_id, remark, sale_money, receivable_money, amount, cost, real_money, createtime, updatetime)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        customersId,
        this.n(doc.purchase_time),
        doc.purchase_code,
        7,
        -arrears,
        this.n(doc.sale_user) || null,
        doc.note,
        moneyTaxPrice,
        this.r4(realMoney + customersMoney),
        this.n(doc.preferential_money),
        customersMoney,
        this.n(doc.pay_money),
        nowSec(),
        nowSec(),
      ],
    );

    // 4. 应收款余额扣减 + 应收退货核销源单
    if (arrears > 0 && customersId > 0) {
      await this.q(
        `UPDATE kuerp_customers SET need_receive_account = need_receive_account - ? WHERE id = ?`,
        [arrears, customersId],
      );
      await this.q(
        `INSERT INTO kuerp_writeoff_source
         (admin_id, purchase_type, type, customers_id, purchase_code, purchase_time, price, money, write_off, remark)
         VALUES (?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          3,
          2, // 退货
          customersId,
          doc.purchase_code,
          this.n(doc.purchase_time),
          -realMoney,
          -this.n(doc.pay_money),
          -arrears,
          doc.note,
        ],
      );
    }
  }

  /**
   * 库存类单据反审冲转：按单据号删除全部派生记录（流水/明细/开票/核销源单/费用/利润），
   * 按账户流水反向恢复余额，按公式恢复往来单位余额。
   * @param table 单据物理表名
   * @param id 单据主键
   */
  private async unpostStockFunds(
    table: string,
    id: number,
  ): Promise<{ reversed: number }> {
    const key = this.docKey(table);
    const kind = this.STOCK_FUND_DOCS[key].kind;
    const tableName = `kuerp_${key}`;
    const head: any[] = await this.q(
      `SELECT * FROM \`${tableName}\` WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!head.length) return { reversed: 0 };
    const doc = head[0];
    if (this.n(doc.examine_status) !== 1) return { reversed: 0 };
    const code = doc.purchase_code;
    const isBuy = kind === 'buy' || kind === 'buyReturn';

    // 1. 删除派生记录
    await this.q(
      `DELETE FROM kuerp_payment_log WHERE bill_code = ?`,
      [code],
    );
    await this.q(
      `DELETE FROM kuerp_sales_payment_log WHERE bill_code = ?`,
      [code],
    );
    await this.q(`DELETE FROM kuerp_invoicing WHERE bill_code = ?`, [
      code,
    ]);
    await this.q(
      `DELETE FROM kuerp_sales_invoicing WHERE bill_code = ?`,
      [code],
    );
    await this.q(
      `DELETE FROM kuerp_accounts_copewith WHERE purchase_code = ?`,
      [code],
    );
    await this.q(
      `DELETE FROM kuerp_accounts_receivable WHERE purchase_code = ?`,
      [code],
    );
    await this.q(
      `DELETE FROM kuerp_writeoff_source WHERE purchase_code = ?`,
      [code],
    );
    await this.q(
      `DELETE FROM kuerp_cost WHERE purchase_number = ?`,
      [code],
    );
    await this.q(
      `DELETE FROM kuerp_goods_sales_profit WHERE purchase_code = ?`,
      [code],
    );

    // 2. 恢复即时收付款产生的账户余额：读取本单据的账户流水反向后删除
    const bizTypes = isBuy ? [2] : [5];
    const accLogs: any[] = await this.q(
      `SELECT * FROM kuerp_accounts_log WHERE bill_code = ? AND business_type IN (?)`,
      [code, bizTypes],
    );
    const deltas = new Map<number, number>();
    for (const log of accLogs) {
      // 反向后删除：过账时支出=扣钱、收入=加钱，冲转即 加回支出、扣回收入
      const delta = this.n(log.expenditure) - this.n(log.income);
      // 账户ID未直接存于流水，按账户编号回查
      const accRows: any[] = await this.q(
        `SELECT id FROM kuerp_accounts WHERE account_coding = ? LIMIT 1`,
        [log.account_coding],
      );
      if (accRows.length) {
        deltas.set(
          accRows[0].id,
          (deltas.get(accRows[0].id) || 0) + delta,
        );
      }
    }
    await this.applyAccountDeltas(deltas);
    await this.q(
      `DELETE FROM kuerp_accounts_log WHERE bill_code = ? AND business_type IN (?)`,
      [code, bizTypes],
    );

    // 3. 恢复往来单位余额
    const arrears = this.n(doc.arrears);
    if (arrears !== 0) {
      if (kind === 'buy' || kind === 'buyReturn') {
        const supplierId = await this.getSupplierId(doc.supplyer_code);
        if (supplierId) {
          // 购货增加应付款、退货扣减，反审反向
          const back = kind === 'buy' ? -arrears : arrears;
          await this.q(
            `UPDATE kuerp_suppliers SET need_give_account = need_give_account + ? WHERE id = ?`,
            [back, supplierId],
          );
        }
      } else {
        const customersId = this.n(doc.customers_id);
        if (customersId > 0) {
          // 销货增加应收款、退货扣减，反审反向
          const back = kind === 'sell' ? -arrears : arrears;
          await this.q(
            `UPDATE kuerp_customers SET need_receive_account = need_receive_account + ? WHERE id = ?`,
            [back, customersId],
          );
        }
      }
    }
    return { reversed: 1 };
  }

  // =====================================================================
  // 私有小工具
  // =====================================================================

  /**
   * 按供应商编号查供应商ID。
   * @param code 供应商编号（supplyer_code）
   */
  private async getSupplierId(code: string): Promise<number> {
    if (!code) return 0;
    const rows: any[] = await this.q(
      `SELECT id FROM kuerp_suppliers WHERE supplyer_code = ? LIMIT 1`,
      [code],
    );
    return rows.length ? this.n(rows[0].id) : 0;
  }

  /**
   * 按供应商ID查供应商编号。
   * @param id 供应商ID
   */
  private async getSupplierCode(id: number): Promise<string | null> {
    if (!id) return null;
    const rows: any[] = await this.q(
      `SELECT supplyer_code FROM kuerp_suppliers WHERE id = ? LIMIT 1`,
      [id],
    );
    return rows.length ? rows[0].supplyer_code : null;
  }

  /**
   * 同步源单开票状态（采购/销货开票表及其日志表）。
   * @param invoicingTable 开票表名
   * @param logTable 开票日志表名
   * @param billCode 源单编号
   * @param status 新状态
   * @param offset 状态偏移（退货类 +3）
   */
  private async syncInvoiceStatus(
    invoicingTable: string,
    logTable: string,
    billCode: string,
    status: number,
    offset: number,
  ) {
    const finalStatus = status + offset;
    await this.q(
      `UPDATE \`${invoicingTable}\` SET status = ? WHERE bill_code = ?`,
      [finalStatus, billCode],
    );
    await this.q(
      `UPDATE \`${logTable}\` SET status = ? WHERE bill_code = ?`,
      [finalStatus, billCode],
    );
  }

  /**
   * 恢复源单开票状态到过账前快照。
   * @param invoicingTable 开票表名
   * @param logTable 开票日志表名
   * @param billCode 源单编号
   * @param oldStatus 过账前状态（0 表示无快照可恢复，跳过）
   */
  private async restoreInvoiceStatus(
    invoicingTable: string,
    logTable: string,
    billCode: string,
    oldStatus: number,
  ) {
    if (!oldStatus) return;
    await this.q(
      `UPDATE \`${invoicingTable}\` SET status = ? WHERE bill_code = ?`,
      [oldStatus, billCode],
    );
    await this.q(
      `UPDATE \`${logTable}\` SET status = ? WHERE bill_code = ?`,
      [oldStatus, billCode],
    );
  }

  /**
   * 写入一条销货收款一览表流水（核销单用）。
   */
  private async insertSalesPaymentLog(
    doc: any,
    customersId: number | null,
    businessType: number,
    info: any,
    payMoney: number,
  ) {
    await this.q(
      `INSERT INTO kuerp_sales_payment_log
       (admin_id, customers_id, business_type, bill_time, bill_code, bill_codes, pay_money, createtime)
       VALUES (?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        customersId,
        businessType,
        this.n(info.purchase_time) || nowSec(),
        info.purchase_number,
        info.purchase_code,
        payMoney,
        nowSec(),
      ],
    );
  }

  /**
   * 写入一条采购付款一览表流水（核销单用）。
   */
  private async insertPaymentLog(
    doc: any,
    suppliersCode: string | null,
    businessType: number,
    info: any,
    payMoney: number,
  ) {
    await this.q(
      `INSERT INTO kuerp_payment_log
       (admin_id, suppliers_code, business_type, bill_time, bill_code, bill_codes, pay_money, createtime)
       VALUES (?,?,?,?,?,?,?,?)`,
      [
        this.n(doc.admin_id) || null,
        suppliersCode,
        businessType,
        this.n(info.purchase_time) || nowSec(),
        info.purchase_number,
        info.purchase_code,
        payMoney,
        nowSec(),
      ],
    );
  }

  /**
   * 落库采购销售费用（kuerp_cost）。
   *
   * 业务类型与原系统 GoodsPurchase/GoodsSales/GoodsExchange/GoodsSalesExchange 一致：
   *   1=采购费用（购货单）  2=销售费用（销货单）
   *   3=采购退货费用（购货退货单）  4=销售退货费用（销货退货单）
   * 每行的 purchase_code 由「来源单号 + -COST + 行序号」构成，保证同一单据多次审核
   * （先反审再审核）不会与历史行冲突；反审时按 purchase_number 整单删除。
   *
   * @param doc 单据表头（含 cost_data：JSON 数组，元素为 {suppliers_id, expend_type_id, money, remark}）
   * @param kind 单据类型
   */
  private async postCostData(
    doc: any,
    kind: 'buy' | 'sell' | 'buyReturn' | 'sellReturn',
  ) {
    const items = this.parseCostData(doc.cost_data);
    if (!items.length) return;
    // 四类单据 -> 费用业务类型映射（与原系统一致）
    const bizType = kind === 'buy' ? 1 : kind === 'sell' ? 2 : kind === 'buyReturn' ? 3 : 4;
    const isBuySide = kind === 'buy' || kind === 'buyReturn';
    // 往来单位ID：采购类=供应商ID（按编号反查），销货类=客户ID（表头直接存）
    const unitId = isBuySide ? await this.getSupplierId(doc.supplyer_code) : this.n(doc.customers_id);
    let seq = 0;
    for (const item of items) {
      const money = this.n(item.money);
      if (money <= 0) continue; // 金额非正的行跳过
      seq += 1;
      await this.q(
        `INSERT INTO kuerp_cost
         (admin_id, purchase_code, purchase_time, business_type, suppliers_id, suppliers_ids, customers_id, expend_type_id, purchase_number, purchase_times, money, pay_money, remark, preparation_id, operation_id, createtime, updatetime)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
        [
          this.n(doc.admin_id) || null,
          `${doc.purchase_code}-COST${seq}`,
          this.n(doc.purchase_time),
          bizType,
          this.n(item.suppliers_id) || null,
          isBuySide ? unitId || null : null,
          isBuySide ? null : unitId || null,
          this.n(item.expend_type_id) || null,
          doc.purchase_code,
          this.n(doc.purchase_time),
          money,
          money, // pay_money 初始=金额，由其他支出单核销扣减
          item.remark ?? null,
          this.n(doc.preparation_id) || null,
          this.n(doc.operation_id) || null,
          nowSec(),
          nowSec(),
        ],
      );
    }
  }
}
