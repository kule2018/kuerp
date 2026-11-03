<template>
  <DsCard>
    <!-- 工具栏（原 el-form inline） -->
    <div class="bar">
      <DsButton variant="primary" @click="openAdd">新增模板</DsButton>
    </div>

    <DsTable :columns="columns" :data="list" :loading="loading" :striped="true">
      <!-- 操作列 -->
      <template #_action="{ row }">
        <div class="ops">
          <DsButton variant="text" @click="openRender(row)">渲染测试</DsButton>
          <DsButton variant="text" @click="openEdit(row)">编辑</DsButton>
          <DsButton variant="text" @click="onDel(row.id)">删除</DsButton>
        </div>
      </template>
    </DsTable>

    <!-- 新增 / 编辑 -->
    <DsModal :title="editing ? '编辑模板' : '新增模板'" v-model="dialog" :width="640">
      <!-- 表单：原 el-form（label-width 90px）改为 DsField -->
      <DsField label="编码"><DsInput v-model="form.code" placeholder="唯一编码，如 goods_summary" /></DsField>
      <DsField label="名称"><DsInput v-model="form.name" /></DsField>
      <DsField label="模板内容">
        <DsInput v-model="form.content" type="textarea" :rows="8" placeholder="支持 {var} 占位符变量" />
      </DsField>
      <template #footer>
        <DsButton @click="dialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="submit">保存</DsButton>
      </template>
    </DsModal>

    <!-- 渲染测试 -->
    <DsModal title="渲染测试" v-model="renderDialog" :width="640">
      <!-- 渲染测试表单：原 el-form（label-position top），DsField 本身即标签在上 -->
      <DsField label="变量（JSON）">
        <DsInput v-model="renderVars" type="textarea" :rows="4" placeholder='{"goods_name":"苹果","stock":12}' />
      </DsField>
      <DsField label="渲染结果">
        <DsInput :model-value="renderResult" type="textarea" :rows="8" readonly />
      </DsField>
      <template #footer>
        <DsButton @click="doRender" variant="primary" :loading="rendering">渲染</DsButton>
      </template>
    </DsModal>
  </DsCard>
</template>

<script setup>
/**
 * Prompt 模板管理：对应后端 /ai/prompt-template。
 * 模板支持 {var} 占位符，渲染接口 /ai/prompt-template/render 用变量替换后返回。
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

const renderDialog = ref(false);
const rendering = ref(false);
const renderVars = ref('{}');
const renderResult = ref('');
const renderCode = ref('');

/** DsTable 列配置 */
const columns = [
  { key: 'id', title: 'ID', width: '70' },
  { key: 'code', title: '编码', width: '160' },
  { key: 'name', title: '名称', width: '140' },
  { key: 'content', title: '内容', width: '260' },
  { key: '_action', title: '操作', width: '220' },
];

async function load() {
  loading.value = true;
  try { list.value = (await request.get('/ai/prompt-template')) || []; }
  finally { loading.value = false; }
}
function openAdd() { editing.value = false; form.value = { content: '' }; dialog.value = true; }
function openEdit(row) { editing.value = true; form.value = { ...row }; dialog.value = true; }
async function submit() {
  saving.value = true;
  try {
    if (editing.value) await request.post('/ai/prompt-template/edit', { id: form.value.id, ...form.value });
    else await request.post('/ai/prompt-template/add', form.value);
    message.success('保存成功'); dialog.value = false; load();
  } finally { saving.value = false; }
}
async function onDel(id) {
  await confirm('确认删除该模板？', '提示', { type: 'warning' });
  await request.delete('/ai/prompt-template/del', { data: { id } });
  message.success('已删除'); load();
}
function openRender(row) {
  renderCode.value = row.code;
  renderVars.value = '{}';
  renderResult.value = '';
  renderDialog.value = true;
}
async function doRender() {
  let vars = {};
  try { vars = JSON.parse(renderVars.value || '{}'); }
  catch { message.error('变量不是合法 JSON'); return; }
  rendering.value = true;
  try {
    const r = await request.post('/ai/prompt-template/render', { code: renderCode.value, variables: vars });
    renderResult.value = typeof r === 'string' ? r : JSON.stringify(r, null, 2);
  } finally { rendering.value = false; }
}

onMounted(load);
</script>

<style scoped>
/* 工具栏与操作列按钮组 */
.bar { margin-bottom: 12px; }
.ops { display: flex; gap: 4px; }
</style>
