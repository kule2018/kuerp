/**
 * 过账引擎逻辑单测（无需真实数据库）：
 * 用一个内存伪 DataSource 精确复现 PostingService 发出的 SQL 语义，
 * 验证「采购入库 → 二次采购(移动平均) → 销货出库 → 反审冲转」全链路：
 *   - 库存数量 goods_stock.stock 正确增减；
 *   - 移动平均成本 cost_money / stock 计算正确；
 *   - goods_log 收发明细 enter/out/balance 字段正确；
 *   - 商品总库存 kuerp_goods.inventory 联动正确；
 *   - 反审冲转可精确撤销过账（库存/成本/明细全部还原）。
 * 运行：node scripts/posting.test.js
 */
require('reflect-metadata');
const assert = require('assert');
const { PostingService } = require('../dist/kuerp/posting/posting.service');

// —— 内存数据仓库 ——
const store = {
  kuerp_goods: [{ id: 100, goods_code: 'G1', goods_name: '商品1', inventory: 0, purchase_price: 5, batch: 0, serial: 0 }],
  kuerp_goods_stock: [],
  kuerp_goods_log: [],
  kuerp_sets: [],
  kuerp_suppliers: [{ id: 200, supplyer_code: 'S1' }],
  kuerp_goods_purchase: [],
  kuerp_goods_purchase_info: [],
  kuerp_goods_sales: [],
  kuerp_goods_sales_info: [],
};
let autoId = 1000;

/** 伪 DataSource：按 PostingService 实际下发的 SQL 模式分别处理 */
/** 汇总表真实列集合（SummaryService 用 INFORMATION_SCHEMA 做列交集过滤） */
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

const fake = {
  options: { type: 'mysql' },
  async query(sql, params = []) {
    const s = String(sql).replace(/\s+/g, ' ').trim();

    // 表头：SELECT * FROM `tbl` WHERE id = ? LIMIT 1
    let m = /^SELECT \* FROM `(\w+)` WHERE id = \? LIMIT 1$/.exec(s);
    if (m) return store[m[1]].filter((r) => r.id === params[0]).slice(0, 1);

    // 明细：SELECT * FROM `tbl` WHERE `field` = ?
    m = /^SELECT \* FROM `(\w+)` WHERE `(\w+)` = \?$/.exec(s);
    if (m) return store[m[1]].filter((r) => String(r[m[2]]) === String(params[0]));

    // 明细ID列表：SELECT id FROM `tbl` WHERE `field` = ?（批次/序列号冲转用）
    m = /^SELECT id FROM `(\w+)` WHERE `(\w+)` = \?$/.exec(s);
    if (m) return store[m[1]].filter((r) => String(r[m[2]]) === String(params[0])).map((r) => ({ id: r.id }));

    // 系统参数开关（批次/序列号）
    if (/FROM kuerp_sets WHERE name IN/.test(s)) {
      const names = ['batch', 'serial'];
      return names.map((name) => {
        const row = store.kuerp_sets.find((x) => x.name === name);
        return { name, is_checked: row ? row.is_checked : 0 };
      });
    }
    // 商品批次/序列号开关
    if (/SELECT batch, serial FROM kuerp_goods WHERE goods_code = \? LIMIT 1$/.test(s)) {
      const g = store.kuerp_goods.find((x) => x.goods_code === params[0]);
      return g ? [{ batch: g.batch || 0, serial: g.serial || 0 }] : [];
    }
    // 商品ID
    if (/FROM kuerp_goods WHERE goods_code = \? LIMIT 1$/.test(s)) {
      const g = store.kuerp_goods.find((x) => x.goods_code === params[0]);
      return g ? [{ id: g.id }] : [];
    }
    // 供应商ID
    if (/FROM kuerp_suppliers WHERE supplyer_code = \? LIMIT 1$/.test(s)) {
      const g = store.kuerp_suppliers.find((x) => x.supplyer_code === params[0]);
      return g ? [{ id: g.id }] : [];
    }
    // 库存行查询
    if (/^SELECT id, stock, cost_money FROM kuerp_goods_stock WHERE goods_code = \? AND stores_id = \?/.test(s)) {
      const row = store.kuerp_goods_stock.find(
        (r) => r.goods_code === params[0] && r.stores_id === params[1] &&
          (params.length < 3 || r.attribute_id === params[2]),
      );
      return row ? [{ id: row.id, stock: row.stock, cost_money: row.cost_money }] : [];
    }
    // 更新库存行
    if (/^UPDATE kuerp_goods_stock SET stock = \?, cost_money = \?/.test(s)) {
      const row = store.kuerp_goods_stock.find((r) => r.id === params[3]);
      if (row) { row.stock = params[0]; row.cost_money = params[1]; }
      return { affected: 1 };
    }
    // 新增库存行（含 goods_id 子查询）
    // 参数顺序：admin_id, goods_id(子查询), goods_code, attribute_id, stores_id, stock, unit_cost, cost_money, createtime, updatetime
    if (/^INSERT INTO kuerp_goods_stock/.test(s)) {
      const [admin_id, , goods_code, attr, stores_id, stock, unit_cost, cost_money] = params;
      const g = store.kuerp_goods.find((x) => x.goods_code === goods_code);
      store.kuerp_goods_stock.push({
        id: ++autoId, goods_id: g ? g.id : 0, goods_code, attribute_id: attr,
        stores_id, stock, unit_cost, cost_money,
      });
      return { insertId: autoId };
    }
    // 更新商品总库存
    if (/^UPDATE kuerp_goods SET inventory = COALESCE\(inventory,0\) \+ \? WHERE id = \?$/.test(s)) {
      const g = store.kuerp_goods.find((x) => x.id === params[1]);
      if (g) g.inventory = (g.inventory || 0) + params[0];
      return { affected: 1 };
    }
    // 插入收发明细
    if (/^INSERT INTO kuerp_goods_log/.test(s)) {
      const cols = s.slice(s.indexOf('(') + 1, s.indexOf(') VALUES')).split(',').map((c) => c.trim().replace(/`/g, ''));
      const row = {};
      cols.forEach((c, i) => (row[c] = params[i]));
      row.id = ++autoId;
      store.kuerp_goods_log.push(row);
      return { insertId: autoId };
    }
    // 查询收发明细（冲转用）
    if (/^SELECT \* FROM kuerp_goods_log WHERE purchase_code = \? AND business_type IN/.test(s)) {
      const types = params.slice(1).map(String);
      return store.kuerp_goods_log.filter((r) => r.purchase_code === params[0] && types.includes(String(r.business_type)));
    }
    // 删除收发明细（冲转）
    if (/^DELETE FROM kuerp_goods_log WHERE purchase_code = \? AND business_type IN/.test(s)) {
      const types = params.slice(1).map(String);
      const before = store.kuerp_goods_log.length;
      store.kuerp_goods_log = store.kuerp_goods_log.filter(
        (r) => !(r.purchase_code === params[0] && types.includes(String(r.business_type))),
      );
      return { affected: before - store.kuerp_goods_log.length };
    }
    // —— 汇总表同步（SummaryService：采购/销售汇总表 + 销售利润表）——
    // 按单据编号取明细行（SummaryService 的 WHERE 字段未加反引号）
    m = /^SELECT \* FROM `(\w+)` WHERE (\w+) = \?$/.exec(s);
    if (m) return (store[m[1]] || []).filter((r) => String(r[m[2]]) === String(params[0]));
    // 读取目标表列元信息（列交集过滤用）
    if (/^SELECT COLUMN_NAME AS name FROM INFORMATION_SCHEMA.COLUMNS/.test(s)) {
      const cols = SUMMARY_COLUMNS[params[0]] || [];
      return cols.map((name) => ({ name }));
    }
    // 汇总表写入
    m = /^INSERT INTO `(kuerp_\w+)` \((.+)\) VALUES /.exec(s);
    if (m) {
      const cols = m[2].split(',').map((c) => c.trim().replace(/`/g, ''));
      const row = {};
      cols.forEach((c, i) => (row[c] = params[i]));
      row.id = ++autoId;
      (store[m[1]] = store[m[1]] || []).push(row);
      return { insertId: autoId };
    }
    // 销售利润表写死列顺序，单独处理
    if (/^INSERT INTO kuerp_goods_sales_profit/.test(s)) {
      const cols = s.slice(s.indexOf('(') + 1, s.indexOf(') VALUES')).split(',').map((c) => c.trim().replace(/\s/g, ''));
      const row = {};
      cols.forEach((c, i) => (row[c] = params[i]));
      row.id = ++autoId;
      (store.kuerp_goods_sales_profit = store.kuerp_goods_sales_profit || []).push(row);
      return { insertId: autoId };
    }
    // 销售成本：取本单收发明细的出库成本合计
    if (/^SELECT IFNULL\(SUM\(out_cost\),0\) AS oc, IFNULL\(SUM\(enter_cost\),0\) AS ec FROM kuerp_goods_log WHERE purchase_code = \?$/.test(s)) {
      const rows = store.kuerp_goods_log.filter((r) => r.purchase_code === params[0]);
      return [{
        oc: rows.reduce((t, r) => t + (Number(r.out_cost) || 0), 0),
        ec: rows.reduce((t, r) => t + (Number(r.enter_cost) || 0), 0),
      }];
    }
    // 汇总表 / 利润表 冲转删除
    m = /^DELETE FROM `(kuerp_\w+)` WHERE purchase_code = \? AND purchase_type = \?$/.exec(s);
    if (m) {
      const before = (store[m[1]] || []).length;
      store[m[1]] = (store[m[1]] || []).filter(
        (r) => !(r.purchase_code === params[0] && String(r.purchase_type) === String(params[1])),
      );
      return { affected: before - store[m[1]].length };
    }
    if (/^DELETE FROM kuerp_goods_sales_profit WHERE purchase_code = \? AND purchase_type = \?$/.test(s)) {
      const before = (store.kuerp_goods_sales_profit || []).length;
      store.kuerp_goods_sales_profit = (store.kuerp_goods_sales_profit || []).filter(
        (r) => !(r.purchase_code === params[0] && String(r.purchase_type) === String(params[1])),
      );
      return { affected: before - store.kuerp_goods_sales_profit.length };
    }
    // 批次/序列号联动表（本测试不涉及，统一按空数据处理）
    if (/kuerp_goods_batch|kuerp_goods_serial/.test(s)) {
      if (/^SELECT/.test(s)) return [];
      return { affected: 0 };
    }
    throw new Error('未匹配的 SQL: ' + s);
  },
};

const svc = new PostingService(fake);
const approx = (a, b) => assert.ok(Math.abs(a - b) < 1e-6, `期望 ${b} 实际 ${a}`);
const stock = () => store.kuerp_goods_stock[0];

(async () => {
  // 1) 采购入库：10 件 @ 含税单价 5
  store.kuerp_goods_purchase.push({ id: 1, purchase_code: 'P1', purchase_time: 100, supplyer_code: 'S1', examine_status: 0, admin_id: 1 });
  store.kuerp_goods_purchase_info.push({ id: 11, purchase_code: 'P1', goods_code: 'G1', goods_attr: 0, stores_id: 1, goods_unit: 1, number: 10, basic_nmber: 10, tax_included: 5, unit_price: 5 });
  await svc.post('kuerp_goods_purchase', 1);
  store.kuerp_goods_purchase[0].examine_status = 1; // 模拟 examine 翻转状态
  approx(stock().stock, 10); approx(stock().cost_money, 50);
  approx(store.kuerp_goods[0].inventory, 10);
  assert.strictEqual(store.kuerp_goods_log.length, 1);
  approx(store.kuerp_goods_log[0].enter_basics, 10);
  approx(store.kuerp_goods_log[0].enter_cost, 50);
  approx(store.kuerp_goods_log[0].balance_unit, 5);
  console.log('✅ 采购入库 10@5 → stock=10 cost=50 unit=5');

  // 2) 二次采购：10 件 @ 含税单价 7 → 移动平均单价 = 120/20 = 6
  store.kuerp_goods_purchase.push({ id: 2, purchase_code: 'P2', purchase_time: 200, supplyer_code: 'S1', examine_status: 0, admin_id: 1 });
  store.kuerp_goods_purchase_info.push({ id: 12, purchase_code: 'P2', goods_code: 'G1', goods_attr: 0, stores_id: 1, goods_unit: 1, number: 10, basic_nmber: 10, tax_included: 7, unit_price: 7 });
  await svc.post('kuerp_goods_purchase', 2);
  store.kuerp_goods_purchase[1].examine_status = 1;
  approx(stock().stock, 20); approx(stock().cost_money, 120);
  approx(store.kuerp_goods[0].inventory, 20);
  approx(store.kuerp_goods_log[1].balance_unit, 6); // 结存平均价
  console.log('✅ 二次采购 10@7 → stock=20 cost=120 移动平均 unit=6');

  // 3) 销货出库 5 件 → 按平均价 6 出库，出库成本 30；结存 15 / 90（单价仍 6）
  store.kuerp_goods_sales.push({ id: 3, purchase_code: 'SALE1', purchase_time: 300, customers_id: 5, examine_status: 0, admin_id: 1 });
  store.kuerp_goods_sales_info.push({ id: 13, purchase_code: 'SALE1', goods_code: 'G1', goods_attr: 0, stores_id: 1, goods_unit: 1, number: 5, basic_nmber: 5, cost_price: 0 });
  await svc.post('kuerp_goods_sales', 3);
  store.kuerp_goods_sales[0].examine_status = 1;
  approx(stock().stock, 15); approx(stock().cost_money, 90);
  approx(store.kuerp_goods[0].inventory, 15);
  approx(store.kuerp_goods_log[2].out_unit, 6);
  approx(store.kuerp_goods_log[2].out_cost, 30);
  approx(store.kuerp_goods_log[2].balance_unit, 6);
  console.log('✅ 销货出库 5 → stock=15 cost=90 out_cost=30 平均价保持 6');

  // 4) 库存不足拦截：出库 999 应抛错
  store.kuerp_goods_sales.push({ id: 4, purchase_code: 'SALE2', purchase_time: 400, customers_id: 5, examine_status: 0, admin_id: 1 });
  store.kuerp_goods_sales_info.push({ id: 14, purchase_code: 'SALE2', goods_code: 'G1', goods_attr: 0, stores_id: 1, goods_unit: 1, number: 999, basic_nmber: 999, cost_price: 0 });
  let threw = false;
  try { await svc.post('kuerp_goods_sales', 4); } catch { threw = true; }
  assert.ok(threw, '库存不足应抛错');
  console.log('✅ 库存不足被拦截');

  // 5) 反审销货单 → 精确还原到 20 / 120 / 20
  await svc.unpost('kuerp_goods_sales', 3);
  approx(stock().stock, 20); approx(stock().cost_money, 120);
  approx(store.kuerp_goods[0].inventory, 20);
  assert.strictEqual(store.kuerp_goods_log.length, 2);
  console.log('✅ 反审销货单 → stock=20 cost=120 明细回到 2 条');

  // 6) 依次反审两笔采购 → 全部归零
  await svc.unpost('kuerp_goods_purchase', 2);
  await svc.unpost('kuerp_goods_purchase', 1);
  approx(stock().stock, 0); approx(stock().cost_money, 0);
  approx(store.kuerp_goods[0].inventory, 0);
  assert.strictEqual(store.kuerp_goods_log.length, 0);
  console.log('✅ 反审两笔采购 → 库存/成本/总库存/明细全部归零');

  console.log('\n🎉 过账引擎逻辑单测全部通过');
  process.exit(0);
})().catch((e) => {
  console.error('❌ 过账逻辑测试失败:', e.message);
  if (e.stack) console.error(e.stack.split('\n').slice(0, 12).join('\n'));
  process.exit(1);
});
