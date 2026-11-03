# 进销存 ERP — NestJS 重构版（前后端分离，1:1 还原酷柚易汛 Kuerp）

本项目是一套**开源的进销存 ERP 后端实现**，技术栈为：

- **后端**：NestJS + TypeORM + MySQL（JWT 鉴权）
- **前端**：Vue3 + Element-Plus + Vue-Router + Axios（见同级 `../vue3-erp`）
- **AI 能力**：在 NestJS 内以 Node 生态 **等价实现 Spring AI 全套能力**（见下文映射表）
- **数据库**：MySQL 5.7+，**159 张业务表 1:1 还原**（`db/schema.sql`）+ 4 张 AI 表（`db/ai-schema.sql`）

> 前后端分离：`nestjs-erp`（API，:3000）+ `vue3-erp`（管理后台，:5173），共用同一 MySQL。

---

## 一、目录结构

```
nestjs-erp/
├── db/
│   ├── schema.sql        # 159 张 kuerp_* 业务表（1:1，含初始数据）
│   └── ai-schema.sql     # 4 张 AI 能力表
├── scripts/gen-schema.js # 由原 install.sql 生成 schema.sql 的脚本
├── src/
│   ├── main.ts / app.module.ts
│   ├── common/           # 响应拦截器/异常过滤/分页/JWT守卫/bigint转换
│   ├── auth/             # 登录 / JWT / 改密
│   ├── system/           # 管理员等系统基础
│   ├── ai/               # ★ AI 能力模块（等价 Spring AI 全套）
│   └── kuerp/            # ★ 进销存业务（通用动态表，覆盖全部 159 表）
│       ├── table/        #   动态 CRUD/审核服务 + /kuerp/:table/* 控制器
│       ├── crud/         #   通用 CRUD 工厂（备用）
│       └── goods/        #   商品等参考实体
├── docker-compose.yml    # 一键 MySQL（首次自动导入建表脚本）
└── .env                  # 运行配置（由 .env.example 复制）
```

---

## 二、AI 能力模块（等价 Spring AI 全套）

原需求中的 Spring AI 概念，在 NestJS 侧一一对应落地（均为自研 Node 实现，非 Java）：

| Spring AI 概念 | 本项目实现 | 位置 |
|---|---|---|
| `ChatModel` / `ChatClient`（流式 Builder） | `ChatModelService` + `ChatClient`（`.prompt().system().user().tools().call()`） | `src/ai/chat-client.ts` |
| 模型配置数据库化 | `AiModelConfig` 实体 + 运行时按 enabled/isDefault 选择 | `src/ai/entities/ai-model-config.entity.ts` |
| `PromptTemplate` 管理 | `AiPromptTemplate` + `{var}` 渲染服务 | `src/ai/prompt-template.service.ts` |
| `@Tool` / `ToolCallbacks`（Function Calling） | `@Tool` 装饰器 + `ToolRegistry` 注册表 + `demo-tools.ts` | `src/ai/tool.decorator.ts` `tool.registry.ts` |
| Agent 多轮自主执行 | `AgentService`（ReAct 式循环：模型→工具→再模型） | `src/ai/agent.service.ts` |
| 关键词检索（RAG 检索环节） | `KeywordRetrievalService`（内存倒排 + topK） | `src/ai/keyword-retrieval.service.ts` |
| 结构化 JSON 输出 | `JsonOutputService`（response_format=json_object + 解析重试） | `src/ai/json-output.service.ts` |
| 调用/工具调用日志（Observation） | `AiCallLog` / `AiToolCallLog` 落库 | `src/ai/ai-log.service.ts` |

底层统一走 **OpenAI 兼容 API**（`fetch`），因此可直接接 **DeepSeek / 通义 / OpenAI / 本地 Ollama** 等，只需在「模型配置」里填 BaseURL + Key + 模型名。

### AI 接口（均需 JWT）
- `GET/POST/DELETE /ai/model-config…` 模型配置 CRUD
- `GET/POST/DELETE /ai/prompt-template…` + `POST /ai/prompt-template/render` 模板渲染
- `GET /ai/tools` 已注册工具列表
- `POST /ai/chat` 普通对话（ChatClient）
- `POST /ai/agent` Agent 多轮 + 工具调用（返回 `content/turns/toolCalls`）
- `POST /ai/structured` 结构化 JSON 输出
- `POST /ai/retrieve/index-goods` + `POST /ai/retrieve` 关键词检索
- `GET /ai/call-logs` `GET /ai/tool-logs` 调用/工具日志

---

## 三、业务接口（1:1 对齐原系统）

原 FastAdmin 每张表共用 `index/get/add/edit/del/examine` 通用模型。本项目用**通用动态表**等效还原，一个控制器覆盖全部 159 表：

```
GET    /kuerp/:table/index     列表/检索（page/limit/search/filter/sort/order）
GET    /kuerp/:table/get       详情（?id=）
POST   /kuerp/:table/add       新增
POST   /kuerp/:table/edit      编辑（body.id）
DELETE /kuerp/:table/del       删除（软删除 deletetime）
POST   /kuerp/:table/examine   审核（{id,status}）
GET    /kuerp/:table/columns   表字段元信息（前端动态渲染用）
GET    /kuerp/tables           列出所有业务表
```

`:table` 支持连字符（`goods-type` → 物理表 `kuerp_goods_type`）。SQL 全参数化 + 表名/列名白名单，防注入。

需要特殊业务联动的表（如购货/销货审核改库存、资金核销改余额）可按同一模式叠加专用控制器，静态路由优先，不影响通用接口。

---

## 四、运行步骤

### 1) 启动 MySQL（推荐 Docker，首次自动建表）
```bash
cd nestjs-erp
docker compose up -d          # 自动创建 kuerp_erp 库并导入 schema.sql + ai-schema.sql
```
> 若用本地 MySQL：手动执行 `mysql -uroot -p kuerp_erp < db/schema.sql` 再 `< db/ai-schema.sql`。

### 2) 配置并启动后端
```bash
cp .env.example .env          # 已生成，按需改 DB_* / JWT_SECRET / AI_*
npm run build                 # tsc 编译到 dist/
npm start                     # node dist/main.js  → http://localhost:3000
```
> 本环境 `@nestjs/cli` 依赖曾被安装中断损坏，故构建用纯 `tsc`（`npm run build`）；应用本身类型检查/编译均已通过。

### 3) 启动前端
```bash
cd ../vue3-erp
npm run dev                   # → http://localhost:5173（已配置 /kuerp /ai /auth 代理到 :3000）
```

### 4) 登录
默认账号来自 `schema.sql` 种子数据：**admin / 123456**（可在「模型配置」页接入 DeepSeek 等后到「对话/Agent」页测试 AI）。

---

## 五、完成度与后续批次

**已完成（1:1）**
- 工程骨架、JWT 鉴权、统一响应/异常、分页
- 159 张业务表 schema 1:1 + 4 张 AI 表
- 全部 159 表的 index/get/add/edit/del/examine 通用接口
- AI 能力全套（模型配置/Prompt/工具调用/Agent/检索/JSON/日志）
- Vue3 管理后台：登录、工作台、资料/采购/销售/仓库/资金全模块（通用动态表格页）、AI 四页面

**后续可分批深化（同模式叠加，不动通用接口）**
- 购货/销货/收付款「审核联动库存与账户余额」的专用 Service
- 报表统计、导入导出、打印、条码、序列号/批次等原系统专有端点
- 更细的字段级校验与权限（按角色）

---

## 六、技术说明
- 时间戳：与原系统一致用秒级 `bigint`（`createtime/updatetime/deletetime`），实体层 `BigIntTransformer` 转 number。
- 软删除：统一 `deletetime`，非 0 即已删；查询默认过滤。
- 响应格式：`{ code:1, msg, data }`，与前端拦截器约定一致（失败 `code:0`）。
