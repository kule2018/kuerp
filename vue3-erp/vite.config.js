import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import { fileURLToPath, URL } from 'node:url';

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    port: 5173,
    host: true,
    // 后端地址（前后端分离，开发期代理到 NestJS）
    proxy: {
      // 注意：必须以斜杠结尾，否则会误伤前端路由：
      // '/auth' 会匹配 /auth-group、/auth-admin 等菜单路由并把它们代理到后端导致 404；
      // 后端接口统一是 /auth/、/system/、/ai/、/kuerp/（带斜杠），加斜杠后互不冲突。
      '/kuerp/': { target: 'http://localhost:3000', changeOrigin: true },
      '/ai/': { target: 'http://localhost:3000', changeOrigin: true },
      '/auth/': { target: 'http://localhost:3000', changeOrigin: true },
      '/system/': { target: 'http://localhost:3000', changeOrigin: true },
    },
  },
});
