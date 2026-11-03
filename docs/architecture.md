# 架构详解

本文档说明进销存 ERP 开源版的整体架构、模块职责与技术要点。配套接口清单见 `nestjs-erp/docs/API.md`。

---

## 一、整体架构

```
┌────────────────────┐      ┌────────────────────┐      ┌────────────────────┐
│   PC 管理后台       │      │   移动订货通        │      │   第三方系统        │
│   (vue3-erp)       │      │  (Uniapp 小程序)   │      │  (开放 API 对接)   │
│   Vue3 + ds 组件库  │      │  uView UI          │      │                    │
└─────────┬──────────┘      └─────────┬──────────┘      └─────────┬──────────┘
          │  /kuerp /ai /auth         │  /shop/*                  │  /openapi/third/*
          │  /system /api              │                           │
          ▼                           ▼                           ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         NestJS 后端 (nestjs-erp)                         │
│  Auth(JWT) · RBAC · 通用动态表引擎 · 业务模块 · AI 能力中心 · 开放API · 商城 │
└───────────────────────────────────────┬─────────────────────────────────┘
                                        │ TypeORM
                                        ▼
                            ┌──────────────────────────┐
                            │   MySQL 5.7+ (kuerp_erp) │
                            │   业务表 + AI 表 + 权限表 │
                            └──────────────────────────┘
```

部署形态：根目录 `docker-compose.yml` 编排 `mysql` + `backend` + `frontend` 三个容器，前端由 Nginx 反向代理到后端，前后端同源；也可各自独立运行（本地开发模式）。

---

## 二、后端模块（nestjs-erp/src）

| 模块 | 职责 |
|---|---|
| `auth` | 账号密码登录、JWT 签发、个人信息、权限集合、改密 |
| `system` | 管理员管理（含 RBAC 角色 / 权限节点） |
| `ai` | AI 能力中心：模型配置、Prompt 模板、工具注册、ReAct Agent、RAG 检索、结构化输出、调用日志 |
| `kuerp/table` | ★ 通用动态表引擎：覆盖全部业务表的 `index/get/add/edit/del/examine/columns/options/import/export/recyclebin` 等动作 |
| `kuerp/biz` | 业务专用端点：价格口径、序列号、扫码、类别树、核销源单、订货单审核/发货/生成销货单、库存校验、组装拆卸模板 |
| `kuerp/funds` | 资金过账（post）/ 冲转（unpost），幂等 |
| `kuerp/posting` | 智能补货 / 以销定购看板，由看板生成购货订单 |
| `kuerp/approval` | 审批流：提交 / 通过 / 驳回 / 进度 / 历史 / 待办 |
| `openapi` | 面向第三方的开放接口（账号 + 签名鉴权）：商品、客户、销货单 |
| `shop` | 移动端商城后端：配置、微信登录/支付、短信、会员、购物车、订货单、收货地址 |
| `common` | 缓存、上传、审计日志、消息中心、微信令牌、定时任务、健康检查 |

### 通用动态表引擎（核心设计）

原系统每张业务表共用一套通用模型动作。本项目用**单控制器 + 动态表名**等效还原，一个 `/kuerp/:table/*` 覆盖全部业务表：

```
GET    /kuerp/:table/index     列表 / 检索（page/limit/search/filter/like/sort/order）
GET    /kuerp/:table/get       详情（?id=）
GET    /kuerp/:table/columns   表字段元信息（前端动态渲染列表列与表单）
GET    /kuerp/:table/options   外键字段下拉选项
POST   /kuerp/:table/add       新增
POST   /kuerp/:table/edit      编辑（body.id）
DELETE /kuerp/:table/del       删除（软删除 deletetime）
POST   /kuerp/:table/examine   审核 / 反审（status）
POST   /kuerp/:table/counter   对单 / 反对单
GET    /kuerp/tables           列出所有业务表（前端导航）
```

- 表名支持连字符（`goods-type` → 物理表 `kuerp_goods_type`）。
- **安全**：SQL 全参数化；表名 / 列名走白名单（正则 + `INFORMATION_SCHEMA` 元数据校验），杜绝注入。
- **扩展**：需要特殊业务联动的表（如购货/销货审核改库存、资金核销改余额）按同一模式叠加专用控制器，**静态路由优先**于动态路由，互不影响。

---

## 三、数据模型

数据库 `kuerp_erp`，字符集 `utf8mb4`。建表脚本位于 `nestjs-erp/db/`：

| 文件 | 内容 |
|---|---|
| `schema.sql` | 核心进销存业务表（商品、采购、销售、仓库、资金、报表等） |
| `ai-schema.sql` | AI 能力表（模型配置、Prompt 模板、调用日志、工具日志等） |
| `admin-schema.sql` | 管理员 / 管理员日志 |
| `rbac-schema.sql` | 角色 / 权限节点 / 用户-角色关联 |
| `shop-schema.sql` | 移动端商城（会员、购物车、订货单、地址、配置、轮播） |
| `extension-schema.sql` | 扩展能力（审批、消息、定时任务、上传等） |

通用约定：
- 时间戳统一为**秒级整数** `bigint`（`createtime` / `updatetime` / `deletetime`），实体层 `BigIntTransformer` 转 `number`。
- 软删除：`deletetime > 0` 表示已删除，查询默认过滤。
- 响应格式：`{ code: 1, msg, data }`（成功 `code:1`，失败 `code:0`），与前端拦截器约定一致。

---

## 四、鉴权与权限（RBAC）

- 登录：`POST /auth/login` 返回 JWT，后续请求在 `Authorization: Bearer <token>` 携带。
- 权限模型：角色 → 权限节点（菜单 / 按钮级）；登录后 `/auth/perms` 返回当前用户权限集合，前端据此控制菜单与按钮显隐。
- 业务接口细粒度权限：动态表及专用端点采用「登录 + 权限节点」双重校验。
- 开放 API：独立于 JWT，使用「三方账号 + 签名」机制（`/openapi/third/*`），由 `openapi` 模块校验签名后放行。

---

## 五、AI 能力中心（src/ai）

底层统一走 **OpenAI 兼容 API**（`fetch`），因此可对接 DeepSeek / 通义 / OpenAI / 本地 Ollama 等，只需在「模型配置」中填写 BaseURL + Key + 模型名。

| 能力 | 实现 | 位置 |
|---|---|---|
| 对话 / ChatClient | `ChatModelService` + 流式 Builder | `ai/chat-client.ts` |
| 模型配置数据库化 | `AiModelConfig` 实体 + 运行时选择 | `ai/entities/` |
| Prompt 模板 | `AiPromptTemplate` + `{var}` 渲染 | `ai/prompt-template.service.ts` |
| Function Calling | `@Tool` 装饰器 + `ToolRegistry` | `ai/tool.decorator.ts` `tool.registry.ts` |
| ReAct Agent | `AgentService`（模型→工具→再模型循环） | `ai/agent.service.ts` |
| RAG 检索 | `KeywordRetrievalService`（内存倒排 + topK） | `ai/keyword-retrieval.service.ts` |
| 结构化 JSON | `JsonOutputService`（JSON 模式 + 重试） | `ai/json-output.service.ts` |
| 调用 / 工具日志 | `AiCallLog` / `AiToolCallLog` 落库 | `ai/ai-log.service.ts` |

主要接口（`/ai/*`，均需 JWT）：模型配置、Prompt 模板（含 `render`）、工具列表、对话、Agent、结构化输出、索引/检索、调用/工具日志。

---

## 六、PC 前端（vue3-erp）

- 技术栈：Vue 3 + Vite + Pinia + Vue-Router + Axios + 自研 `ds` 组件库（位于 `src/components/ds`）。
- 路由守卫在 `router/index.js`，鉴权态持久化在 `store/auth.js`。
- **通用业务页 `crud-page.vue`**：动态列 + 动态表单 + 增删改查/审核，通过路由 `meta.api`（如 `/kuerp/goods-purchase`）指向对应表；列与表单在运行期从 `/kuerp/:table/columns` 动态生成，从而以零样板覆盖全部模块。
- 专用页：工作台、报表（利润/欠款/预警）、打印中心、POS 收银台、订货单管理、组装/拆卸单据等。
- 网络层：`utils/request.js` 自动注入 JWT 并解包 `{ code, msg, data }`。

---

## 七、移动端（Uniapp前端源码）

- 技术栈：UniApp（Vue2 语法）+ uView UI，可编译到微信小程序 / H5 / App。
- 主要页面（`pages.json`）：登录、首页、分类、订货单、提交订单、收货地址、我的、订单与物流、账户管理、AI 智能客服。
- 后端由 `nestjs-erp/src/shop` 模块支撑：会员、购物车、订货单、收货地址、微信登录/支付、短信验证码、轮播与配置。

---

## 八、基础设施

- **缓存**：进程内缓存（`common/cache`），支持按前缀失效；`/system/cache/*` 可查看统计与清理。
- **上传**：`/api/upload`，单文件 / 多文件 / 图片，文件落 `uploads/` 目录（Docker 中以卷挂载，容器重建不丢）。
- **审计**：操作日志 `common/audit` → `/system/log/*`。
- **消息**：站内消息 `common/message` → `/system/message/*`。
- **定时任务**：`common/scheduler` → `/system/job/*`（作业清单 / 手动触发 / 执行历史）。
- **健康检查**：`/health`（公开，含 `SELECT 1` 数据库连通校验），供容器探针使用。
