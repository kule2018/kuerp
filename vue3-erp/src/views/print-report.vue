<template>
  <div class="rp-page">
    <!-- 工具栏（打印时隐藏） -->
    <div class="toolbar no-print">
      <DsButton @click="$router.back()">返回</DsButton>
      <DsSelect
        v-model="report"
        :options="presets"
        filterable
        placeholder="选择要打印的报表"
        style="width: 220px"
        @change="onReportChange"
      />
      <DsButton variant="primary" :loading="loading" @click="load">刷新数据</DsButton>
      <DsButton variant="primary" @click="doPrint">打印 / 导出 PDF</DsButton>
      <span class="hint">共 {{ rows.length }} 行{{ truncated ? '（已截断，请缩小日期/关键字范围）' : '' }}</span>
    </div>

    <DsEmpty v-if="!report" title="请选择要打印的报表" />
    <div v-else class="sheet">
      <div v-if="loading" class="loading-tip no-print">加载中…</div>
      <!-- 抬头：公司名 + 报表名 + 期间 -->
      <div class="sheet-head">
        <h1>{{ company }}</h1>
        <h2>{{ title }}</h2>
        <div class="meta">
          <span>统计期间：{{ periodText }}</span>
          <span>打印时间：{{ printTime }}</span>
        </div>
      </div>

      <table class="grid">
        <thead>
          <tr>
            <th class="idx">#</th>
            <th
              v-for="c in showColumns"
              :key="c.name"
              :class="{ num: isNumeric(c.type) }"
            >{{ fieldLabel(c.name, c.comment) }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(row, i) in rows" :key="i">
            <td class="idx">{{ i + 1 }}</td>
            <td v-for="c in showColumns" :key="c.name" :class="{ num: isNumeric(c.type) }">
              <template v-if="isDateCol(c)">{{ fmtDate(row[c.name]) }}</template>
              <template v-else-if="isNumeric(c.type)">{{ fmtNum(row[c.name]) }}</template>
              <template v-else>{{ row[c.name] ?? '-' }}</template>
            </td>
          </tr>
        </tbody>
        <!-- 合计行：数值列求和 -->
        <tfoot v-if="rows.length">
          <tr>
            <td class="idx">合计</td>
            <td v-for="c in showColumns" :key="c.name" :class="{ num: isNumeric(c.type) }">
              {{ isNumeric(c.type) ? fmtNum(totalOf(c.name)) : '' }}
            </td>
          </tr>
        </tfoot>
      </table>

      <div class="sheet-foot">
        <span>制单：____________</span>
        <span>审核：____________</span>
        <span>第 1 页 / 共 1 页</span>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * 报表打印页：1:1 还原原系统 Prints 控制器里「报表类打印」（type 为字符串的那一组）。
 *
 * 原系统对应模板与类型码：
 *   cgmx      采购明细表            → kuerp_goods_purchase_info（明细表）
 *   cgddgz    采购订单跟踪表        → kuerp_goods_purchase_order_info
 *   cghzb_sp  采购汇总表（按商品）  → 虚拟报表 goods-purchase-summary
 *   cghzb_gys 采购汇总表（按供应商）→ 虚拟报表 goods-purchase-summarys
 *   cgfk      采购付款记录          → kuerp_payment_log
 *   xsddgz    销售订单跟踪表        → kuerp_goods_sales_order_info
 * 本页用「报表表名 + 期间 + 关键字」统一驱动，A4 横向版式，数值列右对齐并带合计行。
 *
 * 用法：/print-report?report=goods-purchase-summary&title=采购汇总表&starttime=..&endtime=..&search=..
 *   report    报表/明细表名（连字符或下划线均可）
 *   title     标题（缺省按 presets 或表名）
 *   starttime 起始秒级时间戳（可选）
 *   endtime   截止秒级时间戳（含当天，可选）
 *   search    关键字（可选）
 */
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import request from '@/utils/request';
import { fetchCompanyName, fmtNum, fmtDate, isDateCol } from '@/utils/print';
import { fieldLabel } from '@/utils/field-meta';

const route = useRoute();
const router = useRouter();

/** 可打印报表预设（前 6 项对应原系统 Prints 的 6 个报表打印类型，其余为常用扩展） */
const presets = [
  { value: 'goods-purchase-info', label: '采购明细表' },
  { value: 'goods-purchase-order-info', label: '采购订单跟踪表' },
  { value: 'goods-purchase-summary', label: '采购汇总表（按商品）' },
  { value: 'goods-purchase-summarys', label: '采购汇总表（按供应商）' },
  { value: 'payment-log', label: '采购付款记录' },
  { value: 'goods-sales-order-info', label: '销售订单跟踪表' },
  { value: 'goods-sales-info', label: '销售明细表' },
  { value: 'goods-sales-summary', label: '销售汇总表（按商品）' },
  { value: 'goods-sales-summaryc', label: '销售汇总表（按客户）' },
  { value: 'goods-stock-balance', label: '库存余额表' },
  { value: 'goods-log-summary', label: '商品收发汇总表' },
  { value: 'cash-bank', label: '现金银行报表' },
  { value: 'intercourse', label: '往来单位欠款表' },
  { value: 'profit', label: '利润表' },
];

const report = ref(String(route.query.report || ''));
const columns = ref([]);
const rows = ref([]);
const loading = ref(false);
const company = ref('进销存管理系统');
const printTime = ref('');
const truncated = ref(false);
/** 单次拉取上限：报表打印面向纸张，超过一册无意义，超出时提示收窄条件 */
const FETCH_LIMIT = 1000;

/** 标题：URL 指定 > 预设名 > 表名 */
const title = computed(() => {
  const t = String(route.query.title || '');
  if (t) return t;
  return presets.find((p) => p.value === report.value)?.label || report.value;
});

/** 期间文案：由 URL 的时间戳还原，缺省显示「全部」 */
const periodText = computed(() => {
  const s = Number(route.query.starttime || 0);
  const e = Number(route.query.endtime || 0);
  if (!s && !e) return '全部';
  return `${s ? fmtDate(s) : '开始'} 至 ${e ? fmtDate(e) : '现在'}`;
});

/** 展示列：排除主键与审计字段 */
const showColumns = computed(() =>
  columns.value.filter((c) => !['id', 'createtime', 'updatetime', 'deletetime'].includes(c.name)),
);

/** 判断数值列（用于右对齐与合计） */
function isNumeric(type) {
  return ['int', 'bigint', 'tinyint', 'smallint', 'decimal', 'double', 'float'].includes(type);
}

/** 某数值列的合计值 */
function totalOf(name) {
  let sum = 0;
  for (const r of rows.value) sum += Number(r[name]) || 0;
  return sum;
}

/**
 * 拉取报表列元信息与数据。
 * 列走 /columns（含中文注释），数据走 /index（虚拟报表由后端聚合）。
 */
async function load() {
  if (!report.value) return;
  loading.value = true;
  try {
    const table = report.value.replace(/_/g, '-');
    const params = { page: 1, limit: FETCH_LIMIT };
    if (route.query.starttime) params.starttime = Number(route.query.starttime);
    if (route.query.endtime) params.endtime = Number(route.query.endtime);
    if (route.query.search) params.search = String(route.query.search);
    const [meta, data] = await Promise.all([
      request.get(`/kuerp/${table}/columns`),
      request.get(`/kuerp/${table}/index`, { params }),
    ]);
    columns.value = meta?.columns || [];
    rows.value = data?.list || [];
    truncated.value = Number(data?.count || 0) > rows.value.length;
  } finally {
    loading.value = false;
  }
}

/** 切换报表：写回 URL（保持刷新后可复现）；数据由 route.fullPath 的 watch 统一重新拉取 */
function onReportChange(v) {
  router.replace({ path: route.path, query: { ...route.query, report: v, title: '' } });
}

function doPrint() {
  window.print();
}

onMounted(async () => {
  printTime.value = new Date().toLocaleString('zh-CN', { hour12: false });
  company.value = await fetchCompanyName();
  load();
});

// URL 参数变化（如从报表页再次点击打印）时重新取数
watch(
  () => route.fullPath,
  () => {
    report.value = String(route.query.report || report.value);
    printTime.value = new Date().toLocaleString('zh-CN', { hour12: false });
    load();
  },
);
</script>

<style scoped>
.rp-page { background: #f5f7fa; min-height: 100%; padding: 12px; }
.toolbar { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
.toolbar .hint { font-size: 12px; color: #888; }
.loading-tip { text-align: center; font-size: 12px; color: #888; padding: 6px 0; }
.sheet {
  background: #fff;
  width: 297mm; /* A4 横向：报表列多，纵向放不下 */
  min-height: 210mm;
  margin: 0 auto;
  padding: 12mm 10mm;
  box-shadow: 0 0 8px rgba(0, 0, 0, 0.08);
}
.sheet-head h1 { font-size: 18px; text-align: center; margin: 0 0 2px; }
.sheet-head h2 { font-size: 15px; text-align: center; margin: 0 0 8px; color: #333; }
.sheet-head .meta {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #666;
  margin-bottom: 10px;
}
table.grid { width: 100%; border-collapse: collapse; }
table.grid th,
table.grid td { border: 1px solid #333; padding: 4px 6px; font-size: 12px; }
table.grid th { background: #f2f2f2; font-weight: 600; }
table.grid td.num,
table.grid th.num { text-align: right; font-variant-numeric: tabular-nums; }
table.grid .idx { width: 40px; text-align: center; }
table.grid tfoot td { font-weight: 600; background: #fafafa; }
.sheet-foot {
  display: flex;
  justify-content: space-between;
  margin-top: 22px;
  font-size: 12px;
  color: #444;
}
/* 打印：隐藏工具栏，A4 横向、无外边距与阴影 */
@media print {
  .no-print { display: none !important; }
  .rp-page { padding: 0; background: #fff; }
  .sheet { box-shadow: none; width: auto; min-height: auto; padding: 0; }
  @page { size: A4 landscape; margin: 10mm; }
  /* 报表行数多时必然跨页，表头与合计行需在每页重复出现 */
  thead { display: table-header-group; }
  tfoot { display: table-footer-group; }
  tr { break-inside: avoid; page-break-inside: avoid; }
  .rp-title, .rp-meta { break-after: avoid; page-break-after: avoid; }
}
</style>
