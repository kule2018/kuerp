-- =====================================================================
-- 扩展能力表（操作日志 / 消息中心 / 多级审批 / 定时任务日志）
-- ---------------------------------------------------------------------
-- 加载顺序 06，须在 schema.sql + admin-schema.sql + rbac-schema.sql 之后。
-- 这些表不是原系统 kuerp_* 业务表的一部分，而是让系统能上生产所需的基础设施表：
--   1) kuerp_admin_log      操作审计（谁在什么时候改了什么）
--   2) kuerp_message        消息中心（库存预警 / 保质期 / 账期 / 审批待办）
--   3) kuerp_approval_flow  多级审批流配置（按单据类型 + 金额区间定级）
--   4) kuerp_approval_log   审批流转记录
--   5) kuerp_job_log        定时任务执行日志
--
-- 时间约定与全库一致：秒级 bigint 时间戳；软删除用 deletetime。
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- 1) 操作日志（审计）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kuerp_admin_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作人ID',
  `username` varchar(50) NOT NULL DEFAULT '' COMMENT '操作人账号',
  `module` varchar(60) NOT NULL DEFAULT '' COMMENT '业务模块(表名,如 goods)',
  `action` varchar(30) NOT NULL DEFAULT '' COMMENT '动作:add/edit/del/examine/import/export/other',
  `method` varchar(10) NOT NULL DEFAULT '' COMMENT 'HTTP 方法',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '请求路径',
  `row_id` varchar(60) NOT NULL DEFAULT '' COMMENT '受影响记录ID(尽力而为)',
  `params` text COMMENT '请求参数(已脱敏并截断)',
  `success` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否成功:1=是,0=否',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '结果消息',
  `ip` varchar(60) NOT NULL DEFAULT '' COMMENT '客户端IP',
  `ua` varchar(300) NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `cost_ms` int(11) NOT NULL DEFAULT '0' COMMENT '耗时毫秒',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_admin` (`admin_id`),
  KEY `idx_module` (`module`),
  KEY `idx_time` (`createtime`),
  KEY `idx_action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志(审计)';

-- ---------------------------------------------------------------------
-- 2) 消息中心
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kuerp_message` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `to_admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '接收人ID,0=全员广播',
  `type` varchar(30) NOT NULL DEFAULT 'system' COMMENT '类型:stock_warning/batch_expiry/ar_due/approval/system',
  `level` varchar(10) NOT NULL DEFAULT 'info' COMMENT '级别:info/warn/danger',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '内容',
  `link` varchar(255) NOT NULL DEFAULT '' COMMENT '前端跳转路由',
  `ref_table` varchar(60) NOT NULL DEFAULT '' COMMENT '关联表',
  `ref_id` varchar(60) NOT NULL DEFAULT '' COMMENT '关联记录ID',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读:1=是,0=否',
  `readtime` bigint(16) DEFAULT NULL COMMENT '阅读时间',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`),
  KEY `idx_to_read` (`to_admin_id`,`is_read`),
  KEY `idx_type` (`type`),
  KEY `idx_time` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息中心';

-- ---------------------------------------------------------------------
-- 2b) 广播消息已读明细
-- 说明：kuerp_message 的 to_admin_id=0 表示全员广播；若直接改 is_read，
--      一个人读了所有人都会变已读，所以广播的已读状态单独落这张表。
--      私有消息（to_admin_id>0）仍用 kuerp_message.is_read。
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kuerp_message_read` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `message_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '消息ID',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '阅读人ID',
  `readtime` bigint(16) DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msg_admin` (`message_id`,`admin_id`),
  KEY `idx_admin` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='广播消息已读明细';

-- ---------------------------------------------------------------------
-- 3) 多级审批流配置
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kuerp_approval_flow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `doc_table` varchar(60) NOT NULL DEFAULT '' COMMENT '单据表名(不含 kuerp_ 前缀,如 goods_purchase_order)',
  `level` int(11) NOT NULL DEFAULT '1' COMMENT '审批级次(从1开始,升序审批)',
  `role_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审批角色组ID(kuerp_auth_group.id),0=不限',
  `min_amount` decimal(16,4) NOT NULL DEFAULT '0.0000' COMMENT '生效金额下限(含)',
  `max_amount` decimal(16,4) NOT NULL DEFAULT '0.0000' COMMENT '生效金额上限(0=不限)',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用:1=是,0=否',
  `note` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`),
  KEY `idx_doc` (`doc_table`,`level`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='多级审批流配置';

-- ---------------------------------------------------------------------
-- 4) 审批流转记录
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kuerp_approval_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `doc_table` varchar(60) NOT NULL DEFAULT '' COMMENT '单据表名(不含前缀)',
  `doc_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '单据ID',
  `doc_code` varchar(60) NOT NULL DEFAULT '' COMMENT '单据编号(便于人看)',
  `level` int(11) NOT NULL DEFAULT '1' COMMENT '当前级次',
  `total_level` int(11) NOT NULL DEFAULT '1' COMMENT '总级数',
  `approver_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审批人ID',
  `approver_name` varchar(50) NOT NULL DEFAULT '' COMMENT '审批人账号',
  `result` varchar(20) NOT NULL DEFAULT 'pending' COMMENT '状态:pending=待审,pass=通过,reject=驳回',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '审批意见',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_doc` (`doc_table`,`doc_id`),
  KEY `idx_result` (`result`),
  KEY `idx_approver` (`approver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审批流转记录';

-- ---------------------------------------------------------------------
-- 5) 定时任务执行日志
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kuerp_job_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `job_name` varchar(60) NOT NULL DEFAULT '' COMMENT '任务标识',
  `job_title` varchar(100) NOT NULL DEFAULT '' COMMENT '任务名称',
  `success` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否成功',
  `cost_ms` int(11) NOT NULL DEFAULT '0' COMMENT '耗时毫秒',
  `message` varchar(500) NOT NULL DEFAULT '' COMMENT '结果摘要',
  `detail` text COMMENT '详细输出(截断)',
  `createtime` bigint(16) DEFAULT NULL COMMENT '执行时间',
  PRIMARY KEY (`id`),
  KEY `idx_job` (`job_name`),
  KEY `idx_time` (`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='定时任务执行日志';

-- ---------------------------------------------------------------------
-- 默认审批流种子：购货订单 / 销货订单 各一级（可由界面调整）
-- 说明：只给两张订单表建默认流，其余单据保持「单级审核」行为不变；
--       min/max 都为 0 表示不限金额，任何金额都需这一级审批。
-- ---------------------------------------------------------------------
INSERT INTO `kuerp_approval_flow` (`doc_table`,`level`,`role_id`,`min_amount`,`max_amount`,`status`,`note`,`createtime`,`updatetime`)
SELECT 'goods_purchase_order',1,0,0.0000,0.0000,0,'购货订单默认一级审批',UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_approval_flow` WHERE doc_table='goods_purchase_order') t);

INSERT INTO `kuerp_approval_flow` (`doc_table`,`level`,`role_id`,`min_amount`,`max_amount`,`status`,`note`,`createtime`,`updatetime`)
SELECT 'goods_sales_order',1,0,0.0000,0.0000,0,'销货订单默认一级审批',UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_approval_flow` WHERE doc_table='goods_sales_order') t);

-- ---------------------------------------------------------------------
-- 定时作业开关（type=5，在「系统参数」页表现为一个独立分区，勾选=启用）
-- value: '1' 或空 = 启用，'0' = 停用
-- ---------------------------------------------------------------------
INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'job_wechat_token','定时刷新微信 access_token','1','0',NULL,'小程序 access_token 有效期 7200 秒，停用后需改为每次调用前现场获取（会拖慢接口）',1,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='job_wechat_token') t);

INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'job_stock_warning','每日库存预警扫描','1','0',NULL,'按商品的库存预警设置扫描总库存，低于下限或高于上限写入消息中心',1,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='job_stock_warning') t);

INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'job_batch_expiry','每日批次保质期预警','1','0',NULL,'按商品的保质期与预警天数扫描批次，临期/过期写入消息中心',1,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='job_batch_expiry') t);

INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'job_ar_due','每日应收逾期提醒','1','0',NULL,'按客户账期计算逾期的销货单（未收款/部分收款）写入消息中心',1,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='job_ar_due') t);

INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'job_message_purge','清理过期已读消息','0','0',NULL,'删除 90 天前已读的消息，避免消息表无限增长（默认关闭）',0,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='job_message_purge') t);

-- 作业参数（非开关，供作业读取）
INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'ar_due_days','应收逾期天数','30','0',NULL,'销货单超过该天数仍未收完款即视为逾期，用于每日应收提醒',1,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='ar_due_days') t);

INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'batch_warning_days','批次临期预警天数','30','0',NULL,'批次有效期距今小于该天数即视为临期，用于每日保质期提醒',1,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='batch_warning_days') t);

-- 负库存策略：0=禁止（默认）/ 1=警告放行 / 2=允许放行
-- 由 PostingService.negativeStockPolicy() 读取；放行时会写 warn 日志便于事后追溯。
INSERT INTO `kuerp_sets` (`admin_id`,`type`,`name`,`nickname`,`value`,`is_edit`,`notice`,`explain`,`is_checked`,`set`)
SELECT 1,5,'stock_negative','负库存出库策略','0','0',NULL,'0=禁止出库(默认) 1=警告但放行 2=允许放行；放行会在服务端记录告警日志',1,NULL
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_sets` WHERE name='stock_negative') t);
