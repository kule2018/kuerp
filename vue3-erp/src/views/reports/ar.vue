<template>
  <div class="ar-report">
    <!-- 检索区：往来单位欠款为实时余额快照，无日期维度（等价原 Intercourse.php） -->
    <DsCard>
      <div class="ds-form ds-form--inline row">
        <DsField label="关键字">
          <DsInput v-model="search" placeholder="单位编号 / 名称" clearable style="width: 240px" @keyup.enter="onSearch" />
        </DsField>
        <DsField label="单位类型">
          <DsSelect v-model="typeFilter" :options="typeOptions" clearable placeholder="全部" style="width: 160px" @change="onSearch" />
        </DsField>
        <div class="row-btns">
          <DsButton variant="primary" @click="onSearch">查询</DsButton>
          <DsButton @click="resetFilter">重置</DsButton>
          <DsButton variant="primary" @click="exportCsv">导出 CSV</DsButton>
          <DsButton variant="default" @click="doPrintReport">打印</DsButton>
        </div>
      </div>
    </DsCard>

    <!-- 顶部统计卡：应收 / 应付总览 -->
    <div class="stats">
      <DsStatCard label="客户应收欠款" :value="money(sum.customer)" tone="danger" />
      <DsStatCard label="供应商应付欠款" :value="money(sum.supplier)" tone="warning" />
      <DsStatCard label="往来欠款合计" :value="money(sum.customer + sum.supplier)" tone="brand" />
    </div>

    <DsCard :pad="false">
      <DsTable :columns="cols" :data="pageRows" :loading="loading" :striped="true">
        <template #unit_type="{ row }">
          <DsTag :color="row.unit_type === '客户' ? 'brand' : 'success'" size="sm">{{ row.unit_type }}</DsTag>
        </template>
        <template #amount="{ row }">{{ money(row.amount) }}</template>
        <template #balance="{ row }">
          <span :class="Number(row.balance) > 0 ? 'owe' : 'zero'">{{ money(row.balance) }}</span>
        </template>
      </DsTable>
      <div class="pager">
        <DsPagination
          :current-page="page" :page-size="pageSize" :total="filtered.length"
          :page-sizes="[10, 20, 50, 100]" layout="total, sizes, prev, pager, next"
          @update:currentPage="onPage" @update:pageSize="onSize"
        />
      </div>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 往来单位欠款表（专用 1:1 页，等价原系统 Intercourse.php）。
 * 数据来自虚拟报表：客户应收(need_receive_account) + 供应商应付(need_give_account) 合并快照，
 * 后端 /kuerp/intercourse/index 已算好 amount / balance（实时余额，无日期维度）。
 * 本页在通用报表基础上增加：应收/应付分类标签、欠款着色、顶部应收应付统计卡。
 */
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { message } from '@/utils/ui';
import request from '@/utils/request';

const api = '/kuerp/intercourse';
const router = useRouter();
const search = ref('');
const typeFilter = ref('');
const page = ref(1);
const pageSize = ref(10);
/** 全量行（原系统该报表整表返回、不分页；此处全量拉回后前端筛选+分页） */
const list = ref([]);
const loading = ref(false);
/** 单次拉取上限：往来单位为主数据，1000 覆盖绝大多数账套 */
const FETCH_LIMIT = 1000;

const typeOptions = [
  { value: '客户', label: '客户' },
  { value: '供应商', label: '供应商' },
];

const cols = [
  { key: 'code', title: '单位编号', width: '140px' },
  { key: 'name', title: '单位名称', width: '220px' },
  { key: 'unit_type', title: '单位类型', width: '120px' },
  { key: 'amount', title: '应收/应付金额', width: '160px', align: 'right' },
  { key: 'balance', title: '欠款余额', width: '160px', align: 'right' },
];

function money(v) {
  return '¥' + (Number(v) || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

/** 按单位类型筛选（后端已合并客户+供应商，前端筛更快且不影响统计口径） */
const filtered = computed(() =>
  typeFilter.value ? list.value.filter((r) => r.unit_type === typeFilter.value) : list.value,
);

/** 当前页数据（前端分页） */
const pageRows = computed(() => {
  const start = (page.value - 1) * pageSize.value;
  return filtered.value.slice(start, start + pageSize.value);
});

/** 应收（客户）/ 应付（供应商）合计（按筛选后的全量计算，翻页不变） */
const sum = computed(() => {
  let customer = 0;
  let supplier = 0;
  for (const r of filtered.value) {
    if (r.unit_type === '客户') customer += Number(r.balance) || 0;
    else supplier += Number(r.balance) || 0;
  }
  return { customer, supplier };
});

/** 拉取往来单位欠款（实时余额快照，无日期维度） */
async function load() {
  loading.value = true;
  try {
    const r = await request.get(`${api}/index`, {
      params: { page: 1, limit: FETCH_LIMIT, search: search.value },
    });
    list.value = r?.list || [];
    if (Number(r?.count || 0) > list.value.length) {
      message.warning(`数据量较大，仅加载前 ${list.value.length} 条，请用关键字缩小范围`);
    }
  } finally {
    loading.value = false;
  }
}

function onSearch() { page.value = 1; load(); }
function onPage(p) { page.value = p; }
function onSize(s) { pageSize.value = s; page.value = 1; }
function resetFilter() { search.value = ''; typeFilter.value = ''; page.value = 1; load(); }

/**
 * 打开报表打印页（A4 横向）。
 * 欠款表无日期维度，仅透传关键字；类型筛选为前端展示用，打印输出全部往来单位。
 * @returns {void}
 */
function doPrintReport() {
  const query = { report: 'intercourse', title: '往来单位欠款表' };
  if (search.value) query.search = search.value;
  router.push({ name: 'PrintReport', query });
}
function exportCsv() {
  if (!filtered.value.length) { message.warning('暂无数据可导出'); return; }
  const head = cols.map((c) => c.title).join(',');
  const rows = filtered.value.map((r) => cols.map((c) => `"${String(r[c.key] ?? '').replace(/"/g, '""')}"`).join(','));
  const csv = '﻿' + [head, ...rows].join('\r\n');
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url; a.download = '往来单位欠款表.csv'; a.click();
  URL.revokeObjectURL(url);
  message.success('已导出 CSV');
}

onMounted(load);
</script>

<style scoped>
.ar-report { display: flex; flex-direction: column; gap: 12px; }
.row { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 12px; }
.row > * { min-width: 150px; }
.row-btns { display: flex; gap: 8px; min-width: auto; margin-left: auto; }
.stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 12px; }
.pager { margin-top: 12px; }
.owe { color: #e34d59; font-weight: 600; }
.zero { color: var(--ds-text-3); }
</style>
