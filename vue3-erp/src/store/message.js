import { defineStore } from 'pinia';
import request from '../utils/request';

/**
 * 消息中心状态（未读计数 + 轮询）。
 *
 * 为什么单独建 store 而不是各页面自取自用：
 * 侧边栏徽标、消息中心页、审批待办三处都要读未读数，且都要求「读了就变」，
 * 用一个全局单例 + 定时轮询最省事，避免各自维护副本导致数字不一致。
 */
export const useMessageStore = defineStore('message', {
  state: () => ({
    /** 未读条数 */
    unread: 0,
    /** 轮询定时器（非响应式，挂 state 便于统一清理） */
    timer: null,
  }),
  actions: {
    /**
     * 刷新未读条数。
     * @returns {Promise<number>} 最新未读数（失败时保持原值）
     */
    async refresh() {
      try {
        const r = await request.get('/system/message/unread-count');
        this.unread = Number(r?.count || 0);
      } catch {
        // 未登录 / 后端未就绪时静默，不打断界面
      }
      return this.unread;
    },

    /**
     * 启动 60 秒轮询（重复调用不会叠加定时器）。
     * @returns 无
     */
    startPolling() {
      if (this.timer) return;
      this.refresh();
      this.timer = setInterval(() => this.refresh(), 60000);
    },

    /**
     * 停止轮询（登出时调用）。
     * @returns 无
     */
    stopPolling() {
      if (this.timer) clearInterval(this.timer);
      this.timer = null;
      this.unread = 0;
    },
  },
});
