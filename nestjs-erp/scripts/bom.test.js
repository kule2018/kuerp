/**
 * 组装单 / 拆卸单过账逻辑单测（无需真实数据库）：
 * 用内存伪 DataSource 复现 PostingService 发出的 SQL 语义，验证：
 *   组装单：子件出库(13) + 组合件入库(12)，组合件按明细 cost_money 入库；
 *   拆卸单：组合件出库(14) 按移动平均价 + 子件入库(15)；
 *   goods.inventory 总库存联动；反审可精确冲转还原。
 * 运行：node scripts/bom.test.js
 */
require('reflect-metadata');
const assert = require('assert');
const { PostingService } = require('../dist/kuerp/posting/posting.service');

// —— 内存数据仓库 ——
const store = {
  // G1=子件(零件)，G2=组合件(成品)
  kuerp_goods: [
    { id: 100, goods_code: 'G1', goods_name: '零件', inventory: 0, batch: 0, serial: 0 },
    { id: 101, goods_code: 'G2', goods_name: '成品', inventory: 0, batch: 0, serial: 0 },
  ],
  kuerp_goods_stock: [],
  kuerp_goods_log: [],
  kuerp_sets: [],
  kuerp_suppliers: [{ id: 200, supplyer_code: 'S1' }],
  kuerp_assemble: [],
  kuerp_assemble_info: [],
  kuerp_split: [],
  kuerp_split_info: [],
};
let autoId = 1000;

/** 伪 DataSource：按 PostingService 实际下发的 SQL 模式分别处理 */
const fake = {
  options: { type: 'mysql' },
  async query(sql, params = []) {
    const s = String(sql).replace(/\s+/g, ' ').trim();

    let m = /^SELECT \* FROM `(\w+)` WHERE id = \? LIMIT 1$/.exec(s);
    if (m) return store[m[1]].filter((r) => r.id === params[0]).slice(0, 1);

    m = /^SELECT \* FROM `(\w+)` WHERE `(\w+)` = \?$/.exec(s);
    if (m) return store[m[1]].filter((r) => String(r[m[2]]) === String(params[0]));

    m = /^SELECT id FROM `(\w+)` WHERE `(\w+)` = \?$/.exec(s);
    if (m) return store[m[1]].filter((r) => String(r[m[2]]) === String(params[0])).map((r) => ({ id: r.id }));

    if (/FROM kuerp_sets WHERE name IN/.test(s)) {
      return ['batch', 'serial'].map((name) => {
        const row = store.kuerp_sets.find((x) => x.name === name);
        return { name, is_checked: row ? row.is_checked : 0 };
      });
    }
    if (/SELECT batch, serial FROM kuerp_goods WHERE goods_code = \? LIMIT 1$/.test(s)) {
      const g = store.kuerp_goods.find((x) => x.goods_code === params[0]);
      return g ? [{ batch: g.batch || 0, serial: g.serial || 0 }] : [];
    }
    if (/FROM kuerp_goods WHERE goods_code = \? LIMIT 1$/.test(s)) {
      const g = store.kuerp_goods.find((x) => x.goods_code === params[0]);
      return g ? [{ id: g.id }] : [];
    }
    if (/FROM kuerp_suppliers WHERE supplyer_code = \? LIMIT 1$/.test(s)) {
      const g = store.kuerp_suppliers.find((x) => x.supplyer_code === params[0]);
      return g ? [{ id: g.id }] : [];
    }
    if (/^SELECT id, stock, cost_money FROM kuerp_goods_stock WHERE goods_code = \? AND stores_id = \?/.test(s)) {
      const row = store.kuerp_goods_stock.find(
        (r) => r.goods_code === params[0] && r.stores_id === params[1] &&
          (params.length < 3 || r.attribute_id === params[2]),
      );
      return row ? [{ id: row.id, stock: row.stock, cost_money: row.cost_money }] : [];
    }
    if (/^UPDATE kuerp_goods_stock SET stock = \?, cost_money = \?/.test(s)) {
      const row = store.kuerp_goods_stock.find((r) => r.id === params[3]);
      if (row) { row.stock = params[0]; row.cost_money = params[1]; }
      return { affected: 1 };
    }
    if (/^INSERT INTO kuerp_goods_stock/.test(s)) {
      const [, , goods_code, attr, stores_id, stock, unit_cost, cost_money] = params;
      const g = store.kuerp_goods.find((x) => x.goods_code === goods_code);
      store.kuerp_goods_stock.push({
        id: ++autoId, goods_id: g ? g.id : 0, goods_code, attribute_id: attr,
        stores_id, stock, unit_cost, cost_money,
      });
      return { insertId: autoId };
    }
    if (/^UPDATE kuerp_goods SET inventory = COALESCE\(inventory,0\) \+ \? WHERE id = \?$/.test(s)) {
      const g = store.kuerp_goods.find((x) => x.id === params[1]);
      if (g) g.inventory = (g.inventory || 0) + params[0];
      return { affected: 1 };
    }
    if (/^INSERT INTO kuerp_goods_log/.test(s)) {
      const cols = s.slice(s.indexOf('(') + 1, s.indexOf(') VALUES')).split(',').map((c) => c.trim().replace(/`/g, ''));
      const row = {};
      cols.forEach((c, i) => (row[c] = params[i]));
      row.id = ++autoId;
      store.kuerp_goods_log.push(row);
      return { insertId: autoId };
    }
    if (/^SELECT \* FROM kuerp_goods_log WHERE purchase_code = \? AND business_type IN/.test(s)) {
      const types = params.slice(1).map(String);
      return store.kuerp_goods_log.filter((r) => r.purchase_code === params[0] && types.includes(String(r.business_type)));
    }
    if (/^DELETE FROM kuerp_goods_log WHERE purchase_code = \? AND business_type IN/.test(s)) {
      const types = params.slice(1).map(String);
      const before = store.kuerp_goods_log.length;
      store.kuerp_goods_log = store.kuerp_goods_log.filter(
        (r) => !(r.purchase_code === params[0] && types.includes(String(r.business_type))),
      );
      return { affected: before - store.kuerp_goods_log.length };
    }
    // 批次/序列号联动表（本测试不涉及）
    if (/kuerp_goods_batch|kuerp_goods_serial/.test(s)) {
      if (/^SELECT/.test(s)) return [];
      return { affected: 0 };
    }
    throw new Error('未匹配的 SQL: ' + s);
  },
};

const svc = new PostingService(fake);
const approx = (a, b) => assert.ok(Math.abs((a || 0) - b) < 1e-6, `期望 ${b} 实际 ${a}`);
const stockOf = (code) => store.kuerp_goods_stock.find((r) => r.goods_code === code);
const goodsOf = (code) => store.kuerp_goods.find((g) => g.goods_code === code);

(async () => {
  // ——— 前置：给子件 G1 备库存 10 件 @5（成本 50），组合件 G2 无库存 ———
  store.kuerp_goods_log.push({
    id: 1, purchase_code: 'INIT', business_type: '2', goods_id: 100, goods_code: 'G1',
    stores_id: 1, attribute_id: 0, enter_basics: 10, enter_cost: 50, out_basics: null, out_cost: null,
    balance_basics: 10, balance_unit: 5, balance_cost: 50,
  });
  store.kuerp_goods_stock.push({ id: 1, goods_id: 100, goods_code: 'G1', attribute_id: 0, stores_id: 1, stock: 10, cost_money: 50 });
  goodsOf('G1').inventory = 10;

  // ——— 场景1：组装单 —— 2 个子件 G1（各 2 件）组成 1 个组合件 G2 ———
  store.kuerp_assemble.push({ id: 1, admin_id: 1, purchase_code: 'ZZ1', purchase_time: 100, business_type: '1', examine_status: 0 });
  store.kuerp_assemble_info.push(
    // 子件：出库 4 件（2 行 × 2 件），按移动平均价 5 出库
    { id: 11, purchase_code: 'ZZ1', type: '2', goods_id: 100, goods_code: 'G1', goods_attr: 0, goods_unit: 1, stores_id: 1, number: 2, basic_number: 2, unit_cost: 5, cost_money: 10, period: '', batch_id: 0, batch: '' },
    { id: 12, purchase_code: 'ZZ1', type: '2', goods_id: 100, goods_code: 'G1', goods_attr: 0, goods_unit: 1, stores_id: 1, number: 2, basic_number: 2, unit_cost: 5, cost_money: 10, period: '', batch_id: 0, batch: '' },
    // 组合件：入库 1 件，成本 20（= 子件成本合计）
    { id: 13, purchase_code: 'ZZ1', type: '1', goods_id: 101, goods_code: 'G2', goods_attr: 0, goods_unit: 1, stores_id: 1, number: 1, basic_number: 1, unit_cost: 20, cost_money: 20, period: '', batch_id: 0, batch: '' },
  );
  await svc.post('kuerp_assemble', 1);
  store.kuerp_assemble[0].examine_status = 1;

  approx(stockOf('G1').stock, 6);   // 10 - 4
  approx(stockOf('G1').cost_money, 30); // 50 - 4*5
  approx(goodsOf('G1').inventory, 6);
  approx(stockOf('G2').stock, 1);
  approx(stockOf('G2').cost_money, 20);
  approx(goodsOf('G2').inventory, 1);
  assert.strictEqual(store.kuerp_goods_log.length, 4); // 1 条初始 + 3 条组装
  const zzOut = store.kuerp_goods_log.filter((r) => String(r.business_type) === '13');
  const zzIn = store.kuerp_goods_log.filter((r) => String(r.business_type) === '12');
  assert.strictEqual(zzOut.length, 2, '子件出库明细 2 条');
  assert.strictEqual(zzIn.length, 1, '组合件入库明细 1 条');
  approx(zzIn[0].enter_cost, 20);
  approx(zzOut[0].out_unit, 5); // 按移动平均价出库
  console.log('✅ 组装单：子件出库 4@5 + 组合件入库 1@20 → G1=6/30，G2=1/20');

  // ——— 场景2：组装单反审 → 精确还原 ———
  await svc.unpost('kuerp_assemble', 1);
  approx(stockOf('G1').stock, 10);
  approx(stockOf('G1').cost_money, 50);
  approx(goodsOf('G1').inventory, 10);
  approx(stockOf('G2').stock, 0);
  approx(stockOf('G2').cost_money, 0);
  approx(goodsOf('G2').inventory, 0);
  assert.strictEqual(store.kuerp_goods_log.length, 1, '仅剩初始入库流水');
  console.log('✅ 组装单反审：库存/成本/明细全部还原');

  // ——— 场景3：拆卸单 —— 1 个组合件 G2 拆成 2 个子件 G1 ———
  // 先给 G2 备库存 2 件 @20（成本 40）：复用场景1 中已建立的库存行，避免同键重复行
  const g2Stock = stockOf('G2');
  g2Stock.stock = 2;
  g2Stock.cost_money = 40;
  goodsOf('G2').inventory = 2;

  store.kuerp_split.push({ id: 2, admin_id: 1, purchase_code: 'CX1', purchase_time: 200, business_type: '1', examine_status: 0 });
  store.kuerp_split_info.push(
    // 组合件：出库 1 件，按移动平均价 20
    { id: 21, purchase_code: 'CX1', type: '1', goods_id: 101, goods_code: 'G2', goods_attr: 0, goods_unit: 1, stores_id: 1, number: 1, basic_number: 1, unit_cost: 20, cost_money: 20, period: '', batch_id: 0, batch: '' },
    // 子件：入库 2 件，成本合计 20（明细指定）
    { id: 22, purchase_code: 'CX1', type: '2', goods_id: 100, goods_code: 'G1', goods_attr: 0, goods_unit: 1, stores_id: 1, number: 2, basic_number: 2, unit_cost: 10, cost_money: 20, period: '', batch_id: 0, batch: '' },
  );
  await svc.post('kuerp_split', 2);
  store.kuerp_split[0].examine_status = 1;

  approx(stockOf('G2').stock, 1);   // 2 - 1
  approx(stockOf('G2').cost_money, 20); // 40 - 20
  approx(goodsOf('G2').inventory, 1);
  approx(stockOf('G1').stock, 12);  // 10 + 2
  approx(stockOf('G1').cost_money, 70); // 50 + 20
  approx(goodsOf('G1').inventory, 12);
  const cxOut = store.kuerp_goods_log.filter((r) => String(r.business_type) === '14');
  const cxIn = store.kuerp_goods_log.filter((r) => String(r.business_type) === '15');
  assert.strictEqual(cxOut.length, 1, '组合件出库明细 1 条');
  assert.strictEqual(cxIn.length, 1, '子件入库明细 1 条');
  approx(cxOut[0].out_unit, 20); // 按移动平均价出库
  approx(cxIn[0].enter_cost, 20);
  console.log('✅ 拆卸单：组合件出库 1@20 + 子件入库 2（成本20） → G2=1/20，G1=12/70');

  // ——— 场景4：拆卸单反审 → 还原 ———
  await svc.unpost('kuerp_split', 2);
  approx(stockOf('G2').stock, 2);
  approx(stockOf('G2').cost_money, 40);
  approx(goodsOf('G2').inventory, 2);
  approx(stockOf('G1').stock, 10);
  approx(stockOf('G1').cost_money, 50);
  approx(goodsOf('G1').inventory, 10);
  assert.ok(!store.kuerp_goods_log.some((r) => ['14', '15'].includes(String(r.business_type))), '拆卸流水已清除');
  console.log('✅ 拆卸单反审：库存/成本/明细全部还原');

  // ——— 场景5：子件库存不足应拦截 ———
  store.kuerp_assemble.push({ id: 3, admin_id: 1, purchase_code: 'ZZ2', purchase_time: 300, business_type: '1', examine_status: 0 });
  store.kuerp_assemble_info.push(
    { id: 31, purchase_code: 'ZZ2', type: '2', goods_id: 100, goods_code: 'G1', goods_attr: 0, goods_unit: 1, stores_id: 1, number: 999, basic_number: 999, unit_cost: 5, cost_money: 4995, period: '', batch_id: 0, batch: '' },
    { id: 32, purchase_code: 'ZZ2', type: '1', goods_id: 101, goods_code: 'G2', goods_attr: 0, goods_unit: 1, stores_id: 1, number: 1, basic_number: 1, unit_cost: 20, cost_money: 20, period: '', batch_id: 0, batch: '' },
  );
  let threw = false;
  try { await svc.post('kuerp_assemble', 3); } catch { threw = true; }
  assert.ok(threw, '子件库存不足应抛错');
  console.log('✅ 子件库存不足被拦截');

  console.log('\n🎉 组装/拆卸过账单测全部通过');
  process.exit(0);
})().catch((e) => {
  console.error('❌ 测试失败：', e.message);
  console.error(e.stack);
  process.exit(1);
});
