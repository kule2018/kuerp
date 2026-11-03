/**
 * 生成 RBAC 权限表结构与种子数据（等效原 FastAdmin admin/auth 模块）：
 *   kuerp_auth_group        角色组
 *   kuerp_auth_rule         权限节点（菜单/操作）
 *   kuerp_auth_group_access 管理员-角色关联
 *
 * 权限节点从 db/schema.sql 的全部 kuerp_* 表自动生成（name=kuerp/<表名>），
 * 另补充工作台/大屏/AI/权限管理等非表节点，保证与原系统菜单 1:1。
 */
const fs = require('fs');
const path = require('path');

const dbDir = path.join(__dirname, '..', 'db');
const schemaPath = path.join(dbDir, 'schema.sql');
const outPath = path.join(dbDir, 'rbac-schema.sql');

const schema = fs.readFileSync(schemaPath, 'utf8');

// —— 从 schema.sql 提取 表名 -> 中文注释 ——
const tableRe = /CREATE TABLE IF NOT EXISTS `(kuerp_[a-z_0-9]+)` \(([\s\S]*?)\n\) ENGINE/g;
const nodes = [];
let m;
while ((m = tableRe.exec(schema)) !== null) {
  const table = m[1];
  const cm = /COMMENT='([^']*)'/.exec(m[2].slice(-200));
  const comment = cm ? cm[1] : '';
  const title = String(comment).split('/')[0].trim() || table;
  nodes.push({ name: `kuerp/${table.replace('kuerp_', '')}`, title });
}

// —— 非表类固定节点（与原系统菜单一一对应）——
const staticNodes = [
  ['dashboard', '工作台'],
  ['screen', '数字大屏'],
  ['datainfo', '数据管理'],
  ['initialization', '重新初始化'],
  ['print', '单据打印'],
  ['auth/group', '角色管理'],
  ['auth/rule', '权限规则'],
  ['ai/model-config', 'AI模型配置'],
  ['ai/prompt-template', 'Prompt模板'],
  ['ai/playground', '对话/Agent'],
  ['ai/logs', 'AI调用日志'],
];

/**
 * 操作级权限节点（kuerp/<表>:<动作>）。
 *
 * 只给「主档 + 单据」这类真正需要区分增删改审的表生成，不给 155 张全生成：
 * - *_info / 日志 / 报表类表页面是只读或由单据联动写入，单独控权没有业务意义；
 * - 节点越多，角色配置页的复选框越长，反而没人愿意配。
 * 未配置操作级节点的表，RbacGuard 会回落到表级节点判定（向后兼容）。
 */
const ACTION_TABLES = [
  'goods', 'goods_type', 'unit', 'warehouse', 'customers', 'suppliers', 'staff', 'driver',
  'accounts', 'settlement_type', 'goods_stock',
  'goods_purchase', 'goods_purchase_order', 'goods_exchange',
  'goods_sales', 'goods_sales_order', 'goods_sales_exchange',
  'allocation', 'assemble', 'split', 'adjustment', 'inventory',
  'warehousing', 'warehouse', 'collection', 'payment', 'writeoff', 'income', 'expenditure',
];

/** 动作级节点后缀（与后端 RbacGuard 解析的 action 名保持一致） */
const ACTIONS = [
  ['add', '新增'],
  ['edit', '编辑'],
  ['del', '删除'],
  ['examine', '审核'],
];

const esc = (s) => String(s).replace(/'/g, "''");

let sql = `-- ============================================================
-- RBAC 权限表（等效原 FastAdmin admin/auth 模块，框架级表）
-- 由 scripts/gen-rbac.js 自动生成；加载顺序 04，须在 schema.sql 之后。
-- 权限模型：kuerp_auth_group.rules 存逗号分隔的节点名（'*' 表示全部），
--           JwtAuthGuard/RbacGuard 按请求路径 kuerp/<table> 命中节点放行。
-- ============================================================
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS \`kuerp_auth_group\` (
  \`id\` int(10) unsigned NOT NULL AUTO_INCREMENT,
  \`name\` varchar(50) NOT NULL DEFAULT '' COMMENT '角色名称',
  \`rules\` text COMMENT '权限节点(逗号分隔,*=全部)',
  \`status\` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态:1=正常,0=禁用',
  \`createtime\` bigint(16) DEFAULT NULL COMMENT '创建时间',
  \`updatetime\` bigint(16) DEFAULT NULL COMMENT '更新时间',
  \`deletetime\` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (\`id\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色组';

CREATE TABLE IF NOT EXISTS \`kuerp_auth_rule\` (
  \`id\` int(10) unsigned NOT NULL AUTO_INCREMENT,
  \`name\` varchar(100) NOT NULL DEFAULT '' COMMENT '节点标识(如 kuerp/goods)',
  \`title\` varchar(100) NOT NULL DEFAULT '' COMMENT '节点名称',
  \`type\` varchar(20) NOT NULL DEFAULT 'menu' COMMENT '类型:menu=菜单,action=操作',
  \`status\` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态:1=显示,0=隐藏',
  \`createtime\` bigint(16) DEFAULT NULL COMMENT '创建时间',
  \`updatetime\` bigint(16) DEFAULT NULL COMMENT '更新时间',
  \`deletetime\` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (\`id\`),
  UNIQUE KEY \`name\` (\`name\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限节点';

CREATE TABLE IF NOT EXISTS \`kuerp_auth_group_access\` (
  \`admin_id\` int(10) unsigned NOT NULL COMMENT '管理员ID',
  \`group_id\` int(10) unsigned NOT NULL COMMENT '角色组ID',
  PRIMARY KEY (\`admin_id\`,\`group_id\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员-角色关联';

-- 默认角色：超级管理员（拥有全部权限）
INSERT INTO \`kuerp_auth_group\` (\`name\`, \`rules\`, \`status\`, \`createtime\`, \`updatetime\`)
VALUES ('超级管理员', '*', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 默认角色：普通成员（仅资料与常用单据，可按需增删）
INSERT INTO \`kuerp_auth_group\` (\`name\`, \`rules\`, \`status\`, \`createtime\`, \`updatetime\`)
VALUES ('普通成员', 'dashboard,screen,kuerp/goods,kuerp/goods_type,kuerp/unit,kuerp/warehouse,kuerp/customers,kuerp/suppliers,kuerp/goods_stock,kuerp/collection,kuerp/payment', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- admin 账号归入超级管理员组
INSERT INTO \`kuerp_auth_group_access\` (\`admin_id\`, \`group_id\`)
SELECT id, 1 FROM \`kuerp_admin\` WHERE username = 'admin';
`;

// —— 权限节点种子（幂等：按 name 去重插入）——
sql += `\n-- 权限节点种子\n`;
const allNodes = [...staticNodes.map(([n, t]) => ({ name: n, title: t })), ...nodes];
for (const n of allNodes) {
  sql += `INSERT INTO \`kuerp_auth_rule\` (\`name\`, \`title\`, \`type\`, \`status\`, \`createtime\`, \`updatetime\`)
SELECT '${esc(n.name)}', '${esc(n.title)}', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM \`kuerp_auth_rule\` WHERE name = '${esc(n.name)}') t);\n`;
}

// —— 操作级节点种子（kuerp/<表>:<动作>，type=action）——
// 与菜单级节点分开标注，便于「权限规则」页按类型筛选，也便于以后批量升级动作语义。
const tableTitle = new Map(nodes.map((n) => [n.name.replace('kuerp/', ''), n.title]));
sql += `\n-- 操作级权限节点（按钮级权限）\n`;
let actionCount = 0;
for (const t of ACTION_TABLES) {
  const tTitle = tableTitle.get(t) || t;
  for (const [act, actTitle] of ACTIONS) {
    const name = `kuerp/${t}:${act}`;
    const title = `${tTitle}-${actTitle}`;
    sql += `INSERT INTO \`kuerp_auth_rule\` (\`name\`, \`title\`, \`type\`, \`status\`, \`createtime\`, \`updatetime\`)
SELECT '${esc(name)}', '${esc(title)}', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM \`kuerp_auth_rule\` WHERE name = '${esc(name)}') t);\n`;
    actionCount++;
  }
}

fs.writeFileSync(outPath, sql, 'utf8');
console.log(`✅ rbac-schema 已生成: ${outPath}`);
console.log(`   权限节点: ${allNodes.length} 个（表节点 ${nodes.length} + 固定节点 ${staticNodes.length}）`);
console.log(`   操作级节点: ${actionCount} 个（${ACTION_TABLES.length} 表 × ${ACTIONS.length} 动作）`);
