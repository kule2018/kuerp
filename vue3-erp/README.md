# 进销存 ERP 管理前端 — Vue3 + Element-Plus

`nestjs-erp` 的配套管理后台，前后端分离。

## 技术栈
Vue3 + Vite + Element-Plus + Vue-Router + Pinia + Axios

## 目录
```
src/
├── main.js / App.vue / style.css
├── router/index.js      # 路由（含鉴权守卫；全部业务模块 → 通用动态表格页）
├── menus.js             # 侧边栏菜单
├── layout/index.vue     # 布局（侧边菜单 + 顶栏）
├── store/auth.js        # 登录态（token/user，localStorage 持久化）
├── utils/request.js     # Axios 封装（JWT 注入 + {code,msg,data} 统一解包）
└── views/
    ├── login.vue / dashboard.vue
    ├── crud-page.vue    # ★ 通用动态表格页：动态列 + 动态表单 + 增删改查/审核，驱动全部 kuerp_* 表
    ├── goods/           # 商品资料（参考实现）
    └── ai/              # 模型配置 / Prompt模板 / 对话Agent / 调用日志
```

## 运行
```bash
npm install
npm run dev      # → http://localhost:5173
```
开发代理（`vite.config.js`）已将 `/kuerp` `/ai` `/auth` `/system` 转发到后端 `http://localhost:3000`，请先启动 `nestjs-erp`。

生产构建：`npm run build`（产物在 `dist/`）。

## 说明
- 登录默认账号：admin / 123456
- 「资料/采购/销售/仓库/资金」各页面复用 `crud-page.vue`，通过路由 `meta.api`（如 `/kuerp/goods-purchase`）指向对应表，列与表单在运行期从后端 `/kuerp/:table/columns` 动态生成，从而实现全部模块 1:1 覆盖。
- 「AI 能力中心」四个页面对接 `/ai/*` 接口。
