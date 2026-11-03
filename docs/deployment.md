# 部署指南

本文档说明进销存 ERP 开源版的部署方式，涵盖 **Docker 一键部署**、**环境变量**、**生产加固** 与 **本地开发**。

---

## 一、环境要求

| 组件 | 版本要求 |
|---|---|
| Docker / Docker Compose | 推荐 Docker 24+（Compose v2） |
| Node.js | 18.x（本地开发 / 自定义构建时） |
| MySQL | 5.7+（Docker 内已封装；也可使用外部实例） |
| 浏览器 | 现代 Chromium 内核（PC 管理后台） |

---

## 二、Docker 一键部署（推荐）

在项目根目录执行：

```bash
docker compose up -d --build
```

该命令会构建并启动三个容器：

| 容器 | 镜像 | 端口 | 说明 |
|---|---|---|---|
| `erp-mysql` | mysql:5.7 | 127.0.0.1:3306 | 数据库；首次按文件名顺序导入 `nestjs-erp/db/*.sql` |
| `erp-backend` | 本地构建（NestJS） | 3000 | 后端 API |
| `erp-frontend` | 本地构建（Nginx + Vue3） | 8080 → 80 | PC 管理后台，Nginx 反代后端，前后端同源 |

访问：
- 管理后台：<http://localhost:8080>
- 后端直连（调试）：<http://localhost:3000>
- 默认账号：`admin` / `123456`（**生产务必修改**）

> 与 `nestjs-erp/docker-compose.yml` 的分工：根目录文件是「完整生产形态」（三容器、前端反代）；`nestjs-erp/docker-compose.yml` 只起 MySQL，供本地 `npm run start:dev` 开发用。

数据持久化：`mysql-data`（数据库文件）与 `uploads-data`（上传文件）为命名卷，容器重建不丢数据。

---

## 三、环境变量

后端通过 `.env`（由 `.env.example` 复制）或宿主机环境变量注入。Docker 部署时建议在根目录 `docker-compose.yml` 的 `backend.environment` 中覆盖关键项。

### 应用与数据库

| 变量 | 默认值 | 说明 |
|---|---|---|
| `PORT` | `3000` | 后端监听端口 |
| `GLOBAL_PREFIX` | （空） | 全局路由前缀；留空则业务接口保持 `/kuerp/xxx` |
| `DB_HOST` | `127.0.0.1` | 数据库地址（Docker 内为 `mysql`） |
| `DB_PORT` | `3306` | 数据库端口 |
| `DB_USER` | `root` | 数据库用户 |
| `DB_PASSWORD` | `root` | 数据库密码 |
| `DB_NAME` | `kuerp_erp` | 数据库名 |
| `DB_CHARSET` | `utf8mb4` | 字符集 |
| `DB_SYNCHRONIZE` | `false` | 是否自动同步表结构（首次可 `true`，生产建议 `false` 配合 SQL 脚本） |

### 鉴权

| 变量 | 默认值 | 说明 |
|---|---|---|
| `JWT_SECRET` | `kuerp-nestjs-erp-secret-change-me` | JWT 签名密钥，**生产必须修改** |
| `JWT_EXPIRES_IN` | `7200` | Token 有效期（秒） |

### AI（可选）

| 变量 | 默认值 | 说明 |
|---|---|---|
| `AI_DEFAULT_BASE_URL` | `https://api.openai.com/v1` | 模型接口 BaseURL（兼容 DeepSeek / 通义 / Ollama） |
| `AI_DEFAULT_API_KEY` | （空） | 模型 API Key |
| `AI_DEFAULT_MODEL` | `gpt-4o-mini` | 默认模型名 |
| `AI_DEFAULT_TEMPERATURE` | `0.7` | 采样温度 |
| `AI_DEFAULT_MAX_TOKENS` | `2048` | 最大 token |
| `AI_ENABLE_LOG` | `true` | 是否记录 AI 调用 / 工具调用日志 |

### 缓存

| 变量 | 默认值 | 说明 |
|---|---|---|
| `CACHE_MAX` | `2000` | 进程内缓存条目上限 |
| `CACHE_TTL` | `60` | 默认缓存 TTL（秒） |

---

## 四、本地开发部署

适合二次开发，前后端分别启动：

```bash
# 1) 数据库
cd nestjs-erp
docker compose up -d

# 2) 后端
cp .env.example .env
npm install
npm run build
npm start                # http://localhost:3000

# 3) PC 前端
cd ../vue3-erp
npm install
npm run dev              # http://localhost:5173（已配置代理到 :3000）

# 4) 移动端
#    用 HBuilderX 打开 Uniapp前端源码/，运行到微信小程序 / 浏览器
```

若使用本地（非 Docker）MySQL，请手动导入建表脚本：

```bash
mysql -uroot -p kuerp_erp < nestjs-erp/db/schema.sql
mysql -uroot -p kuerp_erp < nestjs-erp/db/ai-schema.sql
mysql -uroot -p kuerp_erp < nestjs-erp/db/admin-schema.sql
mysql -uroot -p kuerp_erp < nestjs-erp/db/rbac-schema.sql
mysql -uroot -p kuerp_erp < nestjs-erp/db/shop-schema.sql
mysql -uroot -p kuerp_erp < nestjs-erp/db/extension-schema.sql
```

---

## 五、生产环境加固建议

1. **修改默认口令**：`admin / 123456` 仅为种子数据，上线前在管理员页面修改密码。
2. **覆盖密钥**：在 `docker-compose.yml` 的 `backend.environment` 或 `.env` 中设置强随机 `JWT_SECRET` 与 `DB_PASSWORD`，不要使用默认值。
3. **数据库端口**：根 `docker-compose.yml` 已将 MySQL 端口绑定到 `127.0.0.1`，避免暴露公网；如确需远程访问请加防火墙 / 跳板。
4. **HTTPS**：生产建议在 Nginx / 网关层终止 TLS，并将前端 `WEB_PORT` 改为 443 映射（或前置反向代理）。
5. **关闭调试端口**：生产可注释掉 `backend.ports` 的 `3000:3000` 映射，仅保留前端 8080 同源访问。
6. **表结构变更**：生产环境将 `DB_SYNCHRONIZE` 设为 `false`，通过 `db/*.sql` 与受控的迁移脚本管理结构变更。
7. **备份**：定期备份 `mysql-data` 卷与 `uploads-data` 卷（或直接 `mysqldump`）。

---

## 六、健康检查与排障

- 后端存活 + 数据库连通：`GET /health`（公开，容器内 `SELECT 1` 校验）。
- 前端存活：Nginx 容器 `wget -q --spider http://127.0.0.1/` 探针。
- 后端启动依赖数据库「真正可登录」（`depends_on: condition: service_healthy`），避免 TypeORM 首连失败退出。
- 首次启动较慢属正常：MySQL 初始化 + 导入 6 个 SQL 脚本 + 后端编译镜像。

---

## 七、常用运维命令

```bash
# 查看日志
docker compose logs -f backend
docker compose logs -f frontend

# 停止 / 重启
docker compose down
docker compose up -d

# 仅重建后端（改代码后）
docker compose up -d --build backend

# 进入数据库
docker exec -it erp-mysql mysql -uroot -p kuerp_erp
```
