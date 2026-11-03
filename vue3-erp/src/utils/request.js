import axios from 'axios';
import { message } from '@/utils/ui';
import router from '../router';
import { useAuthStore } from '@/store/auth';

const request = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || 'http://localhost:3000',
  timeout: 30000,
});

/**
 * 会话失效统一处理：必须走 store 的 logout()，
 * 只清 localStorage 的话 Pinia 里的 token 还在，
 * 路由守卫会认为仍已登录，把 /login 又弹回首页，形成死循环。
 */
function forceLogout(tip = '登录已过期，请重新登录') {
  useAuthStore().logout();
  message.error(tip);
  router.replace('/login');
}

// 请求拦截：注入 JWT
request.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) config.headers.Authorization = token;
  return config;
});

// 响应拦截：统一解包 { code, msg, data }
request.interceptors.response.use(
  (resp) => {
    const body = resp.data;
    if (body && typeof body.code !== 'undefined') {
      if (body.code === 1) return body.data;
      if (body.code === 0) {
        // 会话失效（未登录 / token 过期 / 账号被禁用）：清登录态并回登录页
        if (body.msg && /登录|Unauthorized|过期/.test(body.msg)) {
          forceLogout();
          return Promise.reject(new Error(body.msg));
        }
        message.error(body.msg || '操作失败');
        return Promise.reject(new Error(body.msg || 'error'));
      }
    }
    return body;
  },
  (error) => {
    const status = error.response?.status;
    if (status === 401) {
      forceLogout(error.response?.data?.msg || '登录已过期，请重新登录');
      return Promise.reject(error);
    }
    message.error(error.response?.data?.msg || error.message || '网络错误');
    return Promise.reject(error);
  },
);

export default request;
