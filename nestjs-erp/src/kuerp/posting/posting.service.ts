import { Injectable, BadRequestException, Optional, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { nowSec } from '../../common/bigint.transformer';
import { runInTx, txQuery } from '../../common/tx/tx-context';
import { SummaryService } from './summary.service';

/**
 * 单据过账所需的归一化分录。
 * 将不同明细表的字段差异（数量/成本/仓库/属性）统一抽象为「进 / 出 / 调拨」三类动作，
 * 使过账与冲转逻辑只面对一套结构，屏蔽各单据表的字段命名差异。
 */
interface PostLine {
  goodsCode: string;      // 商品编号（关联 kuerp_goods）
  attr: number;           // 辅助属性组合ID（0=无属性）
  storesId: number;       // 仓库ID
  unit: number;           // 商品单位（goods_unit）
  customerId: number;     // 往来单位（供应商/客户）ID
  number: number;         // 原始数量（按商品单位，写入 goods_log.enter_number/out_number）
  qtyBase: number;        // 基本单位数量（库存计量，写入 goods_stock.stock）
  dir: 'in' | 'out';      // 进出方向
  unitCost: number;       // 单位成本（入库=入库价；出库=移动平均价，由过账时计算）
  useDetailCost?: boolean; // 出库腿若为真，则用单据明细存储成本而非仓库移动平均价（组装子件/拆卸组合件）
  logType: string;        // goods_log.business_type
  infoId: number;         // 明细行ID（批次/序列号日志的 order_id/purchase_id 关联）
  batchId: number;        // 明细所选批次ID（0=未选；批次管理商品必填）
  batchName: string;      // 批次名称（新建 goods_batch 主数据用）
  manufacture: number;    // 生产日期（秒）
  guarantee: number;      // 保质期（天）
  validity: number;       // 有效期至（秒）
  period: string;         // 序列号原文（PHP 序列化或 JSON 数组）
  unitPrice: number;      // 单价（批次日志记录用）
  taxIncluded: number;    // 含税单价（批次日志记录用）
  allMoney: number;       // 金额（批次日志记录用）
  taxMoney: number;       // 税额（批次日志记录用）
  moneyTaxPrice: number;  // 价税合计（批次日志记录用）
  remark: string;         // 备注（批次/序列号日志记录用）
  batchBt: number;        // goods_batch_log.business_type（枚举与 goods_log 不同）
  serialStatus: number;   // goods_serial.status（入库后状态）
  serialLink: string;     // goods_serial 关联字段名（purchase_id/sale_id/...）
}

/**
 * 过账累加器：在同一张单据内多行可能命中同一库存行，
 * 这里先在内存中按 (商品+属性+仓库) 聚合，最后一次性落库，避免同行重复读改写导致覆盖。
 */
interface StockState {
  id: number;             // 库存行 id（0=尚不存在，需 INSERT）
  stock: number;          // 聚合后的库存数量
  cost: number;           // 聚合后的库存总成本
  exists: boolean;        // 是否已存在于 kuerp_goods_stock
}

/**
 * 业务过账引擎：审核单据时联动库存 / 收发明细 / 商品总库存，并维护移动平均成本。
 *
 * 设计动机（对齐原酷柚易汛 Kuerp 的 examine 过账逻辑）：
 *   原系统「单据只有在审核后才会生效」——审核购货单会增加库存、审核销货单会扣减库存，
 *   同时往 kuerp_goods_log 写入收发明细、往 kuerp_goods.inventory 汇总总库存。
 *   本服务在 NestJS 侧等效还原该过账引擎，使仓库模块（库存余额 / 收发明细 / 收发汇总 /
 *   库存预警 / 商品期间）由「死数据」变为随单据审核实时联动的活数据。
 *
 * 成本模型（移动加权平均）：
 *   - goods_stock.cost_money 保存当前库存总成本，goods_stock.stock 保存当前库存数量，
 *     隐含单位成本 = cost_money / stock。
 *   - 入库：stock += qty；cost_money += qty * 入库单价（含税）。
 *   - 出库：按当前隐含平均价出库，stock -= qty；cost_money -= qty * 平均价（平均价保持不变）。
 *
 * 冲转（反审）：过账时已把每笔进出的成本数量写进 goods_log，反审时按 goods_log 记录
 *   逐笔反向冲减库存与成本，再删除对应 goods_log，从而精确撤销过账效果（与平均价计算无关）。
 */
@Injectable()
export class PostingService {
  /**
   * @param dataSource 数据库连接（动态表 SQL 全部走原生查询）
   * @param summary 汇总表同步服务（可选注入；单测直接 new 本服务时内部自建）
   */
  constructor(
    private readonly dataSource: DataSource,
    @Optional() private readonly summary?: SummaryService,
  ) {
    if (!this.summary) this.summary = new SummaryService(dataSource);
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

  /** 日志（库存策略告警、汇总同步失败等不阻断主流程的信息） */
  private readonly logger = new Logger(PostingService.name);

  /**
   * 执行一条 SQL。
   *
   * 关键点：优先走当前异步上下文的事务连接（由 post/unpost 用 runInTx 开启），
   * 没有事务时回落到连接池。这样过账过程中的几十处查询都能自动纳入同一事务，
   * 且不需要把 QueryRunner 一路传参。
   *
   * @param sql SQL 语句（表名/列名均在调用方做了白名单约束）
   * @param params 参数化绑定值
   * @returns 查询结果
   */
  private async q(sql: string, params?: any[]): Promise<any[]> {
    const inTxRows = await txQuery(sql, params);
    if (inTxRows !== null) return inTxRows;
    return await this.dataSource.query(sql, params);
  }

  /**
   * 读取负库存策略。
   *
   * 取值来自系统参数 kuerp_sets.name = 'stock_negative'：
   *   '0' 或空 = 禁止（默认，出库超库存直接报错）
   *   '1'      = 警告（允许过账，但写告警日志，适合先上车后治理）
   *   '2'      = 允许（不校验，仅个别老数据迁移期使用）
   *
   * 为什么默认「禁止」：原系统出库超库存会直接拒绝审核，
   * ERP 里放任负库存会同时破坏成本核算与库存预警口径。
   *
   * @returns 策略取值
   */
  private async negativeStockPolicy(): Promise<'deny' | 'warn' | 'allow'> {
    try {
      const rows = await this.q(
        `SELECT value FROM kuerp_sets WHERE name = 'stock_negative' LIMIT 1`,
      );
      const v = String(rows?.[0]?.value ?? '0');
      if (v === '1') return 'warn';
      if (v === '2') return 'allow';
      return 'deny';
    } catch {
      // 参数表缺失/查询异常时按最严格策略处理，宁可拒绝也不写错账
      return 'deny';
    }
  }

  /**
   * 对本次过账涉及的商品加行锁，串行化并发审核。
   *
   * 【为什么锁 kuerp_goods 而不是 kuerp_goods_stock】
   * 库存行可能尚不存在（首次入库），对不存在的行 FOR UPDATE 什么也锁不住，
   * 两个并发请求会各自 INSERT 出重复库存行。商品主档一定存在，
   * 用它当互斥锚点可保证「同一商品的过账串行执行」。
   *
   * 【为什么排序】
   * 多商品单据并发时，若各自按不同顺序加锁会形成环路死锁（A 等 B、B 等 A）。
   * 统一按 goods_code 升序加锁即可消除环路。
   *
   * @param lines 归一化后的分录
   */
  private async lockGoodsRows(lines: PostLine[]): Promise<void> {
    const codes = [...new Set(lines.map((l) => l.goodsCode).filter(Boolean))].sort();
    for (const code of codes) {
      await this.q('SELECT id FROM kuerp_goods WHERE goods_code = ? LIMIT 1 FOR UPDATE', [code]);
    }
    // 再对已存在的库存行加锁：保证读取到的 stock 在事务提交前不被他人改动
    const keys = [...new Set(lines.map((l) => `${l.goodsCode}|${l.attr}|${l.storesId}`))].sort();
    for (const k of keys) {
      const [code, attr, stores] = k.split('|');
      let sql = 'SELECT id FROM kuerp_goods_stock WHERE goods_code = ? AND stores_id = ?';
      const params: any[] = [code, Number(stores)];
      if (Number(attr) > 0) {
        sql += ' AND attribute_id = ?';
        params.push(Number(attr));
      }
      await this.q(`${sql} LIMIT 1 FOR UPDATE`, params);
    }
  }

  /**
   * 单据表 -> 过账定义映射。
   * 仅这些表的审核会触发库存过账；其余表（资料/配置/资金单据等）审核仅翻转状态。
   */
  private readonly DOCS: Record<
    string,
    {
      info: string;
      byCode: boolean;
      codeField: string;
      kind:
        | 'buy' | 'sell' | 'buyReturn' | 'sellReturn'
        | 'otherIn' | 'otherOut' | 'transfer' | 'adjust' | 'inventory'
        // 组装单：子件出库(13) + 组合件入库(12)；拆卸单：组合件出库(14) + 子件入库(15)
        | 'assemble' | 'split';
    }
  > = {
    goods_purchase: { info: 'kuerp_goods_purchase_info', byCode: true, codeField: 'purchase_code', kind: 'buy' },
    goods_exchange: { info: 'kuerp_goods_exchange_info', byCode: true, codeField: 'purchase_code', kind: 'buyReturn' },
    goods_sales: { info: 'kuerp_goods_sales_info', byCode: true, codeField: 'purchase_code', kind: 'sell' },
    goods_sales_exchange: { info: 'kuerp_goods_sales_exchange_info', byCode: true, codeField: 'purchase_code', kind: 'sellReturn' },
    warehousing: { info: 'kuerp_warehousing_info', byCode: true, codeField: 'purchase_code', kind: 'otherIn' },
    warehouse: { info: 'kuerp_warehouse_info', byCode: true, codeField: 'purchase_code', kind: 'otherOut' },
    allocation: { info: 'kuerp_allocation_info', byCode: false, codeField: 'allocation_id', kind: 'transfer' },
    adjustment: { info: 'kuerp_adjustment_info', byCode: true, codeField: 'purchase_code', kind: 'adjust' },
    inventory: { info: 'kuerp_inventory_info', byCode: true, codeField: 'purchase_code', kind: 'inventory' },
    assemble: { info: 'kuerp_assemble_info', byCode: true, codeField: 'purchase_code', kind: 'assemble' },
    split: { info: 'kuerp_split_info', byCode: true, codeField: 'purchase_code', kind: 'split' },
  };

  /** 是否為支持库存过账的单据表 */
  isDocTable(table: string): boolean {
    return Object.prototype.hasOwnProperty.call(this.DOCS, this.docKey(table));
  }

  /**
   * 归一化单据表名到 DOCS 键：物理表名带 kuerp_ 前缀（kuerp_goods_purchase），
   * 而 DOCS 配置键不含前缀（goods_purchase），此处统一剥离以便查表。
   * @param table 物理表名或裸表名
   */
  private docKey(table: string): string {
    return table.replace(/^kuerp_/, '');
  }

  /**
   * 把一张单据的明细归一化为进出分录数组。
   * @param table 物理单据表名
   * @param header 单据表头行
   */
  private async normalize(table: string, header: any): Promise<PostLine[]> {
    const def = this.DOCS[this.docKey(table)];
    // 关联明细：多数按单据编号，调拨单按表头主键
    const linkVal = def.byCode ? header.purchase_code : header.id;
    const infoRows: any[] = await this.q(
      `SELECT * FROM \`${def.info}\` WHERE \`${def.codeField}\` = ?`,
      [linkVal],
    );
    const customerId = this.n(
      header.supplyer_code
        ? (await this.supplierId(header.supplyer_code))
        : header.customers_id,
    );
    const lines: PostLine[] = [];
    // 单据类型 -> 批次/序列号联动默认值（batchBt 为 goods_batch_log 枚举，与 goods_log 不同）
    const bs = (
      batchBt: number,
      serialStatus: number,
      serialLink: string,
    ) => ({ batchBt, serialStatus, serialLink });

    for (const r of infoRows) {
      const base = this.n(r.basic_nmber) || this.n(r.number); // 基本数量优先
      const common = {
        goodsCode: r.goods_code,
        attr: this.n(r.goods_attr),
        storesId: this.n(r.stores_id),
        unit: this.n(r.goods_unit),
        customerId,
        number: this.n(r.number),
        qtyBase: base,
        infoId: this.n(r.id),
        batchId: this.n(r.batch_id),
        batchName: r.batch_name || '',
        manufacture: this.n(r.manufacture),
        guarantee: this.n(r.guarantee),
        validity: this.n(r.validity),
        period: r.period || '',
        unitPrice: this.n(r.unit_price),
        taxIncluded: this.n(r.tax_included),
        allMoney: this.n(r.all_money),
        taxMoney: this.n(r.tax_money),
        moneyTaxPrice: this.n(r.money_tax_price),
        remark: r.remark || '',
        ...bs(0, 0, 'order_id'),
      };
      switch (def.kind) {
        case 'buy': // 购货单 → 入库(2)，成本=含税单价
          lines.push({ ...common, dir: 'in', unitCost: this.n(r.tax_included) || this.n(r.unit_price), logType: '2', ...bs(2, 1, 'purchase_id') });
          break;
        case 'buyReturn': // 购货退货 → 出库(3)，按移动平均价
          lines.push({ ...common, dir: 'out', unitCost: 0, logType: '3', ...bs(3, 2, 'purchase_exchange_id') });
          break;
        case 'sell': // 销货单/零售 → 出库(4)，按移动平均价
          lines.push({ ...common, dir: 'out', unitCost: 0, logType: '4', ...bs(4, 3, 'sale_id') });
          break;
        case 'sellReturn': // 销货退货 → 入库(5)，成本=成本价/含税价
          lines.push({ ...common, dir: 'in', unitCost: this.n(r.cost_price) || this.n(r.tax_included) || this.n(r.unit_price), logType: '5', ...bs(5, 4, 'sale_exchange_id') });
          break;
        case 'otherIn': // 其他入库/盘盈入库 → 入库，成本=入库单价
          lines.push({
            ...common, dir: 'in', unitCost: this.n(r.unit_price) || this.n(r.tax_included),
            logType: this.n(header.business_type) === 1 ? '8' : '9',
            ...bs(this.n(header.business_type) === 1 ? 8 : 7, this.n(header.business_type) === 1 ? 8 : 7, 'warehousing_id'),
          });
          break;
        case 'otherOut': // 其他出库/盘亏出库 → 出库
          lines.push({
            ...common, dir: 'out', unitCost: 0,
            logType: this.n(header.business_type) === 1 ? '10' : '11',
            ...bs(this.n(header.business_type) === 1 ? 10 : 9, this.n(header.business_type) === 1 ? 10 : 9, 'warehoue_id'),
          });
          break;
        case 'transfer': {
          // 调拨：调出仓出库(6) + 调入仓入库(6)，成本=调出仓移动平均价，两腿同价
          // 注意：allocation_info 的批次字段名为 goods_batch_id/goods_batch_name，序列号在 goods_serial_id
          // 多单位：单据 number 按单位换算成基本数量（对齐 PHP Allocation.php:551-562）
          const lineNumber = this.n(r.number);
          let qty = lineNumber;
          if (lineNumber > 0) {
            const baseUnit = await this.goodsBaseUnit(r.goods_code);
            const lineUnit = this.n(r.goods_unit);
            if (baseUnit && lineUnit && baseUnit !== lineUnit) {
              const rate = await this.unitAdvanceRate(baseUnit, lineUnit);
              if (rate <= 0) throw new BadRequestException(`商品 ${r.goods_code} 单位换算信息缺失，无法过账`);
              qty = this.r4(lineNumber * rate);
            }
          }
          const tCommon = {
            goodsCode: r.goods_code, attr: this.n(r.goods_attr), unit: this.n(r.goods_unit),
            infoId: this.n(r.id), batchId: this.n(r.goods_batch_id) || this.n(r.batch_id),
            batchName: r.goods_batch_name || r.batch_name || '',
            manufacture: this.n(r.manufacture), guarantee: this.n(r.guarantee), validity: this.n(r.validity),
            period: r.goods_serial_id || r.period || '',
            unitPrice: 0, taxIncluded: 0, allMoney: 0, taxMoney: 0, moneyTaxPrice: 0,
            remark: r.remarks || r.remark || '', ...bs(6, 6, 'order_id'),
          };
          lines.push({ ...tCommon, storesId: this.n(r.stores_out), customerId, number: lineNumber, qtyBase: qty, dir: 'out', unitCost: 0, logType: '6' });
          lines.push({ ...tCommon, storesId: this.n(r.stores_enter), customerId, number: lineNumber, qtyBase: qty, dir: 'in', unitCost: 0, logType: '6' });
          break;
        }
        case 'adjust': {
          // 成本调整(7)：不改变数量，仅按金额调整总成本；金额暂存 enter_cost 供冲转取回
          // 注意：adjustment_info 只有 goods_id 无 goods_code，需反查商品编号
          lines.push({
            goodsCode: r.goods_code || (await this.goodsCodeById(this.n(r.goods_id))), attr: 0, storesId: this.n(r.stores_id), unit: this.n(r.goods_unit),
            customerId, number: 0, qtyBase: 0, dir: 'in', unitCost: 0, logType: '7',
            infoId: this.n(r.id), batchId: 0, batchName: '', manufacture: 0, guarantee: 0, validity: 0,
            period: '', unitPrice: 0, taxIncluded: 0, allMoney: 0, taxMoney: 0, moneyTaxPrice: 0, remark: '',
            ...bs(0, 0, 'order_id'),
          });
          // 调整金额挂在行上（复用 remark 之外的专用通道：临时存到 lines 的 unitCost 不可用，
          // 这里直接把金额写进 qtyBase 旁的私有字段不可行，故单独存到 map）
          (lines as any).adjustMoney = (lines as any).adjustMoney || [];
          (lines as any).adjustMoney.push(this.n(r.money));
          break;
        }
        case 'inventory': {
          // 盘点：盘盈入库(8)/盘亏出库(10)，数量=盘点库存-系统库存
          // 注意：inventory_info 只有 goods_id 无 goods_code，需反查商品编号
          const goodsCode = r.goods_code || (await this.goodsCodeById(this.n(r.goods_id)));
          const profit = this.n(r.profit) || (this.n(r.invertory_stock) - this.n(r.stock));
          if (profit === 0) break;
          const bt = profit > 0 ? 7 : 9; // 批次枚举：7=盘盈, 9=盘亏
          lines.push({
            goodsCode, attr: this.n(r.goods_attr), storesId: this.n(r.stores_id),
            unit: this.n(r.goods_unit), customerId, number: Math.abs(profit), qtyBase: Math.abs(profit),
            dir: profit > 0 ? 'in' : 'out', unitCost: 0,
            logType: profit > 0 ? '8' : '10',
            infoId: this.n(r.id), batchId: this.n(r.batch_id), batchName: r.batch_name || '',
            manufacture: this.n(r.manufacture), guarantee: this.n(r.guarantee), validity: this.n(r.validity),
            period: r.period || '', unitPrice: this.n(r.unit_price), taxIncluded: 0, allMoney: 0, taxMoney: 0,
            moneyTaxPrice: 0, remark: r.remark || '', ...bs(bt, bt, 'order_id'),
          });
          break;
        }
        case 'assemble': {
          // 组装单：子件(type=2)出库(13) + 组合件(type=1)入库(12)。
          // 组合件入库成本取明细行的 cost_money（原系统把组装费用一并摊入组合件成本）。
          const isMain = this.n(r.type) === 1; // 1=组合件，2=子件
          const qty = this.n(r.basic_number) || this.n(r.number);
          const unitCost = this.n(r.unit_cost) || (qty ? this.r4(this.n(r.cost_money) / qty) : 0);
          lines.push({
            goodsCode: r.goods_code, attr: this.n(r.goods_attr), storesId: this.n(r.stores_id),
            unit: this.n(r.goods_unit), customerId,
            number: this.n(r.number), qtyBase: qty,
            dir: isMain ? 'in' : 'out', unitCost, useDetailCost: !isMain, // 子件出库用明细存储成本（对齐 PHP）
            logType: isMain ? '12' : '13',
            infoId: this.n(r.id), batchId: this.n(r.batch_id), batchName: r.batch || r.batch_name || '',
            manufacture: this.n(r.manufacture), guarantee: this.n(r.guarantee), validity: this.n(r.validity),
            period: r.period || '',
            unitPrice: this.n(r.unit_cost), taxIncluded: this.n(r.unit_cost),
            allMoney: this.n(r.cost_money), taxMoney: 0, moneyTaxPrice: this.n(r.cost_money),
            remark: r.remark || '',
            // 批次枚举：11=组合件入库、12=子件出库；序列号状态：11=组合单入库、12=组合单出库
            ...bs(isMain ? 11 : 12, isMain ? 11 : 12, 'assemble_id'),
          });
          break;
        }
        case 'split': {
          // 拆卸单：组合件(type=1)出库(14) + 子件(type=2)入库(15)。
          // 子件入库成本取明细行的 cost_money（原系统把拆卸费用一并摊入子件成本）。
          const isMain = this.n(r.type) === 1; // 1=组合件，2=子件
          const qty = this.n(r.basic_number) || this.n(r.number);
          const unitCost = this.n(r.unit_cost) || (qty ? this.r4(this.n(r.cost_money) / qty) : 0);
          lines.push({
            goodsCode: r.goods_code, attr: this.n(r.goods_attr), storesId: this.n(r.stores_id),
            unit: this.n(r.goods_unit), customerId,
            number: this.n(r.number), qtyBase: qty,
            dir: isMain ? 'out' : 'in', unitCost, useDetailCost: isMain, // 组合件出库用明细存储成本（对齐 PHP）
            logType: isMain ? '14' : '15',
            infoId: this.n(r.id), batchId: this.n(r.batch_id), batchName: r.batch || r.batch_name || '',
            manufacture: this.n(r.manufacture), guarantee: this.n(r.guarantee), validity: this.n(r.validity),
            period: r.period || '',
            unitPrice: this.n(r.unit_cost), taxIncluded: this.n(r.unit_cost),
            allMoney: this.n(r.cost_money), taxMoney: 0, moneyTaxPrice: this.n(r.cost_money),
            remark: r.remark || '',
            // 批次枚举：13=组合件出库、14=子件入库；序列号状态：13=拆卸单出库、14=拆卸单入库
            ...bs(isMain ? 13 : 14, isMain ? 13 : 14, 'split_id'),
          });
          break;
        }
      }
    }
    return lines;
  }

  /** 依供应商编号取供应商ID（往来单位写入 goods_log.customer_id） */
  private async supplierId(code: string): Promise<number> {
    const rows: any[] = await this.q(
      `SELECT id FROM kuerp_suppliers WHERE supplyer_code = ? LIMIT 1`,
      [code],
    );
    return rows[0] ? this.n(rows[0].id) : 0;
  }

  /** 依商品ID反查商品编号（盘点/成本调整明细仅有 goods_id） */
  private async goodsCodeById(id: number): Promise<string> {
    if (!id) return '';
    const rows: any[] = await this.q(
      `SELECT goods_code FROM kuerp_goods WHERE id = ? LIMIT 1`,
      [id],
    );
    return rows[0] ? String(rows[0].goods_code) : '';
  }

  /** 依商品编号取基本单位ID（kuerp_goods.unit_id） */
  private async goodsBaseUnit(code: string): Promise<number> {
    const rows: any[] = await this.q(
      `SELECT unit_id FROM kuerp_goods WHERE goods_code = ? LIMIT 1`,
      [code],
    );
    return rows.length ? this.n(rows[0].unit_id) : 0;
  }

  /**
   * 取单位换算进率：基本单位(baseUnit) -> 单据单位(viceUnit)。
   * 对齐 PHP：kuerp_unit_conversion WHERE main_unit=baseUnit AND vice_unit=viceUnit。
   * 返回 0 表示找不到换算（调用方应报错，与原系统「商品单位信息查询失败」一致）。
   */
  private async unitAdvanceRate(baseUnit: number, viceUnit: number): Promise<number> {
    if (!baseUnit || !viceUnit || baseUnit === viceUnit) return 1;
    const rows: any[] = await this.q(
      `SELECT advance_rate FROM kuerp_unit_conversion WHERE main_unit = ? AND vice_unit = ? LIMIT 1`,
      [baseUnit, viceUnit],
    );
    return rows.length ? this.n(rows[0].advance_rate) : 0;
  }

  /**
   * 读取（或初始化累加器中的）某商品在某仓库(含属性)的库存状态。
   * 属性为 0 时不按属性过滤（与原系统一致：无属性商品匹配任一库存行）。
   */
  private async resolveStock(
    acc: Map<string, StockState>,
    goodsCode: string,
    attr: number,
    storesId: number,
  ): Promise<{ key: string; state: StockState }> {
    const key = `${goodsCode}|${attr}|${storesId}`;
    const cached = acc.get(key);
    if (cached) return { key, state: cached };
    let sql = `SELECT id, stock, cost_money FROM kuerp_goods_stock WHERE goods_code = ? AND stores_id = ?`;
    const params: any[] = [goodsCode, storesId];
    if (attr > 0) {
      sql += ` AND attribute_id = ?`;
      params.push(attr);
    }
    sql += ' LIMIT 1';
    const rows: any[] = await this.q(sql, params);
    if (rows.length) {
      const st: StockState = { id: this.n(rows[0].id), stock: this.n(rows[0].stock), cost: this.n(rows[0].cost_money), exists: true };
      acc.set(key, st);
      return { key, state: st };
    }
    const st: StockState = { id: 0, stock: 0, cost: 0, exists: false };
    acc.set(key, st);
    return { key, state: st };
  }

  /**
   * 审核过账：把单据写入库存 / 收发明细 / 商品总库存。
   *
   * 整体包在一个事务里：任一步失败（库存不足、批次不存在、金额异常）都整体回滚，
   * 不会留下「库存加了但收发明细没写」这类半截数据。
   *
   * @param table 物理单据表名
   * @param id 单据主键
   * @returns 过账的分录数
   */
  async post(table: string, id: number): Promise<{ posted: number }> {
    if (!this.isDocTable(table)) return { posted: 0 };
    return await runInTx(this.dataSource, () => this.postInner(table, id));
  }

  /**
   * 过账主体（须在事务内执行，见 post）。
   * @param table 物理单据表名
   * @param id 单据主键
   * @returns 过账的分录数
   */
  private async postInner(table: string, id: number): Promise<{ posted: number }> {
    const header: any[] = await this.q(
      `SELECT * FROM \`${table}\` WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!header.length) throw new BadRequestException('单据不存在');
    const head = header[0];
    // 防重复过账：仅未审核单据可过账
    if (this.n(head.examine_status) === 1) return { posted: 0 };

    const lines = await this.normalize(table, head);

    // —— 并发保护：先对本单涉及的商品/库存行加锁，再读库存 ——
    // 顺序很关键：必须在 normalize 之后（此时才知道涉及哪些商品），
    // 但必须在任何库存读取之前，否则读到的是可能被并发改写的旧值。
    await this.lockGoodsRows(lines);
    const stockPolicy = await this.negativeStockPolicy();

    const stockAcc = new Map<string, StockState>();     // 库存行累加器
    const goodsInv = new Map<number, number>();         // 商品总库存增量（goods_id -> delta）
    const goodsIdByCode = new Map<string, number>();    // 商品编号 -> id 缓存
    const transferCost = new Map<string, number>();     // 调拨：源仓出库移动平均价（供调入腿按同价入库）
    const logs: any[] = [];                             // goods_log 待插入行
    const adjustMoney = (lines as any).adjustMoney as number[] | undefined;
    let adjustIdx = 0;

    // —— 批次/序列号联动所需上下文（原系统 examine 同款逻辑）——
    const sets = await this.setsFlags();                // 系统参数：批次/序列号总开关
    const goodsFlags = new Map<string, { batch: boolean; serial: boolean }>(); // 商品批次/序列号开关缓存
    const batchAcc = new Map<string, { id: number; stock: number; exists: boolean }>(); // 批次库存累加器
    const batchLogs: any[] = [];                        // goods_batch_log 待插入行
    const serialInserts: any[] = [];                    // goods_serial 待插入行（入库）
    const serialUpdates: any[] = [];                    // goods_serial 待更新行（出库）
    const serialLogs: any[] = [];                       // goods_serial_log 待插入行

    for (const ln of lines) {
      // 商品ID（写 goods.inventory 与 goods_log.goods_id 用）
      let goodsId = goodsIdByCode.get(ln.goodsCode);
      if (goodsId === undefined) {
        const g: any[] = await this.q(
          `SELECT id FROM kuerp_goods WHERE goods_code = ? LIMIT 1`,
          [ln.goodsCode],
        );
        if (!g.length) throw new BadRequestException(`商品 ${ln.goodsCode} 不存在，无法过账`);
        goodsId = this.n(g[0].id);
        goodsIdByCode.set(ln.goodsCode, goodsId);
      }

      const { state } = await this.resolveStock(stockAcc, ln.goodsCode, ln.attr, ln.storesId);
      const curUnit = state.stock > 0 ? state.cost / state.stock : 0; // 当前移动平均单位成本

      // —— 成本调整单独处理：仅改总成本，不动数量 ——
      if (ln.logType === '7') {
        const money = adjustMoney ? adjustMoney[adjustIdx++] : 0;
        state.cost = this.r4(state.cost + money);
        logs.push(this.logRow(head, ln, goodsId, { enterCost: money }));
        continue;
      }

      if (ln.dir === 'in') {
        // 调拨调入腿：按源仓出库时的移动平均价入库，保持调拨两腿同价
        if (ln.logType === '6') {
          const cached = transferCost.get(`${ln.goodsCode}|${ln.attr}`);
          if (cached !== undefined) ln.unitCost = cached;
        }
        const qty = ln.qtyBase;
        const inCost = this.r4(ln.unitCost * qty);
        state.stock = this.r4(state.stock + qty);
        state.cost = this.r4(state.cost + inCost);
        goodsInv.set(goodsId, (goodsInv.get(goodsId) || 0) + qty);
        logs.push(this.logRow(head, ln, goodsId, { enterCost: inCost }, { stock: state.stock, cost: state.cost }));
      } else {
        const qty = ln.qtyBase;
        // 库存充足性校验（出库）：策略由系统参数 stock_negative 控制
        if (qty > state.stock + 1e-6) {
          const shortfall = this.r4(qty - state.stock);
          if (stockPolicy === 'deny') {
            throw new BadRequestException(
              `商品 ${ln.goodsCode} 在仓库库存不足（可用 ${state.stock}，需 ${qty}，缺 ${shortfall}），无法过账`,
            );
          }
          // warn / allow：放行，但记录告警，便于事后追查负库存来源
          this.logger.warn(
            `负库存放行：单据 ${head.purchase_code || id} 商品 ${ln.goodsCode} ` +
            `仓库 ${ln.storesId} 出库 ${qty} > 库存 ${state.stock}（策略=${stockPolicy}）`,
          );
        }
        // 出库单位成本：默认用当前移动平均价（cost_money/stock）；
        // 但组装子件/拆卸组合件出库应取单据明细存储成本（useDetailCost），由 normalize 已写入 ln.unitCost
        if (!ln.useDetailCost) ln.unitCost = curUnit;
        // 调拨出库腿：缓存源仓移动平均价，供随后的调入腿按同价入库
        if (ln.logType === '6') transferCost.set(`${ln.goodsCode}|${ln.attr}`, curUnit);
        const outCost = this.r4(ln.unitCost * qty);
        state.stock = this.r4(state.stock - qty);
        state.cost = this.r4(state.cost - outCost);
        goodsInv.set(goodsId, (goodsInv.get(goodsId) || 0) - qty);
        logs.push(this.logRow(head, ln, goodsId, { outCost }, { stock: state.stock, cost: state.cost }));
      }

      // —— 批次/序列号联动（在库存逻辑之后逐行处理）——
      await this.applyBatchSerial(
        head, ln, goodsId, sets, goodsFlags,
        batchAcc, batchLogs, serialInserts, serialUpdates, serialLogs,
      );
    }

    await this.flushStock(stockAcc, head);
    await this.flushGoodsInv(goodsInv);
    await this.insertLogs(logs);
    // —— 业务汇总表同步（采购/销售汇总表、销售利润表：报表页的数据源）——
    // 必须在 insertLogs 之后：销售利润表的「销售成本」取自本单刚写入的 goods_log.out_cost。
    // 注：汇总表由 SummaryService 用自己的连接写入，不参与本事务；因此这里捕获异常只告警，
    // 不让「报表同步失败」把已经算好的库存过账整体回滚（可从报表页重算补齐）。
    try {
      await this.summary.syncOnPost(table, head, this.n(head.examine_id) || undefined);
    } catch (e: any) {
      this.logger.error(`单据 ${head.purchase_code || id} 汇总表同步失败：${e?.message || e}`);
    }
    await this.flushBatch(batchAcc);
    this.insertRows('kuerp_goods_batch_log', batchLogs);
    this.insertRows('kuerp_goods_serial', serialInserts);
    await this.applySerialUpdates(serialUpdates);
    this.insertRows('kuerp_goods_serial_log', serialLogs);
    return { posted: logs.length };
  }

  // ============================================================
  //  批次 / 序列号联动（对齐原系统 examine 过账）
  // ============================================================

  /** 读取系统参数中的批次/序列号总开关（kuerp_sets.name = batch / serial） */
  private async setsFlags(): Promise<{ batch: boolean; serial: boolean }> {
    const rows: any[] = await this.q(
      `SELECT name, is_checked FROM kuerp_sets WHERE name IN ('batch','serial')`,
    );
    const m: Record<string, number> = {};
    for (const r of rows) m[r.name] = this.n(r.is_checked);
    return { batch: m['batch'] === 1, serial: m['serial'] === 1 };
  }

  /** 读取商品的批次/序列号开关（kuerp_goods.batch / serial），带缓存 */
  private async goodsFlagsCached(
    code: string,
    cache: Map<string, { batch: boolean; serial: boolean }>,
  ): Promise<{ batch: boolean; serial: boolean }> {
    const hit = cache.get(code);
    if (hit) return hit;
    const rows: any[] = await this.q(
      `SELECT batch, serial FROM kuerp_goods WHERE goods_code = ? LIMIT 1`,
      [code],
    );
    const f = {
      batch: rows.length ? this.n(rows[0].batch) === 1 : false,
      serial: rows.length ? this.n(rows[0].serial) === 1 : false,
    };
    cache.set(code, f);
    return f;
  }

  /**
   * 单行批次/序列号联动（原系统 examine 的核心逻辑）：
   * - 批次：入库时 find-or-create 批次主数据 + 批次库存累加；出库时批次库存扣减（不足报错）。
   *   两种方向都写 goods_batch_log 批次跟踪流水。
   * - 序列号：入库时校验序列号未占用后插入 goods_serial（在库）；出库时校验在库后置为出库。
   *   两种方向都写 goods_serial_log 序列号跟踪流水。
   */
  private async applyBatchSerial(
    head: any,
    ln: PostLine,
    goodsId: number,
    sets: { batch: boolean; serial: boolean },
    goodsFlags: Map<string, { batch: boolean; serial: boolean }>,
    batchAcc: Map<string, { id: number; stock: number; exists: boolean }>,
    batchLogs: any[],
    serialInserts: any[],
    serialUpdates: any[],
    serialLogs: any[],
  ): Promise<void> {
    const gf = await this.goodsFlagsCached(ln.goodsCode, goodsFlags);

    // —— 批次联动 ——
    if (sets.batch && gf.batch && ln.batchBt > 0) {
      let batchId = ln.batchId;
      if (!batchId) {
        if (!ln.batchName) {
          throw new BadRequestException(`商品 ${ln.goodsCode} 启用批次管理，请选择生产批次`);
        }
        // 按 (商品+属性+仓库+批次名) 找或建批次主数据
        let rows: any[] = await this.q(
          `SELECT id FROM kuerp_goods_batch
            WHERE goods_id = ? AND stores_id = ? AND batch_name = ?` +
            (ln.attr > 0 ? ' AND attribute_id = ?' : ''),
          ln.attr > 0 ? [goodsId, ln.storesId, ln.batchName, ln.attr] : [goodsId, ln.storesId, ln.batchName],
        );
        if (!rows.length) {
          await this.q(
            `INSERT INTO kuerp_goods_batch
               (admin_id, goods_id, goods_code, attribute_id, stores_id, batch_name, manufacture, guarantee, validity, createtime, updatetime)
             VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
            [this.n(head.admin_id), goodsId, ln.goodsCode, ln.attr, ln.storesId, ln.batchName,
              ln.manufacture || null, ln.guarantee || null, ln.validity || null, nowSec(), nowSec()],
          );
          rows = await this.q(
            `SELECT id FROM kuerp_goods_batch
              WHERE goods_id = ? AND stores_id = ? AND batch_name = ?` +
              (ln.attr > 0 ? ' AND attribute_id = ?' : ''),
            ln.attr > 0 ? [goodsId, ln.storesId, ln.batchName, ln.attr] : [goodsId, ln.storesId, ln.batchName],
          );
        }
        batchId = rows.length ? this.n(rows[0].id) : 0;
      }
      if (!batchId) throw new BadRequestException(`商品 ${ln.goodsCode} 批次信息无效，无法过账`);

      // 批次库存行累加器（key = 批次库存行主键，避免同行重复读写）
      const key = `${batchId}|${ln.goodsCode}|${ln.attr}|${ln.storesId}`;
      let st = batchAcc.get(key);
      if (!st) {
        const rows: any[] = await this.q(
          `SELECT id, stock FROM kuerp_goods_batch_stock
            WHERE batch_id = ? AND goods_code = ? AND stores_id = ?` +
            (ln.attr > 0 ? ' AND attribute_id = ?' : ''),
          ln.attr > 0 ? [batchId, ln.goodsCode, ln.storesId, ln.attr] : [batchId, ln.goodsCode, ln.storesId],
        );
        st = rows.length
          ? { id: this.n(rows[0].id), stock: this.n(rows[0].stock), exists: true }
          : { id: 0, stock: 0, exists: false };
        batchAcc.set(key, st);
      }
      if (ln.dir === 'in') {
        st.stock = this.r4(st.stock + ln.qtyBase);
      } else {
        if (ln.qtyBase > st.stock + 1e-6) {
          throw new BadRequestException(`商品 ${ln.goodsCode} 批次库存不足，无法过账`);
        }
        st.stock = this.r4(st.stock - ln.qtyBase);
      }
      // 批次跟踪流水（number 统一记基本数量，供反审精确冲转）
      batchLogs.push({
        admin_id: this.n(head.admin_id),
        goods_id: goodsId,
        unit_price: ln.unitPrice,
        tax_included: ln.taxIncluded,
        all_money: ln.allMoney,
        tax_money: ln.taxMoney,
        money_tax_price: ln.moneyTaxPrice,
        goods_unit: ln.unit,
        stores_id: ln.storesId,
        batch_id: batchId,
        number: ln.qtyBase,
        purchase_code: head.purchase_code,
        purchase_time: this.n(head.purchase_time),
        business_type: String(ln.batchBt),
        customer_id: ln.customerId,
        remarks: ln.remark || null,
        order_id: ln.infoId,
        createtime: nowSec(),
        updatetime: nowSec(),
      });
    }

    // —— 序列号联动 ——
    if (sets.serial && gf.serial && ln.period) {
      const serials = this.parsePeriod(ln.period);
      if (!serials.length) {
        throw new BadRequestException(`商品 ${ln.goodsCode} 启用序列号管理，请输入序列号`);
      }
      const link = this.serialLinkFields(ln.serialLink, ln.infoId, head.purchase_code);
      if (ln.dir === 'in') {
        // 入库：序列号必须未被占用（本单据重复过账或单内重复均报错）
        for (const s of serials) {
          if (serialInserts.some((x) => x.serial === s.serial)) {
            throw new BadRequestException(`商品序列号 ${s.serial} 重复`);
          }
          const rows: any[] = await this.q(
            `SELECT id, purchase_id, sale_id, purchase_exchange_id, sale_exchange_id, warehousing_id
               FROM kuerp_goods_serial WHERE serial = ? LIMIT 1`,
            [s.serial],
          );
          if (rows.length) {
            const r = rows[0];
            const owned = [r.purchase_id, r.sale_id, r.purchase_exchange_id, r.sale_exchange_id, r.warehousing_id]
              .some((v) => this.n(v) === ln.infoId);
            if (!owned) {
              throw new BadRequestException(`商品序列号 ${s.serial} 已被使用`);
            }
          }
          serialInserts.push({
            admin_id: this.n(head.admin_id),
            goods_id: goodsId,
            goods_code: ln.goodsCode,
            stores_id: ln.storesId,
            attribute_id: String(ln.attr),
            serial: s.serial,
            status: String(ln.serialStatus),
            store_status: '1', // 在库
            remark: s.remark || null,
            ...link,
            createtime: nowSec(),
            updatetime: nowSec(),
          });
          serialLogs.push({
            admin_id: this.n(head.admin_id),
            goods_id: goodsId,
            stores_id: ln.storesId,
            attribute_id: String(ln.attr),
            serial: s.serial,
            business_type: String(ln.batchBt),
            store_status: '1',
            remarks: s.remark || ln.remark || null,
            purchase_id: ln.infoId,
            purchase_code: head.purchase_code,
            purchase_time: this.n(head.purchase_time),
            customer_id: ln.customerId,
            order_id: ln.infoId,
            createtime: nowSec(),
            updatetime: nowSec(),
          });
        }
      } else {
        // 出库：序列号必须存在且在库
        const codes = serials.map((s) => s.serial);
        const marks = codes.map(() => '?').join(',');
        const rows: any[] = await this.q(
          `SELECT id, serial, store_status FROM kuerp_goods_serial WHERE serial IN (${marks})`,
          codes,
        );
        const inStock = rows.filter((r) => this.n(r.store_status) === 1);
        if (inStock.length !== codes.length) {
          const missing = codes.filter((c) => !inStock.some((r) => r.serial === c));
          throw new BadRequestException(`商品序列号 ${missing.join(',')} 不存在或已出库`);
        }
        for (const r of inStock) {
          serialUpdates.push({
            serial: r.serial,
            status: String(ln.serialStatus),
            storeStatus: '2', // 出库
            link,
          });
          serialLogs.push({
            admin_id: this.n(head.admin_id),
            goods_id: goodsId,
            stores_id: ln.storesId,
            attribute_id: String(ln.attr),
            serial: r.serial,
            business_type: String(ln.batchBt),
            store_status: '2',
            remarks: ln.remark || null,
            purchase_id: ln.infoId,
            purchase_code: head.purchase_code,
            purchase_time: this.n(head.purchase_time),
            customer_id: ln.customerId,
            order_id: ln.infoId,
            createtime: nowSec(),
            updatetime: nowSec(),
          });
        }
      }
    }
  }

  /** 由单据类型推导 goods_serial 的关联字段（写入 goods_serial 的哪个外键） */
  private serialLinkFields(link: string, infoId: number, code: string): Record<string, any> {
    switch (link) {
      case 'purchase_id': return { purchase_id: infoId, purchase_code: code };
      case 'purchase_exchange_id': return { purchase_exchange_id: infoId, purchase_exchange_code: code };
      case 'sale_id': return { sale_id: infoId, sale_code: code };
      case 'sale_exchange_id': return { sale_exchange_id: infoId, sale_exchange_code: code };
      case 'warehousing_id': return { warehousing_id: infoId };
      case 'warehoue_id': return { warehoue_id: infoId };
      default: return { order_id: infoId };
    }
  }

  /**
   * 解析明细行的序列号原文（period 字段）。
   * 兼容 JSON 数组（[{serial,remark}]）与原系统 PHP serialize(a:N:{...}) 两种格式。
   */
  private parsePeriod(raw: string): { serial: string; remark: string }[] {
    if (!raw) return [];
    const s = String(raw).trim();
    if (s.startsWith('[') || s.startsWith('{')) {
      try {
        const arr = JSON.parse(s);
        const list = Array.isArray(arr) ? arr : [arr];
        return list
          .map((x: any) => ({ serial: String(x?.serial ?? x ?? '').trim(), remark: String(x?.remark ?? '') }))
          .filter((x) => x.serial);
      } catch {
        /* 落到 PHP 序列化解析 */
      }
    }
    if (!s.startsWith('a:')) return [];
    // —— 极简 PHP serialize 解析（仅支持本场景的 a:N:{i:k;(s|a):...} 嵌套）——
    let pos = 0;
    const skip = (ch: string) => { if (s[pos] === ch) pos += 1; };
    const parse = (): any => {
      const c1 = s.indexOf(':', pos);
      const type = s.slice(pos, c1);
      if (type === 'i' || type === 'd' || type === 'b') {
        const end = s.indexOf(';', c1);
        const rawV = s.slice(c1 + 1, end);
        pos = end + 1;
        return type === 'i' ? parseInt(rawV, 10) : type === 'd' ? parseFloat(rawV) : rawV === '1';
      }
      const c2 = s.indexOf(':', c1 + 1);
      const len = parseInt(s.slice(c1 + 1, c2), 10);
      pos = c2 + 1;
      if (type === 's') {
        pos += 1; // 跳过开引号
        const val = s.slice(pos, pos + len);
        pos += len;
        skip('"');
        skip(';');
        return val;
      }
      if (type === 'a') {
        pos += 1; // 跳过 {
        const out: any[] = [];
        for (let k = 0; k < len; k++) {
          const kc = s.indexOf(';', pos); // 跳过 i:k;
          pos = kc + 1;
          out.push(parse());
        }
        skip('}');
        return out;
      }
      return null;
    };
    const arr = parse();
    if (!Array.isArray(arr)) return [];
    return arr
      .map((x: any) => ({ serial: String(x?.serial ?? '').trim(), remark: String(x?.remark ?? '') }))
      .filter((x) => x.serial);
  }

  /** 落库批次库存累加器：已存在行 UPDATE，新行 INSERT */
  private async flushBatch(acc: Map<string, { id: number; stock: number; exists: boolean }>) {
    for (const [key, st] of acc.entries()) {
      if (st.exists) {
        await this.q(
          `UPDATE kuerp_goods_batch_stock SET stock = ?, updatetime = ? WHERE id = ?`,
          [st.stock, nowSec(), st.id],
        );
      } else if (st.stock !== 0) {
        // key 形如 `${batchId}|${goodsCode}|${attr}|${storesId}`
        const [batchId, goodsCode, attr, storesId] = key.split('|');
        // 参数顺序与列一一对应：batch_id, goods_id(子查询), goods_code, attribute_id, stores_id, stock, createtime, updatetime
        await this.q(
          `INSERT INTO kuerp_goods_batch_stock
             (admin_id, batch_id, goods_id, goods_code, attribute_id, stores_id, stock, createtime, updatetime)
           VALUES (NULL, ?, (SELECT id FROM kuerp_goods WHERE goods_code=? LIMIT 1), ?, ?, ?, ?, ?, ?)`,
          [Number(batchId), goodsCode, goodsCode, Number(attr), Number(storesId), st.stock, nowSec(), nowSec()],
        );
      }
    }
  }

  /** 应用序列号出库更新（status/store_status/关联字段） */
  private async applySerialUpdates(updates: any[]) {
    for (const u of updates) {
      const assigns: string[] = ['status = ?', 'store_status = ?'];
      const params: any[] = [u.status, u.storeStatus];
      for (const [col, val] of Object.entries(u.link)) {
        assigns.push(`${col} = ?`);
        params.push(val);
      }
      params.push(u.serial);
      await this.q(
        `UPDATE kuerp_goods_serial SET ${assigns.join(', ')}, updatetime = ? WHERE serial = ?`,
        [...params.slice(0, -1), nowSec(), u.serial],
      );
    }
  }

  /** 通用批量插入（按行动态列） */
  private async insertRows(table: string, rows: any[]) {
    for (const row of rows) {
      const cols = Object.keys(row);
      const sql =
        `INSERT INTO ${table} (${cols.map((c) => `\`${c}\``).join(', ')})` +
        ` VALUES (${cols.map(() => '?').join(', ')})`;
      await this.q(sql, cols.map((c) => row[c]));
    }
  }

  /**
   * 反审冲转：按 goods_log 记录逐笔反向冲减库存/成本，再删除对应收发明细。
   *
   * 与 post 一样整体包在事务里：冲转中途失败（例如批次库存已不足）时全部回滚，
   * 保证「单据已反审」与「库存已冲回」不会脱节。
   *
   * @param table 物理单据表名
   * @param id 单据主键
   */
  async unpost(table: string, id: number): Promise<{ reversed: number }> {
    if (!this.isDocTable(table)) return { reversed: 0 };
    return await runInTx(this.dataSource, () => this.unpostInner(table, id));
  }

  /**
   * 冲转主体（须在事务内执行，见 unpost）。
   * @param table 物理单据表名
   * @param id 单据主键
   * @returns 冲转的分录数
   */
  private async unpostInner(table: string, id: number): Promise<{ reversed: number }> {
    const def = this.DOCS[this.docKey(table)];
    const header: any[] = await this.q(
      `SELECT * FROM \`${table}\` WHERE id = ? LIMIT 1`,
      [id],
    );
    if (!header.length) return { reversed: 0 };
    const head = header[0];
    if (this.n(head.examine_status) !== 1) return { reversed: 0 }; // 未审核无需冲转
    const code = def.byCode ? head.purchase_code : head.purchase_code;
    // 该单据过账时使用的 business_type 集合：
    // 盘点=盘盈8/盘亏10；组装=组合件入库12 + 子件出库13；拆卸=组合件出库14 + 子件入库15
    const types =
      def.kind === 'inventory' ? ['8', '10']
        : def.kind === 'assemble' ? ['12', '13']
          : def.kind === 'split' ? ['14', '15']
            : [String(this.logTypeOf(def.kind, head))];
    const marks = types.map(() => '?').join(',');
    const rows: any[] = await this.q(
      `SELECT * FROM kuerp_goods_log WHERE purchase_code = ? AND business_type IN (${marks})`,
      [code, ...types],
    );
    const stockAcc = new Map<string, StockState>();
    const goodsInv = new Map<number, number>();
    for (const r of rows) {
      const { state } = await this.resolveStock(stockAcc, r.goods_code, this.n(r.attribute_id), this.n(r.stores_id));
      const enterBase = this.n(r.enter_basics);
      const outBase = this.n(r.out_basics);
      const enterCost = this.n(r.enter_cost);
      const outCost = this.n(r.out_cost);
      // 反向：库存与成本按入库/出库镜像冲减
      state.stock = this.r4(state.stock - enterBase + outBase);
      state.cost = this.r4(state.cost - enterCost + outCost);
      goodsInv.set(this.n(r.goods_id), (goodsInv.get(this.n(r.goods_id)) || 0) - enterBase + outBase);
    }
    await this.flushStock(stockAcc, head);
    await this.flushGoodsInv(goodsInv);
    await this.q(
      `DELETE FROM kuerp_goods_log WHERE purchase_code = ? AND business_type IN (${marks})`,
      [code, ...types],
    );
    // —— 批次/序列号冲转（与过账方向镜像）——
    await this.unpostBatchSerial(table, head, def);
    // —— 汇总表冲转：删除本单写入的采购/销售汇总行与销售利润行 ——
    await this.summary.removeOnUnpost(table, code);
    return { reversed: rows.length };
  }

  /**
   * 反审时冲转批次/序列号联动效果（镜像 post 的 applyBatchSerial）：
   * - 批次库存：入库单据冲减、出库单据加回（不足报错，与原系统一致）。
   * - goods_batch_log / goods_serial_log：删除本单据的跟踪流水（order_id/purchase_id = 明细ID）。
   * - goods_serial：本单据新入库的序列号删除行；已存在的序列号按上一笔流水恢复状态与在库状态。
   */
  private async unpostBatchSerial(
    table: string,
    head: any,
    def: { info: string; byCode: boolean; codeField: string; kind: string },
  ): Promise<void> {
    // allocation(byCode=false) 明细按表头主键 allocation_id 关联，此处必须用 head.id 反查，
    // 否则用 head.purchase_code 匹配 allocation_id 会命中 0 行，导致批次/序列号冲转被整体跳过
    const code = def.byCode ? head.purchase_code : head.id;
    const infoRows: any[] = await this.q(
      `SELECT id FROM \`${def.info}\` WHERE \`${def.codeField}\` = ?`,
      [code],
    );
    if (!infoRows.length) return;
    const infoIds = infoRows.map((r) => this.n(r.id));
    const marks = infoIds.map(() => '?').join(',');

    // —— 1. 批次库存反向冲减（重新归一化明细，方向取反）——
    const lines = await this.normalize(table, head);
    const sets = await this.setsFlags();
    const batchAcc = new Map<string, { id: number; stock: number; exists: boolean }>();
    for (const ln of lines) {
      if (!sets.batch || ln.batchBt <= 0) continue;
      const gf = await this.goodsFlagsCached(ln.goodsCode, new Map());
      if (!gf.batch) continue;
      if (!ln.batchId && !ln.batchName) continue; // 未选批次的行过账时也未写批次，跳过
      let batchId = ln.batchId;
      if (!batchId) {
        const rows: any[] = await this.q(
          `SELECT id FROM kuerp_goods_batch
            WHERE goods_id = (SELECT id FROM kuerp_goods WHERE goods_code = ? LIMIT 1)
              AND stores_id = ? AND batch_name = ?` +
            (ln.attr > 0 ? ' AND attribute_id = ?' : ''),
          ln.attr > 0 ? [ln.goodsCode, ln.storesId, ln.batchName, ln.attr] : [ln.goodsCode, ln.storesId, ln.batchName],
        );
        batchId = rows.length ? this.n(rows[0].id) : 0;
      }
      if (!batchId) continue;
      const key = `${batchId}|${ln.goodsCode}|${ln.attr}|${ln.storesId}`;
      let st = batchAcc.get(key);
      if (!st) {
        const rows: any[] = await this.q(
          `SELECT id, stock FROM kuerp_goods_batch_stock
            WHERE batch_id = ? AND goods_code = ? AND stores_id = ?` +
            (ln.attr > 0 ? ' AND attribute_id = ?' : ''),
          ln.attr > 0 ? [batchId, ln.goodsCode, ln.storesId, ln.attr] : [batchId, ln.goodsCode, ln.storesId],
        );
        st = rows.length
          ? { id: this.n(rows[0].id), stock: this.n(rows[0].stock), exists: true }
          : { id: 0, stock: 0, exists: false };
        batchAcc.set(key, st);
      }
      if (ln.dir === 'in') {
        // 反冲入库：扣减（不足报错）
        if (ln.qtyBase > st.stock + 1e-6) {
          throw new BadRequestException(`商品 ${ln.goodsCode} 批次库存不足，无法反审`);
        }
        st.stock = this.r4(st.stock - ln.qtyBase);
      } else {
        // 反冲出库：加回
        st.stock = this.r4(st.stock + ln.qtyBase);
      }
    }
    await this.flushBatch(batchAcc);

    // —— 2. 序列号恢复/删除 ——
    const sLogs: any[] = await this.q(
      `SELECT * FROM kuerp_goods_serial_log WHERE purchase_id IN (${marks}) ORDER BY id ASC`,
      infoIds,
    );
    if (sLogs.length) {
      const minId = this.n(sLogs[0].id);
      for (const lg of sLogs) {
        const serial = lg.serial;
        // 该序列号在本单据之前的最后一笔流水（用于恢复历史状态）
        const prev: any[] = await this.q(
          `SELECT business_type, store_status FROM kuerp_goods_serial_log
            WHERE serial = ? AND id < ? ORDER BY id DESC LIMIT 1`,
          [serial, minId],
        );
        const cur: any[] = await this.q(
          `SELECT purchase_id, sale_id, purchase_exchange_id, sale_exchange_id, warehousing_id, warehoue_id, order_id
             FROM kuerp_goods_serial WHERE serial = ? LIMIT 1`,
          [serial],
        );
        if (!cur.length) continue;
        const owned = [cur[0].purchase_id, cur[0].sale_id, cur[0].purchase_exchange_id,
          cur[0].sale_exchange_id, cur[0].warehousing_id, cur[0].warehoue_id, cur[0].order_id]
          .some((v) => this.n(v) === this.n(lg.purchase_id));
        if (prev.length) {
          // 曾有历史流水：恢复到上一笔状态
          await this.q(
            `UPDATE kuerp_goods_serial SET status = ?, store_status = ?, updatetime = ? WHERE serial = ?`,
            [String(this.btToSerialStatus(this.n(prev[0].business_type))), String(this.n(prev[0].store_status) || 0), nowSec(), serial],
          );
        } else if (owned) {
          // 无历史流水且由本单据创建：删除该序列号行
          await this.q(`DELETE FROM kuerp_goods_serial WHERE serial = ?`, [serial]);
        } else {
          // 兜底：恢复为在库
          await this.q(
            `UPDATE kuerp_goods_serial SET status = '1', store_status = '1', updatetime = ? WHERE serial = ?`,
            [nowSec(), serial],
          );
        }
        // 清除指向本单据的关联字段
        const linkCols = ['purchase_id', 'sale_id', 'purchase_exchange_id', 'sale_exchange_id', 'warehousing_id', 'warehoue_id', 'order_id'];
        const hit = linkCols.filter((c) => this.n(cur[0][c]) === this.n(lg.purchase_id));
        for (const c of hit) {
          await this.q(
            `UPDATE kuerp_goods_serial SET ${c} = NULL, updatetime = ? WHERE serial = ?`,
            [nowSec(), serial],
          );
        }
      }
      await this.q(
        `DELETE FROM kuerp_goods_serial_log WHERE purchase_id IN (${marks})`,
        infoIds,
      );
    }

    // —— 3. 删除本单据的批次跟踪流水 ——
    await this.q(
      `DELETE FROM kuerp_goods_batch_log WHERE order_id IN (${marks})`,
      infoIds,
    );
  }

  /** goods_batch_log/serial_log.business_type -> goods_serial.status 映射 */
  private btToSerialStatus(bt: number): number {
    const map: Record<number, number> = {
      1: 1, 2: 1, 3: 2, 4: 3, 5: 4, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10,
      11: 11, 12: 12, 13: 13, 14: 14, 16: 15,
    };
    return map[bt] || 1;
  }

  /** 由单据类型推导 goods_log.business_type（warehousing/warehouse 依表头细分） */
  /**
   * 取某类单据过账时写入 goods_log 的 business_type（反审冲转时用于定位流水）。
   * 组装/拆卸单各有两种流水（组装 12 入库 + 13 出库；拆卸 14 出库 + 15 入库），
   * 由调用方通过 kind 判断后自行展开，这里返回主类型（组装=12、拆卸=14）。
   * @param kind 单据类型
   * @param header 单据表头（其他出入库需据 business_type 区分盘盈/盘亏）
   */
  private logTypeOf(kind: string, header: any): number {
    switch (kind) {
      case 'buy': return 2;
      case 'buyReturn': return 3;
      case 'sell': return 4;
      case 'sellReturn': return 5;
      case 'otherIn': return this.n(header.business_type) === 1 ? 8 : 9;
      case 'otherOut': return this.n(header.business_type) === 1 ? 10 : 11;
      case 'transfer': return 6;
      case 'adjust': return 7;
      case 'inventory': return 8;
      case 'assemble': return 12;
      case 'split': return 14;
      default: return 0;
    }
  }

  /**
   * 组装一条 goods_log 收发明细行。
   * @param header 单据表头
   * @param ln 归一化分录
   * @param goodsId 商品ID
   * @param cost { enterCost / outCost } 出入库成本
   * @param balance 过账后结存 { stock, cost }
   */
  private logRow(
    header: any,
    ln: PostLine,
    goodsId: number,
    cost: { enterCost?: number; outCost?: number },
    balance?: { stock: number; cost: number },
  ): any {
    const isIn = ln.dir === 'in';
    const row: any = {
      admin_id: this.n(header.admin_id),
      purchase_code: header.purchase_code,
      purchase_id: ln.infoId, // 明细行ID（收发明细关联单据行）
      purchase_time: this.n(header.purchase_time),
      business_type: ln.logType,
      customer_id: ln.customerId,
      goods_id: goodsId,
      goods_code: ln.goodsCode,
      attribute_id: ln.attr,
      goods_unit: ln.unit,
      remark: null,
      stores_id: ln.storesId,
      enter_number: isIn ? ln.number : 0,
      enter_basics: isIn ? ln.qtyBase : 0,
      enter_unit: isIn ? this.r4(ln.unitCost) : 0,
      enter_cost: cost.enterCost || 0,
      out_number: !isIn ? ln.number : 0,
      out_basics: !isIn ? ln.qtyBase : 0,
      out_unit: !isIn ? this.r4(ln.unitCost) : 0,
      out_cost: cost.outCost || 0,
      balance_basics: balance ? this.r4(balance.stock) : 0,
      balance_unit: balance && balance.stock > 0 ? this.r4(balance.cost / balance.stock) : 0,
      balance_cost: balance ? this.r4(balance.cost) : 0,
      createtime: nowSec(),
      updatetime: nowSec(),
    };
    return row;
  }

  /** 落库库存累加器：已存在行 UPDATE，新行 INSERT */
  private async flushStock(acc: Map<string, StockState>, header: any) {
    for (const [key, st] of acc.entries()) {
      if (st.exists) {
        await this.q(
          `UPDATE kuerp_goods_stock SET stock = ?, cost_money = ?, updatetime = ? WHERE id = ?`,
          [st.stock, st.cost, nowSec(), st.id],
        );
      } else if (st.stock !== 0 || st.cost !== 0) {
        // key 形如 `${goodsCode}|${attr}|${storesId}`，反解出各维度
        const [goodsCode, attr, storesId] = key.split('|');
        // 参数顺序与列一一对应：admin_id, goods_id(子查询), goods_code, attribute_id, stores_id, stock, unit_cost, cost_money, createtime, updatetime
        await this.q(
          `INSERT INTO kuerp_goods_stock
             (admin_id, goods_id, goods_code, attribute_id, stores_id, stock, unit_cost, cost_money, createtime, updatetime, deletetime)
           VALUES (?, (SELECT id FROM kuerp_goods WHERE goods_code=? LIMIT 1), ?, ?, ?, ?, ?, ?, ?, ?, 0)`,
          [this.n(header.admin_id), goodsCode, goodsCode, Number(attr), Number(storesId), st.stock, st.stock > 0 ? this.r4(st.cost / st.stock) : 0, st.cost, nowSec(), nowSec()],
        );
      }
    }
  }

  /** 落库商品总库存增量（kuerp_goods.inventory） */
  private async flushGoodsInv(goodsInv: Map<number, number>) {
    for (const [goodsId, delta] of goodsInv.entries()) {
      if (!goodsId || delta === 0) continue;
      await this.q(
        `UPDATE kuerp_goods SET inventory = COALESCE(inventory,0) + ? WHERE id = ?`,
        [delta, goodsId],
      );
    }
  }

  /** 批量插入 goods_log 收发明细 */
  private async insertLogs(logs: any[]) {
    for (const row of logs) {
      const cols = Object.keys(row);
      const sql =
        `INSERT INTO kuerp_goods_log (${cols.map((c) => `\`${c}\``).join(', ')})` +
        ` VALUES (${cols.map(() => '?').join(', ')})`;
      await this.q(sql, cols.map((c) => row[c]));
    }
  }

  // ============================================================
  //  看板：以销定购 / 智能补货（数据面板「生成单据」能力）
  // ============================================================

  /**
   * 智能补货看板：汇总销货订单明细（待发数量），对比当前库存，给出建议采购量。
   * 数据源 kuerp_goods_sales_order_info 按商品+属性聚合，LEFT JOIN 库存与商品。
   * @returns 每商品一行：{ goods_id, goods_code, goods_name, sale_number, stock, suggest_number }
   */
  async replenishmentBoard(): Promise<any[]> {
    const rows: any[] = await this.q(
      `SELECT oi.goods_code, oi.goods_attr,
              SUM(oi.number) AS sale_number
         FROM kuerp_goods_sales_order_info oi
        GROUP BY oi.goods_code, oi.goods_attr`,
    );
    const out: any[] = [];
    for (const r of rows) {
      const goods: any[] = await this.q(
        `SELECT id, goods_code, goods_name FROM kuerp_goods WHERE goods_code = ? LIMIT 1`,
        [r.goods_code],
      );
      if (!goods.length) continue;
      const stockRows: any[] = await this.q(
        `SELECT COALESCE(SUM(stock),0) AS stock FROM kuerp_goods_stock WHERE goods_code = ?`,
        [r.goods_code],
      );
      const stock = this.n(stockRows[0]?.stock);
      const sale = this.n(r.sale_number);
      const suggest = sale - stock; // 待发超过库存部分即为建议采购量
      out.push({
        goods_id: this.n(goods[0].id),
        goods_code: r.goods_code,
        goods_name: goods[0].goods_name,
        sale_number: sale,
        stock,
        suggest_number: suggest > 0 ? this.r4(suggest) : 0,
      });
    }
    return out;
  }

  /**
   * 以销定购看板：与智能补货同源（均以销货订单为驱动），
   * 额外标注建议供应商为空、由用户生成购货订单时选择。
   */
  async purchaseByBoard(): Promise<any[]> {
    return this.replenishmentBoard();
  }

  /**
   * 由看板勾选生成购货订单（表头 + 明细）。
   * @param rows [{ goods_code, number, unit_price?, supplyer_code? }]
   * @returns { purchase_code, insertId }
   */
  async generatePurchaseOrder(rows: { goods_code: string; number: number; unit_price?: number; supplyer_code?: string }[]): Promise<any> {
    if (!Array.isArray(rows) || !rows.length) throw new BadRequestException('无可生成的采购明细');
    const purchase_code = `CG${new Date().toISOString().slice(0, 10).replace(/-/g, '')}${Math.floor(Math.random() * 100000)}`;
    const t = nowSec();
    // 表头
    const headRes: any = await this.q(
      `INSERT INTO kuerp_goods_purchase_order
         (purchase_code, purchase_time, supplyer_code, number, all_money, examine_status, createtime, updatetime)
       VALUES (?, ?, ?, ?, ?, '0', ?, ?)`,
      [purchase_code, t, rows[0]?.supplyer_code || null, rows.reduce((s, r) => s + this.n(r.number), 0), 0, t, t],
    );
    // 明细
    for (const r of rows) {
      const goods: any[] = await this.q(
        `SELECT id, goods_name, purchase_price FROM kuerp_goods WHERE goods_code = ? LIMIT 1`,
        [r.goods_code],
      );
      if (!goods.length) continue;
      const unitPrice = this.n(r.unit_price) || this.n(goods[0].purchase_price);
      await this.q(
        `INSERT INTO kuerp_goods_purchase_order_info
           (purchase_code, purchase_time, goods_code, goods_note, number, unit_price, all_money, examine_status, createtime, updatetime)
         VALUES (?, ?, ?, ?, ?, ?, ?, '0', ?, ?)`,
        [purchase_code, t, r.goods_code, goods[0].goods_name, this.n(r.number), unitPrice, this.r4(unitPrice * this.n(r.number)), t, t],
      );
    }
    return { purchase_code, insertId: headRes.insertId };
  }
}
