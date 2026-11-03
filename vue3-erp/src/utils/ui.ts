// src/utils/ui.ts
/**
 * 统一 UI 反馈层（ds 设计系统版）。
 *
 * 用 ds 设计系统的 Toast / Modal 取代 Element Plus 的
 * ElMessage / ElMessageBox，使全部轻提示、确认框、输入弹窗统一为 DeepSeek UI 风格。
 * 业务代码统一从本文件引入，后续若要换 UI 库只需改这里。
 *
 * 用法：
 *   import { message, confirm, prompt } from '@/utils/ui';
 *   message.success('保存成功');
 *   const ok = await confirm({ title: '提示', message: '确认删除？' });
 *   const val = await prompt({ title: '重置密码', message: '输入新密码', inputPlaceholder: '新密码' });
 */
import { useToast } from '@/components/ds/toast';

/** 提示类型 */
export type MsgType = 'success' | 'error' | 'warning' | 'info';

/** 单例 Toast，任意位置调用均推送到全局 DsToast 容器 */
const toast = useToast();

/**
 * 轻提示（取代 ElMessage）。
 * @param type 提示类型
 * @param text 文案
 */
export function showMessage(type: MsgType, text: string): void {
  toast[type](text);
}

/** 类 ElMessage 的快捷方法集合 */
export const message = {
  success: (t: string) => toast.success(t),
  error: (t: string) => toast.error(t),
  warning: (t: string) => toast.warning(t),
  info: (t: string) => toast.info(t),
};

/** 确认 / 输入弹窗选项 */
export interface ConfirmOptions {
  /** 标题 */
  title?: string;
  /** 正文（confirm）或输入框上方说明（prompt） */
  message: string;
  /** 主题色：warning 警告 / info 提示 / primary 普通 */
  type?: 'warning' | 'info' | 'primary';
  /** 确定按钮文案 */
  confirmText?: string;
  /** 取消按钮文案 */
  cancelText?: string;
  /** 为 true 时显示输入框（取代 ElMessageBox.prompt） */
  input?: boolean;
  /** 输入框占位 */
  inputPlaceholder?: string;
  /** 输入框默认值 */
  inputValue?: string;
}

/** confirm/prompt 的返回类型：confirm→boolean，prompt→string|null */
export type ConfirmResult = boolean | string | null;

/** 由 ConfirmHost 注入的真实实现（挂载一次） */
let confirmImpl: ((o: ConfirmOptions) => Promise<ConfirmResult>) | null = null;

/**
 * 注入确认弹窗实现（ConfirmHost 调用一次）。
 * @param fn 实际打开弹窗的函数
 */
export function setConfirmImpl(fn: (o: ConfirmOptions) => Promise<ConfirmResult>): void {
  confirmImpl = fn;
}

/**
 * 确认弹窗（取代 ElMessageBox.confirm）。
 * 语义与 ElMessageBox.confirm 完全一致：用户点「确定」resolve true，
 * 点「取消」/关闭遮罩则 reject（与原实现一样靠 try/catch 跳过后续写操作）。
 *
 * 入参兼容两种写法（历史原因，项目里两种都有在用）：
 *   1) 推荐：confirm({ title: '提示', message: '确认删除？', type: 'warning' })
 *   2) 旧写法：confirm('确认删除？', '提示', { type: 'warning' })
 *
 * 旧写法此前是被静默吞掉的（字符串被当成 options，导致正文空白只显示默认标题），
 * 这里统一归一化，避免逐个文件改 17 处调用点带来的回归风险。
 *
 * @param options 选项对象，或旧写法的正文文案
 * @param title 旧写法的标题
 * @param extra 旧写法的其余选项（type / confirmText 等）
 * @returns Promise<true> 仅在确定时 resolve；取消/关闭抛错
 */
export function confirm(
  options: ConfirmOptions | string,
  title?: string,
  extra?: Partial<ConfirmOptions>,
): Promise<true> {
  if (!confirmImpl) {
    console.warn('[ui] confirm 尚未初始化（ConfirmHost 未挂载）');
    return Promise.resolve(true);
  }
  const opts: ConfirmOptions =
    typeof options === 'string'
      ? { title: title || '提示', message: options, ...(extra || {}) }
      : options;
  return confirmImpl(opts).then((r) => {
    if (r === true) return true;
    throw new Error('user-cancelled');
  });
}

/**
 * 输入弹窗（取代 ElMessageBox.prompt）。
 * 语义与 ElMessageBox.prompt 一致：用户点「确定」resolve 输入字符串，
 * 取消/关闭则 reject。
 * @param options 标题 + 文案 + 输入配置
 * @returns Promise<string> 输入非空时 resolve 字符串；取消抛错
 */
export function prompt(options: ConfirmOptions): Promise<string> {
  if (!confirmImpl) {
    console.warn('[ui] prompt 尚未初始化（ConfirmHost 未挂载）');
    return Promise.resolve('');
  }
  return confirmImpl({ ...options, input: true }).then((r) => {
    if (typeof r === 'string') return r;
    throw new Error('user-cancelled');
  });
}
