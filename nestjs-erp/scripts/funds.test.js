/**
 * 资金过账引擎逻辑单测（无需真实数据库）。
 *
 * 用一个通用迷你 SQL 引擎（内存伪 DataSource）精确执行 FundsService 下发的
 * INSERT/UPDATE/DELETE/SELECT 语句，覆盖以下场景：
 *   1. 收款单过账 + 反审冲转（账户加钱/客户余额/源单收款状态/流水/应收明细）；
 *   2. 付款单过账 + 反审冲转（预付核销源单/供应商余额/源购货单付款状态）；
 *   3. 资金转账单过账 + 反审（双账户余额/转入转出流水）；
 *   4. 其他收入单/其他支出单过账 + 反审（账户余额/欠款明细/费用联动）；
 *   5. 购货单资金联动 + 反审（应付款余额/流水/开票/应付明细/核销源单）；
 *   6. 销货单资金联动 + 反审（应收款余额/流水/开票/应收明细/利润表）；
 *   7. 核销单「应收转应收」过账 + 反审（双向余额/明细/新核销源单）。
 * 运行：node scripts/funds.test.js
 */
require('reflect-metadata');
const assert = require('assert');
const { FundsService } = require('../dist/kuerp/funds/funds.service');

// —— 内存数据仓库（按需惰性建表）——
const store = {};
function tbl(name) {
  if (!store[name]) store[name] = [];
  return store[name];
}
let autoId = 1000;
const nextId = () => ++autoId;

/** 去空白归一化 */
function norm(sql) {
  return String(sql).replace(/\s+/g, ' ').trim();
}
/** 去反引号 */
function deb(s) {
  return String(s).replace(/`/g, '').trim();
}

/**
 * 解析 WHERE 子句为条件列表（仅支持 = ? / = 字面量 / IN (?) / IN (字面量列表)）。
 * @param where WHERE 字符串（不含 WHERE 关键字）
 * @param params 参数数组（会被消费）
 */
function parseWhere(where, params) {
  if (!where) return [];
  const conds = [];
  for (const raw of where.split(' AND ')) {
    const c = raw.trim();
    let m = /^(\S+) IN \(\?\)$/.exec(c);
    if (m) {
      conds.push({ col: deb(m[1]), op: 'in', val: params.shift() });
      continue;
    }
    m = /^(\S+) IN \(([^)]+)\)$/.exec(c);
    if (m) {
      conds.push({
        col: deb(m[1]),
        op: 'in',
        val: m[2].split(',').map((x) => x.trim()),
      });
      continue;
    }
    m = /^(\S+) = \?$/.exec(c);
    if (m) {
      conds.push({ col: deb(m[1]), op: 'eq', val: params.shift() });
      continue;
    }
    m = /^(\S+) = (.+)$/.exec(c);
    if (m) {
      conds.push({ col: deb(m[1]), op: 'eq', val: m[2].trim() });
      continue;
    }
    throw new Error('unsupported WHERE cond: ' + c);
  }
  return conds;
}

/** 条件求值（统一转字符串比较，规避 number/varchar 差异） */
function matchConds(row, conds) {
  return conds.every((c) => {
    const cell = row[c.col];
    if (c.op === 'in') {
      const arr = Array.isArray(c.val) ? c.val : [c.val];
      return arr.some((v) => String(v) === String(cell));
    }
    return String(c.val) === String(cell);
  });
}

/** 数值化（null/空串归 0） */
function num(v) {
  const x = Number(v);
  return isNaN(x) ? 0 : x;
}

/** 通用迷你 SQL 引擎伪 DataSource */
const fake = {
  options: { type: 'mysql' },
  async query(sql, params = []) {
    const s = norm(sql);
    const p = params.slice();

    // —— INSERT INTO tbl (cols) VALUES (?,?...) ——
    let m = /^INSERT INTO (\S+) \(([^)]+)\) VALUES \(([^)]+)\)$/.exec(s);
    if (m) {
      const table = deb(m[1]);
      const cols = m[2].split(',').map(deb);
      const row = { id: nextId() };
      cols.forEach((c, i) => (row[c] = p[i] === undefined ? null : p[i]));
      tbl(table).push(row);
      return { insertId: row.id };
    }

    // —— UPDATE tbl SET ... WHERE ... ——
    // 注意：参数顺序为先 SET 后 WHERE，必须先消费 SET 参数再解析 WHERE。
    m = /^UPDATE (\S+) SET (.+?) WHERE (.+)$/.exec(s);
    if (m) {
      const table = deb(m[1]);
      // 1. 先解析 SET 赋值并从参数头部消费（支持 col = ? / col = col + ? / col = col - ?）
      const assigns = [];
      for (const assign of m[2].split(',')) {
        const a = assign.trim();
        let am = /^(\S+) = (\S+) \+ \?$/.exec(a);
        if (am) {
          assigns.push({ col: deb(am[1]), op: 'inc', val: p.shift() });
          continue;
        }
        am = /^(\S+) = (\S+) - \?$/.exec(a);
        if (am) {
          assigns.push({ col: deb(am[1]), op: 'dec', val: p.shift() });
          continue;
        }
        am = /^(\S+) = \?$/.exec(a);
        if (am) {
          assigns.push({ col: deb(am[1]), op: 'set', val: p.shift() });
          continue;
        }
        throw new Error('unsupported SET: ' + a);
      }
      // 2. 再解析 WHERE（消费剩余参数）
      const conds = parseWhere(m[3], p);
      let affected = 0;
      for (const row of tbl(table)) {
        if (!matchConds(row, conds)) continue;
        for (const as of assigns) {
          if (as.op === 'inc') row[as.col] = num(row[as.col]) + as.val;
          else if (as.op === 'dec') row[as.col] = num(row[as.col]) - as.val;
          else row[as.col] = as.val;
        }
        affected++;
      }
      return { affected };
    }

    // —— DELETE FROM tbl WHERE ... ——
    m = /^DELETE FROM (\S+) WHERE (.+)$/.exec(s);
    if (m) {
      const table = deb(m[1]);
      const conds = parseWhere(m[2], p);
      const rows = tbl(table);
      const keep = [];
      let removed = 0;
      for (const row of rows) {
        if (matchConds(row, conds)) removed++;
        else keep.push(row);
      }
      store[table] = keep;
      return { affected: removed };
    }

    // —— SELECT <cols> FROM tbl [WHERE ...] [LIMIT 1] ——
    m = /^SELECT (.+?) FROM (\S+)(?: WHERE (.+?))?(?: LIMIT 1)?$/.exec(s);
    if (m) {
      const colExpr = m[1].trim();
      const table = deb(m[2]);
      const conds = parseWhere(m[3] || '', p);
      let rows = tbl(table).filter((r) => matchConds(r, conds));
      if (/LIMIT 1$/.test(s)) rows = rows.slice(0, 1);
      if (colExpr === '*') return rows.map((r) => ({ ...r }));
      // 聚合：COALESCE(SUM(col),0) AS alias
      const agg = /^COALESCE\(SUM\((\w+)\),0\) AS (\w+)$/.exec(colExpr);
      if (agg) {
        const sum = rows.reduce((acc, r) => acc + num(r[agg[1]]), 0);
        return [{ [agg[2]]: sum }];
      }
      // 普通列投影
      const cols = colExpr.split(',').map(deb);
      return rows.map((r) => {
        const o = {};
        cols.forEach((c) => (o[c] = r[c]));
        return o;
      });
    }

    throw new Error('unsupported SQL: ' + s);
  },
};

const svc = new FundsService(fake);

// =====================================================================
// 测试工具
// =====================================================================
let passed = 0;
function check(name, cond) {
  assert.ok(cond, '断言失败: ' + name);
  passed++;
  console.log('  ✓ ' + name);
}
function reset() {
  for (const k of Object.keys(store)) delete store[k];
}

// =====================================================================
// 场景 1：收款单过账 + 反审
// =====================================================================
console.log('场景1：收款单过账与反审');
reset();
tbl('kuerp_customers').push({ id: 1, need_receive_account: 1000 });
tbl('kuerp_accounts').push({ id: 10, account_coding: 'A01', account_name: '现金', balance: 500 });
tbl('kuerp_goods_sales').push({
  id: 100, purchase_code: 'XS001', real_money: 600, customers_money: 0,
  pay_money: 0, pay_status: 0, money_tax_price: 600,
});
tbl('kuerp_collection').push({
  id: 50, purchase_code: 'SK001', purchase_time: 1000, business_type: 2,
  customers_id: 1, money: 600, write_off: 600, advance: 0, examine_status: 0, remarks: '收款',
});
tbl('kuerp_collection_account').push({ id: 1, collection_id: 50, purchase_code: 'SK001', accounts_id: 10, money: 600 });
tbl('kuerp_collection_sale').push({
  id: 1, collection_id: 50, purchase_code: 'SK001', purchase_number: 'XS001',
  business_type: 3, type: 1, write_off_price: 600,
});

(async () => {
  let r = await svc.post('kuerp_collection', 50);
  check('收款单过账返回 posted=1', r.posted === 1);
  check('账户余额 500→1100', tbl('kuerp_accounts')[0].balance === 1100);
  check('账户流水 bt=7 income=600', tbl('kuerp_accounts_log').length === 1 &&
    tbl('kuerp_accounts_log')[0].business_type === 7 && tbl('kuerp_accounts_log')[0].income === 600);
  check('客户应收余额 1000→400', tbl('kuerp_customers')[0].need_receive_account === 400);
  check('销货单收款状态 pay_money=600 pay_status=1', tbl('kuerp_goods_sales')[0].pay_money === 600 && tbl('kuerp_goods_sales')[0].pay_status === 1);
  check('收款一览表 bt=3', tbl('kuerp_sales_payment_log').length === 1 && tbl('kuerp_sales_payment_log')[0].business_type === 3);
  check('应收明细 bt=9 receivable=-600', tbl('kuerp_accounts_receivable').length === 1 && tbl('kuerp_accounts_receivable')[0].receivable === -600);
  // 模拟 examine() 过账后翻转状态，再验证幂等
  tbl('kuerp_collection')[0].examine_status = 1;
  check('幂等：重复过账跳过', (await svc.post('kuerp_collection', 50)).posted === 0 && tbl('kuerp_accounts_log').length === 1);
  tbl('kuerp_collection')[0].examine_status = 1; // 反审前保持已审状态

  r = await svc.unpost('kuerp_collection', 50);
  check('收款单冲转返回 reversed=1', r.reversed === 1);
  check('账户余额还原 500', tbl('kuerp_accounts')[0].balance === 500);
  check('客户应收余额还原 1000', tbl('kuerp_customers')[0].need_receive_account === 1000);
  check('销货单状态还原 pay_money=0', tbl('kuerp_goods_sales')[0].pay_money === 0 && tbl('kuerp_goods_sales')[0].pay_status === 0);
  check('派生记录全部删除', tbl('kuerp_accounts_log').length === 0 &&
    tbl('kuerp_sales_payment_log').length === 0 && tbl('kuerp_accounts_receivable').length === 0);

  // =====================================================================
  // 场景 2：付款单（预付单）过账 + 反审
  // =====================================================================
  console.log('场景2：付款单（预付）过账与反审');
  reset();
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1', need_give_account: 800 });
  tbl('kuerp_accounts').push({ id: 10, account_coding: 'A01', account_name: '现金', balance: 1000 });
  tbl('kuerp_payment').push({
    id: 60, purchase_code: 'FK001', purchase_time: 1000, business_type: 1,
    customers_id: 200, money: 300, advance: 300, examine_status: 0, remarks: '预付',
  });
  tbl('kuerp_payment_account').push({ id: 1, collection_id: 60, purchase_code: 'FK001', accounts_id: 10, money: 300 });

  r = await svc.post('kuerp_payment', 60);
  tbl('kuerp_payment')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('付款单过账 posted=1', r.posted === 1);
  check('账户余额 1000→700', tbl('kuerp_accounts')[0].balance === 700);
  check('账户流水 bt=8 expenditure=300', tbl('kuerp_accounts_log')[0].business_type === 8 && tbl('kuerp_accounts_log')[0].expenditure === 300);
  check('供应商应付余额 800→500', tbl('kuerp_suppliers')[0].need_give_account === 500);
  check('预付核销源单 pt=2 write_off=300', tbl('kuerp_writeoff_source').length === 1 &&
    tbl('kuerp_writeoff_source')[0].purchase_type === 2 && tbl('kuerp_writeoff_source')[0].write_off === 300);
  check('应付明细 bt=9 advance=300', tbl('kuerp_accounts_copewith')[0].business_type === 9 && tbl('kuerp_accounts_copewith')[0].advance === 300);

  r = await svc.unpost('kuerp_payment', 60);
  check('付款单冲转 reversed=1', r.reversed === 1);
  check('账户余额还原 1000', tbl('kuerp_accounts')[0].balance === 1000);
  check('供应商应付余额还原 800', tbl('kuerp_suppliers')[0].need_give_account === 800);
  check('核销源单与明细已删除', tbl('kuerp_writeoff_source').length === 0 && tbl('kuerp_accounts_copewith').length === 0);

  // =====================================================================
  // 场景 3：付款单核销购货单（business_type=2 + 源单）
  // =====================================================================
  console.log('场景3：付款单核销源购货单');
  reset();
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1', need_give_account: 0 });
  tbl('kuerp_accounts').push({ id: 10, account_coding: 'A01', account_name: '现金', balance: 1000 });
  tbl('kuerp_goods_purchase').push({ id: 300, purchase_code: 'CG001', real_money: 1000, pay_money: 0, pay_status: 0, supplyer_code: 'S1' });
  tbl('kuerp_invoicing').push({ id: 1, bill_code: 'CG001', status: 0 });
  tbl('kuerp_invoicing_log').push({ id: 1, bill_code: 'CG001', status: 0 });
  tbl('kuerp_payment').push({
    id: 61, purchase_code: 'FK002', purchase_time: 1000, business_type: 2,
    customers_id: 200, money: 400, advance: 0, examine_status: 0, remarks: '付款',
  });
  tbl('kuerp_payment_account').push({ id: 1, collection_id: 61, purchase_code: 'FK002', accounts_id: 10, money: 400 });
  tbl('kuerp_payment_sale').push({
    id: 1, collection_id: 61, purchase_code: 'FK002', purchase_number: 'CG001',
    business_type: 4, type: 1, write_off_price: 400,
  });

  r = await svc.post('kuerp_payment', 61);
  tbl('kuerp_payment')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('核销付款过账 posted=1', r.posted === 1);
  check('购货单 pay_money=400 pay_status=2', tbl('kuerp_goods_purchase')[0].pay_money === 400 && tbl('kuerp_goods_purchase')[0].pay_status === 2);
  check('采购付款一览表 bt=3', tbl('kuerp_payment_log')[0].business_type === 3 && tbl('kuerp_payment_log')[0].pay_money === 400);
  check('开票状态同步为 2', tbl('kuerp_invoicing')[0].status === 2 && tbl('kuerp_invoicing_log')[0].status === 2);
  check('应付明细 bt=9 receivable=-400', tbl('kuerp_accounts_copewith')[0].receivable === -400);

  r = await svc.unpost('kuerp_payment', 61);
  check('核销付款冲转 reversed=1', r.reversed === 1);
  check('购货单状态还原 pay_money=0', tbl('kuerp_goods_purchase')[0].pay_money === 0 && tbl('kuerp_goods_purchase')[0].pay_status === 0);
  check('账户余额还原 1000', tbl('kuerp_accounts')[0].balance === 1000);

  // =====================================================================
  // 场景 4：资金转账单
  // =====================================================================
  console.log('场景4：资金转账单过账与反审');
  reset();
  tbl('kuerp_accounts').push({ id: 10, account_coding: 'A01', account_name: '现金', balance: 1000 });
  tbl('kuerp_accounts').push({ id: 11, account_coding: 'A02', account_name: '工行', balance: 200 });
  tbl('kuerp_accounts_transfer').push({ id: 70, purchase_code: 'ZZ001', purchase_time: 1000, money: 200, examine_status: 0 });
  tbl('kuerp_accounts_transfer_info').push({ id: 1, purchase_id: 70, purchase_code: 'ZZ001', accounts_out_id: 10, accounts_enter_id: 11, money: 200 });

  r = await svc.post('kuerp_accounts_transfer', 70);
  tbl('kuerp_accounts_transfer')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('转账过账 posted=1', r.posted === 1);
  check('转出账户 1000→800', tbl('kuerp_accounts')[0].balance === 800);
  check('转入账户 200→400', tbl('kuerp_accounts')[1].balance === 400);
  check('两条流水 bt=12/11', tbl('kuerp_accounts_log').length === 2 &&
    tbl('kuerp_accounts_log').some((l) => l.business_type === 12 && l.expenditure === 200) &&
    tbl('kuerp_accounts_log').some((l) => l.business_type === 11 && l.income === 200));

  r = await svc.unpost('kuerp_accounts_transfer', 70);
  check('转账冲转 reversed=1', r.reversed === 1);
  check('两账户余额还原', tbl('kuerp_accounts')[0].balance === 1000 && tbl('kuerp_accounts')[1].balance === 200);
  check('流水已删除', tbl('kuerp_accounts_log').length === 0);

  // =====================================================================
  // 场景 5：其他收入单 / 其他支出单
  // =====================================================================
  console.log('场景5：其他收支单过账与反审');
  reset();
  tbl('kuerp_accounts').push({ id: 10, account_coding: 'A01', account_name: '现金', balance: 500 });
  tbl('kuerp_customers').push({ id: 1, need_receive_account: 0 });
  tbl('kuerp_cost').push({ id: 900, pay_money: 0 });
  tbl('kuerp_income').push({
    id: 80, purchase_code: 'SR001', purchase_time: 1000, accounts_id: 10, customers_id: 1,
    money: 300, pay_money: 200, arrears: 100, examine_status: 0, cost_id: 900,
  });
  r = await svc.post('kuerp_income', 80);
  tbl('kuerp_income')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('收入过账 posted=1', r.posted === 1);
  check('账户 500→700', tbl('kuerp_accounts')[0].balance === 700);
  check('欠款应收明细 bt=8 receivable=100', tbl('kuerp_accounts_receivable')[0].business_type === 8 && tbl('kuerp_accounts_receivable')[0].receivable === 100);
  check('费用单已收 0→-200（原系统语义：pay_money 递减）', tbl('kuerp_cost')[0].pay_money === -200);
  r = await svc.unpost('kuerp_income', 80);
  check('收入冲转后账户还原 500', tbl('kuerp_accounts')[0].balance === 500);
  check('应收明细删除、费用还原', tbl('kuerp_accounts_receivable').length === 0 && tbl('kuerp_cost')[0].pay_money === 0);

  tbl('kuerp_accounts').push({ id: 12, account_coding: 'A03', account_name: '招行', balance: 800 });
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1', need_give_account: 0 });
  tbl('kuerp_expenditure').push({
    id: 81, purchase_code: 'ZC001', purchase_time: 1000, accounts_id: 12, suppliers_id: 200,
    money: 500, pay_money: 400, arrears: 100, examine_status: 0,
  });
  r = await svc.post('kuerp_expenditure', 81);
  tbl('kuerp_expenditure')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('支出过账 posted=1', r.posted === 1);
  check('账户 800→400', tbl('kuerp_accounts').find((a) => a.id === 12).balance === 400);
  check('欠款应付明细 bt=8 receivable=100', tbl('kuerp_accounts_copewith')[0].business_type === 8 && tbl('kuerp_accounts_copewith')[0].receivable === 100);
  r = await svc.unpost('kuerp_expenditure', 81);
  check('支出冲转后账户还原 800', tbl('kuerp_accounts').find((a) => a.id === 12).balance === 800);

  // =====================================================================
  // 场景 6：购货单资金联动 + 反审
  // =====================================================================
  console.log('场景6：购货单资金联动与反审');
  reset();
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1', need_give_account: 0 });
  tbl('kuerp_accounts').push({ id: 10, account_coding: 'A01', account_name: '现金', balance: 1000 });
  tbl('kuerp_goods_purchase').push({
    id: 300, purchase_code: 'CG001', purchase_time: 1000, supplyer_code: 'S1',
    all_money: 1000, preferential_money: 50, real_money: 950, tax_money: 130,
    pay_money: 200, account: 10, arrears: 750, pay_status: 2, examine_status: 0, note: '进货',
  });
  r = await svc.post('kuerp_goods_purchase', 300);
  tbl('kuerp_goods_purchase')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('购货资金联动 posted=1', r.posted === 1);
  check('供应商应付款余额 0→750', tbl('kuerp_suppliers')[0].need_give_account === 750);
  check('账户 1000→800（即时付款200）', tbl('kuerp_accounts')[0].balance === 800);
  check('账户流水 bt=2 expenditure=200', tbl('kuerp_accounts_log')[0].business_type === 2 && tbl('kuerp_accounts_log')[0].expenditure === 200);
  check('采购付款一览表 bt=1 give_money=750', tbl('kuerp_payment_log')[0].business_type === 1 && tbl('kuerp_payment_log')[0].give_money === 750);
  check('采购开票表 money=820(=950-130)', tbl('kuerp_invoicing')[0].money === 820);
  check('应付明细 bt=6 receivable=750', tbl('kuerp_accounts_copewith')[0].business_type === 6 && tbl('kuerp_accounts_copewith')[0].receivable === 750);
  check('应付核销源单 pt=4 write_off=750', tbl('kuerp_writeoff_source')[0].purchase_type === 4 && tbl('kuerp_writeoff_source')[0].write_off === 750);

  r = await svc.unpost('kuerp_goods_purchase', 300);
  check('购货资金冲转 reversed=1', r.reversed === 1);
  check('供应商余额还原 0', tbl('kuerp_suppliers')[0].need_give_account === 0);
  check('账户余额还原 1000', tbl('kuerp_accounts')[0].balance === 1000);
  check('派生记录全部删除', tbl('kuerp_payment_log').length === 0 && tbl('kuerp_invoicing').length === 0 &&
    tbl('kuerp_accounts_copewith').length === 0 && tbl('kuerp_writeoff_source').length === 0 && tbl('kuerp_accounts_log').length === 0);

  // =====================================================================
  // 场景 7：销货单资金联动 + 反审
  // =====================================================================
  console.log('场景7：销货单资金联动与反审');
  reset();
  tbl('kuerp_customers').push({ id: 1, need_receive_account: 0 });
  tbl('kuerp_accounts').push({ id: 10, account_coding: 'A01', account_name: '现金', balance: 300 });
  tbl('kuerp_goods_sales_info').push({ id: 1, purchase_code: 'XS001', dis_money: 20 });
  tbl('kuerp_goods_sales').push({
    id: 400, purchase_code: 'XS001', purchase_time: 1000, customers_id: 1, sale_user: 5,
    all_money: 1000, preferential_money: 50, real_money: 950, tax_money: 130, money_tax_price: 1080,
    customers_money: 30, pay_money: 300, account: 10, arrears: 680, pay_status: 2, examine_status: 0, note: '销售',
  });
  r = await svc.post('kuerp_goods_sales', 400);
  tbl('kuerp_goods_sales')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('销货资金联动 posted=1', r.posted === 1);
  check('客户应收余额 0→680', tbl('kuerp_customers')[0].need_receive_account === 680);
  check('账户 300→600（即时收款300）', tbl('kuerp_accounts')[0].balance === 600);
  check('账户流水 bt=5 income=300', tbl('kuerp_accounts_log')[0].business_type === 5 && tbl('kuerp_accounts_log')[0].income === 300);
  check('收款一览表 bt=1 give_money=680', tbl('kuerp_sales_payment_log')[0].business_type === 1 && tbl('kuerp_sales_payment_log')[0].give_money === 680);
  check('销货开票表 real_money=money_tax_price(1080)', tbl('kuerp_sales_invoicing')[0].real_money === 1080);
  check('应收明细 bt=6 receivable=680', tbl('kuerp_accounts_receivable')[0].business_type === 6 && tbl('kuerp_accounts_receivable')[0].receivable === 680);
  check('应收核销源单 pt=3 write_off=680', tbl('kuerp_writeoff_source')[0].purchase_type === 3 && tbl('kuerp_writeoff_source')[0].write_off === 680);
  check('销售利润表 need_money=980 amount=20', tbl('kuerp_goods_sales_profit')[0].need_money === 980 && tbl('kuerp_goods_sales_profit')[0].amount === 20);

  r = await svc.unpost('kuerp_goods_sales', 400);
  check('销货资金冲转 reversed=1', r.reversed === 1);
  check('客户余额还原 0', tbl('kuerp_customers')[0].need_receive_account === 0);
  check('账户余额还原 300', tbl('kuerp_accounts')[0].balance === 300);
  check('派生记录全部删除', tbl('kuerp_sales_payment_log').length === 0 && tbl('kuerp_sales_invoicing').length === 0 &&
    tbl('kuerp_accounts_receivable').length === 0 && tbl('kuerp_writeoff_source').length === 0 &&
    tbl('kuerp_goods_sales_profit').length === 0 && tbl('kuerp_accounts_log').length === 0);

  // =====================================================================
  // 场景 8：核销单「应收转应收」+ 反审
  // =====================================================================
  console.log('场景8：核销单应收转应收与反审');
  reset();
  tbl('kuerp_customers').push({ id: 1, need_receive_account: 500 });
  tbl('kuerp_customers').push({ id: 2, need_receive_account: 100 });
  tbl('kuerp_writeoff').push({
    id: 90, purchase_code: 'HX001', purchase_time: 1000, business_type: 4,
    customers_id: 1, customers_out_id: 1, customers_enter_id: 2, write_off: 100,
    examine_status: 0, remarks: '转应收',
  });
  tbl('kuerp_writeoff_info').push({
    id: 1, collection_id: 90, purchase_code: 'HX001', purchase_number: 'XS001',
    purchase_type: 3, type: 1, business_type: 4, write_off_price: 100, top: 1, source_id: 0,
  });
  tbl('kuerp_writeoff_source').push({ id: 500, customers_id: 1, purchase_code: 'XS001', purchase_type: 3 });
  tbl('kuerp_goods_sales').push({ id: 400, purchase_code: 'XS001', money_tax_price: 600, pay_money: 0, pay_status: 0 });

  r = await svc.post('kuerp_writeoff', 90);
  tbl('kuerp_writeoff')[0].examine_status = 1; // 模拟 examine() 过账后翻转状态
  check('核销过账 posted=1', r.posted === 1);
  check('转出客户 500→400', tbl('kuerp_customers')[0].need_receive_account === 400);
  check('转入客户 100→200', tbl('kuerp_customers')[1].need_receive_account === 200);
  check('两条应收明细 bt=4（±100）', tbl('kuerp_accounts_receivable').length === 2 &&
    tbl('kuerp_accounts_receivable')[0].receivable === -100 && tbl('kuerp_accounts_receivable')[1].receivable === 100);
  check('转入方新核销源单 pt=3 type=4', tbl('kuerp_writeoff_source').some((s) => s.purchase_type === 3 && s.type === 4 && s.write_off === 100));
  check('销货单 pay_money=100 pay_status=2', tbl('kuerp_goods_sales')[0].pay_money === 100 && tbl('kuerp_goods_sales')[0].pay_status === 2);
  check('双向收款流水（±100）', tbl('kuerp_sales_payment_log').length === 2 &&
    tbl('kuerp_sales_payment_log')[0].pay_money === -100 && tbl('kuerp_sales_payment_log')[1].pay_money === 100);

  r = await svc.unpost('kuerp_writeoff', 90);
  check('核销冲转 reversed=1', r.reversed === 1);
  check('转出客户还原 500', tbl('kuerp_customers')[0].need_receive_account === 500);
  check('转入客户还原 100', tbl('kuerp_customers')[1].need_receive_account === 100);
  check('明细/流水/新源单全部删除', tbl('kuerp_accounts_receivable').length === 0 &&
    tbl('kuerp_sales_payment_log').length === 0 &&
    !tbl('kuerp_writeoff_source').some((s) => s.type === 4));
  check('销货单状态还原 pay_money=0', tbl('kuerp_goods_sales')[0].pay_money === 0);

  console.log('\n全部通过：' + passed + ' 项断言');
})().catch((e) => {
  console.error('\n测试失败:', e.message);
  process.exit(1);
});
