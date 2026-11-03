/**
 * 业务汇总表同步单测（无需真实数据库）。
 *
 * 覆盖 SummaryService 的核心链路：
 *   购货单审核      -> kuerp_goods_purchase_summary（purchase_type=1，原样复制明细）
 *   购货退货单审核  -> kuerp_goods_purchase_summary（purchase_type=2，数量金额取负）
 *   销货单审核      -> kuerp_goods_sales_summary + kuerp_goods_sales_profit（销售成本取自 goods_log）
 *   销货退货单审核  -> 同上，且各金额取负
 *   反审            -> 按 purchase_code + purchase_type 精确删除汇总行与利润行
 * 运行：node scripts/summary.test.js
 */
require('reflect-metadata');
const assert = require('assert');
const { SummaryService } = require('../dist/kuerp/posting/summary.service');

let pass = 0;
/** 断言并计数 */
const check = (cond, msg) => {
  assert.ok(cond, msg);
  pass++;
  console.log('  ✓ ' + msg);
};

/** 汇总表真实列集合（服务用 INFORMATION_SCHEMA 做列交集过滤，此处模拟返回） */
const SUMMARY_COLUMNS = {
  kuerp_goods_purchase_summary: [
    'purchase_code', 'purchase_type', 'purchase_time', 'supplyer_code', 'goods_code',
    'goods_unit', 'stores_id', 'number', 'basic_nmber', 'all_money', 'tax_money',
    'money_tax_price', 'real_money', 'pay_money', 'remark', 'createtime', 'updatetime',
  ],
  kuerp_goods_sales_summary: [
    'purchase_code', 'purchase_type', 'purchase_time', 'customers_id', 'sale_user',
    'goods_code', 'goods_unit', 'stores_id', 'number', 'basic_nmber', 'all_money',
    'tax_money', 'money_tax_price', 'real_money', 'pay_money', 'remark', 'createtime', 'updatetime',
  ],
};

// —— 内存数据仓库 ——
const store = {
  kuerp_goods_purchase_info: [
    {
      id: 11, purchase_code: 'P1', purchase_time: 1000, supplyer_code: 'S1',
      goods_code: 'G1', goods_unit: 1, stores_id: 1,
      number: 10, basic_nmber: 10, all_money: 100, tax_money: 13,
      money_tax_price: 113, real_money: 113, pay_money: 0, remark: '采购',
    },
  ],
  // 退货明细：number 为原单数量，retreat_number 为本次退货数量
  kuerp_goods_exchange_info: [
    {
      id: 21, purchase_code: 'T1', purchase_info_id: 11, purchase_id: 1,
      retreat_status: 0, goods_code: 'G1', goods_unit: 1, stores_id: 1,
      number: 10, retreat_number: 3, basic_nmber: 3, all_money: 30, tax_money: 3.9,
      money_tax_price: 33.9, real_money: 33.9, pay_money: 0, retreat_money: 33.9, remark: '退货',
    },
  ],
  kuerp_goods_sales_info: [
    {
      id: 31, purchase_code: 'X1', purchase_time: 2000, customers_id: 9,
      goods_code: 'G1', goods_unit: 1, stores_id: 1,
      number: 5, basic_nmber: 5, all_money: 80, tax_money: 10.4,
      money_tax_price: 90.4, real_money: 90.4, pay_money: 0, remark: '销售',
    },
  ],
  kuerp_goods_sales_exchange_info: [
    {
      id: 41, purchase_code: 'XT1', purchase_info_id: 31, purchase_id: 1,
      retreat_status: 0, goods_code: 'G1', goods_unit: 1, stores_id: 1,
      number: 5, retreat_number: 2, basic_nmber: 2, all_money: 32, tax_money: 4.16,
      money_tax_price: 36.16, real_money: 36.16, pay_money: 0, retreat_money: 36.16, remark: '销退',
    },
  ],
  // 销货单 X1 的收发明细（出库成本 30），供销售利润表取 sales_cost
  kuerp_goods_log: [
    { id: 51, purchase_code: 'X1', business_type: '4', enter_cost: 0, out_cost: 30 },
  ],
  kuerp_goods_purchase_summary: [],
  kuerp_goods_sales_summary: [],
  kuerp_goods_sales_profit: [],
};
let autoId = 500;

/** 伪 DataSource：覆盖 SummaryService 实际下发的 SQL */
const fake = {
  options: { type: 'mysql' },
  async query(sql, params = []) {
    const s = String(sql).replace(/\s+/g, ' ').trim();

    // 取明细行
    let m = /^SELECT \* FROM `(\w+)` WHERE (\w+) = \?$/.exec(s);
    if (m) return (store[m[1]] || []).filter((r) => String(r[m[2]]) === String(params[0]));

    // 列元信息
    if (/^SELECT COLUMN_NAME AS name FROM INFORMATION_SCHEMA.COLUMNS/.test(s)) {
      return (SUMMARY_COLUMNS[params[0]] || []).map((name) => ({ name }));
    }

    // 汇总表写入
    m = /^INSERT INTO `(\w+)` \((.+)\) VALUES /.exec(s);
    if (m) {
      const cols = m[2].split(',').map((c) => c.trim().replace(/`/g, ''));
      const row = {};
      cols.forEach((c, i) => (row[c] = params[i]));
      row.id = ++autoId;
      (store[m[1]] = store[m[1]] || []).push(row);
      return { insertId: autoId };
    }

    // 销售利润表写入
    if (/^INSERT INTO kuerp_goods_sales_profit/.test(s)) {
      const cols = s
        .slice(s.indexOf('(') + 1, s.indexOf(') VALUES'))
        .split(',')
        .map((c) => c.trim().replace(/\s/g, ''));
      const row = {};
      cols.forEach((c, i) => (row[c] = params[i]));
      row.id = ++autoId;
      store.kuerp_goods_sales_profit.push(row);
      return { insertId: autoId };
    }

    // 销售成本：本单出库成本 - 入库成本
    if (/^SELECT IFNULL\(SUM\(out_cost\),0\) AS oc, IFNULL\(SUM\(enter_cost\),0\) AS ec FROM kuerp_goods_log WHERE purchase_code = \?$/.test(s)) {
      const rows = store.kuerp_goods_log.filter((r) => r.purchase_code === params[0]);
      return [{
        oc: rows.reduce((t, r) => t + (Number(r.out_cost) || 0), 0),
        ec: rows.reduce((t, r) => t + (Number(r.enter_cost) || 0), 0),
      }];
    }

    // 冲转删除
    m = /^DELETE FROM `(\w+)` WHERE purchase_code = \? AND purchase_type = \?$/.exec(s);
    if (m) {
      const before = (store[m[1]] || []).length;
      store[m[1]] = (store[m[1]] || []).filter(
        (r) => !(r.purchase_code === params[0] && String(r.purchase_type) === String(params[1])),
      );
      return { affected: before - store[m[1]].length };
    }
    m = /^DELETE FROM (\w+) WHERE purchase_code = \? AND purchase_type = \?$/.exec(s);
    if (m) {
      const before = (store[m[1]] || []).length;
      store[m[1]] = (store[m[1]] || []).filter(
        (r) => !(r.purchase_code === params[0] && String(r.purchase_type) === String(params[1])),
      );
      return { affected: before - store[m[1]].length };
    }

    throw new Error('未匹配的 SQL: ' + s);
  },
};

const svc = new SummaryService(fake);

(async () => {
  console.log('【1】购货单审核同步采购汇总表');
  await svc.syncOnPost('kuerp_goods_purchase', { purchase_code: 'P1', purchase_time: 1000 }, 7);
  check(store.kuerp_goods_purchase_summary.length === 1, '购货单写入 1 行采购汇总');
  let r = store.kuerp_goods_purchase_summary[0];
  check(String(r.purchase_type) === '1', 'purchase_type=1（购货）');
  check(Number(r.number) === 10, '数量 10 原样带入');
  check(Number(r.money_tax_price) === 113, '价税合计 113 原样带入');
  check(r.goods_code === 'G1' && r.supplyer_code === 'S1', '商品编号与供应商编号带入');
  check(!('id' in r) || r.id !== 11, '明细主键未被复制（汇总表自增 id）');
  check(typeof r.createtime === 'number' && r.createtime > 0, 'createtime/updatetime 已写入');

  console.log('【2】购货退货单审核：数量与金额取负');
  await svc.syncOnPost('kuerp_goods_exchange', { purchase_code: 'T1', purchase_time: 1100 }, 7);
  const rows = store.kuerp_goods_purchase_summary;
  check(rows.length === 2, '退货单再写入 1 行采购汇总');
  r = rows[1];
  check(String(r.purchase_type) === '2', 'purchase_type=2（退货）');
  check(Number(r.number) === -3, '数量取 retreat_number 并取负：-3');
  check(Number(r.all_money) === -30 && Number(r.money_tax_price) === -33.9, '金额/价税合计取负');
  check(!('retreat_number' in r) && !('purchase_info_id' in r), '退货专属列被列交集过滤掉');

  console.log('【3】反审冲转：按单号精确删除');
  const res = await svc.removeOnUnpost('kuerp_goods_purchase', 'P1');
  check(store.kuerp_goods_purchase_summary.length === 1, '购货单汇总行已删除');
  check(store.kuerp_goods_purchase_summary[0].purchase_code === 'T1', '退货单汇总行保留');
  check(res.cleared.includes('kuerp_goods_purchase_summary'), '返回被清理的汇总表名');

  console.log('【4】销货单审核：销售汇总表 + 销售利润表');
  await svc.syncOnPost('kuerp_goods_sales', {
    purchase_code: 'X1', purchase_time: 2000, customers_id: 9, sale_user: 3,
    all_money: 80, tax_money: 10.4, money_tax_price: 90.4,
    preferential_money: 0, purchase_money: 0, real_money: 90.4, customers_money: 0,
    pay_money: 0, note: '销售',
  }, 7);
  check(store.kuerp_goods_sales_summary.length === 1, '销货单写入 1 行销售汇总');
  check(String(store.kuerp_goods_sales_summary[0].purchase_type) === '1', '销售汇总 purchase_type=1');
  check(store.kuerp_goods_sales_profit.length === 1, '销货单写入 1 行销售利润');
  r = store.kuerp_goods_sales_profit[0];
  check(Number(r.sales_cost) === 30, '销售成本取自 goods_log.out_cost = 30');
  check(Number(r.all_money) === 80, '销售收入 80');
  check(Number(r.need_money) === 90.4, '应收金额 = 优惠后金额 + 客户承担费用 = 90.4');
  check(String(r.purchase_type) === '1', '利润行 purchase_type=1（普通销售）');

  console.log('【5】销货退货单审核：利润行金额取负');
  await svc.syncOnPost('kuerp_goods_sales_exchange', {
    purchase_code: 'XT1', purchase_time: 2100, customers_id: 9, sale_user: 3,
    all_money: 32, tax_money: 4.16, money_tax_price: 36.16,
    preferential_money: 0, purchase_money: 0, real_money: 36.16, customers_money: 0,
    pay_money: 0, note: '销退',
  }, 7);
  check(store.kuerp_goods_sales_summary.length === 2, '销货退货写入 1 行销售汇总');
  check(Number(store.kuerp_goods_sales_summary[1].number) === -2, '退货数量取负：-2');
  check(store.kuerp_goods_sales_profit.length === 2, '销货退货写入 1 行销售利润');
  r = store.kuerp_goods_sales_profit[1];
  check(Number(r.all_money) === -32 && Number(r.number) === -2, '退货利润行金额/数量取负');
  check(String(r.purchase_type) === '2', '利润行 purchase_type=2（销售退货）');

  console.log('【6】反审销货单：汇总与利润行一并冲转');
  const res2 = await svc.removeOnUnpost('kuerp_goods_sales', 'X1');
  check(store.kuerp_goods_sales_summary.length === 1, '销货单汇总行已删除');
  check(store.kuerp_goods_sales_profit.length === 1, '销货单利润行已删除');
  check(
    res2.cleared.includes('kuerp_goods_sales_summary') && res2.cleared.includes('kuerp_goods_sales_profit'),
    '返回被清理的汇总表 + 利润表',
  );

  console.log('【7】非购销单据直接跳过（不产生任何汇总写入）');
  const n = await svc.syncOnPost('kuerp_allocation', { purchase_code: 'D1' }, 7);
  check(n === 0, '调拨单不写购销汇总表');

  console.log(`\n汇总表同步测试：${pass} 项断言全部通过`);
})().catch((e) => {
  console.error('❌ 汇总表同步测试失败:', e.message);
  process.exit(1);
});
