<template>
  <div class="profit-report">
    <!-- 检索区：日期范围 + 关键字（利润表支持按单据日期筛选） -->
    <DsCard>
      <div class="ds-form ds-form--inline row">
        <DsField label="开始日期">
          <DsDatePicker v-model="startDate" placeholder="开始日期" @change="onSearch" />
        </DsField>
        <DsField label="结束日期">
          <DsDatePicker v-model="endDate" placeholder="结束日期" @change="onSearch" />
        </DsField>
        <DsField label="关键字">
          <DsInput v-model="search" placeholder="业务类别" clearable style="width: 200px" @keyup.enter="onSearch" />
        </DsField>
        <div class="row-btns">
          <DsButton variant="primary" @click="onSearch">查询</DsButton>
          <DsButton @click="resetFilter">重置</DsButton>
          <DsButton variant="primary" @click="exportCsv">导出 CSV</DsButton>
          <DsButton variant="default" @click="doPrintReport">打印</DsButton>
        </div>
      </div>
    </DsCard>

    <!-- 顶部统计卡：期间总览（原 Profit.php 期间利润口径） -->
    <div class="stats">
      <DsStatCard label="总销售收入" :value="money(sum.all_money)" tone="brand" />
      <DsStatCard label="总毛利" :value="money(sum.profit)" :tone="sum.profit >= 0 ? 'success' : 'danger'" />
      <DsStatCard label="总净利" :value="money(sum.net_profit)" :tone="sum.net_profit >= 0 ? 'success' : 'danger'" />
      <DsStatCard label="总优惠额" :value="money(sum.preferential_money)" />
      <DsStatCard label="总销售费用" :value="money(sum.purchase_money)" />
    </div>

    <!-- 利润明细表 -->
    <DsCard :pad="false">
      <DsTable :columns="cols" :data="pageRows" :loading="loading" :striped="true">
        <template #all_money="{ row }">{{ money(row.all_money) }}</template>
        <template #sales_cost="{ row }">{{ money(row.sales_cost) }}</template>
        <template #profit="{ row }">
          <span :class="row.profit >= 0 ? 'up' : 'down'">{{ money(row.profit) }}</span>
        </template>
        <template #profit_rate="{ row }">
          <span :class="row.profit_rate >= 0 ? 'up' : 'down'">{{ row.profit_rate }}%</span>
        </template>
        <template #preferential_money="{ row }">{{ money(row.preferential_money) }}</template>
        <template #purchase_money="{ row }">{{ money(row.purchase_money) }}</template>
        <template #other_income="{ row }">{{ money(row.other_income) }}</template>
        <template #other_expend="{ row }">{{ money(row.other_expend) }}</template>
        <template #net_profit="{ row }">
          <span :class="row.net_profit >= 0 ? 'up' : 'down'">{{ money(row.net_profit) }}</span>
        </template>
        <template #net_profit_rate="{ row }">
          <span :class="row.net_profit_rate >= 0 ? 'up' : 'down'">{{ row.net_profit_rate }}%</span>
        </template>
        <template #number="{ row }">{{ fmtNum(row.number) }}</template>
        <template #summary>
          <td>合计</td>
          <td>{{ fmtNum(sum.number) }}</td>
          <td>{{ money(sum.all_money) }}</td>
          <td>{{ money(sum.sales_cost) }}</td>
          <td>{{ money(sum.profit) }}</td>
          <td>—</td>
          <td>{{ money(sum.preferential_money) }}</td>
          <td>{{ money(sum.purchase_money) }}</td>
          <td>{{ money(sum.other_income) }}</td>
          <td>{{ money(sum.other_expend) }}</td>
          <td>{{ money(sum.net_profit) }}</td>
          <td>—</td>
        </template>
      </DsTable>
      <div class="pager">
        <DsPagination
          :current-page="page" :page-size="pageSize" :total="total"
          :page-sizes="[10, 20, 50, 100]" layout="total, sizes, prev, pager, next"
          @update:currentPage="onPage" @update:pageSize="onSize"
        />
      </div>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 利润表（专用 1:1 页，等价原系统 Profit.php 期间利润口径）。
 * 数据来自虚拟报表 kuerp_goods_sales_profit 的三段聚合（普通销售/销售退货、其他收入、其他支出），
 * 后端 /kuerp/profit/index 已算好 毛利 / 毛利率 / 净利 / 净利率 等派生列。
 * 本页在通用报表基础上增加：顶部期间总览统计卡、金额/比率着色、合计行。
 */
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { message } from '@/utils/ui';
import request from '@/utils/request';

const api = '/kuerp/profit';
const router = useRouter();
const startDate = ref('');
const endDate = ref('');
const search = ref('');
const page = ref(1);
const pageSize = ref(10);
/** 当前查询命中的全部行（原系统利润表为整表返回，不分页；此处全量拉回再前端分页） */
const list = ref([]);
const total = ref(0);
const loading = ref(false);
/** 单次拉取上限：报表行数少（按业务类别分组通常仅 3 行），1000 足够覆盖 */
const FETCH_LIMIT = 1000;

const cols = [
  { key: 'biz_name', title: '业务类别', width: '140px' },
  { key: 'number', title: '数量', width: '110px', align: 'right' },
  { key: 'all_money', title: '销售收入', width: '140px', align: 'right' },
  { key: 'sales_cost', title: '销售成本', width: '140px', align: 'right' },
  { key: 'profit', title: '毛利', width: '140px', align: 'right' },
  { key: 'profit_rate', title: '毛利率(%)', width: '110px', align: 'right' },
  { key: 'preferential_money', title: '优惠额', width: '120px', align: 'right' },
  { key: 'purchase_money', title: '销售费用', width: '120px', align: 'right' },
  { key: 'other_income', title: '其他收入', width: '120px', align: 'right' },
  { key: 'other_expend', title: '其他支出', width: '120px', align: 'right' },
  { key: 'net_profit', title: '净利', width: '140px', align: 'right' },
  { key: 'net_profit_rate', title: '净利率(%)', width: '110px', align: 'right' },
];

/** 金额格式化（¥ 两位小数） */
function money(v) {
  return '¥' + (Number(v) || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
/** 数值千分位 */
function fmtNum(v) {
  return (Number(v) || 0).toLocaleString('zh-CN', { maximumFractionDigits: 2 });
}
/** 日期串 → 秒级时间戳（结束日含当天 23:59:59） */
function toSec(s, end = false) {
  if (!s) return null;
  const ms = new Date(`${s} 00:00:00`).getTime();
  return Number.isNaN(ms) ? null : Math.floor(ms / 1000) + (end ? 86399 : 0);
}

/** 期间合计（跨全部命中行汇总，保证翻页后合计不变） */
const sum = computed(() => {
  const t = { number: 0, all_money: 0, sales_cost: 0, profit: 0, preferential_money: 0, purchase_money: 0, other_income: 0, other_expend: 0, net_profit: 0 };
  for (const r of list.value) {
    t.number += Number(r.number) || 0;
    t.all_money += Number(r.all_money) || 0;
    t.sales_cost += Number(r.sales_cost) || 0;
    t.profit += Number(r.profit) || 0;
    t.preferential_money += Number(r.preferential_money) || 0;
    t.purchase_money += Number(r.purchase_money) || 0;
    t.other_income += Number(r.other_income) || 0;
    t.other_expend += Number(r.other_expend) || 0;
    t.net_profit += Number(r.net_profit) || 0;
  }
  return t;
});

/** 当前页数据（前端分页，合计行仍按全量计算） */
const pageRows = computed(() => {
  const start = (page.value - 1) * pageSize.value;
  return list.value.slice(start, start + pageSize.value);
});

/** 拉取利润表数据（带日期范围与关键字） */
async function load() {
  loading.value = true;
  try {
    const params = { page: 1, limit: FETCH_LIMIT, search: search.value };
    const s = toSec(startDate.value);
    const e = toSec(endDate.value, true);
    if (s) params.starttime = s;
    if (e) params.endtime = e;
    const r = await request.get(`${api}/index`, { params });
    list.value = r?.list || [];
    total.value = list.value.length;
    // 命中数超过单次拉取上限时提示收窄条件，避免「看到的数据不全」而不自知
    if (Number(r?.count || 0) > list.value.length) {
      message.warning(`数据量较大，仅加载前 ${list.value.length} 条，请用日期或关键字缩小范围`);
    }
  } finally {
    loading.value = false;
  }
}

function onSearch() { page.value = 1; load(); }
// 前端分页：翻页/改每页条数只切页，不再回后端取数（全量已在 list 中）
function onPage(p) { page.value = p; }
function onSize(s) { pageSize.value = s; page.value = 1; }

/**
 * 打开报表打印页（A4 横向，带期间与合计）。
 * 透传当前日期区间与关键字，保证打印结果与屏幕一致。
 * @returns {void}
 */
function doPrintReport() {
  const query = { report: 'profit', title: '利润表' };
  const s = toSec(startDate.value);
  const e = toSec(endDate.value, true);
  if (s) query.starttime = s;
  if (e) query.endtime = e;
  if (search.value) query.search = search.value;
  router.push({ name: 'PrintReport', query });
}
function resetFilter() {
  startDate.value = ''; endDate.value = ''; search.value = '';
  page.value = 1; load();
}
function exportCsv() {
  if (!list.value.length) { message.warning('暂无数据可导出'); return; }
  const head = cols.map((c) => c.title).join(',');
  const rows = list.value.map((r) => cols.map((c) => `"${String(r[c.key] ?? '').replace(/"/g, '""')}"`).join(','));
  const csv = '﻿' + [head, ...rows].join('\r\n');
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url; a.download = '利润表.csv'; a.click();
  URL.revokeObjectURL(url);
  message.success('已导出 CSV');
}

onMounted(load);
</script>

<style scoped>
.profit-report { display: flex; flex-direction: column; gap: 12px; }
.row { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 12px; }
.row > * { min-width: 150px; }
.row-btns { display: flex; gap: 8px; min-width: auto; margin-left: auto; }
.stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 12px; }
.pager { margin-top: 12px; }
.up { color: #2ba471; font-weight: 600; }
.down { color: #e34d59; font-weight: 600; }
</style>
