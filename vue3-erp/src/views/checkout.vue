<template>
  <div>
    <DsCard>
      <template #title>
        <span>结账 / 反结账</span>
      </template>

      <DsAlert type="warning" :closable="false" show-icon class="mb">
        <template #title>结账说明（见 开发文档/3.设置/3.结账&反结账.md）</template>
        结账后所选日期之前的单据不可修改、不可新增；结账前的未审核单据只能删除。反结账后可恢复修改。
        商品为负库存时不允许结账。
      </DsAlert>

      <!-- 当前结账状态（原 el-descriptions，改走 DsDescriptions 的 items + 字段插槽） -->
      <DsDescriptions :column="2" :items="descItems" :data="current" class="mb">
        <template #item-checkdate>
          <DsTag v-if="current.checkdate" color="danger">{{ current.checkdate }}（已结账）</DsTag>
          <DsTag v-else color="success">未结账</DsTag>
        </template>
        <template #item-status>{{ current.checkdate ? '账期已归档' : '正常记账中' }}</template>
      </DsDescriptions>

      <!-- 结账操作行：已结账时只显示「反结账」 -->
      <div v-if="!current.checkdate" class="ds-form ds-form--inline row">
        <DsField label="结账截止日期" class="grow">
          <DsDatePicker v-model="endDate" placeholder="选择结账日" />
        </DsField>
        <DsButton variant="primary" :disabled="!endDate" :loading="loading" @click="doSettle">结账</DsButton>
      </div>
      <DsButton v-else variant="default" :loading="loading" @click="doUnsettle">反结账</DsButton>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 结账 / 反结账页（对应 开发文档/3.设置/3.结账&反结账.md）。
 * 功能：
 *  - 读取当前结账日期（GET /kuerp/checkout/current）；
 *  - 结账：选定截止日归档账期（POST /kuerp/checkout/settle），
 *    此后所有业务单据（购货/销货/仓库/资金）若单据日期 <= 结账日将被后端拦截（见 TableService.guardCheckoutDate）；
 *  - 反结账：清除结账记录（POST /kuerp/checkout/unsettle）。
 */
import { ref, onMounted } from 'vue';
import { message, confirm } from '@/utils/ui';
import request from '../utils/request';

const current = ref({ checkdate: null, checktime: 0 });
const endDate = ref('');
const loading = ref(false);

/** DsDescriptions 展示项：结账日期与状态（值由同名插槽自定义渲染） */
const descItems = [
  { label: '当前结账日期', key: 'checkdate' },
  { label: '状态', key: 'status' },
];

/** 拉取当前结账状态 */
async function load() {
  try {
    const r = await request.get('/kuerp/checkout/current');
    current.value = r || { checkdate: null, checktime: 0 };
  } catch (e) {
    /* 忽略，默认未结账 */
  }
}

/** 结账 */
async function doSettle() {
  try {
    await confirm(
      `确认将账期结账至 ${endDate.value}？结账后该日期前的单据将不可修改/新增。`,
      '结账确认',
      { type: 'warning' },
    );
  } catch {
    return;
  }
  loading.value = true;
  try {
    await request.post('/kuerp/checkout/settle', { endDate: endDate.value });
    message.success('结账成功');
    await load();
  } catch (e) {
    message.error(e?.response?.data?.msg || '结账失败');
  } finally {
    loading.value = false;
  }
}

/** 反结账 */
async function doUnsettle() {
  try {
    await confirm('确认反结账？反结账后该账期前的单据可重新修改。', '反结账确认', {
      type: 'warning',
    });
  } catch {
    return;
  }
  loading.value = true;
  try {
    await request.post('/kuerp/checkout/unsettle');
    message.success('已反结账');
    await load();
  } catch (e) {
    message.error(e?.response?.data?.msg || '反结账失败');
  } finally {
    loading.value = false;
  }
}

onMounted(load);
</script>

<style scoped>
.mb { margin-bottom: 16px; }
/* 结账操作行：日期控件占满剩余宽度，按钮不换行 */
.row { display: flex; align-items: flex-end; gap: 12px; }
.grow { flex: 1; min-width: 240px; }
</style>
