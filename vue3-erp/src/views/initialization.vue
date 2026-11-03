<template>
  <DsCard>
    <template #title>
      <span>重新初始化</span>
    </template>

    <DsAlert type="error" :closable="false" show-icon title="高危操作：将清空全部业务单据与资料数据（商品/客户/供应商/购货/销货/库存/资金等），且不可恢复！" description="系统参数、单号设置、账户、AI 配置等基础数据会保留。执行前请确认已备份数据库。" />

    <div class="confirm-box">
      <p>确认执行请在下方输入 <span><b>INIT</b></span> ：</p>
      <DsInput v-model="text" style="width: 240px" placeholder="输入 INIT" />
      <DsButton class="ml" variant="danger" :disabled="text !== 'INIT'" :loading="running" @click="onInit">确认初始化</DsButton>
    </div>
  </DsCard>
</template>

<script setup>
/**
 * 重新初始化页：1:1 还原原系统「重新初始化」。
 * 清空全部业务表（保留系统参数/单号/账户/AI 配置），
 * 后端 POST /kuerp/initialize 要求 confirm=INIT 双确认，防止误操作。
 */
import { ref } from 'vue';
import { message, confirm } from '@/utils/ui';
import request from '../utils/request';

const text = ref('');
const running = ref(false);

/** 执行初始化（二次确认 + 文本校验 + 后端 confirm 参数三重保护） */
async function onInit() {
  await confirm('再次确认：初始化后业务数据不可恢复，是否继续？', '最终确认', {
    type: 'warning',
    confirmButtonText: '继续',
    cancelButtonText: '取消',
  });
  running.value = true;
  try {
    const r = await request.post('/kuerp/initialize', { confirm: 'INIT' });
    message.success(r?.msg || '初始化完成');
    text.value = '';
  } finally {
    running.value = false;
  }
}
</script>

<style scoped>
.confirm-box { margin-top: 16px; display: flex; align-items: center; gap: 8px; }
.ml { margin-left: 8px; }
</style>
