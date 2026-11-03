/**
 * 聚合报表定义结构单测（无需真实数据库）。
 *
 * 背景：前端报表页（report-page.vue）通过 /kuerp/:table/columns 与 /index 取数列与数据，
 * 表名段来自 menus.js 的 r() 工厂。若某报表既无物理表、又未在 AGG_REPORTS /
 * VIRTUAL_REPORT_COLUMNS 中声明，页面打开就会 500 或空白。
 * 本测试锁定三条不变量：
 *   1. menus.js 中每个 r() 菜单的表名段，必须有物理表或虚拟报表定义承载；
 *   2. AGG_REPORTS 每条定义的必填字段齐全，且 columns 中的列都能在 select/decorate 中找到来源；
 *   3. decorate 对样本行可正常执行并产出声明的派生列。
 * 运行：node scripts/agg-reports.test.js
 */
require('reflect-metadata');
const assert = require('assert');
const fs = require('fs');
const path = require('path');
const { AGG_REPORTS, runAggReport } = require('../dist/kuerp/table/agg-reports');
const { VIRTUAL_REPORT_COLUMNS } = require('../dist/kuerp/table/table.service');

let pass = 0;
/** 断言并计数 */
const check = (cond, msg) => {
  assert.ok(cond, msg);
  pass++;
  console.log('  ✓ ' + msg);
};

const ROOT = path.resolve(__dirname, '..', '..');
const menusSrc = fs.readFileSync(
  path.join(ROOT, 'vue3-erp', 'src', 'menus.js'),
  'utf-8',
);
const schemaSrc = fs.readFileSync(
  path.join(__dirname, '..', 'db', 'schema.sql'),
  'utf-8',
);

/** schema 中真实存在的物理表集合 */
const tables = new Set(
  [...schemaSrc.matchAll(/CREATE TABLE IF NOT EXISTS `(\w+)`/g)].map((m) => m[1]),
);

/** menus.js 中 r() 工厂产出的报表菜单：[label, key, path] */
const reportMenus = [];
const re = /r\(\s*'([^']+)'\s*,\s*'([a-z0-9\-]+)'\s*,\s*'\/kuerp\/([a-z0-9\-]+)'/g;
let m;
while ((m = re.exec(menusSrc)) !== null) reportMenus.push([m[1], m[2], m[3]]);

console.log('\n=== 1. 报表菜单覆盖检查 ===');
check(reportMenus.length >= 30, `menus.js 共解析到 ${reportMenus.length} 个报表菜单`);
const orphans = reportMenus.filter(
  ([, key, p]) =>
    !AGG_REPORTS[key] &&
    !VIRTUAL_REPORT_COLUMNS[key] &&
    !tables.has('kuerp_' + p.replace(/-/g, '_')),
);
check(
  orphans.length === 0,
  orphans.length === 0
    ? '所有报表菜单均有物理表或聚合报表定义承载'
    : `无承载的报表菜单：${orphans.map((o) => o[1]).join(', ')}`,
);

// 反向：AGG_REPORTS / VIRTUAL_REPORT_COLUMNS 中定义的键必须被菜单引用（避免死代码）
const menuKeys = new Set(reportMenus.map(([, k]) => k));
const unused = Object.keys(AGG_REPORTS).filter((k) => !menuKeys.has(k));
check(
  unused.length === 0,
  unused.length === 0
    ? 'AGG_REPORTS 无未被菜单引用的死定义'
    : `未被引用的聚合报表：${unused.join(', ')}`,
);
const unusedVirtual = Object.keys(VIRTUAL_REPORT_COLUMNS).filter((k) => !menuKeys.has(k));
check(
  unusedVirtual.length === 0,
  unusedVirtual.length === 0
    ? 'VIRTUAL_REPORT_COLUMNS 无未被菜单引用的死定义'
    : `未被引用的虚拟报表：${unusedVirtual.join(', ')}`,
);

console.log('\n=== 2. 聚合报表定义结构检查 ===');
for (const [name, def] of Object.entries(AGG_REPORTS)) {
  check(typeof def.table === 'string' && def.table.length > 0, `${name}: table 非空`);
  check(typeof def.pk === 'string' && def.pk.length > 0, `${name}: pk 非空`);
  check(Array.isArray(def.columns) && def.columns.length > 0, `${name}: columns 非空`);
  // 自定义 run 报表自带查询，无需 select/from/group/dateCol 通用引擎字段
  if (!def.run) {
    check(typeof def.select === 'string' && def.select.includes(' AS '), `${name}: select 含别名`);
    check(typeof def.from === 'string' && def.from.length > 0, `${name}: from 非空`);
    check(typeof def.group === 'string' && def.group.length > 0, `${name}: group 非空`);
    check(typeof def.dateCol === 'string' && def.dateCol.length > 0, `${name}: dateCol 非空`);
  } else {
    check(typeof def.run === 'function', `${name}: 自定义 run 为函数`);
  }
  check(Array.isArray(def.searchCols) && def.searchCols.length > 0, `${name}: searchCols 非空`);

  // dateable=false 的报表不得把时间列当日期列（防止标记与实现脱节）
  if (def.dateable === false) {
    check(
      !/_time$/.test(def.dateCol) && def.dateCol !== 'createtime',
      `${name}: dateable=false 时 dateCol 非时间列`,
    );
  }

  // 通用引擎报表才做 select/group 来源校验；自定义 run 报表的校验见下方 def.run 分支
  if (!def.run) {
  // 列名必须能在 select 或 decorate 产物中找到来源
  const selectAliases = new Set(
    [...def.select.matchAll(/AS (\w+)/g)].map((x) => x[1]),
  );
  for (const c of def.columns) {
    const fromSelect = selectAliases.has(c.name);
    const fromDecorate = typeof def.decorate === 'function';
    check(
      fromSelect || fromDecorate,
      `${name}: 列 ${c.name} 有来源（select 或 decorate）`,
    );
  }
  // ONLY_FULL_GROUP_BY 真实约束：select 中未被聚合函数包裹的裸列，必须出现在分组列里
  const grouped = new Set(def.group.split(',').map((x) => x.trim().split('.').pop()));
  /** 按顶层逗号切分 select（跳过括号/引号内的逗号） */
  const splitTop = (s) => {
    const out = [];
    let depth = 0;
    let quote = null;
    let cur = '';
    for (const ch of s) {
      if (quote) {
        cur += ch;
        if (ch === quote) quote = null;
        continue;
      }
      if (ch === "'" || ch === '"') {
        quote = ch;
        cur += ch;
        continue;
      }
      if (ch === '(') depth++;
      if (ch === ')') depth--;
      if (ch === ',' && depth === 0) {
        out.push(cur);
        cur = '';
        continue;
      }
      cur += ch;
    }
    if (cur.trim()) out.push(cur);
    return out;
  };
  const AGG_FN = /\b(ANY_VALUE|SUM|COUNT|MAX|MIN|AVG|GROUP_CONCAT)\s*\(/i;
  for (const item of splitTop(def.select)) {
    const alias = (item.match(/AS (\w+)\s*$/i) || [])[1];
    if (!alias) continue; // 无别名的选择项不进入前端列
    if (AGG_FN.test(item)) continue; // 聚合列合法
    // 裸列：别名应与某一列引用同名（t.x AS x / x AS x），取列名查分组集合
    const bare = alias;
    check(
      grouped.has(bare) || /^\s*(NULL|0|-?0)\s+AS/i.test(item) || /CASE\b/i.test(item),
      `${name}: 非聚合选择项 ${bare} 已被分组覆盖`,
    );
  }
  } // end if (!def.run)
}

console.log('\n=== 3. decorate 派生列检查 ===');
// 利润表：三段（销售/其他收入/其他支出）派生口径
const profitSample = [
  { biz_type: 'sale', number: 10, all_money: 1000, sales_cost: 600, preferential_money: 50, purchase_money: 20, other_money: 0 },
  { biz_type: 'income', number: 0, all_money: 0, sales_cost: 0, preferential_money: 0, purchase_money: 0, other_money: 200 },
  { biz_type: 'expend', number: 0, all_money: 0, sales_cost: 0, preferential_money: 0, purchase_money: 0, other_money: -80 },
];
const dec = AGG_REPORTS.profit.decorate;
const rows = profitSample.map(dec);
check(rows[0].profit === 400 && rows[0].net_profit === 330, '利润表-销售段：毛利/净利计算正确');
check(rows[1].other_income === 200 && rows[1].other_expend === 0, '利润表-其他收入段：收入计入 other_income');
check(rows[2].other_expend === 80 && rows[2].other_income === 0, '利润表-其他支出段：支出计入 other_expend');
check(
  rows[0].profit_rate === 40 && rows[0].net_profit_rate === 33,
  '利润表-销售段：毛利率/净利率百分比正确',
);

// 往来单位欠款表：客户 + 供应商两侧合并
const ic = AGG_REPORTS.intercourse.decorate({ code: 'KH001', name: '客户A', unit_type: '客户', amount: 500 });
check(ic.balance === 500, '往来单位欠款表：欠款余额=应收/应付金额');

// 批次保质期清单：临期/过期/正常/未设置 四种状态
const be = AGG_REPORTS['goods-batch-expiry'].decorate;
check(
  be({ remain_days: 10, early_warning: 30 }).expiry_status === '临期',
  '批次保质期清单：剩余 10 天且预警 30 天 → 临期',
);
check(be({ remain_days: -5, early_warning: 30 }).expiry_status === '已过期', '批次保质期清单：已过期');
check(be({ remain_days: 90, early_warning: 30 }).expiry_status === '正常', '批次保质期清单：正常');
check(be({ remain_days: null }).expiry_status === '未设置', '批次保质期清单：未设有效期 → 未设置');

console.log('\n=== 4. runAggReport 参数化检查 ===');
// 用一个极简伪 DataSource 捕获下发的 SQL，验证日期/关键字条件均走参数占位
let captured = null;
const probe = {
  async query(sql, params = []) {
    if (/COUNT\(\*\) AS c FROM/.test(sql)) return [{ c: 0 }];
    captured = { sql: String(sql).replace(/\s+/g, ' '), params };
    return [];
  },
};
(async () => {
  await runAggReport(probe, 'goods-batch-expiry', {
    page: 2,
    limit: 20,
    starttime: 1700000000,
    endtime: 1700100000,
    search: 'G001',
  });
  check(captured !== null, 'runAggReport 至少下发过一次查询');
  check(
    captured.params.filter((p) => typeof p === 'number').length >= 4,
    '日期区间 + 分页参数全部走占位符（start/end/limit/offset）',
  );
  check(
    captured.params.some((p) => p === '%G001%'),
    '关键字以 %..% 形式参数化，未拼接进 SQL',
  );
  check(/LIMIT \? OFFSET \?/.test(captured.sql), '分页使用 LIMIT ?/OFFSET ? 占位');
  check(
    !captured.sql.includes('1700000000') && !captured.sql.includes('G001'),
    'SQL 文本中不含字面量时间戳/关键字（无注入面）',
  );

  // dateable=false 的报表（往来单位欠款表）必须完全忽略日期入参
  captured = null;
  await runAggReport(probe, 'intercourse', {
    page: 1,
    limit: 10,
    starttime: 1700000000,
    endtime: 1700100000,
    search: 'KH',
  });
  check(
    captured !== null && !captured.params.some((p) => p === 1700000000 || p === 1700100000),
    '往来单位欠款表（dateable=false）忽略日期区间参数',
  );
  check(
    captured.params.some((p) => p === '%KH%'),
    '往来单位欠款表关键字仍正常参数化',
  );

  console.log(`\n🎉 聚合报表定义单测全部通过（${pass} 项断言）`);
})().catch((e) => {
  console.error('\n❌ 失败：', e.message);
  process.exit(1);
});
