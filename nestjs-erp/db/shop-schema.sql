-- =====================================================================
-- 订货通（微信小程序端）补充表
-- ---------------------------------------------------------------------
-- 原系统依赖 FastAdmin 框架的 `fa_sms` 验证码表，本重建库中无对应表，
-- 故按原结构 1:1 新建 `kuerp_sms`（仅改前缀，字段与语义完全一致）。
--
-- 其余订货通业务表（kuerp_user / kuerp_user_cart / kuerp_user_order /
-- kuerp_user_orderinfo / kuerp_user_address / kuerp_user_sets /
-- kuerp_user_config / kuerp_user_oauth / kuerp_user_history /
-- kuerp_user_applet）已包含在 db/schema.sql 的 159 张表内，此处不再重复。
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- 短信验证码表（等价 FastAdmin fa_sms）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kuerp_sms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event` varchar(30) DEFAULT '' COMMENT '事件:register/login/resetpwd/changemobile/mobilelogin',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机号',
  `code` varchar(10) DEFAULT '' COMMENT '验证码',
  `times` int(11) NOT NULL DEFAULT '0' COMMENT '已验证次数',
  `ip` varchar(30) DEFAULT '' COMMENT '请求IP',
  `createtime` bigint(16) unsigned DEFAULT NULL COMMENT '创建时间(秒级时间戳)',
  PRIMARY KEY (`id`),
  KEY `event` (`event`),
  KEY `mobile` (`mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='短信验证码';
