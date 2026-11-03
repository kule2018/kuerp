# 进销存 ERP 后端接口文档

> 本文件由 `npm run docs:api`（`scripts/gen-api-doc.js`）从控制器源码自动生成，**请勿手工编辑**。
> 修改接口后重新执行即可同步。

## 总览

| 指标 | 数值 |
| --- | --- |
| 控制器 | 16 |
| 接口总数 | 167 |
| 生成时间 | 2026/10/26 21:19:40 |

统一约定：

- 响应体固定为 `{ code, msg, data }`，`code = 1` 表示成功（与原 FastAdmin 一致）；
- 业务表接口形如 `/kuerp/<表名>/<动作>`，表名用连字符（`goods-type`）或下划线均可；
- 通用表动作固定为 `index / get / columns / options / add / edit / del / examine / import / export / recyclebin / reduction / realdel / counter / truncate`；
- 时间戳统一为秒级整数（`createtime` / `updatetime` / `deletetime`），`deletetime > 0` 表示软删除。

## 接口清单

### /ai　<span>（登录）</span>

源码：`src\ai\ai.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/ai/model-config` | modelConfigs | 登录 | - | 列出全部模型配置（含停用记录）。 |
| POST | `/ai/model-config/add` | addModelConfig | 登录 | Body | 新增模型配置。 |
| POST | `/ai/model-config/edit` | editModelConfig | 登录 | Body(id) | 修改模型配置。 |
| DELETE | `/ai/model-config/del` | delModelConfig | 登录 | Body(id) | 删除模型配置。 |
| GET | `/ai/prompt-template` | promptTemplates | 登录 | - | 列出全部 Prompt 模板。 |
| POST | `/ai/prompt-template/add` | addPrompt | 登录 | Body | 新增 Prompt 模板。 |
| POST | `/ai/prompt-template/edit` | editPrompt | 登录 | Body(id) | 修改 Prompt 模板。 |
| DELETE | `/ai/prompt-template/del` | delPrompt | 登录 | Body(id) | 删除 Prompt 模板。 |
| POST | `/ai/prompt-template/render` | renderPrompt | 登录 | Body(code)、Body(variables) | 按模板 code 渲染最终提示词（变量填充）。 |
| GET | `/ai/tools` | tools | 登录 | - | 列出当前注册的 AI 工具（供前端/模型选择可用能力）。 |
| POST | `/ai/chat` | chat | 登录 | Body | 单轮对话（不调工具）。 |
| POST | `/ai/agent` | agent | 登录 | Body | Agent 模式：模型自主决定调用哪些工具、调用几轮，直到能回答。 |
| POST | `/ai/structured` | structured | 登录 | Body | 让模型按给定 schema 返回 JSON（生成单据草稿、字段抽取等场景）。 |
| POST | `/ai/retrieve/index-goods` | indexGoods | 登录 | Body | 把商品主档写入检索索引（RAG 的“建库”步骤）。 |
| POST | `/ai/retrieve` | retrieve | 登录 | Body | 在指定数据集里检索（RAG 的“召回”步骤）。 |
| GET | `/ai/call-logs` | callLogs | 登录 | Query(page)、Query(limit) | 分页查询模型调用日志（排查“为什么这次答得慢/答错了”）。 |
| GET | `/ai/tool-logs` | toolLogs | 登录 | Query(page)、Query(limit) | 分页查询工具调用日志（Agent 每轮调了哪个工具、入参出参是什么）。 |

### /auth　<span>（登录）</span>

源码：`src\auth\auth.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| POST | `/auth/login` | login | 公开 | Body | 账号密码登录，成功后返回 JWT 与用户基本信息。 |
| GET | `/auth/profile` | profile | 登录 | CurrentUser(id) | 读取当前登录用户的资料（含角色、菜单树）。 |
| GET | `/auth/perms` | perms | 登录 | CurrentUser(id) | 当前用户权限集合（按钮级权限用）。 |
| POST | `/auth/change-pwd` | changePwd | 登录 | CurrentUser(id)、Body | 修改本人密码（需先校验原密码）。 |

### /system/log　<span>（登录）</span>

源码：`src\common\audit\audit.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/system/log/index` | index | 登录 | Query、CurrentUser | 分页查询操作日志。 |
| GET | `/system/log/facets` | facets | 登录 | CurrentUser | 模块与动作的候选值（供前端筛选下拉）。 |

### /system/cache　<span>（登录）</span>

源码：`src\common\cache\cache.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/system/cache/stats` | stats | 登录 | CurrentUser | 查询缓存运行状态（容量、命中率、淘汰次数）。 |
| POST | `/system/cache/clear` | clear | 登录 | CurrentUser | 清空全部缓存。 |
| POST | `/system/cache/evict` | evict | 登录 | Query(prefix)、CurrentUser | 按前缀失效缓存（例如只清某个表的下拉选项）。 |

### /health　<span>（公开）</span>

源码：`src\common\health\health.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/health` | check | 公开 | - | 存活 + 依赖检查。 |

### /system/message　<span>（登录）</span>

源码：`src\common\message\message.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/system/message/index` | index | 登录 | Query、CurrentUser | 分页查询当前用户的消息。 |
| GET | `/system/message/unread-count` | unread | 登录 | Query、CurrentUser | 未读条数（侧栏徽标）。 |
| POST | `/system/message/read` | read | 登录 | Body、CurrentUser | 标记单条已读。 |
| POST | `/system/message/read-all` | readAll | 登录 | CurrentUser | 全部标记已读。 |
| POST | `/system/message/del` | del | 登录 | Body、CurrentUser | 删除一条消息（软删除）。 |

### /system/job　<span>（登录）</span>

源码：`src\common\scheduler\scheduler.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/system/job/index` | index | 登录 | CurrentUser | 作业清单（含下次执行时间、上次结果、开关状态）。 |
| POST | `/system/job/run` | run | 登录 | Body、CurrentUser | 手动触发一个作业（用于验证配置或补跑）。 |
| GET | `/system/job/logs` | logs | 登录 | Query、CurrentUser | 作业执行历史。 |

### /api/upload　<span>（登录）</span>

源码：`src\common\upload\upload.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/api/upload/config` | config | 登录 | - | 上传前的能力探测：前端据此渲染 accept 提示与大小上限文案。 |
| POST | `/api/upload` | single | 登录 | UploadedFile | 单文件上传（字段名 file）。 |
| POST | `/api/upload/multi` | multi | 登录 | - | 多文件上传（字段名 files，最多 UPLOAD_MAX_COUNT 个）。 |
| POST | `/api/upload/image` | image | 登录 | UploadedFile | 兼容原 FastAdmin 的字段名 image。 |

### /kuerp/approval　<span>（登录）</span>

源码：`src\kuerp\approval\approval.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| POST | `/kuerp/approval/submit` | submit | 登录 | Body、CurrentUser | 提交审批。 |
| POST | `/kuerp/approval/approve` | approve | 登录 | Body、CurrentUser | 审批通过。 |
| POST | `/kuerp/approval/reject` | reject | 登录 | Body、CurrentUser | 审批驳回。 |
| GET | `/kuerp/approval/status` | status | 登录 | Query | 审批进度。 |
| GET | `/kuerp/approval/history` | history | 登录 | Query | 审批历史。 |
| GET | `/kuerp/approval/todo` | todo | 登录 | Query、CurrentUser | 我的待办。 |

### /kuerp　<span>（登录 + 权限节点）</span>

源码：`src\kuerp\biz\biz.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/kuerp/goods/unit` | goodsUnit | 登录 + 权限节点 | Query(rows)、Query(goods_id)、Query(mode)、Query(customers_id) | 商品单位与价格（批量）。 |
| GET | `/kuerp/goods/sale-unit` | goodsSaleUnit | 登录 + 权限节点 | Query(rows)、Query(goods_id)、Query(customers_id) | 商品售价（按客户等级切换价格口径，等价 getSaleUnit） |
| GET | `/kuerp/goods/serial` | goodsSerial | 登录 + 权限节点 | Query(goods_code)、Query(stores_id)、Query(attribute_id) | 可用序列号（等价 getSerial） |
| POST | `/kuerp/goods/serial-build` | goodsSerialBuild | 登录 + 权限节点 | Body | 序列号录入归一化（等价 Goods::period） |
| GET | `/kuerp/goods/scan` | goodsScan | 登录 + 权限节点 | Query(code) | 扫码定位商品（等价 getGoods） |
| GET | `/kuerp/goods/menu` | goodsMenu | 登录 + 权限节点 | - | 商品类别树（等价 getMenu） |
| GET | `/kuerp/customers/receiving-address` | receivingAddress | 登录 + 权限节点 | Query(customers_id) | 客户收货地址（等价 getReceivingAddress） |
| GET | `/kuerp/branch/list` | branchList | 登录 + 权限节点 | Query(keyword) | 门店 / 仓库分支列表（等价 getBranch） |
| GET | `/kuerp/writeoff/sources` | writeoffSources | 登录 + 权限节点 | Query | 核销源单列表。 |
| POST | `/kuerp/user-order/audit` | userOrderAudit | 登录 + 权限节点 | Body、CurrentUser | 订货单审核（等价 UserOrder::examine，status → 2 待发货）。 |
| POST | `/kuerp/user-order/deliver` | userOrderDeliver | 登录 + 权限节点 | Body、CurrentUser | 订货单发货（等价 UserOrder::deliver）。 |
| POST | `/kuerp/user-order/to-sales` | userOrderToSales | 登录 + 权限节点 | Body、CurrentUser | 订货单生成销货单（等价列表「生成销货单」→ goods_sales/add?order_id=x）。 |
| GET | `/kuerp/user-order/express` | expressList | 登录 + 权限节点 | - | 快递公司字典（等价 deliver.html 的 express_list） |
| POST | `/kuerp/assemble/savetemp` | assembleSaveTemp | 登录 + 权限节点 | Body、CurrentUser | 存为模板（等价 Assemble::savetemp / Split::savetemp）。 |
| POST | `/kuerp/split/savetemp` | splitSaveTemp | 登录 + 权限节点 | Body、CurrentUser | 保存拆卸单模板（等价 SplitTemp::savetemp）。 |
| GET | `/kuerp/assemble/temps` | assembleTemps | 登录 + 权限节点 | - | 模板列表（等价 AssembleTemp/SplitTemp::index） |
| GET | `/kuerp/split/temps` | splitTemps | 登录 + 权限节点 | - | 拆卸单模板列表。 |
| GET | `/kuerp/assemble/temps/get` | assembleTempGet | 登录 + 权限节点 | Query(id) | 模板详情（等价 AssembleTemp::gettemp） |
| GET | `/kuerp/split/temps/get` | splitTempGet | 登录 + 权限节点 | Query(id) | 拆卸单模板详情。 |
| POST | `/kuerp/stock/check` | stockCheck | 登录 + 权限节点 | Body | 单据出库库存校验（等价 checkPurchase / checkExchange / checkInventory）。 |

### /kuerp/funds　<span>（登录 + 权限节点）</span>

源码：`src\kuerp\funds\funds.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| POST | `/kuerp/funds/post` | post | 登录 + 权限节点 | Body(table)、Body(id) | 手动过账：对指定单据执行资金过账（幂等，已过账则跳过）。 |
| POST | `/kuerp/funds/unpost` | unpost | 登录 + 权限节点 | Body(table)、Body(id) | 手动冲转：对指定单据执行资金反审冲转（幂等，未审核则跳过）。 |

### /kuerp/boards　<span>（登录 + 权限节点）</span>

源码：`src\kuerp\posting\posting.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/kuerp/boards/replenishment` | replenishment | 登录 + 权限节点 | - | 智能补货看板：销货订单待发量 - 当前库存 = 建议采购量 |
| GET | `/kuerp/boards/purchaseby` | purchaseby | 登录 + 权限节点 | - | 以销定购看板：以销定购驱动采购建议 |
| POST | `/kuerp/boards/generate` | generate | 登录 + 权限节点 | Body | 由看板勾选生成购货订单。 |

### /kuerp　<span>（登录 + 权限节点）</span>

源码：`src\kuerp\table\table.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/kuerp/:table/index` | index | 登录 + 权限节点 | Param(table)、Query、CurrentUser | 列表 / 检索 |
| GET | `/kuerp/tables` | tables | 登录 + 权限节点 | - | 列出所有业务表（前端导航用，路径为 /kuerp/tables，单段不与 :table/index 冲突） |
| GET | `/kuerp/tables/stats` | tableStats | 登录 + 权限节点 | - | 各业务表数据量统计（数据管理页用） |
| GET | `/kuerp/prefix/gen-code` | genCode | 登录 + 权限节点 | Query(dbname)、Query(field) | 按「单号设置」规则生成下一个单据编号（等价原系统 Thirds::getCodes）。 |
| GET | `/kuerp/:table/get` | get | 登录 + 权限节点 | Param(table)、Query(id) | 详情 |
| GET | `/kuerp/:table/columns` | columns | 登录 + 权限节点 | Param(table) | 表字段元信息（前端动态渲染列表列/表单用） |
| GET | `/kuerp/:table/options` | options | 登录 + 权限节点 | Param(table)、Query(field) | 外键字段下拉选项（等价原系统 selectpage / getSuppliers 等）。 |
| POST | `/kuerp/:table/add` | add | 登录 + 权限节点 | Param(table)、Body | 新增 |
| POST | `/kuerp/:table/edit` | edit | 登录 + 权限节点 | Param(table)、Body | 编辑 |
| DELETE | `/kuerp/:table/del` | delDelete | 登录 + 权限节点 | Param(table)、Body、Query(id) | 删除（等价原系统 del）。 |
| POST | `/kuerp/:table/del` | delPost | 登录 + 权限节点 | Param(table)、Body、Query(id) | 删除（POST 形态，等价原系统 del）。 |
| GET | `/kuerp/:table/recyclebin` | recyclebin | 登录 + 权限节点 | Param(table)、Query | 回收站列表（等价原系统 recyclebin） |
| POST | `/kuerp/:table/reduction` | reduction | 登录 + 权限节点 | Param(table)、Body | 还原（等价原系统 reduction，支持批量） |
| POST | `/kuerp/:table/realdel` | realdel | 登录 + 权限节点 | Param(table)、Body | 真实删除（等价原系统 realdel，支持批量，不可恢复） |
| POST | `/kuerp/:table/import` | import | 登录 + 权限节点 | Param(table)、Body | 批量导入（等价原系统 import） |
| POST | `/kuerp/initialize` | initialize | 登录 + 权限节点 | Body | 重新初始化（等价原系统 Initialization）：清空全部业务单据数据。 |
| GET | `/kuerp/checkout/current` | checkoutCurrent | 登录 + 权限节点 | - | 当前结账日期（数据面板 / 结账页读取） |
| POST | `/kuerp/checkout/settle` | checkoutSettle | 登录 + 权限节点 | Body、CurrentUser | 结账：归档账期（endDate 格式 YYYY-MM-DD） |
| POST | `/kuerp/checkout/unsettle` | checkoutUnsettle | 登录 + 权限节点 | - | 反结账：清除结账记录与归档明细 |
| GET | `/kuerp/statistics/dashboard` | dashboardStats | 登录 + 权限节点 | - | 数据面板（工作台）核心指标聚合 |
| POST | `/kuerp/sets/prefix-save` | savePrefixRules | 登录 + 权限节点 | Body | 保存单号组合规则（kuerp_prefix，见 3.设置/1.系统参数.md「单号设置」）。 |
| POST | `/kuerp/:table/counter` | counter | 登录 + 权限节点 | Param(table)、Body、CurrentUser | 对单 / 反对单（等价原系统 GoodsPurchase::counter 等 4 个购销单据控制器）。 |
| POST | `/kuerp/:table/examine` | examine | 登录 + 权限节点 | Param(table)、Body | 审核 / 反审（等价原系统 examine，status 0=反审, 1=已审） |

### /openapi/third　<span>（开放接口（账号 + 签名））</span>

源码：`src\openapi\openapi.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| POST | `/openapi/third/goods/goodsTypeList` | goodsTypeList | 开放接口（账号 + 签名） | Body | 商品分类列表。 |
| POST | `/openapi/third/goods/getGoodsList` | getGoodsList | 开放接口（账号 + 签名） | Body | 商品列表（分页）。 |
| POST | `/openapi/third/goods/getGoodsInfo` | getGoodsInfo | 开放接口（账号 + 签名） | Body | 商品详情（含多单位、价格、库存）。 |
| POST | `/openapi/third/customers/getSalesList` | staffList | 开放接口（账号 + 签名） | Body | 职员（业务员）列表。 |
| POST | `/openapi/third/customers/getCustomersList` | getCustomersList | 开放接口（账号 + 签名） | Body | 客户列表（分页）。 |
| POST | `/openapi/third/customers/joinCustomers` | joinCustomers | 开放接口（账号 + 签名） | Body | 新增客户。 |
| POST | `/openapi/third/customers/customersInfo` | customersInfo | 开放接口（账号 + 签名） | Body | 客户详情。 |
| POST | `/openapi/third/customers/editCustomers` | editCustomers | 开放接口（账号 + 签名） | Body | 编辑客户。 |
| POST | `/openapi/third/customers/delCustomers` | delCustomers | 开放接口（账号 + 签名） | Body | 注销/删除客户。 |
| POST | `/openapi/third/sales/getSalesList` | getSalesList | 开放接口（账号 + 签名） | Body | 销货单列表（分页，可按日期区间过滤）。 |
| POST | `/openapi/third/sales/sales` | sales | 开放接口（账号 + 签名） | Body | 新增销货单（含明细，服务端生成单号并过账）。 |
| POST | `/openapi/third/sales/salesInfo` | salesInfo | 开放接口（账号 + 签名） | Body | 销货单详情（表头 + 明细）。 |
| POST | `/openapi/third/sales/returnSales` | returnSales | 开放接口（账号 + 签名） | Body | 新增销货退货单。 |
| POST | `/openapi/third/sales/returnSalesInfo` | returnSalesInfo | 开放接口（账号 + 签名） | Body | 销货退货单详情。 |

### /shop/index　<span>（公开）</span>

源码：`src\shop\shop.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| POST | `/shop/index/getConfig` | getConfig | 公开 | - | 支付配置（等价 Index::getConfig） |
| POST | `/shop/index/wxpays` | wxpays | 公开 | Body、Req | 支付下单（等价 Index::wxpays / Index::wxpay，两代接口同一实现） |
| POST | `/shop/index/wxpay` | wxpay | 公开 | Body、Req | 支付下单（v2 入口，逻辑同 wxpays） |
| POST | `/shop/index/notify` | notify | 公开 | Body、Req | 微信支付回调（等价 Index::notify）。 |
| POST | `/shop/index/getArea` | getArea | 公开 | Body | 地区详情（等价 Index::getArea） |
| POST | `/shop/index/address_list` | addressList | 公开 | Body | 发货地址 / 自提门店列表（等价 Index::address_list） |
| POST | `/shop/index/banner` | banner | 公开 | Body | 轮播图（等价 Index::banner） |
| POST | `/shop/index/goodsTypeList` | goodsTypeList | 公开 | Body、Req | 商品分类（等价 Index::goodsTypeList） |
| POST | `/shop/index/goodsGoodsList` | goodsGoodsList | 公开 | Body、Req | 商品列表（等价 Index::goodsGoodsList） |
| POST | `/shop/index/goodsGoodsInfo` | goodsGoodsInfo | 公开 | Body、Req | 商品详情（等价 Index::goodsGoodsInfo） |
| POST | `/shop/index/getGoodsUnit` | getGoodsUnit | 公开 | Body、Req | 商品多单位与单位价（等价 Index::getGoodsUnit） |
| POST | `/shop/index/getGoodsAuxiliary` | getGoodsAuxiliary | 公开 | Body、Req | 商品辅助属性（等价 Index::getGoodsAuxiliary） |
| POST | `/shop/index/getHistory` | getHistory | 公开 | Body、Req | 浏览历史（等价 Index::getHistory） |
| POST | `/shop/index/getCartNumber` | getCartNumber | 公开 | Body、Req | 购物车数量（等价 Index::getCartNumber） |
| POST | `/shop/index/getCart` | getCart | 公开 | Body、Req | 购物车列表（等价 Index::getCart） |
| POST | `/shop/index/addCart` | addCart | 公开 | Body、Req | 加入购物车（等价 Index::addCart） |
| POST | `/shop/index/editCart` | editCart | 公开 | Body、Req | 修改购物车（等价 Index::editCart） |
| POST | `/shop/index/delCart` | delCart | 公开 | Body、Req | 删除购物车商品（等价 Index::delCart） |
| POST | `/shop/index/cancelCart` | cancelCart | 公开 | Body、Req | 清空购物车（等价 Index::cancelCart） |
| POST | `/shop/index/leaving` | leaving | 公开 | Body、Req | 商品留言（等价 Index::leaving） |
| POST | `/shop/index/createOrder` | createOrder | 公开 | Body、Req | 创建订货单（等价 Index::createOrder） |
| POST | `/shop/index/getOrderList` | getOrderList | 公开 | Body、Req | 订单列表（等价 Index::getOrderList） |
| POST | `/shop/index/orderInfo` | orderInfo | 公开 | Body、Req | 订单详情（等价 Index::orderInfo） |
| POST | `/shop/index/receiving` | receiving | 公开 | Body、Req | 确认收货（等价 Index::receiving） |
| POST | `/shop/index/cancelOrder` | cancelOrder | 公开 | Body、Req | 取消订单（等价 Index::cancelOrder） |
| POST | `/shop/index/getlist` | getlist | 公开 | Body、Req | 收货地址列表（等价 Order\Address::getlist） |
| POST | `/shop/index/getdetail` | getdetail | 公开 | Body、Req | 收货地址详情（等价 Order\Address::getdetail） |
| POST | `/shop/index/adddetail` | adddetail | 公开 | Body、Req | 新增收货地址（等价 Order\Address::adddetail） |
| POST | `/shop/index/editdetail` | editdetail | 公开 | Body、Req | 编辑收货地址（等价 Order\Address::editdetail） |
| POST | `/shop/index/deldetail` | deldetail | 公开 | Body、Req | 删除收货地址（等价 Order\Address::deldetail） |
| POST | `/shop/index/area` | area | 公开 | Body | 省市区联动（等价 Order\Address::area） |
| POST | `/shop/index/getdetail` | getdetail | 公开 | Body | 配置详情（等价 Order\Config::getdetail） |
| POST | `/shop/index/adddetail` | adddetail | 公开 | Body | 新增配置（等价 Order\Config::adddetail） |
| POST | `/shop/index/editdetail` | editdetail | 公开 | Body | 编辑配置（等价 Order\Config::editdetail） |
| POST | `/shop/index/getSet` | getSet | 公开 | Body | 取单个配置值（等价 Order\Config::getSet） |
| POST | `/shop/index/getConfig` | getConfig | 公开 | Body | 批量取订货通配置（等价 Order\Config::getConfig） |
| POST | `/shop/index/send` | send | 公开 | Body | 发送验证码（等价 Order\Sms::send） |
| POST | `/shop/index/check` | check | 公开 | Body | 校验验证码（等价 Order\Sms::check，供联调自测） |
| POST | `/shop/index/index` | index | 公开 | Body、Req | 会员中心欢迎语（等价 Order\User::index） |
| POST | `/shop/index/login` | login | 公开 | Body | 账号密码登录（等价 Order\User::login） |
| POST | `/shop/index/mobilelogin` | mobilelogin | 公开 | Body | 手机验证码登录，未注册则自动注册（等价 Order\User::mobilelogin） |
| POST | `/shop/index/register` | register | 公开 | Body | 注册会员（等价 Order\User::register） |
| POST | `/shop/index/logout` | logout | 公开 | Body、Req | 退出登录（等价 Order\User::logout） |
| POST | `/shop/index/profile` | profile | 公开 | Body、Req | 修改昵称/头像（等价 Order\User::profile） |
| POST | `/shop/index/changeemail` | changeemail | 公开 | Body、Req | 修改邮箱（等价 Order\User::changeemail）。 |
| POST | `/shop/index/changemobile` | changemobile | 公开 | Body、Req | 绑定手机号（等价 Order\User::changemobile） |
| POST | `/shop/index/resetpwd` | resetpwd | 公开 | Body | 重置密码（等价 Order\User::resetpwd） |
| POST | `/shop/index/userInfo` | userInfo | 公开 | Body、Req | 通过 token 取会员信息（等价 Order\User::userInfo） |
| POST | `/shop/index/getWxMiniProgramSessionKey` | getSessionKey | 公开 | Body | code 换 session_key（等价 Weixin::getWxMiniProgramSessionKey）。 |
| POST | `/shop/index/wxMiniProgramOauth` | miniProgramOauth | 公开 | Body | 小程序授权登录（等价 Weixin::wxMiniProgramOauth） |
| POST | `/shop/index/bind` | bind | 公开 | Body、Req | 绑定手机号（等价 Weixin::bind） |
| POST | `/shop/index/thirdOauthInfo` | thirdOauthInfo | 公开 | Body、Req | 三方授权信息（等价 Weixin::thirdOauthInfo） |
| POST | `/shop/index/unbindThirdOauth` | unbindThirdOauth | 公开 | Body、Req | 解除三方绑定（等价 Weixin::unbindThirdOauth） |
| POST | `/shop/index/init` | init | 公开 | Body | 小程序启动初始化（等价 Order\Common::init）。 |
| GET | `/shop/index/ping` | ping | 公开 | - | 健康检查（便于小程序端联调确认服务可达） |

### /system/admin　<span>（登录）</span>

源码：`src\system\system.controller.ts`

| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |
| --- | --- | --- | --- | --- | --- |
| GET | `/system/admin/index` | index | 登录 | Query(page)、Query(limit)、Query(search) | 管理员列表（分页 + 关键字搜索）。 |
| POST | `/system/admin/add` | add | 登录 | Body | 新增管理员。 |
| POST | `/system/admin/edit` | edit | 登录 | Body(id) | 修改管理员信息（密码为空表示不修改）。 |
| DELETE | `/system/admin/del` | del | 登录 | Body(id) | 删除管理员（软删除）。 |
| POST | `/system/admin/del` | del | 登录 | Body(id) | 删除管理员（软删除）。 |
