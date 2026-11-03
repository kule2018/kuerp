/**
 * 聚合报表定义（虚拟报表）。
 *
 * 背景：原 Kuerp 系统中的「汇总表 / 明细表 / 对账单 / 利润表 / 现金银行报表」等页面
 * 均为控制器内 SQL 实时聚合（JOIN + GROUP BY + SUM），并非单表直读。
 * 通用动态表接口 /kuerp/:table/index 只能单表查询，直接指向物理表会导致：
 *   - 汇总类页面（如采购汇总表）读到的是未聚合的流水行，数字不对；
 *   - 部分报表（如商品收发汇总、现金银行报表、对账单）根本没有对应物理表。
 * 本文件以「虚拟报表」方式为这些页面提供独立的列元信息与聚合 SQL，
 * 由 TableService.columns()/index() 按表名段分发，前端 report-page.vue 无需改动。
 */

import { BadRequestException } from '@nestjs/common';

/** 单个聚合报表定义 */
export interface AggReport {
  /** 逻辑表名（仅用于展示/回显） */
  table: string;
  /** 虚拟主键（报表无主键，取分组首列） */
  pk: string;
  /** 列元信息（与 INFORMATION_SCHEMA 输出同构，供 report-page 渲染表头） */
  columns: { name: string; type: string; comment: string; nullable?: boolean; isPk?: boolean }[];
  /** SELECT 表达式（含聚合函数）；自定义 run 报表可省略 */
  select?: string;
  /** FROM 及 JOIN 子句；自定义 run 报表可省略 */
  from?: string;
  /** GROUP BY 表达式；自定义 run 报表可省略 */
  group?: string;
  /** 日期过滤作用的列（SQL 表达式）；自定义 run 报表可省略 */
  dateCol?: string;
  /**
   * 是否支持日期范围筛选（默认 true）。
   * 无日期维度的报表（如往来单位欠款表只反映当前余额快照）必须显式置 false：
   * 否则前端一旦选择日期区间，就会拿时间戳与分组列做比较，MySQL 把 varchar 强转为 0
   * 导致整表查空。前端 report-page 依据该标记隐藏日期选择器。
   */
  dateable?: boolean;
  /** 关键字搜索列（SQL 表达式数组） */
  searchCols: string[];
  /** 默认排序表达式（可空） */
  order?: string;
  /** 结果行后处理：补充派生列（单价 / 毛利 / 余额等） */
  decorate?: (row: any) => any;
  /**
   * 自定义查询（可选）。
   * 通用 GROUP BY 引擎只能表达「聚合 + WHERE 过滤」，无法表达库存预警这类
   * 「按阈值筛选（stock < min OR stock > max）」的语义，故允许报表自带 run 覆盖默认引擎。
   * 签名与 runAggReport 一致，返回 { list, count, page, limit }。
   */
  run?: (
    ds: { query: (sql: string, params?: any[]) => Promise<any[]> },
    q: Record<string, any>,
  ) => Promise<{ list: any[]; count: number; page: number; limit: number }>;
}

/** 列元信息简写工厂 */
const col = (name: string, comment: string, type = 'varchar') => ({
  name,
  type,
  comment,
  nullable: true,
  isPk: false,
});
/** 数值列工厂（report-page 会按 type 做数字格式化与合计） */
const num = (name: string, comment: string) => col(name, comment, 'double');

/** 派生列：比率 = 分子 / 分母（分母为 0 返回 0） */
const rate = (a: number, b: number): number => (b ? Math.round((a / b) * 10000) / 100 : 0);
/** 派生列：单价 = 金额 / 数量（数量为 0 返回 0） */
const price = (money: number, qty: number): number =>
  qty ? Math.round((money / qty) * 10000) / 10000 : 0;
/** 安全数值化 */
const n = (v: any): number => {
  const x = Number(v);
  return isNaN(x) ? 0 : x;
};

export const AGG_REPORTS: Record<string, AggReport> = {
  // ===================== 购货 =====================
  // 采购汇总表（按商品）：按 商品+仓库 汇总购货与退货（退货行金额为负，自然冲减）
  'goods-purchase-summary': {
    table: 'kuerp_goods_purchase_summary',
    pk: 'goods_code',
    columns: [
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('goods_spec', '规格型号'),
      col('type_name', '商品分类'),
      col('stores_name', '仓库'),
      num('number', '数量'),
      num('basic_nmber', '基本数量'),
      num('unit_price', '平均单价'),
      num('all_money', '购货金额'),
      num('tax_money', '税额'),
      num('money_tax_price', '价税合计'),
      num('purchase_money', '采购费用'),
    ],
    select: `i.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(g.goods_specification_id) AS goods_spec,
             ANY_VALUE(gt.supplier_type_name) AS type_name,
             ANY_VALUE(s.name) AS stores_name,
             SUM(i.number) AS number,
             SUM(i.basic_nmber) AS basic_nmber,
             SUM(i.all_money) AS all_money,
             SUM(i.tax_money) AS tax_money,
             SUM(i.money_tax_price) AS money_tax_price,
             SUM(i.purchase_money) AS purchase_money`,
    from: `kuerp_goods_purchase_summary i
           LEFT JOIN kuerp_goods g ON g.goods_code = i.goods_code
           LEFT JOIN kuerp_goods_type gt ON gt.id = g.goods_type_id
           LEFT JOIN kuerp_stores s ON s.id = i.stores_id`,
    group: 'i.goods_code, i.stores_id',
    dateCol: 'i.purchase_time',
    searchCols: ['i.goods_code', 'g.goods_name', 'i.purchase_code'],
    order: 'goods_code ASC',
    decorate: (r) => ({ ...r, unit_price: price(n(r.all_money), n(r.number)) }),
  },

  // 采购汇总表（按供应商）：在按商品基础上多一层供应商维度
  'goods-purchase-summarys': {
    table: 'kuerp_goods_purchase_summary',
    pk: 'goods_code',
    columns: [
      col('supplyer_code', '供应商编号'),
      col('supplyer_name', '供应商名称'),
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('stores_name', '仓库'),
      num('number', '数量'),
      num('unit_price', '平均单价'),
      num('all_money', '购货金额'),
      num('tax_money', '税额'),
      num('money_tax_price', '价税合计'),
    ],
    select: `ANY_VALUE(i.supplyer_code) AS supplyer_code,
             ANY_VALUE(sp.supplyer_name) AS supplyer_name,
             i.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(s.name) AS stores_name,
             SUM(i.number) AS number,
             SUM(i.all_money) AS all_money,
             SUM(i.tax_money) AS tax_money,
             SUM(i.money_tax_price) AS money_tax_price`,
    from: `kuerp_goods_purchase_summary i
           LEFT JOIN kuerp_suppliers sp ON sp.supplyer_code = i.supplyer_code
           LEFT JOIN kuerp_goods g ON g.goods_code = i.goods_code
           LEFT JOIN kuerp_stores s ON s.id = i.stores_id`,
    group: 'i.supplyer_code, i.goods_code, i.stores_id',
    dateCol: 'i.purchase_time',
    searchCols: ['i.supplyer_code', 'sp.supplyer_name', 'i.goods_code', 'g.goods_name'],
    order: 'supplyer_code ASC, goods_code ASC',
    decorate: (r) => ({ ...r, unit_price: price(n(r.all_money), n(r.number)) }),
  },

  // ===================== 销货 =====================
  // 销售汇总表（按商品）
  'goods-sales-summary': {
    table: 'kuerp_goods_sales_summary',
    pk: 'goods_code',
    columns: [
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('goods_spec', '规格型号'),
      col('type_name', '商品分类'),
      col('stores_name', '仓库'),
      num('number', '数量'),
      num('unit_price', '平均单价'),
      num('all_money', '销售金额'),
      num('tax_money', '税额'),
      num('money_tax_price', '价税合计'),
      num('cost_price', '成本'),
      num('profit', '毛利'),
    ],
    select: `i.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(g.goods_specification_id) AS goods_spec,
             ANY_VALUE(gt.supplier_type_name) AS type_name,
             ANY_VALUE(s.name) AS stores_name,
             SUM(i.number) AS number,
             SUM(i.all_money) AS all_money,
             SUM(i.tax_money) AS tax_money,
             SUM(i.money_tax_price) AS money_tax_price,
             SUM(i.cost_price * i.basic_nmber) AS cost_price`,
    from: `kuerp_goods_sales_summary i
           LEFT JOIN kuerp_goods g ON g.goods_code = i.goods_code
           LEFT JOIN kuerp_goods_type gt ON gt.id = g.goods_type_id
           LEFT JOIN kuerp_stores s ON s.id = i.stores_id`,
    group: 'i.goods_code, i.stores_id',
    dateCol: 'i.purchase_time',
    searchCols: ['i.goods_code', 'g.goods_name', 'i.purchase_code'],
    order: 'goods_code ASC',
    decorate: (r) => ({
      ...r,
      unit_price: price(n(r.all_money), n(r.number)),
      profit: Math.round((n(r.all_money) - n(r.cost_price)) * 10000) / 10000,
    }),
  },

  // 销售汇总表（按客户）
  'goods-sales-summaryc': {
    table: 'kuerp_goods_sales_summary',
    pk: 'goods_code',
    columns: [
      col('customer_code', '客户编号'),
      col('customer_name', '客户名称'),
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('stores_name', '仓库'),
      num('number', '数量'),
      num('unit_price', '平均单价'),
      num('all_money', '销售金额'),
      num('money_tax_price', '价税合计'),
    ],
    select: `ANY_VALUE(c.customer_code) AS customer_code,
             ANY_VALUE(c.customer_name) AS customer_name,
             i.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(s.name) AS stores_name,
             SUM(i.number) AS number,
             SUM(i.all_money) AS all_money,
             SUM(i.money_tax_price) AS money_tax_price`,
    from: `kuerp_goods_sales_summary i
           LEFT JOIN kuerp_customers c ON c.id = i.customers_id
           LEFT JOIN kuerp_goods g ON g.goods_code = i.goods_code
           LEFT JOIN kuerp_stores s ON s.id = i.stores_id`,
    group: 'i.customers_id, i.goods_code, i.stores_id',
    dateCol: 'i.purchase_time',
    searchCols: ['c.customer_name', 'i.goods_code', 'g.goods_name'],
    order: 'customer_code ASC, goods_code ASC',
    decorate: (r) => ({ ...r, unit_price: price(n(r.all_money), n(r.number)) }),
  },

  // 销售汇总表（按销售员）
  'goods-sales-summarys': {
    table: 'kuerp_goods_sales_summary',
    pk: 'goods_code',
    columns: [
      col('sale_user_name', '销售员'),
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('stores_name', '仓库'),
      num('number', '数量'),
      num('unit_price', '平均单价'),
      num('all_money', '销售金额'),
      num('money_tax_price', '价税合计'),
    ],
    select: `ANY_VALUE(sm.name) AS sale_user_name,
             i.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(s.name) AS stores_name,
             SUM(i.number) AS number,
             SUM(i.all_money) AS all_money,
             SUM(i.money_tax_price) AS money_tax_price`,
    from: `kuerp_goods_sales_summary i
           LEFT JOIN kuerp_staff_member sm ON sm.id = i.sale_user
           LEFT JOIN kuerp_goods g ON g.goods_code = i.goods_code
           LEFT JOIN kuerp_stores s ON s.id = i.stores_id`,
    group: 'i.sale_user, i.goods_code, i.stores_id',
    dateCol: 'i.purchase_time',
    searchCols: ['sm.name', 'i.goods_code', 'g.goods_name'],
    order: 'sale_user_name ASC, goods_code ASC',
    decorate: (r) => ({ ...r, unit_price: price(n(r.all_money), n(r.number)) }),
  },

  // 销售排行表：按商品汇总销售数量/金额/税额/价税合计，按销售额降序排行
  // （对应 6.销货/12.销售排行表.md：统计一段时间内商品销售情况，可按单据日期/商品类别/商品编号查询）
  'goods-sales-ranking': {
    table: 'kuerp_goods_sales_summary',
    pk: 'goods_code',
    columns: [
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('goods_spec', '规格型号'),
      col('type_name', '商品分类'),
      num('number', '销售数量'),
      num('unit_price', '平均单价'),
      num('all_money', '销售金额'),
      num('tax_money', '税额'),
      num('money_tax_price', '价税合计'),
    ],
    select: `i.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(g.goods_specification_id) AS goods_spec,
             ANY_VALUE(gt.supplier_type_name) AS type_name,
             SUM(i.number) AS number,
             SUM(i.all_money) AS all_money,
             SUM(i.tax_money) AS tax_money,
             SUM(i.money_tax_price) AS money_tax_price`,
    from: `kuerp_goods_sales_summary i
           LEFT JOIN kuerp_goods g ON g.goods_code = i.goods_code
           LEFT JOIN kuerp_goods_type gt ON gt.id = g.goods_type_id`,
    group: 'i.goods_code',
    dateCol: 'i.purchase_time',
    searchCols: ['i.goods_code', 'g.goods_name', 'gt.supplier_type_name'],
    // 默认按销售额降序排行（原系统「排行类别」取金额口径）
    order: 'all_money DESC',
    decorate: (r) => ({ ...r, unit_price: price(n(r.all_money), n(r.number)) }),
  },

  // 销售利润表：按单据输出 收入/成本/毛利/净利（数据来自审核时写入的销售利润表）
  'goods-sales-profit': {
    table: 'kuerp_goods_sales_profit',
    pk: 'purchase_code',
    columns: [
      col('purchase_code', '单据编号'),
      col('purchase_time', '单据日期', 'datetime'),
      col('customer_name', '客户'),
      col('sale_user_name', '销售员'),
      num('number', '数量'),
      num('all_money', '销售收入'),
      num('sales_cost', '销售成本'),
      num('profit', '毛利'),
      num('profit_rate', '毛利率(%)'),
      num('preferential_money', '优惠额'),
      num('purchase_money', '销售费用'),
      num('net_profit', '净利'),
      num('net_profit_rate', '净利率(%)'),
    ],
    select: `p.purchase_code AS purchase_code,
             ANY_VALUE(p.purchase_time) AS purchase_time,
             ANY_VALUE(p.purchase_type) AS purchase_type,
             ANY_VALUE(c.customer_name) AS customer_name,
             ANY_VALUE(sm.name) AS sale_user_name,
             SUM(p.number) AS number,
             SUM(p.all_money) AS all_money,
             SUM(p.sales_cost) AS sales_cost,
             SUM(p.preferential_money) AS preferential_money,
             SUM(p.purchase_money) AS purchase_money,
             SUM(p.real_money) AS real_money`,
    from: `kuerp_goods_sales_profit p
           LEFT JOIN kuerp_customers c ON c.id = p.customers_id
           LEFT JOIN kuerp_staff_member sm ON sm.id = p.sale_user`,
    group: 'p.purchase_code',
    dateCol: 'p.purchase_time',
    searchCols: ['p.purchase_code', 'c.customer_name'],
    order: 'purchase_time DESC',
    decorate: (r) => {
      const profit = Math.round((n(r.all_money) - n(r.sales_cost)) * 10000) / 10000;
      const netProfit =
        Math.round((profit - n(r.preferential_money) - n(r.purchase_money)) * 10000) / 10000;
      return {
        ...r,
        profit,
        profit_rate: rate(profit, n(r.all_money)),
        net_profit: netProfit,
        net_profit_rate: rate(netProfit, n(r.all_money)),
      };
    },
  },

  // 利润表：不按单据拆分，只输出一行期间总览（原系统 Profit.php 的期间利润口径）
  // 利润表：销售利润（含退货）+ 其他收入 + 其他支出 三段合并（原 Profit.php 口径：
  // 逐商品 getProfit 汇总销售收入/成本/优惠/费用，再叠加其他收入与其他支出）
  profit: {
    table: 'kuerp_goods_sales_profit',
    pk: 'biz_type',
    columns: [
      col('biz_type', '业务类别'),
      num('number', '数量'),
      num('all_money', '销售收入'),
      num('sales_cost', '销售成本'),
      num('profit', '毛利'),
      num('profit_rate', '毛利率(%)'),
      num('preferential_money', '优惠额'),
      num('purchase_money', '销售费用'),
      num('other_income', '其他收入'),
      num('other_expend', '其他支出'),
      num('net_profit', '净利'),
      num('net_profit_rate', '净利率(%)'),
    ],
    select: `t.biz_type AS biz_type,
             ANY_VALUE(t.biz_name) AS biz_name,
             SUM(t.number) AS number,
             SUM(t.all_money) AS all_money,
             SUM(t.sales_cost) AS sales_cost,
             SUM(t.preferential_money) AS preferential_money,
             SUM(t.purchase_money) AS purchase_money,
             SUM(t.other_money) AS other_money`,
    // 子查询 UNION 销售利润行与其他收支行（biz_type 用于区分三段）
    from: `(SELECT 'sale' AS biz_type,
                   CASE p.purchase_type WHEN 2 THEN '销售退货' ELSE '普通销售' END AS biz_name,
                   p.number AS number,
                   p.all_money AS all_money,
                   p.sales_cost AS sales_cost,
                   p.preferential_money AS preferential_money,
                   p.purchase_money AS purchase_money,
                   0 AS other_money,
                   p.purchase_time AS biz_time
              FROM kuerp_goods_sales_profit p
            UNION ALL
            SELECT 'income' AS biz_type, '其他收入' AS biz_name,
                   0, 0, 0, 0, 0, SUM(i.money), MAX(i.purchase_time)
              FROM kuerp_income_info i GROUP BY i.purchase_code
            UNION ALL
            SELECT 'expend' AS biz_type, '其他支出' AS biz_name,
                   0, 0, 0, 0, 0, -SUM(e.money), MAX(e.purchase_time)
              FROM kuerp_expenditure_info e GROUP BY e.purchase_code) t`,
    group: 't.biz_type',
    dateCol: 't.biz_time',
    searchCols: ['t.biz_name'],
    order: "FIELD(t.biz_type,'sale','income','expend')",
    decorate: (r) => {
      const biz = String(r.biz_type);
      const profit = Math.round((n(r.all_money) - n(r.sales_cost)) * 10000) / 10000;
      const other = Math.round(n(r.other_money) * 10000) / 10000;
      // 净利 = 毛利 - 优惠 - 费用 + 其他收支（支出段 other_money 已取负）
      const netProfit =
        Math.round((profit - n(r.preferential_money) - n(r.purchase_money) + other) * 10000) / 10000;
      const base = n(r.all_money) || Math.abs(other);
      return {
        ...r,
        other_income: biz === 'income' ? other : 0,
        other_expend: biz === 'expend' ? -other : 0,
        profit,
        profit_rate: rate(profit, n(r.all_money)),
        net_profit: netProfit,
        net_profit_rate: rate(netProfit, base),
      };
    },
  },

  // ===================== 仓库 =====================
  // 商品库存余额表：按 商品+属性 汇总各仓库库存与成本（跨仓合计）
  'goods-stock-balance': {
    table: 'kuerp_goods_stock',
    pk: 'goods_code',
    columns: [
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('goods_spec', '规格型号'),
      col('type_name', '商品分类'),
      num('stock', '库存数量'),
      num('cost_money', '库存成本'),
      num('unit_cost', '单位成本'),
      num('min_stock', '最低库存'),
      num('max_stock', '最高库存'),
    ],
    select: `gs.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(g.goods_specification_id) AS goods_spec,
             ANY_VALUE(gt.supplier_type_name) AS type_name,
             SUM(gs.stock) AS stock,
             SUM(gs.cost_money) AS cost_money,
             MAX(gs.min_stock) AS min_stock,
             MAX(gs.max_stock) AS max_stock`,
    from: `kuerp_goods_stock gs
           LEFT JOIN kuerp_goods g ON g.goods_code = gs.goods_code
           LEFT JOIN kuerp_goods_type gt ON gt.id = g.goods_type_id`,
    group: 'gs.goods_code, gs.attribute_id',
    dateCol: 'gs.createtime',
    searchCols: ['gs.goods_code', 'g.goods_name'],
    order: 'goods_code ASC',
    decorate: (r) => ({ ...r, unit_cost: price(n(r.cost_money), n(r.stock)) }),
  },

  // 商品收发汇总表：按 商品+仓库 汇总期初 / 收入 / 发出 / 结存（原 GoodsLogSummary 口径）
  'goods-log-summary': {
    table: 'kuerp_goods_log',
    pk: 'goods_code',
    columns: [
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('goods_spec', '规格型号'),
      col('stores_name', '仓库'),
      num('period_basics', '期初数量'),
      num('period_cost', '期初成本'),
      num('enter_basics', '收入数量'),
      num('enter_cost', '收入成本'),
      num('out_basics', '发出数量'),
      num('out_cost', '发出成本'),
      num('balance_basics', '结存数量'),
      num('balance_cost', '结存成本'),
    ],
    select: `l.goods_code AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(g.goods_specification_id) AS goods_spec,
             ANY_VALUE(s.name) AS stores_name,
             SUM(CASE WHEN l.business_type = '1' THEN l.balance_basics ELSE 0 END) AS period_basics,
             SUM(CASE WHEN l.business_type = '1' THEN l.balance_cost ELSE 0 END) AS period_cost,
             SUM(l.enter_basics) AS enter_basics,
             SUM(l.enter_cost) AS enter_cost,
             SUM(l.out_basics) AS out_basics,
             SUM(l.out_cost) AS out_cost`,
    from: `kuerp_goods_log l
           LEFT JOIN kuerp_goods g ON g.id = l.goods_id
           LEFT JOIN kuerp_stores s ON s.id = l.stores_id`,
    group: 'l.goods_code, l.stores_id',
    dateCol: 'l.purchase_time',
    searchCols: ['l.goods_code', 'g.goods_name', 'l.purchase_code'],
    order: 'goods_code ASC',
    decorate: (r) => ({
      ...r,
      balance_basics: Math.round((n(r.period_basics) + n(r.enter_basics) - n(r.out_basics)) * 10000) / 10000,
      balance_cost: Math.round((n(r.period_cost) + n(r.enter_cost) - n(r.out_cost)) * 10000) / 10000,
    }),
  },

  // 序列号状态表：按序列号取最近一次流水，展示商品 / 仓库 / 状态（原 GoodsSerialStatus 口径）
  'goods-serial-status': {
    table: 'kuerp_goods_serial_log',
    pk: 'serial',
    columns: [
      col('serial', '序列号'),
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('stores_name', '仓库'),
      col('business_type', '业务类型'),
      col('store_status', '在库状态'),
      col('purchase_code', '单据编号'),
      col('purchase_time', '业务日期', 'datetime'),
    ],
    select: `l.serial AS serial,
             ANY_VALUE(g.goods_code) AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(s.name) AS stores_name,
             ANY_VALUE(l.business_type) AS business_type,
             ANY_VALUE(l.store_status) AS store_status,
             ANY_VALUE(l.purchase_code) AS purchase_code,
             MAX(l.purchase_time) AS purchase_time`,
    from: `kuerp_goods_serial_log l
           LEFT JOIN kuerp_goods g ON g.id = l.goods_id
           LEFT JOIN kuerp_stores s ON s.id = l.stores_id`,
    group: 'l.serial',
    dateCol: 'l.purchase_time',
    searchCols: ['l.serial', 'g.goods_code', 'g.goods_name'],
    order: 'serial ASC',
  },

  // ===================== 资金 =====================
  // 现金银行报表：按结算账户汇总收入 / 支出 / 余额（原 AccountsLog 期间口径）
  'cash-bank': {
    table: 'kuerp_accounts_log',
    pk: 'account_coding',
    columns: [
      col('account_coding', '账户编号'),
      col('account_name', '账户名称'),
      num('income', '收入金额'),
      num('expenditure', '支出金额'),
      num('balance', '余额'),
      num('bill_count', '单据笔数'),
    ],
    select: `l.account_coding AS account_coding,
             ANY_VALUE(l.account_name) AS account_name,
             SUM(l.income) AS income,
             SUM(l.expenditure) AS expenditure,
             COUNT(*) AS bill_count`,
    from: 'kuerp_accounts_log l',
    group: 'l.account_coding',
    dateCol: 'l.pay_time',
    searchCols: ['l.account_coding', 'l.account_name', 'l.bill_code'],
    order: 'account_coding ASC',
    decorate: (r) => ({
      ...r,
      balance: Math.round((n(r.income) - n(r.expenditure)) * 10000) / 10000,
    }),
  },

  // 客户对账单：按 客户+单据 汇总应收 / 已收 / 余额（business_type 1、2 为期初，不参与对账）
  'customers-recon': {
    table: 'kuerp_accounts_receivable',
    pk: 'purchase_code',
    columns: [
      col('customer_code', '客户编号'),
      col('customer_name', '客户名称'),
      col('purchase_code', '单据编号'),
      col('purchase_time', '单据日期', 'datetime'),
      col('business_name', '业务类型'),
      num('receivable', '应收金额'),
      num('receivable_money', '已收金额'),
      num('balance', '未收余额'),
    ],
    select: `ANY_VALUE(c.customer_code) AS customer_code,
             ANY_VALUE(c.customer_name) AS customer_name,
             r.purchase_code AS purchase_code,
             ANY_VALUE(r.purchase_time) AS purchase_time,
             ANY_VALUE(r.business_type) AS business_type,
             SUM(r.receivable) AS receivable,
             SUM(r.receivable_money) AS receivable_money`,
    from: `kuerp_accounts_receivable r
           LEFT JOIN kuerp_customers c ON c.id = r.customers_id`,
    group: 'r.customers_id, r.purchase_code',
    dateCol: 'r.purchase_time',
    searchCols: ['c.customer_name', 'r.purchase_code'],
    order: 'purchase_time DESC',
    decorate: (r) => ({
      ...r,
      business_name: { 3: '销货单', 4: '销货退货', 5: '收款单', 6: '其他收入' }[String(r.business_type)] || '期初',
      balance: Math.round((n(r.receivable) - n(r.receivable_money)) * 10000) / 10000,
    }),
  },

  // 供应商对账单：按 供应商+单据 汇总应付 / 已付 / 余额
  'suppliers-recon': {
    table: 'kuerp_accounts_copewith',
    pk: 'purchase_code',
    columns: [
      col('supplyer_code', '供应商编号'),
      col('supplyer_name', '供应商名称'),
      col('purchase_code', '单据编号'),
      col('purchase_time', '单据日期', 'datetime'),
      col('business_name', '业务类型'),
      num('receivable', '应付金额'),
      num('receivable_money', '已付金额'),
      num('balance', '未付余额'),
    ],
    select: `ANY_VALUE(s.supplyer_code) AS supplyer_code,
             ANY_VALUE(s.supplyer_name) AS supplyer_name,
             r.purchase_code AS purchase_code,
             ANY_VALUE(r.purchase_time) AS purchase_time,
             ANY_VALUE(r.business_type) AS business_type,
             SUM(r.receivable) AS receivable,
             SUM(r.receivable_money) AS receivable_money`,
    from: `kuerp_accounts_copewith r
           LEFT JOIN kuerp_suppliers s ON s.id = r.suppliers_id`,
    group: 'r.suppliers_id, r.purchase_code',
    dateCol: 'r.purchase_time',
    searchCols: ['s.supplyer_name', 'r.purchase_code'],
    order: 'purchase_time DESC',
    decorate: (r) => ({
      ...r,
      business_name: { 3: '购货单', 4: '购货退货', 5: '付款单', 6: '其他支出' }[String(r.business_type)] || '期初',
      balance: Math.round((n(r.receivable) - n(r.receivable_money)) * 10000) / 10000,
    }),
  },

  // 往来单位欠款表：按客户汇总应收 / 已收 / 欠款余额（含期初应收）
  // 往来单位欠款表：客户应收欠款 + 供应商应付欠款 合并展示（原 Intercourse.php 口径：
  // 直接读 kuerp_customers.need_receive_account 与 kuerp_suppliers.need_give_account）
  intercourse: {
    table: 'kuerp_customers',
    pk: 'code',
    columns: [
      col('code', '单位编号'),
      col('name', '单位名称'),
      col('unit_type', '单位类型'),
      num('amount', '应收/应付金额'),
      num('balance', '欠款余额'),
    ],
    select: `t.code AS code,
             ANY_VALUE(t.name) AS name,
             ANY_VALUE(t.unit_type) AS unit_type,
             SUM(t.amount) AS amount`,
    // 子查询 UNION 客户与供应商两侧，外层按单位编号聚合（原系统为两次查询后合并）
    from: `(SELECT customer_code AS code, customer_name AS name,
                   '客户' AS unit_type, COALESCE(need_receive_account, 0) AS amount
              FROM kuerp_customers
            UNION ALL
            SELECT supplyer_code AS code, supplyer_name AS name,
                   '供应商' AS unit_type, COALESCE(need_give_account, 0) AS amount
              FROM kuerp_suppliers) t`,
    // 该报表无日期维度（欠款为实时余额快照），dateCol 取分组列占位，并禁用日期筛选
    group: 't.code',
    dateCol: 't.code',
    dateable: false,
    searchCols: ['t.code', 't.name'],
    order: 'unit_type DESC, code ASC',
    decorate: (r) => ({ ...r, balance: n(r.amount) }),
  },

  // 其他收支明细表：其他收入单明细 + 其他支出单明细 合并展示（原 Revenue.php 口径）
  revenue: {
    table: 'kuerp_income_info',
    pk: 'purchase_code',
    columns: [
      col('purchase_code', '单据编号'),
      col('purchase_time', '单据日期', 'datetime'),
      col('io_type', '收支类型'),
      col('type_name', '收支类别'),
      num('money', '金额'),
      col('remark', '备注'),
    ],
    select: `t.purchase_code AS purchase_code,
             ANY_VALUE(t.purchase_time) AS purchase_time,
             ANY_VALUE(t.io_type) AS io_type,
             ANY_VALUE(t.type_name) AS type_name,
             SUM(t.money) AS money,
             ANY_VALUE(t.remark) AS remark`,
    // 子查询先 UNION 收入与支出，外层再按单据聚合（收入取收入类别名，支出取支出类别名）
    from: `(SELECT i.purchase_code, i.purchase_time, '收入' AS io_type,
                   it.name AS type_name, i.money, i.remark
              FROM kuerp_income_info i
              LEFT JOIN kuerp_income_type it ON it.id = i.income_type_id
            UNION ALL
            SELECT e.purchase_code, e.purchase_time, '支出' AS io_type,
                   et.name AS type_name, e.money, e.remark
              FROM kuerp_expenditure_info e
              LEFT JOIN kuerp_expend_type et ON et.id = e.expend_type_id) t`,
    group: 't.purchase_code, t.io_type',
    dateCol: 't.purchase_time',
    searchCols: ['t.purchase_code', 't.type_name', 't.remark'],
    order: 'purchase_time DESC',
  },

  // 批次保质期清单：按批次列出在库批次的保质期情况，起到到期预警作用（原 GoodsBatchStock 页面口径）。
  // 注意：此前该菜单直接指向物理表 goods-batch-stock，只能看到库存数量、看不到保质期与临期状态。
  'goods-batch-expiry': {
    table: 'kuerp_goods_batch',
    pk: 'id',
    columns: [
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('batch_name', '批次'),
      col('stores_name', '仓库'),
      col('address', '产地'),
      col('manufacture', '生产日期', 'datetime'),
      num('guarantee', '保质期(天)'),
      col('validity', '有效期至', 'datetime'),
      num('stock', '批次库存'),
      num('remain_days', '剩余天数'),
      col('expiry_status', '保质期状态'),
      num('early_warning', '预警天数'),
    ],
    // remain_days 由 SQL 计算（有效期至 - 今天）；未填有效期的批次留空，由 decorate 标记为「未设置」
    select: `b.id AS id,
             ANY_VALUE(g.goods_code) AS goods_code,
             ANY_VALUE(g.goods_name) AS goods_name,
             ANY_VALUE(g.early_warning) AS early_warning,
             ANY_VALUE(b.batch_name) AS batch_name,
             ANY_VALUE(s.name) AS stores_name,
             ANY_VALUE(b.address) AS address,
             ANY_VALUE(b.manufacture) AS manufacture,
             ANY_VALUE(b.guarantee) AS guarantee,
             ANY_VALUE(b.validity) AS validity,
             COALESCE(SUM(bs.stock), 0) AS stock,
             CASE WHEN ANY_VALUE(b.validity) IS NULL OR ANY_VALUE(b.validity) = 0 THEN NULL
                  ELSE DATEDIFF(FROM_UNIXTIME(ANY_VALUE(b.validity)), CURDATE()) END AS remain_days`,
    from: `kuerp_goods_batch b
           LEFT JOIN kuerp_goods g ON g.id = b.goods_id
           LEFT JOIN kuerp_stores s ON s.id = b.stores_id
           LEFT JOIN kuerp_goods_batch_stock bs ON bs.batch_id = b.id`,
    group: 'b.id',
    // 无日期维度（按批次实时库存），dateCol 取创建时间占位
    dateCol: 'b.createtime',
    searchCols: ['g.goods_code', 'g.goods_name', 'b.batch_name'],
    order: 'b.validity ASC, b.id DESC',
    decorate: (r) => {
      // 保质期状态：未设置 / 已过期 / 临期(<=预警天数) / 正常
      // 预警天数取商品档案 early_warning，缺失时按 30 天兜底
      const warn = n(r.early_warning) > 0 ? n(r.early_warning) : 30;
      const days = r.remain_days === null || r.remain_days === undefined ? null : n(r.remain_days);
      let status = '未设置';
      if (days !== null) {
        if (days < 0) status = '已过期';
        else if (days <= warn) status = '临期';
        else status = '正常';
      }
      return { ...r, expiry_status: status };
    },
  },

  /**
   * 库存预警表（虚拟报表，computed）。
   * 业务语义（见开发文档 7.仓库/1.库存预警.md）：
   *   统计「截至当前日期、开启了库存预警、且当前库存低于最低库存或高于最高库存」的商品及其库存数量；
   *   支持按关键字（商品编号 / 商品名称 / 仓库名称 / 商品分类）搜索。
   * 注意：该表不是「录入型」物理表（原 kuerp_goods_stock_warning 仅占位、永不写入），
   * 必须实时计算，故用自定义 run 覆盖通用 GROUP BY 引擎（引擎无法表达阈值 HAVING）。
   */
  'goods-stock-warning': {
    table: 'goods-stock-warning',
    pk: 'goods_code',
    columns: [
      col('goods_code', '商品编号'),
      col('goods_name', '商品名称'),
      col('warehouse_name', '仓库'),
      col('category_name', '商品分类'),
      num('stock', '当前库存'),
      num('min_stock', '最低库存'),
      num('max_stock', '最高库存'),
      col('warning_type', '预警类型'),
    ],
    // 无日期维度（按当前库存实时快照），必须置 false，否则前端日期区间会把分组列强转 0 导致查空
    dateable: false,
    searchCols: ['g.goods_code', 'g.goods_name', 's.name', 'gt.supplier_type_name'],
    // 自定义查询：阈值筛选（stock < min OR stock > max），非聚合
    async run(ds, q) {
      const where = [
        "gs.stock_warning = '1'",
        'gs.deletetime IS NULL',
        // 低于下限 或 （设置了上限且）高于上限；max_stock=0 视为无上限，避免误报
        '(gs.stock < gs.min_stock OR (gs.max_stock > 0 AND gs.stock > gs.max_stock))',
      ];
      const params: any[] = [];
      const search = q.search ? String(q.search).trim() : '';
      if (search) {
        where.push('(g.goods_code LIKE ? OR g.goods_name LIKE ? OR s.name LIKE ? OR gt.supplier_type_name LIKE ?)');
        params.push(`%${search}%`, `%${search}%`, `%${search}%`, `%${search}%`);
      }
      const whereSql = ' WHERE ' + where.join(' AND ');
      const base = `FROM \`kuerp_goods_stock\` gs
        LEFT JOIN \`kuerp_goods\` g ON g.id = gs.goods_id
        LEFT JOIN \`kuerp_stores\` s ON s.id = gs.stores_id
        LEFT JOIN \`kuerp_goods_type\` gt ON gt.id = g.goods_type_id`;
      const select = `SELECT gs.goods_code AS goods_code, g.goods_name AS goods_name,
          s.name AS warehouse_name, gt.supplier_type_name AS category_name,
          gs.stock AS stock, gs.min_stock AS min_stock, gs.max_stock AS max_stock,
          CASE WHEN gs.stock < gs.min_stock THEN '低于下限'
               WHEN gs.max_stock > 0 AND gs.stock > gs.max_stock THEN '高于上限'
               ELSE '正常' END AS warning_type`;
      const page = q.page && Number(q.page) > 0 ? Number(q.page) : 1;
      const limit = q.limit && Number(q.limit) > 0 ? Number(q.limit) : 10;
      const offset = (page - 1) * limit;
      const total = await ds.query(`SELECT COUNT(*) AS c ${base}${whereSql}`, params);
      const count = Number(total[0]?.c || 0);
      const list = await ds.query(
        `${select} ${base}${whereSql} ORDER BY gs.stock ASC LIMIT ? OFFSET ?`,
        [...params, limit, offset],
      );
      return { list, count, page, limit };
    },
  },
};

/**
 * 执行聚合报表查询。
 * @param dataSource 数据库连接
 * @param name 报表名（URL 表段，连字符）
 * @param q 查询参数（分页 / 关键字 / 起止时间）
 * @returns { list, count, page, limit }
 */
export async function runAggReport(
  dataSource: { query: (sql: string, params?: any[]) => Promise<any[]> },
  name: string,
  q: Record<string, any>,
): Promise<{ list: any[]; count: number; page: number; limit: number }> {
  const def = AGG_REPORTS[name];
  if (!def) throw new BadRequestException(`未定义的聚合报表: ${name}`);

  // 自定义查询优先：库存预警等「阈值筛选」类报表绕过通用 GROUP BY 引擎
  if (def.run) return def.run(dataSource, q);

  // —— 组装 WHERE：日期区间 + 关键字（全部参数化，杜绝注入）——
  const where: string[] = [];
  const params: any[] = [];
  // dateable=false 的报表（无日期维度）直接忽略日期入参，避免 varchar 分组列被强转为 0 导致查空
  const dateable = def.dateable !== false;
  if (dateable && q.starttime !== undefined && q.starttime !== null && q.starttime !== '') {
    where.push(`${def.dateCol} >= ?`);
    params.push(Number(q.starttime));
  }
  if (dateable && q.endtime !== undefined && q.endtime !== null && q.endtime !== '') {
    where.push(`${def.dateCol} <= ?`);
    params.push(Number(q.endtime));
  }
  const search = q.search ? String(q.search).trim() : '';
  if (search && def.searchCols.length) {
    where.push(`(${def.searchCols.map((c) => `${c} LIKE ?`).join(' OR ')})`);
    def.searchCols.forEach(() => params.push(`%${search}%`));
  }
  const whereSql = where.length ? ` WHERE ${where.join(' AND ')}` : '';

  // —— 分页 ——
  const page = q.page && Number(q.page) > 0 ? Number(q.page) : 1;
  const limit = q.limit && Number(q.limit) > 0 ? Number(q.limit) : 10;
  const offset = (page - 1) * limit;

  // 总数：把分组结果作为派生表再 COUNT（保证与列表口径一致）
  const groupSql = `SELECT ${def.select} FROM ${def.from}${whereSql} GROUP BY ${def.group}`;
  const totalRows = await dataSource.query(
    `SELECT COUNT(*) AS c FROM (${groupSql}) AS _t`,
    params,
  );
  const count = Number(totalRows[0]?.c || 0);

  const orderSql = def.order ? ` ORDER BY ${def.order}` : '';
  const list = await dataSource.query(
    `${groupSql}${orderSql} LIMIT ? OFFSET ?`,
    [...params, limit, offset],
  );

  return {
    list: def.decorate ? list.map(def.decorate) : list,
    count,
    page,
    limit,
  };
}
