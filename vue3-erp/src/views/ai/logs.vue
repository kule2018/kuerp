<template>
  <DsCard>
    <DsTabs v-model="tab" :items="tabs" variant="pill" class="mb" />

    <!-- 模型调用日志 -->
    <div v-if="tab === 'call'">
      <DsTable :columns="callCols" :data="callList" row-key="id" :loading="callLoading" striped>
        <template #status="{ row }">
          <DsTag :color="row.status === 1 ? 'success' : 'danger'" size="sm">
            {{ row.status === 1 ? '成功' : '失败' }}
          </DsTag>
        </template>
        <template #createtime="{ row }">{{ fmt(row.createtime) }}</template>
      </DsTable>
      <DsPagination class="mt" :total="callTotal" v-model:currentPage="callPage" v-model:pageSize="callSize" :page-sizes="[10, 20, 50, 100]" @change="loadCall" />
    </div>

    <!-- 工具调用日志 -->
    <div v-else>
      <DsTable :columns="toolCols" :data="toolList" row-key="id" :loading="toolLoading" striped>
        <template #status="{ row }">
          <DsTag :color="row.status === 1 ? 'success' : 'danger'" size="sm">
            {{ row.status === 1 ? '成功' : '失败' }}
          </DsTag>
        </template>
        <template #createtime="{ row }">{{ fmt(row.createtime) }}</template>
      </DsTable>
      <DsPagination class="mt" :total="toolTotal" v-model:currentPage="toolPage" v-model:pageSize="toolSize" :page-sizes="[10, 20, 50, 100]" @change="loadTool" />
    </div>
  </DsCard>
</template>

<script setup>
/**
 * AI 调用与工具调用日志查询：对应后端 /ai/call-logs 与 /ai/tool-logs。
 * 用于审计每一次模型调用与 Function Calling。
 */
import { ref, onMounted } from 'vue';
import request from '../../utils/request';

const tab = ref('call');

/** 选项卡定义（DsTabs 无内容插槽，面板改为外部按当前值条件渲染） */
const tabs = [
  { value: 'call', label: '模型调用日志' },
  { value: 'tool', label: '工具调用日志' },
];

/** 模型调用日志列定义 */
const callCols = [
  { key: 'id', title: 'ID', width: '70px' },
  { key: 'model', title: '模型', width: '150px' },
  { key: 'prompt', title: 'Prompt', width: '220px' },
  { key: 'completion', title: '返回', width: '220px' },
  { key: 'tokens_prompt', title: 'Prompt Tokens', width: '120px' },
  { key: 'tokens_completion', title: 'Completion Tokens', width: '140px' },
  { key: 'elapsed_ms', title: '耗时(ms)', width: '100px' },
  { key: 'status', title: '状态', width: '80px', slot: true },
  { key: 'createtime', title: '时间', width: '170px', slot: true },
];

/** 工具调用日志列定义 */
const toolCols = [
  { key: 'id', title: 'ID', width: '70px' },
  { key: 'call_log_id', title: '调用ID', width: '90px' },
  { key: 'tool_name', title: '工具', width: '160px' },
  { key: 'arguments', title: '参数', width: '200px' },
  { key: 'result', title: '结果', width: '220px' },
  { key: 'elapsed_ms', title: '耗时(ms)', width: '100px' },
  { key: 'status', title: '状态', width: '80px', slot: true },
  { key: 'createtime', title: '时间', width: '170px', slot: true },
];

const callList = ref([]); const callTotal = ref(0); const callLoading = ref(false); const callPage = ref(1); const callSize = ref(20);
const toolList = ref([]); const toolTotal = ref(0); const toolLoading = ref(false); const toolPage = ref(1); const toolSize = ref(20);

/** 秒级时间戳 -> 本地时间字符串 */
function fmt(ts) {
  if (!ts) return '';
  return new Date(Number(ts) * 1000).toLocaleString('zh-CN');
}

async function loadCall() {
  callLoading.value = true;
  try {
    const r = await request.get('/ai/call-logs', { params: { page: callPage.value, limit: callSize.value } });
    callList.value = r?.list || []; callTotal.value = r?.count || 0;
  } finally { callLoading.value = false; }
}
async function loadTool() {
  toolLoading.value = true;
  try {
    const r = await request.get('/ai/tool-logs', { params: { page: toolPage.value, limit: toolSize.value } });
    toolList.value = r?.list || []; toolTotal.value = r?.count || 0;
  } finally { toolLoading.value = false; }
}

onMounted(() => { loadCall(); loadTool(); });
</script>

<style scoped>
.mt { margin-top: 12px; }
.mb { margin-bottom: 12px; }
</style>
