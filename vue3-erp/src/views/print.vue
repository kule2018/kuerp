<template>
  <div class="print-page">
    <div v-if="loading" class="loading-tip no-print">加载中…</div>
    <div class="toolbar no-print">
      <DsButton @click="$router.back()">返回</DsButton>
      <DsButton variant="primary" @click="doPrint">打印 / 导出 PDF</DsButton>
    </div>

    <div v-if="!row && !loading" class="empty">
      <DsEmpty title="缺少打印参数（table / id）" />
    </div>

    <!-- 单据打印区：A4 版式，表头字段 + 行项目明细 + 金额合计 -->
    <div v-else class="sheet">
      <div class="sheet-head">
        <h1>{{ company }}</h1>
        <h2>{{ title }}</h2>
        <div class="meta">
          <span>单据编号：{{ row?.purchase_code || row?.order_code || row?.code || row?.id }}</span>
          <span>打印时间：{{ printTime }}</span>
        </div>
      </div>

      <!-- 表头：两列键值（排除审计字段与明细字段） -->
      <table class="kv">
        <tbody>
          <tr v-for="(pair, i) in fieldPairs" :key="i">
            <template v-for="(f, j) in pair" :key="j">
              <td class="label">{{ f.label }}</td>
              <td class="value">{{ f.value }}</td>
            </template>
            <!-- 奇数行补空单元格，保持两列对齐 -->
            <template v-if="pair.length === 1">
              <td class="label" />
              <td class="value" />
            </template>
          </tr>
        </tbody>
      </table>

      <!-- 行项目明细：自动探测同名 *_info 子表（无子表则整段不渲染） -->
      <table v-if="items.length" class="grid">
        <thead>
          <tr>
            <th class="idx">#</th>
            <th v-for="c in itemColumns" :key="c.name">{{ fieldLabel(c.name, c.comment) }}</th>
            <th>金额</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(it, i) in items" :key="i">
            <td class="idx">{{ i + 1 }}</td>
            <td v-for="c in itemColumns" :key="c.name">{{ it[c.name] ?? '-' }}</td>
            <td class="num">{{ money(itemAmount(it)) }}</td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td class="idx">合计</td>
            <td v-for="c in itemColumns" :key="c.name" class="num">
              {{ c.name === 'number' ? fmtNum(itemNumberTotal) : '' }}
            </td>
            <td class="num">{{ money(itemMoneyTotal) }}</td>
          </tr>
        </tfoot>
      </table>

      <!-- 大写金额（原系统 print_money_c，单据有明细时给出） -->
      <div v-if="items.length" class="capital">合计人民币（大写）：{{ capitalMoney }}</div>

      <div class="sheet-foot">
        <span>制单：{{ row?.admin_id || '-' }}</span>
        <span>审核：{{ auditText }}</span>
        <span>签收：____________</span>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * 通用单据打印页：1:1 还原原系统 Prints 控制器的「单据类打印」（type 1..6 及各单据模板）。
 * ------------------------------------------------------------------
 * 用法：/print?table=goods-purchase&id=123（table 用连字符形式）。
 * 行为：
 *   1. 拉表头（/columns 元信息 + /get 详情），按两列键值排布；
 *   2. 自动探测 <table>_info 子表，按 purchase_code 关联拉行项目，渲染明细表 + 数量/金额合计；
 *   3. 合计金额附人民币大写（等价原系统 num_to_rmb）；
 *   4. 抬头公司名取自系统参数 kuerp_sets.company_name；
 *   5. 打印时通过 @media print 隐藏工具栏，仅输出 A4 单据本体。
 */
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import request from '../utils/request';
import { fetchCompanyName, money, fmtNum } from '@/utils/print';
import { fieldLabel } from '@/utils/field-meta';

const route = useRoute();
const table = computed(() => String(route.query.table || ''));
const id = computed(() => String(route.query.id || ''));
const loading = ref(false);
const row = ref(null);
const columns = ref([]);
const items = ref([]);
const itemColumns = ref([]);
const printTime = ref('');
const company = ref('进销存管理系统');

/** 表头/明细都要排除的审计与大字段 */
const EXCLUDE = ['id', 'createtime', 'updatetime', 'deletetime', 'admin_id', 'examine_id', 'operation_id', 'preparation_id', 'print_num'];

/** 页面标题：表名 -> 中文（与原系统 Prints 各模板注释一致，未命中回退表名） */
const title = computed(() => {
  const t = table.value.replace(/-/g, '_');
  const map = {
    kuerp_goods_purchase_order: '购货订单',
    kuerp_goods_purchase: '购货单',
    kuerp_goods_exchange: '购货退货单',
    kuerp_goods_sales_order: '销货订单',
    kuerp_goods_sales: '销货单',
    kuerp_goods_sales_exchange: '销货退货单',
    kuerp_collection: '收款单',
    kuerp_payment: '付款单',
    kuerp_income: '其他收入单',
    kuerp_expenditure: '其他支出单',
    kuerp_allocation: '调拨单',
    kuerp_assemble: '组装单',
    kuerp_split: '拆卸单',
    kuerp_adjustment: '成本调整单',
    kuerp_warehousing: '其他入库单',
    // 其他出库单主表是 kuerp_warehouse（QTCK）；kuerp_stores 为仓库档案
    kuerp_warehouse: '其他出库单',
    kuerp_stores: '仓库档案',
    kuerp_inventory: '盘点单',
    kuerp_writeoff: '核销单',
    kuerp_user_order: '订货单',
  };
  return map[t] || t || '单据';
});

/** 审核状态文本 */
const auditText = computed(() => {
  const col = ['examine_status', 'examine', 'check_status', 'status'].find((n) =>
    columns.value.some((c) => c.name === n),
  );
  if (!col || row.value === null) return '-';
  return String(row.value[col] ?? '0') === '1' ? '已审核' : '未审核';
});

/** 表头字段两两配对，供表格两列布局 */
const fieldPairs = computed(() => {
  const fields = columns.value
    .filter((c) => !EXCLUDE.includes(c.name))
    .map((c) => ({ label: fieldLabel(c.name, c.comment), value: row.value?.[c.name] ?? '-' }));
  const pairs = [];
  for (let i = 0; i < fields.length; i += 2) pairs.push(fields.slice(i, i + 2));
  return pairs;
});

/** 明细金额：优先价税合计 / 金额，其次 数量×单价 */
function itemAmount(it) {
  return (
    Number(it.money_tax_price) ||
    Number(it.all_money) ||
    Number(it.number) * Number(it.unit_price || 0) ||
    0
  );
}

/** 明细数量合计 */
const itemNumberTotal = computed(() =>
  items.value.reduce((s, it) => s + (Number(it.number) || 0), 0),
);

/** 明细金额合计 */
const itemMoneyTotal = computed(() => items.value.reduce((s, it) => s + itemAmount(it), 0));

/**
 * 金额转人民币大写（等价原系统 Prints::num_to_rmb）。
 * @param {number} n 金额
 * @returns {string} 如「壹万贰仟叁佰肆拾伍元陆角柒分」
 */
function numToRmb(n) {
  const num = Number(n) || 0;
  if (!num) return '零元整';
  const digits = '零壹贰叁肆伍陆柒捌玖';
  const units = ['', '拾', '佰', '仟'];
  const bigUnits = ['', '万', '亿', '万亿'];
  let intPart = Math.floor(Math.abs(num));
  const cents = Math.round((Math.abs(num) - intPart) * 100);
  let intText = '';
  let group = 0;
  while (intPart > 0) {
    const seg = intPart % 10000;
    let segText = '';
    let zero = false;
    for (let i = 0, v = seg; i < 4; i++, v = Math.floor(v / 10)) {
      const d = v % 10;
      if (d === 0) {
        zero = true;
      } else {
        segText = digits[d] + units[i] + (zero ? '零' : '') + segText;
        zero = false;
      }
    }
    intText = segText + (segText ? bigUnits[group] : '') + intText;
    intPart = Math.floor(intPart / 10000);
    group++;
  }
  intText = intText ? intText + '元' : '';
  const jiao = Math.floor(cents / 10);
  const fen = cents % 10;
  const decText = jiao || fen ? `${jiao ? digits[jiao] + '角' : '零'}${fen ? digits[fen] + '分' : '整'}` : '整';
  return (num < 0 ? '负' : '') + (intText || '零元') + decText;
}

/** 合计金额大写 */
const capitalMoney = computed(() => numToRmb(itemMoneyTotal.value));

onMounted(async () => {
  printTime.value = new Date().toLocaleString('zh-CN', { hour12: false });
  company.value = await fetchCompanyName();
  if (!table.value || !id.value) return;
  loading.value = true;
  try {
    const api = `/kuerp/${table.value}`;
    const [meta, detail] = await Promise.all([
      request.get(`${api}/columns`),
      request.get(`${api}/get`, { params: { id: id.value } }),
    ]);
    columns.value = meta?.columns || [];
    row.value = detail || null;

    // 行项目：按约定探测 <table>_info 子表，缺子表时静默跳过（资金类单据无明细）
    const code = detail?.purchase_code;
    const infoTable = `${table.value}_info`;
    if (code) {
      try {
        const [imeta, irows] = await Promise.all([
          request.get(`/kuerp/${infoTable}/columns`),
          request.get(`/kuerp/${infoTable}/index`, {
            params: { filter: JSON.stringify({ purchase_code: code }), limit: 200 },
          }),
        ]);
        const cols = imeta?.columns || [];
        // 明细展示列：商品/单位/数量/单价/规格/备注类字段
        itemColumns.value = cols
          .filter((c) => !EXCLUDE.includes(c.name) && /code|name|number|basic|price|spec|attr|remark|unit/i.test(c.name))
          .slice(0, 8);
        items.value = irows?.list || [];
      } catch {
        /* 无明细子表：正常情况（收款单/付款单/核销单等） */
      }
    }
  } finally {
    loading.value = false;
  }
});

/** 触发浏览器打印 */
function doPrint() {
  window.print();
}
</script>

<style scoped>
.print-page { background: #f5f7fa; min-height: 100%; padding: 12px; }
.toolbar { margin-bottom: 12px; }
.loading-tip { text-align: center; font-size: 12px; color: #888; padding: 6px 0; }
.sheet { background: #fff; width: 210mm; min-height: 297mm; margin: 0 auto; padding: 18mm 16mm; box-shadow: 0 0 8px rgba(0,0,0,.08); }
.sheet-head h1 { font-size: 18px; text-align: center; margin: 0 0 2px; }
.sheet-head h2 { font-size: 22px; text-align: center; margin: 0 0 10px; }
.sheet-head .meta { display: flex; justify-content: space-between; font-size: 12px; color: #666; margin-bottom: 12px; }
table.kv { width: 100%; border-collapse: collapse; margin-bottom: 14px; }
table.kv td { border: 1px solid #333; padding: 7px 10px; font-size: 13px; }
td.label { width: 18%; background: #fafafa; color: #555; }
td.value { width: 32%; }
table.grid { width: 100%; border-collapse: collapse; margin-bottom: 10px; }
table.grid th, table.grid td { border: 1px solid #333; padding: 5px 6px; font-size: 12px; }
table.grid th { background: #f2f2f2; font-weight: 600; }
table.grid td.num, table.grid th.num { text-align: right; font-variant-numeric: tabular-nums; }
table.grid .idx { width: 40px; text-align: center; }
table.grid tfoot td { font-weight: 600; background: #fafafa; }
.capital { font-size: 13px; margin-bottom: 6px; }
.sheet-foot { display: flex; justify-content: space-between; margin-top: 28px; font-size: 13px; color: #444; }
.empty { padding-top: 80px; }
/* 打印时只输出单据本体 */
@media print {
  .no-print { display: none !important; }
  .print-page { padding: 0; background: #fff; }
  .sheet { box-shadow: none; width: auto; min-height: auto; padding: 0; }
  /* 长单据跨页时重复表头：否则第二页起只剩数字没有列名，纸质单据无法核对 */
  thead { display: table-header-group; }
  tfoot { display: table-footer-group; }
  /* 单行不跨页断开：一条商品被切在两页之间最容易看错数量 */
  tr, .sheet-head, .capital { break-inside: avoid; page-break-inside: avoid; }
  /* 表头下方的单据信息（客户/日期）也不应被切断 */
  .sheet-head { break-after: avoid; page-break-after: avoid; }
}
</style>
