-- ============================================================
-- 后台管理员表（FastAdmin 框架级表，不在原 kuerp install.sql 的 159 张插件表内）
-- 对应实体 src/system/entities/admin.entity.ts（@Entity('kuerp_admin')）。
-- 默认种子账号：admin / 123456（密码 pbkdf2-sha256 + 盐，兼容 verifyPassword）。
-- 加载顺序：schema.sql → ai-schema.sql → 本文件（本文件含种子数据，须最后执行）。
-- ============================================================
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `kuerp_admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT '密码哈希',
  `salt` varchar(64) NOT NULL DEFAULT '' COMMENT '密码盐',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(100) NOT NULL DEFAULT '' COMMENT '头像',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '邮箱',
  `logintime` bigint(16) DEFAULT NULL COMMENT '最后登录时间',
  `loginip` varchar(50) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态:1=正常,0=禁用',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台管理员';

-- 默认管理员 admin / 123456
INSERT INTO `kuerp_admin` (`username`, `password`, `salt`, `nickname`, `avatar`, `email`, `logintime`, `loginip`, `status`, `createtime`, `updatetime`, `deletetime`)
SELECT 'admin',
       '135e47e23baa2bfb6300110b10de31cc07ca6a367621e3d8023bc76b75d06a00',
       '9ea63abe1238dc54e29b40e95eb9f40a',
       '超级管理员', '', 'admin@example.com', NULL, '', 1,
       UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0
WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM `kuerp_admin` WHERE username='admin') t);
