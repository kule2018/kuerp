-- ============================================================
-- RBAC 权限表（等效原 FastAdmin admin/auth 模块，框架级表）
-- 由 scripts/gen-rbac.js 自动生成；加载顺序 04，须在 schema.sql 之后。
-- 权限模型：kuerp_auth_group.rules 存逗号分隔的节点名（'*' 表示全部），
--           JwtAuthGuard/RbacGuard 按请求路径 kuerp/<table> 命中节点放行。
-- ============================================================
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `kuerp_auth_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '角色名称',
  `rules` text COMMENT '权限节点(逗号分隔,*=全部)',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态:1=正常,0=禁用',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色组';

CREATE TABLE IF NOT EXISTS `kuerp_auth_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '节点标识(如 kuerp/goods)',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '节点名称',
  `type` varchar(20) NOT NULL DEFAULT 'menu' COMMENT '类型:menu=菜单,action=操作',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态:1=显示,0=隐藏',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限节点';

CREATE TABLE IF NOT EXISTS `kuerp_auth_group_access` (
  `admin_id` int(10) unsigned NOT NULL COMMENT '管理员ID',
  `group_id` int(10) unsigned NOT NULL COMMENT '角色组ID',
  PRIMARY KEY (`admin_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员-角色关联';

-- 默认角色：超级管理员（拥有全部权限）
INSERT INTO `kuerp_auth_group` (`name`, `rules`, `status`, `createtime`, `updatetime`)
VALUES ('超级管理员', '*', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 默认角色：普通成员（仅资料与常用单据，可按需增删）
INSERT INTO `kuerp_auth_group` (`name`, `rules`, `status`, `createtime`, `updatetime`)
VALUES ('普通成员', 'dashboard,screen,kuerp/goods,kuerp/goods_type,kuerp/unit,kuerp/warehouse,kuerp/customers,kuerp/suppliers,kuerp/goods_stock,kuerp/collection,kuerp/payment', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- admin 账号归入超级管理员组
INSERT INTO `kuerp_auth_group_access` (`admin_id`, `group_id`)
SELECT id, 1 FROM `kuerp_admin` WHERE username = 'admin';

-- 权限节点种子
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'dashboard', '工作台', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'dashboard') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'screen', '数字大屏', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'screen') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'datainfo', '数据管理', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'datainfo') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'initialization', '重新初始化', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'initialization') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'print', '单据打印', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'print') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'auth/group', '角色管理', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'auth/group') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'auth/rule', '权限规则', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'auth/rule') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'ai/model-config', 'AI模型配置', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'ai/model-config') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'ai/prompt-template', 'Prompt模板', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'ai/prompt-template') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'ai/playground', '对话/Agent', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'ai/playground') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'ai/logs', 'AI调用日志', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'ai/logs') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/area', 'kuerp_area', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/area') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts', 'kuerp_accounts', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts_copewith', 'kuerp_accounts_copewith', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts_copewith') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts_log', 'kuerp_accounts_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts_receivable', 'kuerp_accounts_receivable', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts_receivable') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts_transfer', 'kuerp_accounts_transfer', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts_transfer') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts_transfer_info', 'kuerp_accounts_transfer_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts_transfer_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/address', 'kuerp_address', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/address') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/adjustment', 'kuerp_adjustment', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/adjustment') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/adjustment_info', 'kuerp_adjustment_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/adjustment_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/allocation', 'kuerp_allocation', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/allocation') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/allocation_info', 'kuerp_allocation_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/allocation_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble', 'kuerp_assemble', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble_info', 'kuerp_assemble_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble_info_temp', 'kuerp_assemble_info_temp', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble_info_temp') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble_temp', 'kuerp_assemble_temp', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble_temp') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/attr_combination', 'kuerp_attr_combination', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/attr_combination') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/attribute', 'kuerp_attribute', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/attribute') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/aux_combination', 'kuerp_aux_combination', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/aux_combination') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/auxiliary', 'kuerp_auxiliary', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/auxiliary') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/collection', 'kuerp_collection', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/collection') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/collection_account', 'kuerp_collection_account', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/collection_account') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/collection_sale', 'kuerp_collection_sale', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/collection_sale') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/cost', 'kuerp_cost', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/cost') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customer_goodscoding', 'kuerp_customer_goodscoding', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customer_goodscoding') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customerlevel', 'kuerp_customerlevel', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customerlevel') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customers', 'kuerp_customers', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customers') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customers_user', 'kuerp_customers_user', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customers_user') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customertype', 'kuerp_customertype', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customertype') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/expend_type', 'kuerp_expend_type', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/expend_type') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/expenditure', 'kuerp_expenditure', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/expenditure') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/expenditure_info', 'kuerp_expenditure_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/expenditure_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods', 'kuerp_goods', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_attr', 'kuerp_goods_attr', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_attr') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_batch', 'kuerp_goods_batch', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_batch') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_batch_exchange_info', 'kuerp_goods_batch_exchange_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_batch_exchange_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_batch_info', 'kuerp_goods_batch_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_batch_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_batch_log', 'kuerp_goods_batch_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_batch_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_batch_sale_info', 'kuerp_goods_batch_sale_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_batch_sale_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_batch_salee_info', 'kuerp_goods_batch_salee_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_batch_salee_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_batch_stock', 'kuerp_goods_batch_stock', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_batch_stock') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchange', 'kuerp_goods_exchange', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchange') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchange_info', 'kuerp_goods_exchange_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchange_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_excpur', 'kuerp_goods_excpur', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_excpur') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_excpur_info', 'kuerp_goods_excpur_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_excpur_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_log', 'kuerp_goods_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_period', 'kuerp_goods_period', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_period') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_price', 'kuerp_goods_price', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_price') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase', 'kuerp_goods_purchase', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_info', 'kuerp_goods_purchase_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_order', 'kuerp_goods_purchase_order', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_order') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_order_info', 'kuerp_goods_purchase_order_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_order_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_summary', 'kuerp_goods_purchase_summary', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_summary') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purord', 'kuerp_goods_purord', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purord') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purord_info', 'kuerp_goods_purord_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purord_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_saleexc', 'kuerp_goods_saleexc', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_saleexc') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_saleexc_info', 'kuerp_goods_saleexc_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_saleexc_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_saleord', 'kuerp_goods_saleord', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_saleord') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_saleord_info', 'kuerp_goods_saleord_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_saleord_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales', 'kuerp_goods_sales', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_exchange', 'kuerp_goods_sales_exchange', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_exchange') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_exchange_info', 'kuerp_goods_sales_exchange_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_exchange_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_info', 'kuerp_goods_sales_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_order', 'kuerp_goods_sales_order', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_order') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_order_info', 'kuerp_goods_sales_order_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_order_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_profit', 'kuerp_goods_sales_profit', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_profit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_summary', 'kuerp_goods_sales_summary', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_summary') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_serial', 'kuerp_goods_serial', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_serial') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_serial_log', 'kuerp_goods_serial_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_serial_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_stock', 'kuerp_goods_stock', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_stock') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_stock_warning', 'kuerp_goods_stock_warning', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_stock_warning') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_store_info', 'kuerp_goods_store_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_store_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_type', 'kuerp_goods_type', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_type') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/income', 'kuerp_income', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/income') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/income_info', 'kuerp_income_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/income_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/income_type', 'kuerp_income_type', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/income_type') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory', 'kuerp_inventory', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory_info', 'kuerp_inventory_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory_serial', 'kuerp_inventory_serial', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory_serial') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory_serial_info', 'kuerp_inventory_serial_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory_serial_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/invoicing', 'kuerp_invoicing', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/invoicing') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/invoicing_log', 'kuerp_invoicing_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/invoicing_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment', 'kuerp_payment', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment_account', 'kuerp_payment_account', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment_account') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment_log', 'kuerp_payment_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment_sale', 'kuerp_payment_sale', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment_sale') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/prefix', 'kuerp_prefix', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/prefix') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/sales_invoicing', 'kuerp_sales_invoicing', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/sales_invoicing') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/sales_invoicing_log', 'kuerp_sales_invoicing_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/sales_invoicing_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/sales_payment_log', 'kuerp_sales_payment_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/sales_payment_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/sets', 'kuerp_sets', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/sets') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/settlementtype', 'kuerp_settlementtype', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/settlementtype') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/spendingtype', 'kuerp_spendingtype', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/spendingtype') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split', 'kuerp_split', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split_info', 'kuerp_split_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split_info_temp', 'kuerp_split_info_temp', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split_info_temp') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split_temp', 'kuerp_split_temp', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split_temp') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/staff_member', 'kuerp_staff_member', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/staff_member') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/stores', 'kuerp_stores', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/stores') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/suppliers', 'kuerp_suppliers', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/suppliers') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/suppliers_user', 'kuerp_suppliers_user', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/suppliers_user') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/supplyertype', 'kuerp_supplyertype', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/supplyertype') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/transfers', 'kuerp_transfers', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/transfers') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/unit', 'kuerp_unit', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/unit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/unit_conversion', 'kuerp_unit_conversion', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/unit_conversion') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse', 'kuerp_warehouse', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse_info', 'kuerp_warehouse_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehousing', 'kuerp_warehousing', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehousing') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehousing_info', 'kuerp_warehousing_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehousing_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff', 'kuerp_writeoff', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff_info', 'kuerp_writeoff_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff_log', 'kuerp_writeoff_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff_source', 'kuerp_writeoff_source', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff_source') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/banner', 'kuerp_banner', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/banner') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/banner_type', 'kuerp_banner_type', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/banner_type') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user', 'kuerp_user', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_address', 'kuerp_user_address', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_address') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_cart', 'kuerp_user_cart', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_cart') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_config', 'kuerp_user_config', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_config') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_history', 'kuerp_user_history', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_history') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_oauth', 'kuerp_user_oauth', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_oauth') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_order', 'kuerp_user_order', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_order') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_orderinfo', 'kuerp_user_orderinfo', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_orderinfo') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_ordersale', 'kuerp_user_ordersale', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_ordersale') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_sets', 'kuerp_user_sets', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_sets') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_ordersaleinfo', 'kuerp_user_ordersaleinfo', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_ordersaleinfo') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/enclosure', 'kuerp_enclosure', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/enclosure') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/enclosure_log', 'kuerp_enclosure_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/enclosure_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_salethird', 'kuerp_goods_salethird', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_salethird') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/third_account', 'kuerp_third_account', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/third_account') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchangethird', 'kuerp_goods_exchangethird', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchangethird') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/config', 'kuerp_config', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/config') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_applet', 'kuerp_user_applet', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_applet') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/driver', 'kuerp_driver', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/driver') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/checkout', 'kuerp_checkout', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/checkout') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/checkout_info', 'kuerp_checkout_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/checkout_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/enclosure', 'kuerp_enclosure', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/enclosure') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/enclosure_log', 'kuerp_enclosure_log', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/enclosure_log') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/banner', 'kuerp_banner', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/banner') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/banner_type', 'kuerp_banner_type', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/banner_type') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user', 'kuerp_user', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_address', 'kuerp_user_address', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_address') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_cart', 'kuerp_user_cart', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_cart') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_config', 'kuerp_user_config', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_config') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_history', 'kuerp_user_history', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_history') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_oauth', 'kuerp_user_oauth', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_oauth') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_order', 'kuerp_user_order', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_order') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_orderinfo', 'kuerp_user_orderinfo', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_orderinfo') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_ordersale', 'kuerp_user_ordersale', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_ordersale') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_sets', 'kuerp_user_sets', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_sets') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_ordersaleinfo', 'kuerp_user_ordersaleinfo', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_ordersaleinfo') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/checkout', 'kuerp_checkout', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/checkout') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/checkout_info', 'kuerp_checkout_info', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/checkout_info') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_salethird', 'kuerp_goods_salethird', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_salethird') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/third_account', 'kuerp_third_account', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/third_account') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchangethird', 'kuerp_goods_exchangethird', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchangethird') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/config', 'kuerp_config', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/config') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/user_applet', 'kuerp_user_applet', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/user_applet') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/driver', 'kuerp_driver', 'menu', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/driver') t);

-- 操作级权限节点（按钮级权限）
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods:add', 'kuerp_goods-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods:edit', 'kuerp_goods-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods:del', 'kuerp_goods-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods:examine', 'kuerp_goods-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_type:add', 'kuerp_goods_type-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_type:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_type:edit', 'kuerp_goods_type-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_type:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_type:del', 'kuerp_goods_type-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_type:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_type:examine', 'kuerp_goods_type-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_type:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/unit:add', 'kuerp_unit-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/unit:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/unit:edit', 'kuerp_unit-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/unit:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/unit:del', 'kuerp_unit-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/unit:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/unit:examine', 'kuerp_unit-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/unit:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:add', 'kuerp_warehouse-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:edit', 'kuerp_warehouse-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:del', 'kuerp_warehouse-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:examine', 'kuerp_warehouse-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customers:add', 'kuerp_customers-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customers:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customers:edit', 'kuerp_customers-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customers:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customers:del', 'kuerp_customers-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customers:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/customers:examine', 'kuerp_customers-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/customers:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/suppliers:add', 'kuerp_suppliers-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/suppliers:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/suppliers:edit', 'kuerp_suppliers-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/suppliers:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/suppliers:del', 'kuerp_suppliers-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/suppliers:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/suppliers:examine', 'kuerp_suppliers-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/suppliers:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/staff:add', 'staff-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/staff:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/staff:edit', 'staff-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/staff:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/staff:del', 'staff-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/staff:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/staff:examine', 'staff-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/staff:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/driver:add', 'kuerp_driver-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/driver:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/driver:edit', 'kuerp_driver-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/driver:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/driver:del', 'kuerp_driver-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/driver:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/driver:examine', 'kuerp_driver-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/driver:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts:add', 'kuerp_accounts-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts:edit', 'kuerp_accounts-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts:del', 'kuerp_accounts-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/accounts:examine', 'kuerp_accounts-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/accounts:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/settlement_type:add', 'settlement_type-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/settlement_type:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/settlement_type:edit', 'settlement_type-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/settlement_type:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/settlement_type:del', 'settlement_type-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/settlement_type:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/settlement_type:examine', 'settlement_type-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/settlement_type:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_stock:add', 'kuerp_goods_stock-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_stock:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_stock:edit', 'kuerp_goods_stock-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_stock:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_stock:del', 'kuerp_goods_stock-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_stock:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_stock:examine', 'kuerp_goods_stock-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_stock:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase:add', 'kuerp_goods_purchase-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase:edit', 'kuerp_goods_purchase-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase:del', 'kuerp_goods_purchase-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase:examine', 'kuerp_goods_purchase-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_order:add', 'kuerp_goods_purchase_order-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_order:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_order:edit', 'kuerp_goods_purchase_order-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_order:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_order:del', 'kuerp_goods_purchase_order-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_order:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_purchase_order:examine', 'kuerp_goods_purchase_order-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_purchase_order:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchange:add', 'kuerp_goods_exchange-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchange:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchange:edit', 'kuerp_goods_exchange-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchange:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchange:del', 'kuerp_goods_exchange-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchange:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_exchange:examine', 'kuerp_goods_exchange-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_exchange:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales:add', 'kuerp_goods_sales-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales:edit', 'kuerp_goods_sales-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales:del', 'kuerp_goods_sales-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales:examine', 'kuerp_goods_sales-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_order:add', 'kuerp_goods_sales_order-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_order:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_order:edit', 'kuerp_goods_sales_order-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_order:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_order:del', 'kuerp_goods_sales_order-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_order:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_order:examine', 'kuerp_goods_sales_order-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_order:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_exchange:add', 'kuerp_goods_sales_exchange-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_exchange:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_exchange:edit', 'kuerp_goods_sales_exchange-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_exchange:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_exchange:del', 'kuerp_goods_sales_exchange-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_exchange:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/goods_sales_exchange:examine', 'kuerp_goods_sales_exchange-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/goods_sales_exchange:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/allocation:add', 'kuerp_allocation-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/allocation:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/allocation:edit', 'kuerp_allocation-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/allocation:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/allocation:del', 'kuerp_allocation-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/allocation:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/allocation:examine', 'kuerp_allocation-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/allocation:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble:add', 'kuerp_assemble-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble:edit', 'kuerp_assemble-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble:del', 'kuerp_assemble-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/assemble:examine', 'kuerp_assemble-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/assemble:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split:add', 'kuerp_split-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split:edit', 'kuerp_split-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split:del', 'kuerp_split-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/split:examine', 'kuerp_split-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/split:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/adjustment:add', 'kuerp_adjustment-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/adjustment:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/adjustment:edit', 'kuerp_adjustment-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/adjustment:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/adjustment:del', 'kuerp_adjustment-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/adjustment:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/adjustment:examine', 'kuerp_adjustment-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/adjustment:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory:add', 'kuerp_inventory-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory:edit', 'kuerp_inventory-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory:del', 'kuerp_inventory-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/inventory:examine', 'kuerp_inventory-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/inventory:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehousing:add', 'kuerp_warehousing-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehousing:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehousing:edit', 'kuerp_warehousing-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehousing:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehousing:del', 'kuerp_warehousing-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehousing:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehousing:examine', 'kuerp_warehousing-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehousing:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:add', 'kuerp_warehouse-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:edit', 'kuerp_warehouse-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:del', 'kuerp_warehouse-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/warehouse:examine', 'kuerp_warehouse-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/warehouse:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/collection:add', 'kuerp_collection-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/collection:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/collection:edit', 'kuerp_collection-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/collection:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/collection:del', 'kuerp_collection-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/collection:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/collection:examine', 'kuerp_collection-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/collection:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment:add', 'kuerp_payment-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment:edit', 'kuerp_payment-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment:del', 'kuerp_payment-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/payment:examine', 'kuerp_payment-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/payment:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff:add', 'kuerp_writeoff-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff:edit', 'kuerp_writeoff-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff:del', 'kuerp_writeoff-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/writeoff:examine', 'kuerp_writeoff-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/writeoff:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/income:add', 'kuerp_income-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/income:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/income:edit', 'kuerp_income-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/income:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/income:del', 'kuerp_income-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/income:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/income:examine', 'kuerp_income-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/income:examine') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/expenditure:add', 'kuerp_expenditure-新增', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/expenditure:add') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/expenditure:edit', 'kuerp_expenditure-编辑', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/expenditure:edit') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/expenditure:del', 'kuerp_expenditure-删除', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/expenditure:del') t);
INSERT INTO `kuerp_auth_rule` (`name`, `title`, `type`, `status`, `createtime`, `updatetime`)
SELECT 'kuerp/expenditure:examine', 'kuerp_expenditure-审核', 'action', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_auth_rule` WHERE name = 'kuerp/expenditure:examine') t);
