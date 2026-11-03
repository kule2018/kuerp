<template>
  <div>
    <DsCard>
      <!-- 顶部说明与汇总 -->
      <template #title>
        <div class="head">
          <span>数据管理（共 {{ stats.length }} 张业务表，总记录 {{ totalCount }} 条）</span>
          <DsButton size="sm" :loading="loading" @click="load">刷新</DsButton>
        </div>
      </template>

      <!-- 过滤区（原 el-form inline） -->
      <div class="ds-form ds-form--inline filter">
        <DsField label="表名">
          <DsInput v-model="kw" placeholder="输入表名过滤" clearable style="width: 220px" @input="onFilter" />
        </DsField>
        <DsField label="仅看有数据">
          <DsSwitch v-model="onlyWithData" @change="onFilter" />
        </DsField>
      </div>

      <!-- 全表数据量一览（1:1 还原原系统「数据管理」页） -->
      <DsTable :columns="columns" :data="filtered" :loading="loading" :striped="true">
        <!-- 序号列 -->
        <template #_index="{ index }">{{ index + 1 }}</template>
        <!-- 记录数：统计失败用红色标签标出 -->
        <template #count="{ row }">
          <DsTag v-if="row.count < 0" color="danger" size="sm">统计失败</DsTag>
          <span v-else>{{ row.count }}</span>
        </template>
        <!-- 操作列：跳转该表的通用表格页 -->
        <template #_action="{ row }">
          <DsButton variant="text" @click="openTable(row)">查看</DsButton>
        </template>
      </DsTable>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 数据管理页：1:1 还原原系统「数据管理」。
 * 汇总全部 kuerp_* 业务表的记录数，支持按表名过滤、跳转对应通用表格页。
 */
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import request from '../utils/request';

const router = useRouter();
const stats = ref([]);
const loading = ref(false);
const kw = ref('');
const onlyWithData = ref(false);

/** DsTable 列配置：序号 + 表名 + 业务名 + 记录数 + 操作 */
const columns = [
  { key: '_index', title: '#', width: '50' },
  { key: 'table', title: '表名', width: '180' },
  { key: 'name', title: '业务名', width: '140' },
  { key: 'count', title: '记录数', width: '110', align: 'right' },
  { key: '_action', title: '操作', width: '120' },
];

/** 总记录数 */
const totalCount = computed(() =>
  stats.value.reduce((s, r) => s + (r.count > 0 ? r.count : 0), 0),
);

/** 过滤后的表格数据 */
const filtered = computed(() =>
  stats.value.filter(
    (r) =>
      (!kw.value || r.table.includes(kw.value) || String(r.name).includes(kw.value)) &&
      (!onlyWithData.value || r.count > 0),
  ),
);

/** 拉取全表统计 */
async function load() {
  loading.value = true;
  try {
    const r = await request.get('/kuerp/tables/stats');
    stats.value = r || [];
  } finally {
    loading.value = false;
  }
}

function onFilter() { /* 计算属性自动响应 */ }

/** 跳转对应表的通用表格页（路由 path 用连字符形式） */
function openTable(row) {
  const path = row.table.replace('kuerp_', '').replace(/_/g, '-');
  router.push(`/${path}`);
}

onMounted(load);
</script>

<style scoped>
.head { display: flex; align-items: center; justify-content: space-between; }
/* 过滤区：表名输入 + 开关横向排列 */
.filter { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 16px; margin-bottom: 8px; }
</style>
