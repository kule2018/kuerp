import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../store/auth';
import { message } from '@/utils/ui';
import Layout from '../layout/index.vue';
import { flattenMenus } from '../menus';
import { loadPerms, usePerm } from '@/utils/perm';

/**
 * 组件名 -> 懒加载组件。
 * 通用动态表格页 crud 驱动全部业务模块（/kuerp/:table）；
 * 其余为原系统中形态特殊的页面（工作台/大屏/打印/AI/权限等）。
 */
const components = {
  crud: () => import('../views/crud-page.vue'),
  report: () => import('../views/report-page.vue'),
  pos: () => import('../views/pos.vue'),
  'print-center': () => import('../views/print-center.vue'),
  'goods-period': () => import('../views/goods-period.vue'),
  dashboard: () => import('../views/dashboard.vue'),
  screen: () => import('../views/screen.vue'),
  datainfo: () => import('../views/datainfo.vue'),
  initialization: () => import('../views/initialization.vue'),
  'auth-group': () => import('../views/auth/group.vue'),
  'auth-admin': () => import('../views/auth/admin.vue'),
  checkout: () => import('../views/checkout.vue'),
  board: () => import('../views/board.vue'),
  sets: () => import('../views/sets.vue'),
  'fund-doc': () => import('../views/fund-doc.vue'),
  'doc-editor': () => import('../views/doc-editor.vue'),
  'serial-inventory': () => import('../views/serial-inventory.vue'),
  'report-profit': () => import('../views/reports/profit.vue'),
  'report-ar': () => import('../views/reports/ar.vue'),
  'report-warning': () => import('../views/reports/stock-warning.vue'),
  'user-order': () => import('../views/user-order.vue'),
  goods: () => import('../views/goods/index.vue'),
  'ai/model-config': () => import('../views/ai/model-config.vue'),
  'ai/prompt-template': () => import('../views/ai/prompt-template.vue'),
  'ai/playground': () => import('../views/ai/playground.vue'),
  'ai/assistant': () => import('../views/ai/assistant.vue'),
  'ai/logs': () => import('../views/ai/logs.vue'),
  // 接口管理：移动端商城(order) / 第三方对接(third) 的接口说明页
  'api-doc': () => import('../views/api-doc.vue'),
  // 系统运维：操作日志（审计）
  'sys-log': () => import('../views/system/log.vue'),
  // 系统运维：消息中心 / 定时作业
  'sys-message': () => import('../views/system/message.vue'),
  'sys-job': () => import('../views/system/job.vue'),
  // 系统运维：审批待办（消息中心 type=approval 的 link 指向 /approval-todo）
  'sys-approval-todo': () => import('../views/system/approval-todo.vue'),
};

// 由菜单唯一事实源生成全部业务路由（页面与原系统 1:1）
// meta 除 title/api 外，还透传菜单节点上的 meta 配置（如资金单据的 fund 配置）
const businessRoutes = flattenMenus().map((m) => ({
  path: m.path,
  name: m.name,
  component: components[m.component] || components.crud,
  meta: { title: m.title, api: m.api, perm: m.perm, ...(m.meta || {}) },
}));

const routes = [
  { path: '/login', name: 'Login', component: () => import('../views/login.vue'), meta: { public: true } },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      ...businessRoutes,
      // 商品编辑（专用表单页，隐藏于菜单）
      { path: 'goods/edit', name: 'GoodsEdit', component: () => import('../views/goods/form.vue'), meta: { title: '商品编辑', hidden: true, api: '/kuerp/goods' } },
      { path: 'goods/edit/:id', name: 'GoodsEditId', component: () => import('../views/goods/form.vue'), meta: { title: '商品编辑', hidden: true, api: '/kuerp/goods' } },
      // 通用打印页（原系统 Prints 控制器：按表+单据id 渲染可打印单据）
      { path: 'print', name: 'Print', component: () => import('../views/print.vue'), meta: { title: '单据打印', hidden: true } },
      // 报表打印页（原系统 Prints 的报表类打印：cgmx/cgddgz/cghzb_sp/cghzb_gys/cgfk/xsddgz）
      { path: 'print-report', name: 'PrintReport', component: () => import('../views/print-report.vue'), meta: { title: '报表打印', hidden: true } },
    ],
  },
  { path: '/:pathMatch(.*)*', redirect: '/dashboard' },
];

const router = createRouter({ history: createWebHistory(), routes });

router.beforeEach(async (to, from, next) => {
  const auth = useAuthStore();
  if (!to.meta.public && !auth.token) return next('/login');
  if (to.path === '/login' && auth.token) return next('/');
  // 菜单/页面级权限：超管放行；其余按 route.meta.perm 判定（与后端 RbacGuard 口径一致）。
  // 未登录态由上一层拦截，这里只处理「已登录但无权访问该菜单」的越权直链。
  if (!to.meta.public && to.meta.perm) {
    await loadPerms();
    const { state } = usePerm();
    if (!state.isSuper && !state.nodes.includes('*')) {
      const perm = to.meta.perm;
      const ok = perm.startsWith('kuerp/')
        ? !!state.tables[perm.slice('kuerp/'.length)] || state.nodes.includes(perm) || state.menus.includes(perm)
        : state.menus.includes(perm) || state.nodes.includes(perm);
      if (!ok) {
        message.warning('无权访问该页面');
        return next('/dashboard');
      }
    }
  }
  next();
});

export default router;
