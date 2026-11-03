/**
 * 侧边栏菜单（1:1 还原原酷柚易汛 Kuerp 后台全部模块）。
 *
 * 说明：
 * - 每个叶子节点 = 原系统一个控制器/页面；api 字段指向后端通用动态表接口 /kuerp/:table，
 *   表名与原系统 Model->$name 一一对应（已逐一核对 application/admin/model/kuerp/*.php）。
 * - component: 'crud' 表示复用通用动态表格页；特殊页面（工作台/大屏/打印/AI/权限等）单独指定。
 * - 本文件是路由的唯一事实源：router/index.js 据此自动生成全部路由。
 */

// 通用表格页路由工厂：path 为前端路由，api 为后端表接口（连字符会自动转下划线）
const c = (title, path, api, extra = {}) => ({
  title,
  name: path.replace(/[-/]/g, '_').replace(/^_/, ''),
  path,
  api,
  component: 'crud',
  ...extra,
});

// 报表页工厂：在 c 基础上标记为只读报表（日期筛选 + 合计行）。
// 用于原系统中各类「汇总表 / 明细表 / 利润表 / 对账表」页面。
const r = (title, path, api, extra = {}) => c(title, path, api, { ...extra, component: 'report' });

// 资金单据页工厂：表头 + 子表（结算账户/核销源单/转账明细/支出明细）编辑器。
// fund 配置经 router 透传到 route.meta.fund，由 fund-doc.vue 消费：
//   mode       account=收款/付款单(账户+源单) / writeoff=核销单(源单) /
//              transfer=转账单(转入转出) / expend=其他支出单(支出明细)
//   prefix     单据编号前缀（SK/FK/HX/ZZ/ZC）
//   counterparty 往来单位口径：customer=客户 / supplier=供应商
//   accountInfo/sourceInfo/transferInfo/simpleInfo 子表接口
const d = (title, path, api, fund = {}) => ({
  title,
  name: path.replace(/[-/]/g, '_').replace(/^_/, ''),
  path,
  api,
  component: 'fund-doc',
  meta: { fund },
});

// 库存单据页工厂：表头 + 明细子表编辑器（doc-editor.vue 消费 route.meta.doc）：
//   info            明细表 API 前缀（如 goods-purchase-info）
//   prefix          单据编号前缀（与 kuerp_prefix 种子一致：GHD/XHD/DB/PD/...）
//   counterparty    supplier=供应商(购货类) / customer=客户(销货类) / ''=无
//   counterpartyById true=表头存 customers_id(ID)；false=存 supplyer_code(编号)
//   shape           goods=购销退货(含金额) / order=订单(含金额) / transfer=调拨(双仓库)
//                    stocktake=盘点(系统库存+盈亏) / adjust=成本调整(仅金额) / bom=组装拆卸(组合件+子件)
//   bom             assemble=组装单(子件出库+组合件入库) / split=拆卸单(组合件出库+子件入库)，配合 shape:'bom'
//   priceBase       sell=默认零售价 / purchase=默认进价
//   byId            true=明细按表头主键关联（调拨单 allocation_id）
const g = (title, path, api, doc = {}) => ({
  title,
  name: path.replace(/[-/]/g, '_').replace(/^_/, ''),
  path,
  api,
  component: 'doc-editor',
  meta: { doc },
});

export const menus = [
  { title: '工作台', icon: 'Odometer', name: 'Dashboard', path: 'dashboard', component: 'dashboard' },
  { title: '数字大屏', icon: 'DataLine', name: 'Screen', path: 'screen', component: 'screen' },
  { title: '打印中心', icon: 'Printer', name: 'PrintCenter', path: 'print-center', component: 'print-center' },

  // ===================== 基础资料 =====================
  {
    title: '基础资料',
    icon: 'Goods',
    children: [
      { title: '商品管理', icon: 'Goods', name: 'Goods', path: 'goods', component: 'goods' },
      c('商品类别', 'goods-type', '/kuerp/goods-type'),
      c('商品辅助属性', 'auxiliary', '/kuerp/auxiliary'),
      c('客户物料编码', 'customer-goodscoding', '/kuerp/customer-goodscoding'),
      c('计量单位', 'unit', '/kuerp/unit'),
      c('单位换算', 'unit-conversion', '/kuerp/unit-conversion'),
      c('仓库管理', 'stores', '/kuerp/stores'),
      c('收货地址管理', 'address', '/kuerp/address'),
      c('客户管理', 'customers', '/kuerp/customers'),
      c('客户分类', 'customertype', '/kuerp/customertype'),
      c('客户等级', 'customerlevel', '/kuerp/customerlevel'),
      c('供应商管理', 'suppliers', '/kuerp/suppliers'),
      c('供应商分类', 'supplyertype', '/kuerp/supplyertype'),
      c('供应商联系人', 'suppliers-user', '/kuerp/suppliers-user'),
      c('职员管理', 'staff-member', '/kuerp/staff-member'),
      c('司机管理', 'driver', '/kuerp/driver'),
      c('订货通用户', 'customers-user', '/kuerp/customers-user'),
      c('账户管理', 'accounts', '/kuerp/accounts'),
      c('付款账户', 'payment-account', '/kuerp/payment-account'),
      c('第三方帐号管理', 'third-account', '/kuerp/third-account'),
      c('订货通配置', 'user-sets', '/kuerp/user-sets'),
      c('结算方式', 'settlementtype', '/kuerp/settlementtype'),
      c('支出类别管理', 'expend-type', '/kuerp/expend-type'),
      c('收入类别管理', 'income-type', '/kuerp/income-type'),
      c('轮播管理', 'banner', '/kuerp/banner'),
    ],
  },

  // ===================== 购货 =====================
  {
    title: '购货管理',
    icon: 'ShoppingCart',
    children: [
      g('购货订单', 'goods-purchase-order', '/kuerp/goods-purchase-order', { info: 'goods-purchase-order-info', prefix: 'GHDD', counterparty: 'supplier', shape: 'order', priceBase: 'purchase' }),
      r('采购订单跟踪表', 'goods-purchase-order-tracking', '/kuerp/goods-purchase-order', { meta: { dateField: 'purchase_time' } }),
      g('购货单', 'goods-purchase', '/kuerp/goods-purchase', { info: 'goods-purchase-info', prefix: 'GHD', counterparty: 'supplier', shape: 'goods', priceBase: 'purchase' }),
      c('购货订单明细', 'goods-purchase-order-info', '/kuerp/goods-purchase-order-info'),
      g('购货退货单', 'goods-exchange', '/kuerp/goods-exchange', { info: 'goods-exchange-info', prefix: 'GHTH', counterparty: 'supplier', shape: 'goods', priceBase: 'purchase' }),
      c('购货退货明细', 'goods-exchange-info', '/kuerp/goods-exchange-info'),
      r('采购明细表', 'goods-purchase-info', '/kuerp/goods-purchase-info'),
      r('采购汇总表（商品）', 'goods-purchase-summary', '/kuerp/goods-purchase-summary'),
      r('采购汇总表（供应商）', 'goods-purchase-summarys', '/kuerp/goods-purchase-summarys'),
      r('采购付款一览表', 'payment-log', '/kuerp/payment-log'),
      r('采购开票管理', 'invoicing', '/kuerp/invoicing'),
      r('采购开票记录', 'invoicing-log', '/kuerp/invoicing-log'),
      c('采购销售费用清单', 'cost', '/kuerp/cost'),
      { title: '以销定购看板', icon: 'TrendCharts', name: 'Purchaseby', path: 'purchaseby', component: 'board', api: '/kuerp/boards/purchaseby' },
      { title: '智能补货', icon: 'MagicStick', name: 'Replenishment', path: 'replenishment', component: 'board', api: '/kuerp/boards/replenishment' },
      c('原始单据', 'enclosure', '/kuerp/enclosure'),
    ],
  },

  // ===================== 销货 =====================
  {
    title: '销货管理',
    icon: 'Sell',
    children: [
      g('销货订单', 'goods-sales-order', '/kuerp/goods-sales-order', { info: 'goods-sales-order-info', prefix: 'XHDD', counterparty: 'customer', counterpartyById: true, shape: 'order', priceBase: 'sell' }),
      r('销售订单跟踪表', 'goods-sales-order-tracking', '/kuerp/goods-sales-order', { meta: { dateField: 'purchase_time' } }),
      g('销货单', 'goods-sales', '/kuerp/goods-sales', { info: 'goods-sales-info', prefix: 'XHD', counterparty: 'customer', counterpartyById: true, shape: 'goods', priceBase: 'sell' }),
      c('销货订单明细', 'goods-sales-order-info', '/kuerp/goods-sales-order-info'),
      g('销货退货单', 'goods-sales-exchange', '/kuerp/goods-sales-exchange', { info: 'goods-sales-exchange-info', prefix: 'XHTH', counterparty: 'customer', counterpartyById: true, shape: 'goods', priceBase: 'sell' }),
      c('销货退货明细', 'goods-sales-exchange-info', '/kuerp/goods-sales-exchange-info'),
      r('商品销售明细', 'goods-sales-info', '/kuerp/goods-sales-info'),
      r('销售汇总表（按商品）', 'goods-sales-summary', '/kuerp/goods-sales-summary'),
      r('销售汇总表（按客户）', 'goods-sales-summaryc', '/kuerp/goods-sales-summaryc'),
      r('销售汇总表（按销售员）', 'goods-sales-summarys', '/kuerp/goods-sales-summarys'),
      r('销售利润管理', 'goods-sales-profit', '/kuerp/goods-sales-profit'),
      r('销售利润表', 'salesprofit', '/kuerp/goods-sales-profit'),
      r('销售收款一览表', 'sales-payment-log', '/kuerp/sales-payment-log'),
      r('销货开票管理', 'sales-invoicing', '/kuerp/sales-invoicing'),
      r('销货开票记录', 'sales-invoicing-log', '/kuerp/sales-invoicing-log'),
      { title: '往来单位欠款表', name: 'intercourse', path: 'intercourse', api: '/kuerp/intercourse', component: 'report-ar' },
      r('销售排行表', 'goods-sales-ranking', '/kuerp/goods-sales-ranking'),
      c('原始单据（销货）', 'enclosuresale', '/kuerp/enclosure'),
      c('零售销货', 'retail-goods-sales', '/kuerp/goods-sales', { component: 'pos' }),
      // 零售换货：同一收银台页，经 route.meta.mode 切换到退货口径（goods_sales_exchange）
      c('零售换货', 'retail-goods-sales-exchange', '/kuerp/goods-sales-exchange', {
        component: 'pos',
        meta: { mode: 'exchange' },
      }),
    ],
  },

  // ===================== 仓库 =====================
  {
    title: '仓库管理',
    icon: 'Box',
    children: [
      r('商品库存管理', 'goods-stock', '/kuerp/goods-stock'),
      r('商品库存余额表', 'goods-stock-balance', '/kuerp/goods-stock-balance'),
      { title: '库存预警', name: 'goods_stock_warning', path: 'goods-stock-warning', api: '/kuerp/goods-stock-warning', component: 'report-warning' },
      g('调拨单', 'allocation', '/kuerp/allocation', { info: 'allocation-info', prefix: 'DB', shape: 'transfer', byId: true }),
      g('盘点', 'inventory', '/kuerp/inventory', { info: 'inventory-info', prefix: 'PD', shape: 'stocktake' }),
      { title: '序列号盘点', icon: 'Checked', name: 'InventorySerial', path: 'inventory-serial', component: 'serial-inventory', api: '/kuerp/inventory-serial' },
      g('其他入库单', 'warehousing', '/kuerp/warehousing', { info: 'warehousing-info', prefix: 'QTRK', shape: 'goods' }),
      g('其他出库单', 'warehouse', '/kuerp/warehouse', { info: 'warehouse-info', prefix: 'QTCK', shape: 'goods' }),
      g('组装单', 'assemble', '/kuerp/assemble', { info: 'assemble-info', prefix: 'ZZ', shape: 'bom', bom: 'assemble' }),
      c('组装单模板', 'assemble-temp', '/kuerp/assemble-temp'),
      g('拆卸单', 'split', '/kuerp/split', { info: 'split-info', prefix: 'CX', shape: 'bom', bom: 'split' }),
      c('拆卸单模板', 'split-temp', '/kuerp/split-temp'),
      g('成本调整单', 'adjustment', '/kuerp/adjustment', { info: 'adjustment-info', prefix: 'CBTZ', shape: 'adjust' }),
      r('商品收发明细表', 'goods-log', '/kuerp/goods-log'),
      r('商品收发汇总表', 'goods-log-summary', '/kuerp/goods-log-summary'),
      c('商品批次管理', 'goods-batch', '/kuerp/goods-batch'),
      c('商品批次详情', 'goods-batch-info', '/kuerp/goods-batch-info'),
      r('批次跟踪表', 'goods-batch-log', '/kuerp/goods-batch-log'),
      r('商品批次库存', 'goods-batch-stock', '/kuerp/goods-batch-stock'),
      r('批次保质期清单', 'goods-batch-expiry', '/kuerp/goods-batch-expiry'),
      c('商品序列号', 'goods-serial', '/kuerp/goods-serial'),
      r('序列号跟踪表', 'goods-serial-log', '/kuerp/goods-serial-log'),
      r('序列号状态表', 'goods-serial-status', '/kuerp/goods-serial-status'),
      { title: '商品期间', icon: 'Calendar', name: 'GoodsPeriod', path: 'goods-period', component: 'goods-period' },
    ],
  },

  // ===================== 资金 =====================
  {
    title: '资金管理',
    icon: 'Money',
    children: [
      d('收款单', 'collection', '/kuerp/collection', {
        mode: 'account', prefix: 'SK', counterparty: 'customer',
        accountInfo: '/kuerp/collection-account', sourceInfo: '/kuerp/collection-sale',
      }),
      d('付款单', 'payment', '/kuerp/payment', {
        mode: 'account', prefix: 'FK', counterparty: 'supplier',
        accountInfo: '/kuerp/payment-account', sourceInfo: '/kuerp/payment-sale',
      }),
      d('核销单', 'writeoff', '/kuerp/writeoff', {
        mode: 'writeoff', prefix: 'HX', counterparty: 'customer',
        sourceInfo: '/kuerp/writeoff-info',
      }),
      c('核销记录', 'writeoff-log', '/kuerp/writeoff-log'),
      r('应收账款明细表', 'accounts-receivable', '/kuerp/accounts-receivable'),
      r('应付账款明细表', 'accounts-copewith', '/kuerp/accounts-copewith'),
      d('其他收入单', 'income', '/kuerp/income', {
        mode: 'income', prefix: 'QTSR', counterparty: 'customer',
        simpleInfo: '/kuerp/income-info',
      }),
      d('其他支出单', 'expenditure', '/kuerp/expenditure', {
        mode: 'expend', prefix: 'QTZC', counterparty: 'supplier',
        simpleInfo: '/kuerp/expenditure-info',
      }),
      d('资金转账单', 'accounts-transfer', '/kuerp/accounts-transfer', {
        mode: 'transfer', prefix: 'ZJZZ', transferInfo: '/kuerp/accounts-transfer-info',
      }),
      c('账户记录管理', 'accounts-log', '/kuerp/accounts-log'),
      r('现金银行报表', 'cash-bank', '/kuerp/cash-bank'),
      r('其他收支明细表', 'revenue', '/kuerp/revenue'),
      r('客户对账单', 'customers-recon', '/kuerp/customers-recon'),
      r('供应商对账单', 'suppliers-recon', '/kuerp/suppliers-recon'),
      { title: '利润表', name: 'profit', path: 'profit', api: '/kuerp/profit', component: 'report-profit' },
    ],
  },

  // ===================== 订货通（移动端）=====================
  {
    title: '移动端订货通',
    icon: 'Iphone',
    children: [
      c('订货单管理', 'user-order', '/kuerp/user-order', { component: 'user-order' }),
      c('用户管理', 'kuerp-user', '/kuerp/user'),
    ],
  },

  // ===================== 系统设置 =====================
  {
    title: '系统设置',
    icon: 'Setting',
    children: [
      { title: '系统参数', icon: 'Setting', name: 'Sets', path: 'sets', component: 'sets', api: '/kuerp/sets' },
      c('单号设置', 'prefix', '/kuerp/prefix'),
      { title: '结账/反结账', icon: 'Calendar', name: 'Checkout', path: 'checkout', component: 'checkout' },
      { title: '数据管理', icon: 'Files', name: 'Datainfo', path: 'datainfo', component: 'datainfo' },
      { title: '重新初始化', icon: 'RefreshLeft', name: 'Initialization', path: 'initialization', component: 'initialization' },
      { title: '角色管理', icon: 'UserFilled', name: 'AuthGroup', path: 'auth-group', component: 'auth-group' },
      { title: '管理员管理', icon: 'Avatar', name: 'AuthAdmin', path: 'auth-admin', component: 'auth-admin' },
      c('权限规则', 'auth-rule', '/kuerp/auth-rule'),
      { title: '操作日志', icon: 'Tickets', name: 'SysLog', path: 'system/log', component: 'sys-log' },
      { title: '消息中心', icon: 'ChatDotRound', name: 'SysMessage', path: 'system/message', component: 'sys-message' },
      { title: '审批待办', icon: 'Checked', name: 'SysApprovalTodo', path: 'system/approval-todo', component: 'sys-approval-todo' },
      { title: '定时作业', icon: 'RefreshLeft', name: 'SysJob', path: 'system/job', component: 'sys-job' },
    ],
  },

  // ===================== 接口管理（移动端商城 order / 第三方对接 third）=====================
  // 原系统 application/api/controller/kuerp/order、third 两组对外接口，
  // 后端已由 nestjs-erp 的 shop / openapi 模块 1:1 实现；
  // 此处仅把各控制器挂到后台菜单，点击进入 api-doc 说明页（只读接口参考）。
  {
    title: '小程序商城接口 (order)',
    icon: 'Iphone',
    children: [
      { title: 'Index 商品/订单/支付', path: 'api-order-index', component: 'api-doc', icon: 'Odometer', meta: { docKey: 'order-index' } },
      { title: 'User 会员', path: 'api-order-user', component: 'api-doc', icon: 'Avatar', meta: { docKey: 'order-user' } },
      { title: 'Weixin 微信', path: 'api-order-weixin', component: 'api-doc', icon: 'ChatDotRound', meta: { docKey: 'order-weixin' } },
      { title: 'Sms 短信', path: 'api-order-sms', component: 'api-doc', icon: 'Document', meta: { docKey: 'order-sms' } },
      { title: 'Address 地址', path: 'api-order-address', component: 'api-doc', icon: 'Box', meta: { docKey: 'order-address' } },
      { title: 'Config 配置', path: 'api-order-config', component: 'api-doc', icon: 'Setting', meta: { docKey: 'order-config' } },
      { title: 'Common 通用', path: 'api-order-common', component: 'api-doc', icon: 'Odometer', meta: { docKey: 'order-common' } },
    ],
  },
  {
    title: '第三方对接 (third)',
    icon: 'Link',
    children: [
      { title: 'Thirds 总控(签名鉴权)', path: 'api-third-thirds', component: 'api-doc', icon: 'Setting', meta: { docKey: 'third-thirds' } },
      { title: 'Goods 商品', path: 'api-third-goods', component: 'api-doc', icon: 'Box', meta: { docKey: 'third-goods' } },
      { title: 'Customers 客户', path: 'api-third-customers', component: 'api-doc', icon: 'Avatar', meta: { docKey: 'third-customers' } },
      { title: 'Sales 销货', path: 'api-third-sales', component: 'api-doc', icon: 'ShoppingCart', meta: { docKey: 'third-sales' } },
    ],
  },

  // ===================== AI 能力中心 =====================
  {
    title: 'AI 能力中心',
    icon: 'Cpu',
    children: [
      { title: '模型配置', icon: 'Setting', name: 'AiModelConfig', path: 'ai/model-config', component: 'ai/model-config' },
      { title: 'Prompt 模板', icon: 'Document', name: 'AiPrompt', path: 'ai/prompt-template', component: 'ai/prompt-template' },
      { title: '对话 / Agent', icon: 'ChatDotRound', name: 'AiPlayground', path: 'ai/playground', component: 'ai/playground' },
      { title: 'AI 经营助手', icon: 'MagicStick', name: 'AiAssistant', path: 'ai/assistant', component: 'ai/assistant' },
      { title: '调用日志', icon: 'Tickets', name: 'AiLogs', path: 'ai/logs', component: 'ai/logs' },
    ],
  },
];

/**
 * 非业务表页（无 /kuerp api）的菜单级权限节点映射。
 * 业务表页的节点由 api 自动推导为 `kuerp/<表名>`；
 * 这里的 key 是菜单 path，value 是 auth_rule 里的菜单节点名。
 * 未在此列出且无 api 的页面（如接口说明页）视为公开页（登录即可见）。
 */
const MENU_PERM = {
  dashboard: 'dashboard',
  screen: 'screen',
  'print-center': 'print',
  goods: 'kuerp/goods',
  sets: 'kuerp/sets',
  checkout: 'kuerp/checkout',
  datainfo: 'datainfo',
  initialization: 'initialization',
  'auth-group': 'auth/group',
  'auth-admin': 'auth/admin',
  'auth-rule': 'auth/rule',
  'system/log': 'system/log',
  'system/message': 'system/message',
  'system/approval-todo': 'system/approval-todo',
  'system/job': 'system/job',
  'ai/model-config': 'ai/model-config',
  'ai/prompt-template': 'ai/prompt-template',
  'ai/playground': 'ai/playground',
  'ai/assistant': 'ai/assistant',
  'ai/logs': 'ai/logs',
};

/**
 * 给每个叶子菜单挂上权限节点（供前端菜单过滤 + 路由守卫判定）。
 * - 有 api 的业务页：节点 = `kuerp/<表名>`（连字符转下划线，与后端 RbacGuard 一致）；
 * - 无 api 的系统/看板页：取 MENU_PERM 映射；
 * - 其余（接口说明页等）：不设节点，视为公开页。
 * 直接 mutate 原对象，router / layout 共享同一份菜单数据。
 */
(function attachPerm() {
  const walk = (items) =>
    items.forEach((m) => {
      if (m.children) walk(m.children);
      else if (!m.perm) {
        if (m.api && m.api.startsWith('/kuerp/')) {
          m.perm = 'kuerp/' + m.api.replace('/kuerp/', '').replace(/-/g, '_');
        } else if (MENU_PERM[m.path]) {
          m.perm = MENU_PERM[m.path];
        }
      }
    });
  walk(menus);
})();

/**
 * 扁平化菜单为路由数组（供 router 使用）。
 * @returns [{ name, path, title, api, component }]
 */
export function flattenMenus() {
  const out = [];
  const walk = (items) =>
    items.forEach((m) => {
      if (m.children) walk(m.children);
      else if (m.path) out.push(m);
    });
  walk(menus);
  return out;
}
