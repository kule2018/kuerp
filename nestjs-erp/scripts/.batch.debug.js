/**
 * 批次/序列号过账联动逻辑单测（无需真实数据库）。
 *
 * 用一个通用迷你 SQL 引擎（内存伪 DataSource）执行 PostingService 下发的
 * INSERT/UPDATE/DELETE/SELECT（含子查询/NULL 字面量/IN 列表/ORDER BY），覆盖：
 *   1. 采购入库：批次主数据 find-or-create + 批次库存 + 批次流水 + 序列号入库 + 序列号流水；
 *   2. 销货出库：批次库存扣减 + 序列号出库状态 + 流水；
 *   3. 反审冲转：批次库存还原 + 序列号恢复历史状态 + 流水删除（精确撤销）；
 *   4. 批次库存不足报错；
 *   5. 序列号重复/已出库报错；
 *   6. 系统参数关闭批次/序列号时不过账。
 * 运行：node scripts/batch.test.js
 */
require('reflect-metadata');
const assert = require('assert');
const { PostingService } = require('../dist/kuerp/posting/posting.service');

// —— 内存数据仓库（惰性建表）——
const store = {};
function tbl(name) {
  if (!store[name]) store[name] = [];
  return store[name];
}
let autoId = 1000;
const nextId = () => ++autoId;
const norm = (sql) => String(sql).replace(/\s+/g, ' ').trim();
const deb = (s) => String(s).replace(/`/g, '').trim();
const num = (v) => {
  const x = Number(v);
  return isNaN(x) ? 0 : x;
};

/**
 * 预处理 SQL：把 `(SELECT id FROM kuerp_goods WHERE goods_code = ? LIMIT 1)` 子查询
 * 替换为字面量 ID，并按位置从参数数组中移除对应参数（子查询可能位于参数列表中段）。
 * @returns {{ sql: string, params: any[] }}
 */
function resolveGoodsSubquery(s, p) {
  const re = /\(SELECT id FROM kuerp_goods WHERE goods_code\s*=\s*\? LIMIT 1\)/g;
  const removedIdx = [];
  let out = '';
  let last = 0;
  let m;
  while ((m = re.exec(s))) {
    const before = s.slice(last, m.index);
    const qCount = (before.match(/\?/g) || []).length; // 子查询参数在参数列表中的位置
    removedIdx.push(qCount);
    const code = p[qCount];
    const g = tbl('kuerp_goods').find((x) => x.goods_code === code);
    out += before + String(g ? g.id : 0);
    last = m.index + m[0].length;
  }
  out += s.slice(last);
  const params = p.filter((_, i) => !removedIdx.includes(i));
  return { sql: out, params };
}

/** 去掉 SQL 字面量两侧引号 */
function unquote(v) {
  if (typeof v !== 'string') return v;
  const t = v.trim();
  if (t.length >= 2 && ((t.startsWith("'") && t.endsWith("'")) || (t.startsWith('"') && t.endsWith('"')))) {
    return t.slice(1, -1);
  }
  return t;
}

/** 解析 WHERE 为条件列表（= ? / = NULL / = 字面量 / IN (?) / IN (字面量) / < ?） */
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
      conds.push({ col: deb(m[1]), op: 'in', val: m[2].split(',').map(unquote) });
      continue;
    }
    m = /^(\S+) < \?$/.exec(c);
    if (m) {
      conds.push({ col: deb(m[1]), op: 'lt', val: params.shift() });
      continue;
    }
    m = /^(\S+) = \?$/.exec(c);
    if (m) {
      conds.push({ col: deb(m[1]), op: 'eq', val: params.shift() });
      continue;
    }
    m = /^(\S+) = NULL$/.exec(c);
    if (m) {
      conds.push({ col: deb(m[1]), op: 'eq', val: null });
      continue;
    }
    m = /^(\S+) = (.+)$/.exec(c);
    if (m) {
      conds.push({ col: deb(m[1]), op: 'eq', val: unquote(m[2]) });
      continue;
    }
    throw new Error('unsupported WHERE cond: ' + c);
  }
  return conds;
}

function matchConds(row, conds) {
  return conds.every((c) => {
    const cell = row[c.col];
    if (c.op === 'in') {
      const arr = Array.isArray(c.val) ? c.val : [c.val];
      return arr.some((v) => String(v) === String(cell));
    }
    if (c.op === 'lt') return num(cell) < num(c.val);
    if (c.val === null) return cell === null || cell === undefined;
    return String(c.val) === String(cell);
  });
}

const fake = {
  options: { type: 'mysql' },
  async query(sql, params = []) {
    let s = norm(sql);
    let p = params.slice();
    const resolved = resolveGoodsSubquery(s, p);
    s = resolved.sql;
    p = resolved.params;

    // —— INSERT INTO tbl (cols) VALUES (?, ?, NULL, 0, ...) ——
    let m = /^INSERT INTO (\S+) \(([^)]+)\) VALUES \(([^)]+)\)$/.exec(s);
    if (m) {
      const table = deb(m[1]);
      const cols = m[2].split(',').map(deb);
      const vals = m[3].split(',').map((x) => x.trim());
      const row = { id: nextId() };
      let pi = 0;
      cols.forEach((c, i) => {
        const v = vals[i];
        if (v === '?') row[c] = p[pi++];
        else if (v === 'NULL') row[c] = null;
        else if (/^-?\d+(\.\d+)?$/.test(v)) row[c] = Number(v);
        else row[c] = v.replace(/^'|'$/g, '');
      });
      tbl(table).push(row);
      return { insertId: row.id };
    }

    // —— UPDATE tbl SET ... WHERE ... ——
    m = /^UPDATE (\S+) SET (.+?) WHERE (.+)$/.exec(s);
    if (m) {
      const table = deb(m[1]);
      // 括号感知的逗号切分（避免拆散 COALESCE(inventory,0)）
      const assigns = [];
      let depth = 0;
      let cur = '';
      const parts = [];
      for (const ch of m[2]) {
        if (ch === '(') depth++;
        if (ch === ')') depth--;
        if (ch === ',' && depth === 0) {
          parts.push(cur);
          cur = '';
        } else cur += ch;
      }
      if (cur.trim()) parts.push(cur);
      for (const assign of parts) {
        const a = assign.trim();
        let am = /^(\S+) = (\S+) \+ \?$/.exec(a);
        if (am) {
          assigns.push({ col: deb(am[1]), op: 'inc', val: p.shift() });
          continue;
        }
        am = /^(\S+) = COALESCE\(\w+,0\) \+ \?$/.exec(a);
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
        am = /^(\S+) = NULL$/.exec(a);
        if (am) {
          assigns.push({ col: deb(am[1]), op: 'set', val: null });
          continue;
        }
        throw new Error('unsupported SET: ' + a);
      }
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

    // —— SELECT <cols> FROM tbl [WHERE ...] [ORDER BY ...] [LIMIT 1] ——
    m = /^SELECT (.+?) FROM (\S+)(?: WHERE (.+?))?(?: ORDER BY (\w+) (ASC|DESC))?(?: LIMIT 1)?$/.exec(s);
    if (m) {
      const colExpr = m[1].trim();
      const table = deb(m[2]);
      const conds = parseWhere(m[3] || '', p);
      let rows = tbl(table).filter((r) => matchConds(r, conds));
      if (m[4]) {
        const col = m[4];
        const dir = m[5] === 'DESC' ? -1 : 1;
        rows = rows.slice().sort((a, b) => (num(a[col]) - num(b[col])) * dir);
      }
      if (/LIMIT 1$/.test(s)) rows = rows.slice(0, 1);
      if (colExpr === '*') return rows.map((r) => ({ ...r }));
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

const svc = new PostingService(fake);
let passed = 0;
function check(name, cond) {
  assert.ok(cond, '断言失败: ' + name);
  passed++;
  console.log('  ✓ ' + name);
}
function reset() {
  for (const k of Object.keys(store)) delete store[k];
}
const approx = (a, b) => Math.abs(a - b) < 1e-6;

/** 造一张已审核的采购单（含批次+序列号明细），返回批次ID */
async function seedPurchase(opts = {}) {
  const { batchName = 'B2024', serials = ['SN001', 'SN002'], number = 10, tax = 5 } = opts;
  const code = opts.code || 'P1';
  tbl('kuerp_goods_purchase').push({
    id: opts.pid || 1, purchase_code: code, purchase_time: 1000, supplyer_code: 'S1',
    examine_status: 0, admin_id: 1,
  });
  tbl('kuerp_goods_purchase_info').push({
    id: opts.iid || 11, purchase_code: code, goods_code: 'G1', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number, basic_nmber: number, unit_price: tax, tax_included: tax,
    all_money: number * tax, tax_money: 0, money_tax_price: number * tax,
    batch_id: 0, batch_name: batchName, manufacture: 1000, guarantee: 365, validity: 2000,
    period: JSON.stringify(serials.map((s) => ({ serial: s, remark: '' }))),
  });
  await svc.post('kuerp_goods_purchase', opts.pid || 1);
  tbl('kuerp_goods_purchase').find((r) => r.id === (opts.pid || 1)).examine_status = 1;
  const b = tbl('kuerp_goods_batch')[0];
  return b ? b.id : 0;
}

(async () => {
  // =====================================================================
  // 场景 1：采购入库（批次 + 序列号 + 库存 + 收发明细）
  // =====================================================================
  console.log('场景1：采购入库批次/序列号过账');
  reset();
  tbl('kuerp_goods').push({ id: 100, goods_code: 'G1', goods_name: '商品1', inventory: 0, batch: 1, serial: 1 });
  tbl('kuerp_goods').push({ id: 101, goods_code: 'G2', goods_name: '商品2', inventory: 0, batch: 0, serial: 0 });
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1' });
  tbl('kuerp_sets').push({ name: 'batch', is_checked: 1 }, { name: 'serial', is_checked: 1 });
  // 不含批次/序列号的普通商品行（G2）与批次行（G1）同单
  tbl('kuerp_goods_purchase').push({ id: 1, purchase_code: 'P1', purchase_time: 1000, supplyer_code: 'S1', examine_status: 0, admin_id: 1 });
  tbl('kuerp_goods_purchase_info').push({
    id: 11, purchase_code: 'P1', goods_code: 'G1', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number: 10, basic_nmber: 10, unit_price: 5, tax_included: 5,
    all_money: 50, tax_money: 0, money_tax_price: 50,
    batch_id: 0, batch_name: 'B2024', manufacture: 1000, guarantee: 365, validity: 2000,
    period: JSON.stringify([{ serial: 'SN001', remark: '' }, { serial: 'SN002', remark: '' }]),
  });
  tbl('kuerp_goods_purchase_info').push({
    id: 12, purchase_code: 'P1', goods_code: 'G2', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number: 3, basic_nmber: 3, unit_price: 2, tax_included: 2,
    all_money: 6, tax_money: 0, money_tax_price: 6, batch_id: 0, batch_name: '', period: '',
  });

  const r1 = await svc.post('kuerp_goods_purchase', 1);
  tbl('kuerp_goods_purchase')[0].examine_status = 1;
  check('过账分录数=2', r1.posted === 2);
  check('批次主数据已创建', tbl('kuerp_goods_batch').length === 1 && tbl('kuerp_goods_batch')[0].batch_name === 'B2024');
  console.log('DEBUG batch_stock:', JSON.stringify(tbl('kuerp_goods_batch_stock'))); check('批次库存=10', tbl('kuerp_goods_batch_stock').length === 1 && tbl('kuerp_goods_batch_stock')[0].stock === 10);
  check('批次流水 bt=2 number=10', tbl('kuerp_goods_batch_log').length === 1 &&
    String(tbl('kuerp_goods_batch_log')[0].business_type) === '2' && tbl('kuerp_goods_batch_log')[0].number === 10 &&
    tbl('kuerp_goods_batch_log')[0].order_id === 11);
  check('序列号入库 2 条（在库/购货状态）', tbl('kuerp_goods_serial').length === 2 &&
    tbl('kuerp_goods_serial').every((x) => x.status === '1' && x.store_status === '1' && x.purchase_id === 11));
  check('序列号流水 bt=2 store_status=1', tbl('kuerp_goods_serial_log').length === 2 &&
    tbl('kuerp_goods_serial_log').every((x) => String(x.business_type) === '2' && x.store_status === '1'));
  check('普通商品无批次记录', tbl('kuerp_goods_batch_log').every((x) => x.goods_id === 100));
  const g1stock = tbl('kuerp_goods_stock').find((x) => x.goods_code === 'G1');
  const g2stock = tbl('kuerp_goods_stock').find((x) => x.goods_code === 'G2');
  check('G1 库存=10 成本=50', g1stock && g1stock.stock === 10 && approx(g1stock.cost_money, 50));
  check('G2 库存=3 成本=6', g2stock && g2stock.stock === 3 && approx(g2stock.cost_money, 6));
  check('商品总库存联动', tbl('kuerp_goods')[0].inventory === 10 && tbl('kuerp_goods')[1].inventory === 3);

  // =====================================================================
  // 场景 2：销货出库（批次扣减 + 序列号出库）
  // =====================================================================
  console.log('场景2：销货出库批次/序列号过账');
  const batchId = tbl('kuerp_goods_batch')[0].id;
  tbl('kuerp_goods_sales').push({ id: 2, purchase_code: 'X1', purchase_time: 2000, customers_id: 300, examine_status: 0, admin_id: 1 });
  tbl('kuerp_goods_sales_info').push({
    id: 21, purchase_code: 'X1', goods_code: 'G1', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number: 4, basic_nmber: 4, unit_price: 8, tax_included: 8,
    all_money: 32, tax_money: 0, money_tax_price: 32, batch_id: batchId, batch_name: 'B2024',
    period: JSON.stringify([{ serial: 'SN001', remark: '' }, { serial: 'SN002', remark: '' }]),
  });
  const r2 = await svc.post('kuerp_goods_sales', 2);
  tbl('kuerp_goods_sales')[0].examine_status = 1;
  check('销货过账分录数=1', r2.posted === 1);
  check('批次库存 10→6', tbl('kuerp_goods_batch_stock')[0].stock === 6);
  check('批次流水 bt=4', tbl('kuerp_goods_batch_log').length === 2 &&
    String(tbl('kuerp_goods_batch_log')[1].business_type) === '4' && tbl('kuerp_goods_batch_log')[1].order_id === 21);
  check('序列号出库（status=3/store_status=2）', tbl('kuerp_goods_serial').every((x) =>
    x.status === '3' && x.store_status === '2' && x.sale_id === 21 && x.sale_code === 'X1'));
  check('序列号流水 bt=4 store_status=2', tbl('kuerp_goods_serial_log').length === 4 &&
    tbl('kuerp_goods_serial_log').slice(2).every((x) => String(x.business_type) === '4' && x.store_status === '2'));
  check('G1 库存 10→6', tbl('kuerp_goods_stock').find((x) => x.goods_code === 'G1').stock === 6);

  // =====================================================================
  // 场景 3：反审销货单（批次加回 + 序列号恢复历史状态）
  // =====================================================================
  console.log('场景3：反审销货单冲转');
  const r3 = await svc.unpost('kuerp_goods_sales', 2);
  check('冲转分录数=1', r3.reversed === 1);
  check('批次库存还原 6→10', tbl('kuerp_goods_batch_stock')[0].stock === 10);
  check('序列号恢复在库/购货状态', tbl('kuerp_goods_serial').every((x) =>
    x.status === '1' && x.store_status === '1' && (x.sale_id === null || x.sale_id === undefined)));
  check('序列号流水删除本单 2 条', tbl('kuerp_goods_serial_log').length === 2);
  check('批次流水删除本单 1 条', tbl('kuerp_goods_batch_log').length === 1);
  check('G1 库存还原 10', tbl('kuerp_goods_stock').find((x) => x.goods_code === 'G1').stock === 6 + 4);
  check('商品总库存还原', tbl('kuerp_goods')[0].inventory === 10);

  // =====================================================================
  // 场景 4：反审采购单（批次冲减 + 序列号行删除）
  // =====================================================================
  console.log('场景4：反审采购单冲转');
  await svc.unpost('kuerp_goods_purchase', 1);
  check('批次库存冲减为 0', tbl('kuerp_goods_batch_stock')[0].stock === 0);
  check('序列号行已删除（本单创建）', tbl('kuerp_goods_serial').length === 0);
  check('序列号流水已清空', tbl('kuerp_goods_serial_log').length === 0);
  check('批次流水已清空', tbl('kuerp_goods_batch_log').length === 0);
  check('G1 库存还原 0', tbl('kuerp_goods_stock').find((x) => x.goods_code === 'G1').stock === 0);
  check('商品总库存还原 0', tbl('kuerp_goods')[0].inventory === 0);

  // =====================================================================
  // 场景 5：批次库存不足报错
  // =====================================================================
  console.log('场景5：批次库存不足拦截');
  reset();
  tbl('kuerp_goods').push({ id: 100, goods_code: 'G1', goods_name: '商品1', inventory: 0, batch: 1, serial: 0 });
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1' });
  tbl('kuerp_sets').push({ name: 'batch', is_checked: 1 }, { name: 'serial', is_checked: 1 });
  const bid = await seedPurchase({ batchName: 'B1', serials: [], number: 5, tax: 5 });
  check('采购入库后批次库存=5', tbl('kuerp_goods_batch_stock')[0].stock === 5);
  tbl('kuerp_goods_sales').push({ id: 2, purchase_code: 'X1', purchase_time: 2000, customers_id: 300, examine_status: 0, admin_id: 1 });
  tbl('kuerp_goods_sales_info').push({
    id: 21, purchase_code: 'X1', goods_code: 'G1', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number: 20, basic_nmber: 20, unit_price: 8, tax_included: 8,
    batch_id: bid, batch_name: 'B1', period: '',
  });
  let err = null;
  try {
    await svc.post('kuerp_goods_sales', 2);
  } catch (e) {
    err = e;
  }
  check('超量出库抛错（批次库存不足）', err && /批次库存不足/.test(err.message));
  check('批次库存未被改动', tbl('kuerp_goods_batch_stock')[0].stock === 5);

  // =====================================================================
  // 场景 6：序列号重复 / 已出库报错
  // =====================================================================
  console.log('场景6：序列号占用校验');
  reset();
  tbl('kuerp_goods').push({ id: 100, goods_code: 'G1', goods_name: '商品1', inventory: 0, batch: 0, serial: 1 });
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1' });
  tbl('kuerp_sets').push({ name: 'batch', is_checked: 1 }, { name: 'serial', is_checked: 1 });
  await seedPurchase({ code: 'P1', pid: 1, iid: 11, batchName: '', serials: ['SN001', 'SN002'], number: 5, tax: 5 });
  check('序列号入库 2 条', tbl('kuerp_goods_serial').length === 2);
  // 6a. 单内重复
  tbl('kuerp_goods_purchase').push({ id: 3, purchase_code: 'P2', purchase_time: 1000, supplyer_code: 'S1', examine_status: 0, admin_id: 1 });
  tbl('kuerp_goods_purchase_info').push({
    id: 31, purchase_code: 'P2', goods_code: 'G1', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number: 2, basic_nmber: 2, unit_price: 5, tax_included: 5,
    batch_id: 0, batch_name: '', period: JSON.stringify([{ serial: 'SN001' }, { serial: 'SN001' }]),
  });
  err = null;
  try {
    await svc.post('kuerp_goods_purchase', 3);
  } catch (e) {
    err = e;
  }
  check('单内序列号重复抛错', err && /重复/.test(err.message));
  // 6b. 跨单重复
  tbl('kuerp_goods_purchase_info').find((x) => x.id === 31).period = JSON.stringify([{ serial: 'SN001' }, { serial: 'SN003' }]);
  err = null;
  try {
    await svc.post('kuerp_goods_purchase', 3);
  } catch (e) {
    err = e;
  }
  check('跨单序列号占用抛错', err && /已被使用/.test(err.message));
  check('序列号未被写入', tbl('kuerp_goods_serial').length === 2);
  // 6c. 出库不存在的序列号
  tbl('kuerp_goods_sales').push({ id: 4, purchase_code: 'X9', purchase_time: 2000, customers_id: 300, examine_status: 0, admin_id: 1 });
  tbl('kuerp_goods_sales_info').push({
    id: 41, purchase_code: 'X9', goods_code: 'G1', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number: 1, basic_nmber: 1, unit_price: 8, tax_included: 8,
    batch_id: 0, batch_name: '', period: JSON.stringify([{ serial: 'SNXXX' }]),
  });
  err = null;
  try {
    await svc.post('kuerp_goods_sales', 4);
  } catch (e) {
    err = e;
  }
  check('出库不存在序列号抛错', err && /不存在或已出库/.test(err.message));

  // =====================================================================
  // 场景 7：系统参数关闭时不过账批次/序列号
  // =====================================================================
  console.log('场景7：系统参数开关');
  reset();
  tbl('kuerp_goods').push({ id: 100, goods_code: 'G1', goods_name: '商品1', inventory: 0, batch: 1, serial: 1 });
  tbl('kuerp_suppliers').push({ id: 200, supplyer_code: 'S1' });
  tbl('kuerp_sets').push({ name: 'batch', is_checked: 0 }, { name: 'serial', is_checked: 0 });
  tbl('kuerp_goods_purchase').push({ id: 1, purchase_code: 'P1', purchase_time: 1000, supplyer_code: 'S1', examine_status: 0, admin_id: 1 });
  tbl('kuerp_goods_purchase_info').push({
    id: 11, purchase_code: 'P1', goods_code: 'G1', goods_attr: 0, stores_id: 1,
    goods_unit: 1, number: 5, basic_nmber: 5, unit_price: 5, tax_included: 5,
    batch_id: 0, batch_name: 'B1', period: JSON.stringify([{ serial: 'SN001' }]),
  });
  await svc.post('kuerp_goods_purchase', 1);
  check('关闭后无批次记录', tbl('kuerp_goods_batch').length === 0 && tbl('kuerp_goods_batch_stock').length === 0);
  check('关闭后无序列号记录', tbl('kuerp_goods_serial').length === 0);
  check('库存仍正常过账', tbl('kuerp_goods_stock')[0].stock === 5);

  console.log(`\n批次/序列号过账测试：${passed} 项断言全部通过`);
})().catch((e) => {
  console.error('测试失败:', e);
  process.exit(1);
});
