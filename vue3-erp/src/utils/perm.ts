/**
 * 按钮级权限（前端）。
 *
 * 【为什么需要它】
 * 菜单级 RBAC 只解决「能不能看到这个页面」，进了页面之后所有按钮都亮着，
 * 非超管点「删除」才被后端 403 拦下——体验差且容易误操作。
 * 这里把后端 /auth/perms 的结果缓存下来，供页面在渲染时直接判断。
 *
 * 【口径必须与后端一致】
 * 后端 RbacGuard 的判定顺序是：'*' → `kuerp/<表>` → `kuerp/<表>:*` → `kuerp/<表>:<动作>`，
 * 因此前端 hasPerm 也按同样顺序判断，不做任何「前端更宽松」的假设，
 * 否则会出现「按钮亮着但点了 403」。
 *
 * 【缓存策略】
 * 进程内单例（模块级 reactive），登录后加载一次；
 * 切换账号或角色变更后调用 loadPerms(true) 强制刷新。
 */
import { reactive } from 'vue';
import request from './request';

/** 表级权限：'*' 表示该表全部动作，数组表示仅这些动作 */
export type TablePerm = '*' | string[];

/** 权限状态 */
export interface PermState {
  /** 是否已加载（未加载时不隐藏任何按钮，避免首屏闪烁） */
  loaded: boolean;
  /** 是否超级管理员 */
  isSuper: boolean;
  /** 表 → 动作集合 */
  tables: Record<string, TablePerm>;
  /** 原始节点，便于调试 */
  nodes: string[];
  /** 非 kuerp 前缀的菜单级节点 */
  menus: string[];
}

/** 模块级单例状态 */
const state = reactive<PermState>({
  loaded: false,
  isSuper: false,
  tables: {},
  nodes: [],
  menus: [],
});

/**
 * 把路由里的 api 前缀归一化成物理表名。
 *
 * 例：'/kuerp/goods-purchase' → 'goods_purchase'；'/kuerp/goods' → 'goods'。
 *
 * @param api 路由 meta.api 或表名本身
 * @returns 归一化后的表名（不含 kuerp_ 前缀）
 */
export function normalizeTable(api: string): string {
  return String(api || '')
    .replace(/^\/?kuerp\//, '')
    .replace(/^kuerp_/, '')
    .replace(/-/g, '_')
    .replace(/\/.*$/, '');
}

/**
 * 加载当前用户权限集合。
 *
 * @param force 为 true 时强制重新请求（角色变更后使用）
 * @returns 是否加载成功
 */
export async function loadPerms(force = false): Promise<boolean> {
  if (state.loaded && !force) return true;
  try {
    const r = await request.get('/auth/perms');
    state.isSuper = !!r?.isSuper;
    state.tables = r?.tables || {};
    state.nodes = Array.isArray(r?.nodes) ? r.nodes : [];
    state.menus = Array.isArray(r?.menus) ? r.menus : [];
    state.loaded = true;
    return true;
  } catch {
    // 接口异常（如旧后端无该路由）时放行，避免整个系统按钮全灰
    state.loaded = false;
    return false;
  }
}

/**
 * 判断当前用户能否对某表执行某动作。
 *
 * @param table 表名（可传路由 api 前缀，内部会归一化）
 * @param action 动作名：index/get/add/edit/del/examine/import/export…
 * @returns 是否有权限（未加载完成时返回 true，避免按钮闪烁）
 */
export function hasPerm(table: string, action: string): boolean {
  if (!state.loaded) return true;
  if (state.isSuper) return true;
  if (state.nodes.includes('*')) return true;
  const key = normalizeTable(table);
  const p = state.tables[key];
  if (!p) return false;
  if (p === '*') return true;
  return (p as string[]).includes(action);
}

/**
 * 组合式入口：页面里 const { state, hasPerm } = usePerm()。
 * @returns 权限状态与判定函数
 */
export function usePerm() {
  return { state, hasPerm, loadPerms };
}
