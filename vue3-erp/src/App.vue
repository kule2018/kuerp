<template>
  <router-view />
  <!-- 全局轻提示容器（ds 设计系统） -->
  <DsToast />
  <!-- 全局确认 / 输入弹窗宿主（取代 ElMessageBox） -->
  <ConfirmHost />
</template>

<script setup lang="ts">
import DsToast from '@/components/ds/DsToast.vue';
import ConfirmHost from '@/components/ConfirmHost.vue';
</script>
