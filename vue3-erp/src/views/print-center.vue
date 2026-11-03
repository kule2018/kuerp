<template>
  <div class="pc">
    <!-- 左侧：单据类型 + 单据列表 -->
    <DsCard class="left">
      <div class="doc-types">
        <div
          v-for="d in docTypes"
          :key="d.table"
          class="dt"
          :class="{ active: active?.table === d.table }"
          @click="selectType(d)"
        >{{ d.title }}</div>
      </div>

      <DsDivider>单据列表</DsDivider>
      <DsInput v-model="docSearch" placeholder="按单据号检索" clearable size="small" @keyup.enter="loadDocs" class="mb" />
      <div class="doc-list">
        <div v-if="docLoading" class="loading-tip">加载中…</div>
        <div
          v-for="row in docs"
          :key="row.id"
          class="doc"
          :class="{ active: current?.id === row.id }"
          @click="selectDoc(row)"
        >
          <div>{{ row.purchase_code || row.order_code || row.code || ('#' + row.id) }}</div>
          <div class="sub">{{ fmtTime(row.purchase_time || row.createtime) }}</div>
        </div>
        <DsEmpty v-if="!docs.length && !docLoading" title="暂无单据"  />
      </div>
    </DsCard>

    <!-- 右侧：A4 打印预览 -->
    <DsCard class="right">
      <div class="toolbar no-print">
        <span class="t">{{ active?.title || '单据打印' }}</span>
        <DsButton variant="primary" :disabled="!current" @click="doPrint">打印 / 导出 PDF</DsButton>
      </div>

      <div class="sheet">
        <div v-if="loading" class="loading-tip no-print">加载中…</div>
        <template v-if="current">
          <div class="sheet-head">
            <h1>{{ company.name }}</h1>
            <h2>{{ active.title }}</h2>
            <div class="meta">
              <span>单据编号：{{ current.purchase_code || current.order_code || current.code || '-' }}</span>
              <span>单据日期：{{ fmtTime(current.purchase_time || current.createtime) }}</span>
            </div>
          </div>

          <!-- 表头字段（动态渲染，排除明细相关与审计字段） -->
          <table class="kv">
            <tbody>
              <tr v-for="(pair, i) in headerPairs" :key="i">
                <template v-for="(f, j) in pair" :key="j">
                  <td class="k">{{ f.label }}</td>
                  <td class="v">{{ f.value }}</td>
                </template>
                <template v-if="pair.length === 1"><td class="k" /><td class="v" /></template>
              </tr>
            </tbody>
          </table>

          <!-- 行项目明细（若存在子表） -->
          <table v-if="items.length" class="grid">
            <thead>
              <tr>
                <th>序号</th>
                <th v-for="c in itemColumns" :key="c.name">{{ c.label }}</th>
                <th>金额</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(it, i) in items" :key="i">
                <td>{{ i + 1 }}</td>
                <td v-for="c in itemColumns" :key="c.name">{{ it[c.name] }}</td>
                <td>{{ money(itemAmount(it)) }}</td>
              </tr>
            </tbody>
          </table>

          <div class="sheet-foot">
            <span>制单：{{ current.admin_id || '-' }}</span>
            <span>审核：{{ auditText }}</span>
            <span>签收：____________</span>
          </div>
        </template>
        <DsEmpty v-else title="请选择左侧单据进行打印预览"  />
      </div>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 打印中心：1:1 还原原系统 Prints 控制器的打印能力（prints/prints.html 为单据类型导航，
 * 各 prints/*.html 为对应单据的 A4 打印模板）。
 *
 * 实现：左侧按单据类型列出单据，右侧拉取单据头（动态表 /get）+ 行项目（*_info 子表，按 purchase_code 关联），
 * 渲染标准 A4 发票版式；打印时通过 @media print 隐藏工具栏，仅输出单据本体。
 */
import { ref, reactive, computed, onMounted } from 'vue';
import { message } from '@/utils/ui';
import request from '../utils/request';
import { fetchCompanyName } from '@/utils/print';
import { fieldLabel } from '@/utils/field-meta';

// 单据类型配置：title 显示名；table 表名（不含 kuerp_）；info 行项目子表
// 顺序与原系统 Prints 控制器的 type 1..6 一致（订单 → 单据 → 退货单），其后为资金/仓储类单据
const docTypes = [
  { title: '采购订单', table: 'goods_purchase_order', info: 'goods_purchase_order_info' },
  { title: '购货单', table: 'goods_purchase', info: 'goods_purchase_info' },
  { title: '购货退货单', table: 'goods_exchange', info: 'goods_exchange_info' },
  { title: '销货订单', table: 'goods_sales_order', info: 'goods_sales_order_info' },
  { title: '销货单', table: 'goods_sales', info: 'goods_sales_info' },
  { title: '销货退货单', table: 'goods_sales_exchange', info: 'goods_sales_exchange_info' },
  { title: '收款单', table: 'collection' },
  { title: '付款单', table: 'payment' },
  { title: '其他收入单', table: 'income', info: 'income_info' },
  { title: '其他支出单', table: 'expenditure', info: 'expenditure_info' },
  { title: '调拨单', table: 'allocation', info: 'allocation_info' },
  { title: '组装单', table: 'assemble', info: 'assemble_info' },
  { title: '拆卸单', table: 'split', info: 'split_info' },
  { title: '成本调整单', table: 'adjustment', info: 'adjustment_info' },
  { title: '其他入库单', table: 'warehousing', info: 'warehousing_info' },
  // 其他出库单的主表是 kuerp_warehouse（前缀 QTCK）；kuerp_stores 是仓库档案，勿混用
  { title: '其他出库单', table: 'warehouse', info: 'warehouse_info' },
  { title: '盘点单', table: 'inventory', info: 'inventory_info' },
  { title: '核销单', table: 'writeoff', info: 'writeoff_info' },
];

/** 打印抬头公司名（取自系统参数 kuerp_sets.company_name，见 /utils/print.js） */
const company = reactive({ name: '进销存管理系统' });
const active = ref(null);
const docs = ref([]);
const docSearch = ref('');
const docLoading = ref(false);
const current = ref(null);
const items = ref([]);
const itemColumns = ref([]);
const headerColumns = ref([]);
const loading = ref(false);

/** 排除的字段（不进表头/明细展示） */
const EXCLUDE = ['id', 'createtime', 'updatetime', 'deletetime', 'admin_id', 'examine_id', 'operation_id', 'preparation_id', 'print_num'];

const auditText = computed(() => {
  const col = ['examine_status', 'examine', 'check_status', 'status'].find((n) => headerColumns.value.some((c) => c.name === n));
  if (!col || current.value === null) return '-';
  const v = String(current.value[col] ?? '0');
  return v === '1' ? '已审核' : '未审核';
});

/** 表头字段两两配对 */
const headerPairs = computed(() => {
  const fields = headerColumns.value
    .filter((c) => !EXCLUDE.includes(c.name))
    .map((c) => ({ label: fieldLabel(c.name, c.comment), value: current.value?.[c.name] ?? '-' }));
  const pairs = [];
  for (let i = 0; i < fields.length; i += 2) pairs.push(fields.slice(i, i + 2));
  return pairs;
});

/** 明细金额：优先 all_money / money_tax_price，否则 数量*单价 */
function itemAmount(it) {
  return Number(it.money_tax_price) || Number(it.all_money) || (Number(it.number) * Number(it.unit_price || 0)) || 0;
}

function money(v) {
  return '¥' + (Number(v) || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
function fmtTime(s) {
  if (!s) return '-';
  return new Date(Number(s) * 1000).toLocaleDateString('zh-CN');
}

/** 选择单据类型，加载该类型单据列表 */
async function selectType(d) {
  active.value = d;
  current.value = null;
  items.value = [];
  await loadDocs();
}

/** 加载单据列表（取号 + 日期字段不固定，前端按 id 倒序取前 50） */
async function loadDocs() {
  if (!active.value) return;
  docLoading.value = true;
  try {
    const r = await request.get(`/kuerp/${active.value.table}/index`, {
      params: { limit: 50, search: docSearch.value || undefined },
    });
    docs.value = r?.list || [];
  } finally {
    docLoading.value = false;
  }
}

/** 选择单据，加载表头 + 行项目 */
async function selectDoc(row) {
  loading.value = true;
  try {
    const t = active.value.table;
    const [meta, detail] = await Promise.all([
      request.get(`/kuerp/${t}/columns`),
      request.get(`/kuerp/${t}/get`, { params: { id: row.id } }),
    ]);
    headerColumns.value = meta?.columns || [];
    current.value = detail || null;

    // 行项目：存在子表时按 purchase_code 关联拉取
    items.value = [];
    itemColumns.value = [];
    const info = active.value.info;
    if (info && detail?.purchase_code) {
      const [imeta, irows] = await Promise.all([
        request.get(`/kuerp/${info}/columns`),
        request.get(`/kuerp/${info}/index`, { params: { filter: { purchase_code: detail.purchase_code }, limit: 200 } }),
      ]);
      const cols = imeta?.columns || [];
      // 明细展示列：商品编号/名称/数量/单价/金额类
      itemColumns.value = cols.filter((c) =>
        !EXCLUDE.includes(c.name) && /code|name|number|basic|unit_price|price|spec|attr|remark|unit/i.test(c.name),
      ).slice(0, 8);
      items.value = irows?.list || [];
    }
  } catch (e) {
    message.error('加载单据失败：' + (e?.message || '接口错误'));
  } finally {
    loading.value = false;
  }
}

function doPrint() { window.print(); }

onMounted(async () => {
  // 抬头取系统参数里的公司名（原系统 Prints 控制器 assign('company_name', ...)）
  company.name = await fetchCompanyName();
  // 默认选中第一个单据类型，减少一次点击
  if (docTypes.length) selectType(docTypes[0]);
});
</script>

<style scoped>
.pc { display: flex; gap: 12px; height: calc(100vh - 140px); }
.left { width: 320px; display: flex; flex-direction: column; }
.doc-types { display: flex; flex-wrap: wrap; gap: 6px; }
.dt { padding: 5px 10px; border: 1px solid #dcdfe6; border-radius: 4px; cursor: pointer; font-size: 13px; }
.dt.active { background: #409eff; color: #fff; border-color: #409eff; }
.doc-list { overflow: auto; flex: 1; }
.doc { padding: 8px 10px; border-bottom: 1px solid #f2f2f2; cursor: pointer; }
.doc:hover { background: #f5f7fa; }
.doc.active { background: #ecf5ff; }
.doc .sub { font-size: 12px; color: #999; }
.mb { margin-bottom: 8px; }
.loading-tip { text-align: center; font-size: 12px; color: #888; padding: 6px 0; }
.right { flex: 1; overflow: auto; }
.toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.toolbar .t { font-weight: 600; }
.sheet { background: #fff; width: 210mm; min-height: 297mm; margin: 0 auto; padding: 16mm 14mm; box-shadow: 0 0 8px rgba(0,0,0,.08); }
.sheet-head h1 { font-size: 22px; text-align: center; margin: 0 0 2px; }
.sheet-head h2 { font-size: 16px; text-align: center; margin: 0 0 8px; color: #333; }
.sheet-head .meta { display: flex; justify-content: space-between; font-size: 12px; color: #666; margin-bottom: 12px; }
table.kv { width: 100%; border-collapse: collapse; margin-bottom: 12px; }
table.kv td { border: 1px solid #333; padding: 6px 8px; font-size: 13px; }
table.kv td.k { width: 18%; background: #fafafa; color: #555; }
table.kv td.v { width: 32%; }
table.grid { width: 100%; border-collapse: collapse; margin-bottom: 16px; }
table.grid th, table.grid td { border: 1px solid #333; padding: 5px 6px; font-size: 12px; text-align: center; }
.sheet-foot { display: flex; justify-content: space-between; margin-top: 28px; font-size: 13px; color: #444; }
@media print {
  .no-print { display: none !important; }
  .pc { display: block; height: auto; }
  .left { display: none !important; }
  .right { width: 100%; box-shadow: none; }
  .sheet { box-shadow: none; width: auto; min-height: auto; padding: 0; }
  /* 明细跨页时每页都带表头，避免后续页出现「无名数字」 */
  thead { display: table-header-group; }
  tfoot { display: table-footer-group; }
  tr { break-inside: avoid; page-break-inside: avoid; }
}
</style>
