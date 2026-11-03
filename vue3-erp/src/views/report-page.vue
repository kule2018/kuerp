<template>
  <div>
    <DsCard>
      <!--
        报表检索区：日期范围 + 关键字（还原原系统报表的起止日期与筛选条件）。
        原 el-date-picker 的 daterange 在 ds 组件库里没有对应实现，
        改用「开始 / 结束」两个 DsDatePicker，取值口径保持一致（结束日含当天 23:59:59）。
      -->
      <div class="ds-form ds-form--inline row">
        <template v-if="dateable">
          <DsField label="开始日期">
            <DsDatePicker v-model="startDate" placeholder="开始日期" @change="onSearch" />
          </DsField>
          <DsField label="结束日期">
            <DsDatePicker v-model="endDate" placeholder="结束日期" @change="onSearch" />
          </DsField>
        </template>
        <DsField label="关键字">
          <DsInput v-model="search" placeholder="输入关键字回车搜索" clearable style="width: 240px" @keyup.enter="onSearch" />
        </DsField>
        <div class="row-btns">
          <DsButton variant="primary" @click="onSearch">查询</DsButton>
          <DsButton @click="resetFilter">重置</DsButton>
          <DsButton variant="primary" @click="exportCsv">导出 CSV</DsButton>
          <!-- 打印：等价原系统报表类打印（cgmx/cgddgz/cghzb_sp/cghzb_gys/cgfk/xsddgz），带期间与合计 -->
          <DsButton variant="default" @click="doPrintReport">打印</DsButton>
          <!-- AI 解读：把当前报表数据交给模型做趋势/异常/建议分析 -->
          <DsButton variant="default" :loading="aiLoading" @click="doAiExplain">AI 解读</DsButton>
          <!-- 列显示/隐藏：等价原系统「显示列」 -->
          <DsPopover trigger="click" placement="bottom-end">
            <template #reference>
              <DsButton variant="default">列设置</DsButton>
            </template>
            <div class="col-vis">
              <label v-for="c in displayColumns" :key="c.name" class="col-vis__item">
                <DsCheckbox v-model="colVis[c.name]" />
                <span>{{ c.label }}</span>
              </label>
            </div>
          </DsPopover>
        </div>
      </div>

      <!-- 报表数据表格：列由后端 /columns 动态生成，只读展示 -->
      <DsTable
        :columns="dsColumns"
        :data="sortedList"
        :loading="loading"
        :striped="true"
        :sort-key="sortKey"
        :sort-order="sortOrder"
        @sort-change="onSortChange"
        :key="tableKey"
      >
        <!-- 序号列：跨页连续编号 -->
        <template #_index="{ index }">{{ (page - 1) * pageSize + index + 1 }}</template>

        <!-- 业务列：审核态用标签，日期列转可读日期，数值列千分位 -->
        <template v-for="col in displayColumns" :key="col.name" #[col.name]="{ row }">
          <DsTag v-if="col.name === examineCol && String(row[col.name] ?? '0') === '1'" color="success" size="sm">已审</DsTag>
          <DsTag v-else-if="col.name === examineCol" color="neutral" size="sm">未审</DsTag>
          <!-- 日期列（秒级时间戳）转换为可读日期 -->
          <span v-else-if="isDateCol(col)">{{ formatDate(row[col.name]) }}</span>
          <!-- 枚举列：0/1/2 等编码翻译为注释里的中文选项 -->
          <span v-else-if="isEnumCol(col.name)">{{ enumText(col.name, row[col.name]) }}</span>
          <span v-else-if="isNumeric(col.type) && row[col.name] !== null && row[col.name] !== undefined">
            {{ formatNum(row[col.name]) }}
          </span>
          <span v-else>{{ row[col.name] }}</span>
        </template>

        <!-- 合计行：跨过序号列与首列给「合计」留位，数值列从第二列起求和 -->
        <template #summary>
          <td colspan="2">合计</td>
          <td v-for="col in displayColumns.slice(1)" :key="col.name">{{ sumOf(col) }}</td>
        </template>
      </DsTable>

      <!-- 分页 -->
      <DsPagination class="mt" layout="total, sizes, prev, pager, next" :total="total" :current-page="page" :page-size="pageSize" :page-sizes="[10, 20, 50, 100]" @update:currentPage="onPage" @update:pageSize="onSize" />
      <!-- AI 解读弹窗：展示模型对当前报表的洞察 -->
      <DsModal v-model="aiVisible" title="AI 报表解读" :width="760">
        <div v-if="aiLoading" class="ai-loading">AI 正在分析本报表数据…</div>
        <DsMarkdown v-else :content="aiText || '（无内容）'" />
      </DsModal>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 通用报表页：1:1 还原原系统各类「汇总表 / 明细表 / 利润表 / 对账表」的展示形态。
 *
 * 与 crud-page 的差异：
 * - 只读，无新增/编辑/删除/审核等操作（报表是查询分析视图）；
 * - 内置日期范围筛选（按 createtime，可由 route.meta.dateField 指定其它日期列）；
 * - 数值列自动在表尾生成「合计」行（原系统报表的金额/数量合计）；
 * - 支持导出当前查询结果为 CSV。
 *
 * 驱动方式同 crud-page：route.meta.api（如 /kuerp/goods-purchase-summary）。
 */
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { message } from '@/utils/ui';
import request from '../utils/request';
import { fieldLabel, parseComment } from '../utils/field-meta';

const route = useRoute();
const router = useRouter();
const api = route.meta.api || '/kuerp/goods'; // 报表对应的表接口前缀
const dateField = route.meta.dateField || 'createtime'; // 报表默认按 createtime 筛选

// —— 列表状态 ——
const list = ref([]);
const total = ref(0);
const search = ref('');
const loading = ref(false);
const page = ref(1);
const pageSize = ref(20);
const tableKey = ref(0);
// 日期范围：ds 的 DsDatePicker 为单日期，故拆成起止两个字符串（YYYY-MM-DD）
const startDate = ref('');
const endDate = ref('');

// —— 表元信息 ——
const meta = ref({ pk: 'id', columns: [] });
const examineCol = ref('');
// 是否支持日期范围筛选（后端 /columns 返回；无日期维度的报表如往来单位欠款表为 false）
const dateable = ref(true);

// 展示列：过滤主键/审计字段（可排序）。
// label 统一走 fieldLabel：注释优先 + 通用中文字典兜底，避免表头出现
// admin_id / purchase_time 这类裸英文字段名或超长枚举注释。
const displayColumns = computed(() =>
  meta.value.columns
    .filter((c) => !['id', 'createtime', 'updatetime', 'deletetime'].includes(c.name))
    .map((c) => ({ name: c.name, label: fieldLabel(c.name, c.comment), type: c.type, width: c.type === 'text' ? 200 : 120, sortable: true })),
);

// 枚举列（注释形如「业务类型:0=期初余额,1=预收…」）：单元格把 0/1/2 翻译成中文选项
const enumOptions = ref({});
const isEnumCol = (name) => !!enumOptions.value[name];

/** 枚举列取值翻译：值 → 注释里的中文选项；未命中时原样返回 */
function enumText(name, v) {
  const opts = enumOptions.value[name];
  if (!opts) return String(v ?? '');
  const hit = opts.find((o) => String(o.value) === String(v));
  return hit ? hit.label : String(v ?? '');
}

// 列显示/隐藏状态（列名 -> 是否显示；默认全显）
const colVis = ref({});
// 排序状态
const sortKey = ref('');
const sortOrder = ref('');

/** 列表展示数据：支持表头点击排序（客户端排序） */
const sortedList = computed(() => {
  if (!sortKey.value || !sortOrder.value) return list.value;
  const k = sortKey.value;
  const dir = sortOrder.value === 'asc' ? 1 : -1;
  return [...list.value].sort((a, b) => {
    const av = a[k];
    const bv = b[k];
    const an = Number(av);
    const bn = Number(bv);
    if (!Number.isNaN(an) && !Number.isNaN(bn) && av != null && bv != null && av !== '' && bv !== '') {
      return (an - bn) * dir;
    }
    return String(av ?? '').localeCompare(String(bv ?? ''), 'zh-CN') * dir;
  });
});

/** DsTable 列配置：首列序号 + 后端返回的展示列（按列显隐过滤，均可排序） */
const dsColumns = computed(() => {
  const cols = [{ key: '_index', title: '#', width: '50' }];
  displayColumns.value.forEach((c) => {
    if (colVis.value[c.name] === false) return;
    cols.push({ key: c.name, title: c.label, width: String(c.width), sortable: true });
  });
  return cols;
});

/** 表头点击排序：同列循环 升→降→取消 */
function onSortChange(key) {
  if (sortKey.value !== key) {
    sortKey.value = key;
    sortOrder.value = 'asc';
  } else if (sortOrder.value === 'asc') {
    sortOrder.value = 'desc';
  } else if (sortOrder.value === 'desc') {
    sortKey.value = '';
    sortOrder.value = '';
  } else {
    sortOrder.value = 'asc';
  }
}
const numericCols = computed(() =>
  meta.value.columns.filter(
    (c) =>
      isNumeric(c.type) &&
      !['createtime', 'updatetime'].includes(c.name) &&
      !isDateCol(c) &&
      !isEnumCol(c.name), // 枚举列是分类编码，求和无意义
  ),
);

/** 判断列是否为数值类型 */
function isNumeric(type) {
  return ['int', 'bigint', 'tinyint', 'smallint', 'decimal', 'double', 'float'].includes(type);
}

/** 判断列是否为日期列（虚拟报表声明为 datetime，或字段名以 _time 结尾） */
function isDateCol(col) {
  return col.type === 'datetime' || /_(time|date)$/.test(col.name);
}

/** 秒级时间戳 -> YYYY-MM-DD（空值返回占位符） */
function formatDate(v) {
  const n = Number(v);
  if (!n) return '';
  const d = new Date(n * 1000);
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}

/** 数值千分位/小数格式化 */
function formatNum(v) {
  const n = Number(v);
  if (isNaN(n)) return v;
  return n.toLocaleString('zh-CN', { maximumFractionDigits: 2 });
}

/**
 * 合计行某一列的取值：数值列返回当前页求和结果，其余返回空串。
 * @param col 展示列配置
 * @returns 合计文本（千分位）或空串
 */
function sumOf(col) {
  if (!numericCols.value.some((c) => c.name === col.name)) return '';
  return formatNum(list.value.reduce((acc, r) => acc + (Number(r[col.name]) || 0), 0));
}

/**
 * 日期字符串（YYYY-MM-DD）转秒级时间戳。
 * @param s 日期字符串，形如 2026-10-26；空串返回 0
 * @returns 秒级时间戳（本地时区 00:00:00）
 */
function toSec(s) {
  if (!s) return 0;
  const d = new Date(`${s} 00:00:00`);
  return isNaN(d.getTime()) ? 0 : Math.floor(d.getTime() / 1000);
}

/** 拉取表字段元信息 */
async function loadColumns() {
  const r = await request.get(`${api}/columns`);
  const cols = r?.columns || [];
  meta.value = { pk: r?.pk || 'id', columns: cols };
  examineCol.value = ['examine_status', 'examine', 'status'].find((n) => cols.some((c) => c.name === n)) || '';
  // 无日期维度的报表隐藏日期范围筛选，避免选日期后整表查空
  dateable.value = r?.dateable !== false;
  // 初始化列显隐：展示列默认全部勾选
  const vis = {};
  displayColumns.value.forEach((c) => { vis[c.name] = true; });
  colVis.value = vis;
  // 列注释枚举解析（「业务类型:0=期初余额,1=预收…」→ 值→中文），单元格据此翻译
  const enums = {};
  cols.forEach((c) => {
    const { options } = parseComment(c.comment);
    if (options) enums[c.name] = options;
  });
  enumOptions.value = enums;
  tableKey.value++;
}

/** 拉取报表数据（带日期范围与关键字） */
async function load() {
  loading.value = true;
  try {
    const params = { page: page.value, limit: pageSize.value, search: search.value, dateField };
    // 起止日期转秒；结束日补 86399 秒，保证包含当天 23:59:59
    if (startDate.value) params.starttime = toSec(startDate.value);
    if (endDate.value) params.endtime = toSec(endDate.value) + 86399;
    const r = await request.get(`${api}/index`, { params });
    list.value = r?.list || [];
    total.value = r?.count || 0;
  } finally {
    loading.value = false;
  }
}

function onSearch() { page.value = 1; load(); }
function onPage(p) { page.value = p; load(); }
function onSize(s) { pageSize.value = s; page.value = 1; load(); }

/**
 * 打开报表打印页（A4 横向，含期间、合计行与人民币大写金额口径）。
 * 把当前报表的表名、标题、日期区间与关键字透传到 /print-report，保证打印内容与屏幕一致。
 * @returns {void}
 */
function doPrintReport() {
  const table = String(api).replace(/^\/kuerp\//, '');
  const query = { report: table, title: String(route.meta.title || '') };
  if (dateable.value && startDate.value) query.starttime = toSec(startDate.value);
  if (dateable.value && endDate.value) query.endtime = toSec(endDate.value) + 86399;
  if (search.value) query.search = search.value;
  router.push({ name: 'PrintReport', query });
}
function resetFilter() {
  startDate.value = '';
  endDate.value = '';
  search.value = '';
  page.value = 1;
  load();
}

/** 导出当前查询结果为 CSV（UTF-8 BOM 兼容 Excel） */
function exportCsv() {
  if (!list.value.length) { message.warning('暂无数据可导出'); return; }
  const cols = displayColumns.value;
  const head = cols.map((c) => c.label).join(',');
  const rows = list.value.map((r) => cols.map((c) => `"${String(r[c.name] ?? '').replace(/"/g, '""')}"`).join(','));
  const csv = '﻿' + [head, ...rows].join('\r\n');
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `${route.meta.title || 'report'}.csv`;
  a.click();
  URL.revokeObjectURL(url);
  message.success('已导出 CSV');
}

/** AI 解读：把当前报表的列与数据样例交给模型，产出趋势/异常/建议 */
const aiVisible = ref(false);
const aiText = ref('');
const aiLoading = ref(false);
async function doAiExplain() {
  if (!list.value.length) {
    message.warning('当前报表没有数据，无法解读');
    return;
  }
  aiVisible.value = true;
  aiLoading.value = true;
  aiText.value = '';
  try {
    const cols = (displayColumns.value || []).map((c) => c.label).join('、');
    const sample = JSON.stringify(list.value.slice(0, 30));
    const r = await request.post('/ai/chat', {
      system:
        '你是进销存系统的资深报表分析师。下面是一张业务报表的列名与数据样例（JSON）。' +
        '请用简洁的中文回答：1) 关键趋势；2) 明显的异常或风险；3) Top/Bottom 项；4) 2-3 条可执行的经营建议。' +
        '不要编造数据中不存在的内容。',
      message: `报表标题：${route.meta.title || ''}\n列名：${cols}\n数据样例：\n${sample}`,
    });
    aiText.value = r?.content || '（无返回）';
  } catch (e) {
    aiText.value = '解读失败：' + (e.message || e);
    message.error('AI 解读失败，请确认已在「模型配置」中设置可用的 AI 模型');
  } finally {
    aiLoading.value = false;
  }
}

onMounted(async () => {
  await loadColumns();
  await load();
});
</script>

<style scoped>
.mt { margin-top: 12px; }
/* 检索行：字段横向排列，末尾按钮组左对齐不换行 */
.row { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 12px; }
.row > * { min-width: 150px; }
.row-btns { display: flex; gap: 8px; min-width: auto; }

/* 列显示/隐藏面板 */
.col-vis {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 160px;
  max-height: 320px;
  overflow-y: auto;
  padding: 4px;
}
.col-vis__item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: var(--ds-font-sm);
  color: var(--ds-text-2);
  cursor: pointer;
}
</style>
