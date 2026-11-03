-- ============================================================
-- AI 能力模块配套表（等价 Spring AI 全栈能力）
-- 说明：这 4 张表不在原 install.sql 的 159 张业务表内，为本重构版新增。
--       列名与 src/ai/entities/*.entity.ts 的 TypeORM 默认命名（属性名）严格对齐。
--       加载顺序：先执行 db/schema.sql（159 张业务表），再执行本文件。
-- ============================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- AI 模型配置（数据库化）：运行时按 enabled + isDefault 选择实际模型
CREATE TABLE IF NOT EXISTS `ai_model_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '配置名称',
  `provider` varchar(30) NOT NULL DEFAULT 'openai' COMMENT '供应商(openai/deepseek/ollama...)',
  `baseUrl` varchar(255) NOT NULL DEFAULT '' COMMENT 'API Base URL（OpenAI 兼容）',
  `apiKey` varchar(255) NOT NULL DEFAULT '' COMMENT 'API Key',
  `model` varchar(100) NOT NULL DEFAULT '' COMMENT '模型名称',
  `temperature` double NOT NULL DEFAULT 0.7 COMMENT '温度',
  `maxTokens` int(11) NOT NULL DEFAULT 2048 COMMENT '最大生成 token',
  `topP` double NOT NULL DEFAULT 1 COMMENT 'top_p',
  `isDefault` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否默认配置',
  `enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI 模型配置';

-- Prompt 模板管理（数据库化）：支持 {var} 占位，variables 存 JSON 数组
CREATE TABLE IF NOT EXISTS `ai_prompt_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '模板名称',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '模板编码(唯一)',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `content` text COMMENT '模板内容(支持 {var} 占位)',
  `variables` varchar(500) NOT NULL DEFAULT '' COMMENT '变量列表(JSON数组)',
  `role` varchar(20) NOT NULL DEFAULT 'system' COMMENT '角色(system/user)',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI Prompt 模板';

-- AI 调用日志：审计每一次模型调用（入参/出参/token/耗时/状态）
CREATE TABLE IF NOT EXISTS `ai_call_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `modelConfigId` int(11) NOT NULL DEFAULT 0 COMMENT '关联模型配置ID',
  `model` varchar(100) NOT NULL DEFAULT '' COMMENT '模型',
  `prompt` text COMMENT '提示词(合并后)',
  `completion` text COMMENT '模型返回内容',
  `tokensPrompt` int(11) NOT NULL DEFAULT 0 COMMENT '提示 token 数',
  `tokensCompletion` int(11) NOT NULL DEFAULT 0 COMMENT '补全 token 数',
  `elapsedMs` int(11) NOT NULL DEFAULT 0 COMMENT '耗时(ms)',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态:1=成功,0=失败',
  `error` text COMMENT '错误信息',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI 调用日志';

-- 工具调用日志：审计 Agent 每次 Function Calling
CREATE TABLE IF NOT EXISTS `ai_tool_call_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `callLogId` int(11) NOT NULL DEFAULT 0 COMMENT '关联 AI 调用日志ID',
  `toolName` varchar(100) NOT NULL DEFAULT '' COMMENT '工具名称',
  `arguments` text COMMENT '入参(JSON)',
  `result` text COMMENT '出参',
  `elapsedMs` int(11) NOT NULL DEFAULT 0 COMMENT '耗时(ms)',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态:1=成功,0=失败',
  `error` text COMMENT '错误信息',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) DEFAULT NULL COMMENT '软删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI 工具调用日志';

SET FOREIGN_KEY_CHECKS = 1;
