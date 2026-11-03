<!--
 * 全站布局（DeepSeek UI 风格外壳）。
 * 页面位置 / 用途：挂在路由 '/' 之下，是所有业务页面的公共框架——
 *   左侧分组导航（DsAppShell）+ 顶栏（当前页标题 + 登录人下拉）+ 内容区（router-view）。
 * 与旧版区别：原为 Element Plus 的 el-container/el-menu/el-dropdown 手写布局，
 *   现整体切换为组件库 ds 的 DsAppShell，视觉与交互对齐 DeepSeek 网页版
 *   （侧边栏可折叠、窄屏自动抽屉、导航按菜单分组显示小标题）。
 * 注意：全局 Toast 容器由 App.vue 根节点统一挂载，这里传 :toast="false" 防止重复渲染。
 -->
<template>
  <DsAppShell
    title="进销存 ERP"
    subtitle="Kuerp 管理后台"
    :nav="navItems"
    :collapsible-groups="true"
    :page-title="route.meta.title"
    :toast="false"
  >
    <!-- 顶栏右侧：当前登录人，点击展开下拉（退出登录） -->
    <template #header>
      <DsDropdown :items="userItems" placement="bottom-end" @command="onCommand">
        <DsButton variant="text" size="sm">
          <template #icon><IconFont name="User" :size="15" /></template>
          {{ auth.user?.nickname || auth.user?.username || '未登录' }}
        </DsButton>
      </DsDropdown>
    </template>

    <!--
      内容区：当前路由对应的业务页面。
      key 取 route.path —— 通用表格页 crud-page 在 setup 里按 route.meta.api 固定了表名，
      若复用实例会导致「切到另一个业务表仍查上一张表」，故强制按路径重建组件。
    -->
    <router-view :key="route.path" />

    <!-- 全局 AI 经营助手（悬浮窗）：挂在 router-view 之外，跨页面常驻对话 -->
    <AiCopilot />
  </DsAppShell>
</template>

<script setup>
/**
 * 布局逻辑：把 menus.js 的菜单树转成 DsAppShell 需要的扁平导航项，
 * 并提供顶栏用户下拉命令处理（退出登录）。
 */
import { computed, onMounted, onBeforeUnmount } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { menus } from '../menus';
import { useAuthStore } from '../store/auth';
import { useMessageStore } from '../store/message';
import { DsAppShell, DsButton, DsDropdown, IconFont } from '../components';
import { getIcon } from '../components/ds/icons';
import { loadPerms, usePerm } from '../utils/perm';
import AiCopilot from '../views/ai/AiCopilot.vue';

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
/** 消息中心未读数（侧栏徽标数据源） */
const msgStore = useMessageStore();
/** 权限状态：菜单过滤依赖它（未加载完成前放行全部，避免首屏闪烁） */
const { state: permState } = usePerm();

/**
 * 菜单可见性：超管 / 未加载 / 公开页（无节点）一律可见；
 * 其余按权限节点判定（与后端 RbacGuard 口径一致：表级节点即该表全部动作）。
 * @param node 菜单叶子节点
 */
function menuVisible(node) {
  if (!permState.loaded || permState.isSuper || permState.nodes.includes('*')) return true;
  const perm = node.perm;
  if (!perm) return true; // 公开页（接口说明等）
  if (perm.startsWith('kuerp/')) {
    const table = perm.slice('kuerp/'.length);
    return !!permState.tables[table] || permState.nodes.includes(perm) || permState.menus.includes(perm);
  }
  return permState.menus.includes(perm) || permState.nodes.includes(perm);
}

// 登录态下启动未读轮询 + 加载按钮级权限集合，离开布局（登出）时停掉轮询，避免定时器泄漏
onMounted(() => {
  if (auth.token) {
    msgStore.startPolling();
    loadPerms(); // 权限用于各页面的按钮显隐；失败时 hasPerm 一律放行，不影响可用性
  }
});
onBeforeUnmount(() => {
  msgStore.stopPolling();
});

/**
 * Element Plus 图标名 → ds 内置线性图标名映射表。
 * 背景：menus.js 里各菜单节点存的是原系统的 EP 图标名（如 Odometer），
 *       ds 图标库是另一套 24×24 线性图标，需做等价映射；
 *       ICON_MAP 未命中的名字统一回退 Box（业务图标）。
 */
const ICON_MAP = {
  Odometer: 'Home',
  DataLine: 'Chart',
  Printer: 'Printer',
  Goods: 'Box',
  ShoppingCart: 'Cart',
  Sell: 'Send',
  Box: 'Box',
  Money: 'Money',
  Iphone: 'Phone',
  Setting: 'Setting',
  Cpu: 'Cpu',
  Calendar: 'Calendar',
  Checked: 'Check',
  Files: 'File',
  RefreshLeft: 'Refresh',
  UserFilled: 'Users',
  Avatar: 'User',
  Document: 'File',
  ChatDotRound: 'Chat',
  Tickets: 'Ticket',
  TrendCharts: 'Trend',
  MagicStick: 'Magic',
};

/**
 * 把菜单树拍平成 DsAppShell 导航项。
 * 规则：顶层无 children 的节点直接成项（归入「无标题组」）；
 *       有 children 的组，组名作为分组小标题，子项依次进该组。
 * @returns NavItem[] 每项含 label（文案）/ to（路由路径，需补 / 前缀）/ icon（SVG path）/ group（分组名）
 */
const navItems = computed(() =>
  menus.flatMap((m) => {
    if (m.children) {
      // 按权限过滤子项；无可见子项的组不渲染（DsAppShell 按 group 分组，无项即无标题）
      const kids = m.children
        .filter(menuVisible)
        .map((c) => ({
          label: c.title,
          to: '/' + c.path,
          icon: getIcon(ICON_MAP[c.icon] || 'Box'),
          group: m.title,
          // 消息中心挂未读徽标：条数由 message store 每 60 秒轮询刷新，
          // 点进消息中心标记已读后徽标同步消失（不需要刷新页面）
          badge: c.path === 'system/message' && msgStore.unread ? msgStore.unread : undefined,
        }));
      return kids;
    }
    if (!menuVisible(m)) return [];
    return [{ label: m.title, to: '/' + m.path, icon: getIcon(ICON_MAP[m.icon] || 'Box') }];
  }),
);

/** 顶栏用户下拉菜单项配置（DsDropdown.Item） */
const userItems = [{ command: 'logout', label: '退出登录', icon: 'ExternalLink' }];

/**
 * 用户下拉命令处理：目前仅退出登录——清空登录态并跳回登录页。
 * @param cmd 菜单项 command 值
 * @returns 无
 */
function onCommand(cmd) {
  if (cmd === 'logout') {
    auth.logout();
    router.replace('/login');
  }
}
</script>
