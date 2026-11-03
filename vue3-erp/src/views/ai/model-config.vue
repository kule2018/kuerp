<template>
  <DsCard>
    <!-- 工具栏（原 el-form inline 只包一个按钮，简化为普通行） -->
    <div class="bar">
      <DsButton variant="primary" @click="openAdd">新增模型配置</DsButton>
    </div>

    <DsTable :columns="columns" :data="list" :loading="loading" :striped="true">
      <!-- 启用状态 -->
      <template #status="{ row }">
        <DsTag :color="row.status === '1' ? 'success' : 'neutral'">{{ row.status === '1' ? '启用' : '停用' }}</DsTag>
      </template>
      <!-- 操作列 -->
      <template #_action="{ row }">
        <div class="ops">
          <DsButton variant="text" @click="openEdit(row)">编辑</DsButton>
          <DsButton variant="text" @click="onDel(row.id)">删除</DsButton>
        </div>
      </template>
    </DsTable>

    <DsModal :title="editing ? '编辑模型配置' : '新增模型配置'" v-model="dialog" :width="600">
      <!-- 表单：原 el-form（label-width 110px）改为 DsField -->
      <DsField label="名称"><DsInput v-model="form.name" /></DsField>
      <DsField label="提供商"><DsInput v-model="form.provider" placeholder="openai/deepseek/..." /></DsField>
      <DsField label="模型"><DsInput v-model="form.model" placeholder="如 deepseek-chat / gpt-4o-mini" /></DsField>
      <DsField label="BaseURL"><DsInput v-model="form.base_url" placeholder="https://api.deepseek.com/v1" /></DsField>
      <DsField label="API Key"><DsInput v-model="form.api_key" type="password" /></DsField>
      <DsField label="温度"><DsInput type="number" v-model="form.temperature" /></DsField>
      <DsField label="最大Tokens"><DsInput type="number" v-model="form.max_tokens" /></DsField>
      <!-- 开关：原 el-switch 的 active-value='1' / inactive-value='0'，ds 只认布尔故在此转换 -->
      <DsField label="启用">
        <DsSwitch :model-value="String(form.status) === '1'" @change="(v) => (form.status = v ? '1' : '0')" />
      </DsField>
      <template #footer>
        <DsButton @click="dialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="submit">保存</DsButton>
      </template>
    </DsModal>
  </DsCard>
</template>

<script setup>
/**
 * AI 模型配置管理（数据库化）：对应后端 /ai/model-config。
 * 支持多家 OpenAI 兼容提供商（DeepSeek 等），配置持久化到 kuerp_ai_model_config 表。
 */
import { ref, onMounted } from 'vue';
import { message, confirm } from '@/utils/ui';
import request from '../../utils/request';

const list = ref([]);
const loading = ref(false);
const dialog = ref(false);
const editing = ref(false);
const saving = ref(false);
const form = ref({});

/** DsTable 列配置 */
const columns = [
  { key: 'id', title: 'ID', width: '70' },
  { key: 'name', title: '名称', width: '140' },
  { key: 'provider', title: '提供商', width: '120' },
  { key: 'model', title: '模型', width: '160' },
  { key: 'base_url', title: 'BaseURL', width: '200' },
  { key: 'status', title: '启用', width: '80' },
  { key: '_action', title: '操作', width: '150' },
];

async function load() {
  loading.value = true;
  try {
    list.value = (await request.get('/ai/model-config')) || [];
  } finally {
    loading.value = false;
  }
}

function openAdd() {
  editing.value = false;
  form.value = { status: '1', temperature: 0.7, max_tokens: 2048, provider: 'openai' };
  dialog.value = true;
}
function openEdit(row) {
  editing.value = true;
  form.value = { ...row };
  dialog.value = true;
}
async function submit() {
  saving.value = true;
  try {
    if (editing.value) {
      await request.post('/ai/model-config/edit', { id: form.value.id, ...form.value });
    } else {
      await request.post('/ai/model-config/add', form.value);
    }
    message.success('保存成功');
    dialog.value = false;
    load();
  } finally {
    saving.value = false;
  }
}
async function onDel(id) {
  await confirm('确认删除该模型配置？', '提示', { type: 'warning' });
  await request.delete('/ai/model-config/del', { data: { id } });
  message.success('已删除');
  load();
}

onMounted(load);
</script>

<style scoped>
/* 工具栏与操作列按钮组 */
.bar { margin-bottom: 12px; }
.ops { display: flex; gap: 4px; }
</style>
