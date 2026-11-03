<template>
  <div class="login-wrap">
    <DsCard class="login-card">
      <h2>进销存管理系统</h2>
    <!-- 表单：用原生 form + DsField 排版（原 el-form / el-form-item） -->
    <form @submit.prevent="onLogin">
      <DsField>
        <DsInput v-model="form.username" placeholder="用户名" />
      </DsField>
      <DsField>
        <DsInput v-model="form.password" type="password" placeholder="密码" @keyup.enter="onLogin" />
      </DsField>
      <DsButton variant="primary" :loading="loading" class="btn" @click="onLogin">登 录</DsButton>
    </form>
      <p class="tip">默认账号 admin / 123456</p>
    </DsCard>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../store/auth';
import { message } from '@/utils/ui';
import request from '@/utils/request';

const router = useRouter();
const auth = useAuthStore();
const form = ref({ username: 'admin', password: '123456' });
const loading = ref(false);

async function onLogin() {
  loading.value = true;
  try {
    const data = await request.post('/auth/login', form.value);
    auth.setAuth(data.token, data.user);
    message.success('登录成功');
    router.replace('/');
  } catch (e) {
    /* 错误已在拦截器提示 */
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped>
.login-wrap { height: 100%; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #1e3c72, #2a5298); }
.login-card { width: 380px; }
.login-card :deep(.ds-card-c__body) { padding: 32px 28px 24px; }
/* 字段嵌在 form 里，form.css 的相邻间距规则（只对卡片直接子级生效）命中不了，
   这里用 grid gap 统一竖向节奏：标题 / 字段 / 按钮之间等距呼吸 */
.login-card form { display: grid; gap: 16px; }
.login-card h2 { text-align: center; margin: 8px 0 24px; font-size: 20px; letter-spacing: 1px; }
.btn { width: 100%; }
.tip { text-align: center; color: #999; font-size: 12px; margin-top: 16px; }
</style>
