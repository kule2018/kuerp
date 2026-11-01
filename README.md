# 进销存 ERP（开源版）

> 一套基于现代技术栈从零实现的进销存 / 商贸 ERP 系统，包含 **后端 API**、**PC 管理后台** 与 **移动端（订货通小程序）** 三端，开箱即用，可私有化部署。

本项目为完全开源的进销存管理解决方案，覆盖采购、销售、库存、资金、报表、打印、移动订货等核心商贸场景，并内置一套可插拔的 AI 能力中心（对话 / Agent / 工具调用 / RAG 检索 / 结构化输出）。

---

## 特性

- **前后端分离**：RESTful API + 独立前端，便于二次开发与集成。
- **通用动态表引擎**：一个通用接口即可驱动全部业务表（增删改查 / 审核 / 回收站 / 导入导出），新增业务模块零样板代码。
- **完整商贸闭环**：商品资料、采购、销售、仓库、资金、收付款核销、组装拆卸、序列号/批次、成本调整、结账反结账。
- **丰富报表与打印**：利润表、往来欠款表、库存预警、采购/销售汇总、A4 打印与 CSV 导出。
- **移动订货通**：Uniapp 小程序（首页 / 分类 / 订货单 / 我的 / 收货地址 / 物流跟踪 / AI 客服）。
- **开放 API**：面向第三方系统的签名鉴权接口（商品 / 客户 / 销货单）。
- **AI 能力中心**：基于 OpenAI 兼容协议（DeepSeek / 通义 / OpenAI / 本地 Ollama），支持模型配置、Prompt 模板、Function Calling、ReAct Agent、RAG 检索、结构化 JSON 与调用日志。
- **一键部署**：Docker Compose 编排 MySQL + 后端 + 前端（Nginx 反代），同源部署开箱即用。

---

## 技术架构

| 端 | 技术栈 |
|---|---|
| 后端 API | NestJS 10 · TypeORM · MySQL 5.7+ · JWT · Passport |
| PC 管理后台 | Vue 3 · Vite · Pinia · Vue-Router · Axios · 自研 `ds` 组件库 |
| 移动端 | UniApp（Vue2 语法）· uView UI · 微信小程序 / H5 / App |
| 部署 | Docker · Docker Compose · Nginx |

---

## 仓库结构

> 以下为本仓库开源交付的代码部分（不含任何第三方历史源码）。

```
进销存系统/
├── nestjs-erp/          # 后端 API（NestJS + TypeORM + MySQL）
│   ├── src/
│   │   ├── auth/        # 登录 / JWT / 改密
│   │   ├── system/      # 管理员等系统基础
│   │   ├── ai/          # ★ AI 能力模块（模型/Prompt/工具/Agent/检索/日志）
│   │   ├── kuerp/       # ★ 进销存业务
│   │   │   ├── table/   #   通用动态表 CRUD/审核 + /kuerp/:table/* 控制器
│   │   │   ├── biz/     #   业务专用端点（价格/序列号/订货单/核销/库存校验）
│   │   │   ├── funds/   #   资金过账 / 冲转
│   │   │   ├── posting/ #   智能补货 / 以销定购看板
│   │   │   └── approval/#   审批流
│   │   ├── openapi/     # 开放 API（账号 + 签名）
│   │   ├── shop/        # 移动端商城 / 微信 / 短信
│   │   └── common/      # 缓存 / 上传 / 审计 / 消息 / 微信 / 定时任务 / 健康检查
│   ├── db/              # 建表 SQL（业务表 + AI 表 + 权限表 + 商城表）
│   ├── docs/API.md      # 自动生成的接口文档
│   └── Dockerfile
├── vue3-erp/            # PC 管理后台（Vue3 + Vite）
│   ├── src/
│   │   ├── router/      # 路由 + 鉴权守卫
│   │   ├── store/       # Pinia（登录态 / 消息）
│   │   ├── components/  # 通用组件 + 自研 ds 组件库
│   │   ├── views/       # 登录 / 工作台 / 业务模块 / 报表 / 打印 / AI
│   │   └── utils/       # 请求封装 / 打印 / 权限
│   └── Dockerfile
├── Uniapp前端源码/       # 移动端（订货通小程序）
├── docker-compose.yml   # 全栈一键编排（MySQL + 后端 + 前端）
└── docs/                # 本文档集
    ├── architecture.md  # 架构详解
    └── deployment.md    # 部署指南
```

---

## 快速开始

### 方式一：Docker 一键部署（推荐）

```bash
# 在项目根目录执行（需提前安装 Docker & Docker Compose）
docker compose up -d --build
```

- 访问管理后台：<http://localhost:8080>
- 后端 API 直连（调试）：<http://localhost:3000>
- 默认账号：`admin` / `123456`

首次启动会自动创建 `kuerp_erp` 数据库并导入全部建表脚本（见 `docker-compose.yml` 中挂载的 `db/*.sql`）。

### 方式二：本地开发

**1. 启动数据库**

```bash
cd nestjs-erp
docker compose up -d          # 仅起 MySQL，首次自动建表
```

**2. 启动后端**

```bash
cd nestjs-erp
cp .env.example .env          # 按需修改 DB_* / JWT_SECRET / AI_*
npm install
npm run build                 # tsc 编译到 dist/
npm start                     # node dist/main.js → http://localhost:3000
```

**3. 启动 PC 管理后台**

```bash
cd vue3-erp
npm install
npm run dev                   # → http://localhost:5173（已配置 /kuerp /ai /auth 代理到 :3000）
```

**4. 运行移动端**

使用 HBuilderX 打开 `Uniapp前端源码/`，选择「运行到微信小程序」或「运行到浏览器」即可预览。

> 详细部署与运维说明见 [docs/deployment.md](docs/deployment.md)；架构与模块设计见 [docs/architecture.md](docs/architecture.md)；接口清单见 [nestjs-erp/docs/API.md](../nestjs-erp/docs/API.md)。

---

## 功能模块一览

| 领域 | 主要页面 / 接口 |
|---|---|
| 工作台 | 数据面板（核心指标聚合） |
| 资料 | 商品、类别、单位、客户、供应商、仓库、门店 |
| 采购 | 采购订单、购货单、购货退货单 |
| 销售 | 销售订单、销货单、销货退货单、收银台（POS） |
| 仓库 | 调拨、其他出入库、组装 / 拆卸、成本调整、盘点、序列号 / 批次 |
| 资金 | 收款单、付款单、核销、账户余额 |
| 报表 | 利润表、往来欠款表、库存预警、采购 / 销售汇总、排行、对账 |
| 系统 | 管理员、角色权限（RBAC）、操作日志、消息、定时任务、缓存、单号设置、结账 / 反结账 |
| 移动订货通 | 首页、分类、订货单、收货地址、物流、我的、AI 客服（后台侧由 `shop` 模块支撑） |
| AI 能力中心 | 模型配置、Prompt 模板、对话 / Agent、工具调用、RAG 检索、调用日志 |

---

## 文档导航

- [架构详解 docs/architecture.md](docs/architecture.md)
- [部署指南 docs/deployment.md](docs/deployment.md)
- [后端接口文档 nestjs-erp/docs/API.md](../nestjs-erp/docs/API.md)
- [后端 README nestjs-erp/README.md](../nestjs-erp/README.md)
- [PC 前端 README vue3-erp/README.md](../vue3-erp/README.md)
- [移动端 README Uniapp前端源码/README.md](../Uniapp前端源码/README.md)

---

## 默认账号

| 账号 | 密码 | 说明 |
|---|---|---|
| `admin` | `123456` | 超级管理员，生产环境请务必修改 |

---

## 开源协议

本项目基于 [MIT 协议](LICENSE) 开源。

## 贡献

欢迎提交 Issue 与 Pull Request，详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 免责声明

本项目为独立的开源进销存实现，旨在提供可学习、可私有化部署的商贸 ERP 参考方案。使用本软件所产生的任何业务风险与数据责任由使用者自行承担。
