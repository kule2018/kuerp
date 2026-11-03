/**
 * 单号规则引擎与对单功能单测（无需真实数据库）。
 *
 * 覆盖 TableService 的两块新逻辑（对应 3.设置/1.系统参数.md「单号设置」
 * 与原系统 GoodsPurchase::counter / Goods::getCodes）：
 *   genCodeByRule（等价原系统 Goods::getCodes 管理端口径）：
 *     - 表名/字段白名单校验（拒绝注入形态入参）
 *     - 表不存在、字段不存在、规则未配置均报错
 *     - 序号从规则 start 起步、按 strlen 左侧补零，前缀 + 日期段（年/月/日参与，时分秒不参与）
 *     - 与目标表现有编码查重，已占用则序号 +1 继续尝试（号段空洞会被回填，与原系统一致）
 *     - 同表多规则时按 field 精确匹配（销货单 purchase_code / 零售单 order_code）
 *     - 序号空间不足（连续冲突达上限）时报错
 *   counter（对单/反对单）：
 *     - 无 check_status 列的表拒绝
 *     - 对单仅作用于未对单行、反对单仅作用于已对单行
 *     - 无匹配行时报「请选择需要对单/反对单的数据」
 *     - 已结账且选中单据日期 <= 结账日期时整体拒绝（不要求已审核）
 *     - 同步写入最后操作人 operation_id
 * 运行：node scripts/prefix.test.js
 */
require('reflect-metadata');
const assert = require('assert');
const { TableService } = require('../dist/kuerp/table/table.service');

let pass = 0;
/** 断言并计数 */
const check = (cond, msg) => {
  assert.ok(cond, msg);
  pass++;
  console.log('  ✓ ' + msg);
};

/** 今日日期段（规则中 年/月/日 参与编号） */
const d = new Date();
const p2 = (n) => String(n).padStart(2, '0');
const TODAY = `${d.getFullYear()}${p2(d.getMonth() + 1)}${p2(d.getDate())}`;

// —— 表元信息（模拟 INFORMATION_SCHEMA.COLUMNS 返回）——
const COLUMNS = {
  // 4 个购销单据表：有 check_status + operation_id
  kuerp_goods_purchase: [
    { name: 'id', type: 'int', ckey: 'PRI' },
    { name: 'purchase_code', type: 'varchar' },
    { name: 'purchase_time', type: 'bigint' },
    { name: 'examine_status', type: 'enum' },
    { name: 'check_status', type: 'enum' },
    { name: 'operation_id', type: 'int' },
    { name: 'updatetime', type: 'bigint' },
  ],
  kuerp_goods_sales: [
    { name: 'id', type: 'int', ckey: 'PRI' },
    { name: 'purchase_code', type: 'varchar' },
    { name: 'order_code', type: 'varchar' },
    { name: 'purchase_time', type: 'bigint' },
    { name: 'examine_status', type: 'enum' },
    { name: 'check_status', type: 'enum' },
    { name: 'updatetime', type: 'bigint' },
  ],
  // 无对单状态列的普通表（用于 counter 拒绝场景）
  kuerp_goods: [
    { name: 'id', type: 'int', ckey: 'PRI' },
    { name: 'goods_code', type: 'varchar' },
    { name: 'goods_name', type: 'varchar' },
  ],
};

// —— 内存数据仓库 ——
const store = {
  // 单号规则（对应 schema.sql 种子：购货单 / 销货单 / 零售单 + 一条占位规则）
  kuerp_prefix: [
    {
      id: 8, name: '购货单', prefix: 'GHD', year: '1', month: '1', day: '1',
      hour: '2', minute: '2', second: '2', start: 1, strlen: 3,
      dbname: 'kuerp_goods_purchase', field: 'purchase_code',
    },
    {
      id: 11, name: '销货单', prefix: 'XHD', year: '1', month: '1', day: '1',
      hour: '2', minute: '2', second: '2', start: 1, strlen: 3,
      dbname: 'kuerp_goods_sales', field: 'purchase_code',
    },
    {
      id: 28, name: '零售单', prefix: 'POS', year: '1', month: '1', day: '1',
      hour: '2', minute: '2', second: '2', start: 1, strlen: 3,
      dbname: 'kuerp_goods_sales', field: 'order_code',
    },
    {
      // 序号空间不足场景：uniqueness 对该前缀永远冲突
      id: 99, name: '占位单', prefix: 'FULL', year: '2', month: '2', day: '2',
      hour: '2', minute: '2', second: '2', start: 1, strlen: 3,
      dbname: 'kuerp_goods_purchase', field: 'purchase_code',
    },
  ],
  // 购货单：001 与 003 已占用（002 为空洞），check_status 混合
  kuerp_goods_purchase: [
    { id: 1, purchase_code: `GHD${TODAY}001`, purchase_time: 1000, examine_status: '1', check_status: '0', operation_id: 0 },
    { id: 2, purchase_code: `GHD${TODAY}003`, purchase_time: 2000, examine_status: '0', check_status: '1', operation_id: 0 },
  ],
  kuerp_goods_sales: [
    { id: 3, purchase_code: `XHD${TODAY}002`, order_code: `POS${TODAY}002`, purchase_time: 3000, examine_status: '1', check_status: '0', operation_id: 0 },
  ],
  kuerp_checkout: [],
};

/** 把 IN 占位串展开为实际值数组（按顺序消费 params） */
function expandIn(marks, params) {
  return marks.split(',').map(() => params.shift());
}

/**
 * 伪 DataSource：覆盖 TableService 在 genCodeByRule / counter 链路中实际下发的 SQL。
 * 未匹配的 SQL 直接抛错，保证测试对服务端行为变化的敏感度。
 */
const fake = {
  options: { type: 'mysql' },
  async query(sql, params = []) {
    const s = String(sql).replace(/\s+/g, ' ').trim();
    const p = [...params];
    let m;

    // —— INFORMATION_SCHEMA：物理表清单（listRawTables）——
    if (/^SELECT TABLE_NAME AS `table` FROM INFORMATION_SCHEMA.TABLES/.test(s)) {
      return Object.keys(COLUMNS).map((t) => ({ table: t }));
    }

    // —— INFORMATION_SCHEMA：列元信息（meta）——
    m = /^SELECT COLUMN_NAME AS name, DATA_TYPE AS type, COLUMN_KEY AS ckey FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE\(\) AND TABLE_NAME = \?$/.exec(s);
    if (m) return COLUMNS[p.shift()] || [];

    // —— 单号规则：同 dbname 多规则时 field 精确匹配优先，其次 id 升序 —
    m = /^SELECT \* FROM `kuerp_prefix` WHERE dbname = \? ORDER BY \(field = \?\) DESC, id ASC LIMIT 1$/.exec(s);
    if (m) {
      const dbname = p.shift();
      const field = p.shift();
      const rows = store.kuerp_prefix
        .filter((r) => r.dbname === dbname)
        // 模拟 MySQL「ORDER BY (field = ?) DESC, id ASC」：命中 field 的排前，其余按 id 升序
        .sort((a, b) => {
          const am = a.field === field ? 1 : 0;
          const bm = b.field === field ? 1 : 0;
          return bm - am || a.id - b.id;
        });
      return rows.length ? [{ ...rows[0] }] : [];
    }

    // —— 编号查重 ——
    m = /^SELECT `(\w+)` FROM `(\w+)` WHERE `(\w+)` = \? LIMIT 1$/.exec(s);
    if (m) {
      const val = p.shift();
      // FULL 前缀模拟「序号空间不足」：任何候选都视为已存在
      if (String(val).startsWith('FULL')) return [{ id: 1 }];
      const hit = (store[m[2]] || []).find((r) => String(r[m[3]]) === String(val));
      return hit ? [{ id: hit.id }] : [];
    }

    // —— 当前结账日期 ——
    if (/^SELECT checktime FROM `kuerp_checkout` ORDER BY id DESC LIMIT 1$/.test(s)) {
      const last = store.kuerp_checkout[store.kuerp_checkout.length - 1];
      return last ? [{ checktime: last.checktime }] : [];
    }

    // —— 结账守卫计数（可选 examine_status 条件）——
    m = /^SELECT COUNT\(\*\) AS c FROM `(\w+)` WHERE (`examine_status` = 1 AND )?`(\w+)` <= \? AND `(\w+)` IN \((.+)\)$/.exec(s);
    if (m) {
      const table = m[1];
      const dateCol = m[3];
      const cd = p.shift();
      const ids = expandIn(m[5], p).map(Number);
      const c = (store[table] || []).filter(
        (r) => ids.includes(Number(r.id)) && Number(r[dateCol]) <= Number(cd),
      ).length;
      return [{ c }];
    }

    // —— 对单状态匹配计数 ——
    m = /^SELECT COUNT\(\*\) AS c FROM `(\w+)` WHERE `check_status` = \? AND `(\w+)` IN \((.+)\)$/.exec(s);
    if (m) {
      const st = p.shift();
      const ids = expandIn(m[3], p).map(Number);
      const c = (store[m[1]] || []).filter(
        (r) => ids.includes(Number(r.id)) && String(r.check_status) === String(st),
      ).length;
      return [{ c }];
    }

    // —— 对单/反对单更新 ——
    m = /^UPDATE `(\w+)` SET `check_status` = \?, `updatetime` = \?(, `operation_id` = \?)? WHERE `check_status` = \? AND `(\w+)` IN \((.+)\)$/.exec(s);
    if (m) {
      const table = m[1];
      const toStatus = p.shift();
      p.shift(); // updatetime
      let operatorId = null;
      if (m[3]) operatorId = p.shift();
      const fromStatus = p.shift();
      const ids = expandIn(m[5], p).map(Number);
      let affected = 0;
      for (const r of store[table] || []) {
        if (!ids.includes(Number(r.id))) continue;
        if (String(r.check_status) !== String(fromStatus)) continue;
        r.check_status = String(toStatus);
        if (operatorId !== null) r.operation_id = operatorId;
        affected++;
      }
      return { affectedRows: affected };
    }

    throw new Error('未匹配的 SQL: ' + s);
  },
};

// posting / funds 在本用例中不会被触达，传空桩即可
const svc = new TableService(fake, {}, {});

/** 期望报错（异步拒绝） */
async function expectReject(fn, part, label) {
  let err = null;
  try {
    await fn();
  } catch (e) {
    err = e;
  }
  check(!!err && String(err.message || '').includes(part), `${label}（报错包含：${part}）`);
}

(async () => {
  console.log('=== 1. genCodeByRule 入参校验 ===');
  await expectReject(() => svc.genCodeByRule('kuerp_goods; DROP TABLE', 'purchase_code'), '非法表名', 'SQL 注入形态表名被拒绝');
  await expectReject(() => svc.genCodeByRule('admin', 'purchase_code'), '非法表名', '非 kuerp_ 前缀表名被拒绝');
  await expectReject(() => svc.genCodeByRule('kuerp_goods_purchase', 'code; --'), '非法字段名', 'SQL 注入形态字段名被拒绝');
  await expectReject(() => svc.genCodeByRule('kuerp_not_exists', 'purchase_code'), '不存在', '不存在的表被拒绝');
  await expectReject(() => svc.genCodeByRule('kuerp_goods_purchase', 'not_a_col'), '无字段', '不存在的字段被拒绝');
  await expectReject(() => svc.genCodeByRule('kuerp_goods', 'goods_code'), '未配置', '未配置单号规则的表被拒绝');

  console.log('=== 2. genCodeByRule 基础生成（start 起步 + 空洞回填）===');
  let r = await svc.genCodeByRule('kuerp_goods_purchase', 'purchase_code');
  check(r.code === `GHD${TODAY}002`, `001 已占用、002 空洞被回填（${r.code}）`);
  check(r.rule.prefix === 'GHD' && r.rule.name === '购货单', '返回命中的规则摘要');
  check(/^GHD\d{8}002$/.test(r.code), '日期段 = 年+月+日，时分秒不参与');

  console.log('=== 3. genCodeByRule 起始数兜底 ===');
  // 临时清空购货单：无现有编码 → 序号取 start
  const backup = store.kuerp_goods_purchase;
  store.kuerp_goods_purchase = [];
  r = await svc.genCodeByRule('kuerp_goods_purchase', 'purchase_code');
  check(r.code === `GHD${TODAY}001`, `空表取起始数 1（${r.code}）`);
  // start 大于现值时同样取 start
  store.kuerp_prefix[0].start = 10;
  r = await svc.genCodeByRule('kuerp_goods_purchase', 'purchase_code');
  check(r.code === `GHD${TODAY}010`, `start=10 时序号从 10 起步（${r.code}）`);
  store.kuerp_prefix[0].start = 1;

  console.log('=== 4. genCodeByRule 连续占用时递增 ===');
  // 补上 002：001/002/003 连续占用 → 下一个为 004
  store.kuerp_goods_purchase = [
    { id: 1, purchase_code: `GHD${TODAY}001`, purchase_time: 1000, examine_status: '1', check_status: '0', operation_id: 0 },
    { id: 2, purchase_code: `GHD${TODAY}002`, purchase_time: 1000, examine_status: '1', check_status: '0', operation_id: 0 },
    { id: 3, purchase_code: `GHD${TODAY}003`, purchase_time: 1000, examine_status: '1', check_status: '0', operation_id: 0 },
  ];
  r = await svc.genCodeByRule('kuerp_goods_purchase', 'purchase_code');
  check(r.code === `GHD${TODAY}004`, `001~003 连续占用时递增到 004（${r.code}）`);
  // 还原现场（供 counter 用例使用）
  store.kuerp_goods_purchase = backup;

  console.log('=== 5. genCodeByRule 序号空间不足 ===');
  // 切换到永远冲突的 FULL 规则：连续冲突达上限后报错
  const savedPrefix = store.kuerp_prefix[0].prefix;
  store.kuerp_prefix[0].prefix = 'FULL';
  await expectReject(() => svc.genCodeByRule('kuerp_goods_purchase', 'purchase_code'), '序号空间不足', '连续冲突达上限后报错');
  store.kuerp_prefix[0].prefix = savedPrefix;

  console.log('=== 6. genCodeByRule 同表多规则按 field 精确匹配 ===');
  r = await svc.genCodeByRule('kuerp_goods_sales', 'order_code');
  check(r.code.startsWith('POS') && r.rule.name === '零售单', `零售单命中 order_code 规则（${r.code}）`);
  r = await svc.genCodeByRule('kuerp_goods_sales', 'purchase_code');
  check(r.code.startsWith('XHD') && r.rule.name === '销货单', `销货单命中 purchase_code 规则（${r.code}）`);

  console.log('=== 7. counter 前置校验 ===');
  await expectReject(() => svc.counter('kuerp_goods', 1, 1), '无对单状态字段', '无 check_status 列的表拒绝对单');

  console.log('=== 8. counter 对单 / 反对单 ===');
  // 批量对单：只有未对单行被更新，已对单行不受影响
  await svc.counter('goods-purchase', [1, 2], 1, 7);
  check(String(store.kuerp_goods_purchase[0].check_status) === '1', '未对单行被置为已对单');
  check(Number(store.kuerp_goods_purchase[0].operation_id) === 7, '最后操作人已写入 operation_id');
  check(String(store.kuerp_goods_purchase[1].check_status) === '1', '已对单行不受对单操作影响');
  // 反对单：只挑已对单行
  await svc.counter('goods-purchase', [1], 0, 7);
  check(String(store.kuerp_goods_purchase[0].check_status) === '0', '已对单行被置回未对单');
  check(String(store.kuerp_goods_purchase[1].check_status) === '1', '未对单行不受反对单操作影响');
  // 无匹配行时报错
  await expectReject(() => svc.counter('goods-purchase', [1], 0, 7), '请选择需要反对单的数据', '无已对单行时反对单报错');
  await expectReject(() => svc.counter('goods-purchase', [2], 1, 7), '请选择需要对单的数据', '无未对单行时对单报错');

  console.log('=== 9. counter 结账守卫（不要求已审核）===');
  // 结账日期 1500；id=1 未审核但 purchase_time=1000 <= 1500 → 拦截
  store.kuerp_checkout = [{ id: 1, checktime: 1500 }];
  store.kuerp_goods_purchase[0].examine_status = '0';
  await expectReject(() => svc.counter('goods-purchase', [1], 1, 7), '已结账的单据不能再操作', '未审核但日期已结账的单据被拦截');
  // id=2 日期 2000 > 1500 → 放行
  await svc.counter('goods-purchase', [2], 0, 7);
  check(String(store.kuerp_goods_purchase[1].check_status) === '0', '日期晚于结账日的单据放行');
  // 反结账后放行
  store.kuerp_checkout = [];
  await svc.counter('goods-purchase', [1], 1, 7);
  check(String(store.kuerp_goods_purchase[0].check_status) === '1', '反结账后对单放行');

  console.log(`\n单号规则与对单测试：${pass} 项断言全部通过`);
})().catch((e) => {
  console.error('❌ 单号规则与对单测试失败:', e.message); console.error(e.stack.split('\n').slice(0, 12).join('\n'));
  process.exit(1);
});
