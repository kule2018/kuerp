<template>
  <div class="stock-warning">
    <!-- 检索区：库存预警为实时库存快照，无日期维度（等价原库存预警.md 口径） -->
    <DsCard>
      <div class="ds-form ds-form--inline row">
        <DsField label="关键字">
          <DsInput v-model="search" placeholder="商品编号 / 名称 / 仓库 / 分类" clearable style="width: 280px" @keyup.enter="onSearch" />
        </DsField>
        <DsField label="预警类型">
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

    <!-- 顶部统计卡 -->
    <div class="stats">
      <DsStatCard label="预警商品总数" :value="String(filtered.length)" tone="warning" />
      <DsStatCard label="低于下限" :value="String(sum.low)" tone="danger" />
      <DsStatCard label="高于上限" :value="String(sum.high)" tone="warning" />
      <DsStatCard label="建议补货合计" :value="String(sum.needReplenish)" tone="brand" />
    </div>

    <DsCard :pad="false">
      <DsTable :columns="cols" :data="pageRows" :loading="loading" :striped="true">
        <template #stock="{ row }">
          <span :class="row.warning_type === '低于下限' ? 'low' : row.warning_type === '高于上限' ? 'high' : ''">{{ fmtNum(row.stock) }}</span>
        </template>
        <template #min_stock="{ row }">{{ fmtNum(row.min_stock) }}</template>
        <template #max_stock="{ row }">{{ row.max_stock > 0 ? fmtNum(row.max_stock) : '—' }}</template>
        <template #warning_type="{ row }">
          <DsTag :color="row.warning_type === '低于下限' ? 'danger' : row.warning_type === '高于上限' ? 'warning' : 'success'" size="sm">{{ row.warning_type }}</DsTag>
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
 * 库存预警表（专用 1:1 页，等价原系统库存预警.md 口径）。
 * 数据来自虚拟报表 goods-stock-warning（自定义 run：仅统计开启预警且越限的商品），
 * 后端 /kuerp/goods-stock-warning/index 已算好 warning_type（低于下限 / 高于上限）。
 * 本页在通用报表基础上增加：预警类型标签与着色、建议补货量、顶部预警统计卡。
 */
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { message } from '@/utils/ui';
import request from '@/utils/request';

const api = '/kuerp/goods-stock-warning';
const router = useRouter();
const search = ref('');
const typeFilter = ref('');
const page = ref(1);
const pageSize = ref(10);
/** 全量行（预警为实时快照，原系统整表返回；此处全量拉回后前端筛选+分页） */
const list = ref([]);
const loading = ref(false);
/** 单次拉取上限：预警行数为 商品×仓库 维度，1000 覆盖常见账套 */
const FETCH_LIMIT = 1000;

const typeOptions = [
  { value: '低于下限', label: '低于下限' },
  { value: '高于上限', label: '高于上限' },
];

const cols = [
  { key: 'goods_code', title: '商品编号', width: '140px' },
  { key: 'goods_name', title: '商品名称', width: '200px' },
  { key: 'warehouse_name', title: '仓库', width: '140px' },
  { key: 'category_name', title: '商品分类', width: '140px' },
  { key: 'stock', title: '当前库存', width: '120px', align: 'right' },
  { key: 'min_stock', title: '最低库存', width: '120px', align: 'right' },
  { key: 'max_stock', title: '最高库存', width: '120px', align: 'right' },
  { key: 'warning_type', title: '预警类型', width: '120px' },
  { key: 'need_replenish', title: '建议补货量', width: '120px', align: 'right' },
];

function fmtNum(v) { return (Number(v) || 0).toLocaleString('zh-CN', { maximumFractionDigits: 2 }); }

/** 按预警类型筛选后的全量行 */
const filtered = computed(() =>
  typeFilter.value ? list.value.filter((r) => r.warning_type === typeFilter.value) : list.value,
);

/** 行派生：建议补货量（仅低于下限有意义 = 下限 - 当前库存） */
const derivedRows = computed(() =>
  filtered.value.map((r) => ({
    ...r,
    need_replenish: r.warning_type === '低于下限' ? Math.max(0, (Number(r.min_stock) || 0) - (Number(r.stock) || 0)) : 0,
  })),
);

/** 当前页数据（前端分页） */
const pageRows = computed(() => {
  const start = (page.value - 1) * pageSize.value;
  return derivedRows.value.slice(start, start + pageSize.value);
});

/** 预警统计（按筛选后的全量计算，翻页不变） */
const sum = computed(() => {
  let low = 0;
  let high = 0;
  let needReplenish = 0;
  for (const r of filtered.value) {
    if (r.warning_type === '低于下限') {
      low++;
      needReplenish += Math.max(0, (Number(r.min_stock) || 0) - (Number(r.stock) || 0));
    } else if (r.warning_type === '高于上限') high++;
  }
  return { low, high, needReplenish };
});

/** 拉取库存预警（当前库存实时快照，无日期维度） */
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
 * 库存预警无日期维度，仅透传关键字；打印用于线下盘点/补货单。
 * @returns {void}
 */
function doPrintReport() {
  const query = { report: 'goods-stock-warning', title: '库存预警表' };
  if (search.value) query.search = search.value;
  router.push({ name: 'PrintReport', query });
}
function exportCsv() {
  if (!derivedRows.value.length) { message.warning('暂无数据可导出'); return; }
  const head = cols.map((c) => c.title).join(',');
  const rows = derivedRows.value.map((r) => cols.map((c) => `"${String(r[c.key] ?? '').replace(/"/g, '""')}"`).join(','));
  const csv = '﻿' + [head, ...rows].join('\r\n');
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url; a.download = '库存预警.csv'; a.click();
  URL.revokeObjectURL(url);
  message.success('已导出 CSV');
}

onMounted(load);
</script>

<style scoped>
.stock-warning { display: flex; flex-direction: column; gap: 12px; }
.row { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 12px; }
.row > * { min-width: 150px; }
.row-btns { display: flex; gap: 8px; min-width: auto; margin-left: auto; }
.stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 12px; }
.pager { margin-top: 12px; }
.low { color: #e34d59; font-weight: 600; }
.high { color: #e3a008; font-weight: 600; }
</style>
