<template>
  <div>
    <DsCard>
      <!-- 查询区：商品 + 仓库 + 日期范围 -->
      <div class="ds-form ds-form--inline filter-bar">
        <DsField label="商品">
          <div class="goods-pick">
            <!-- 远程检索：关键字输入框驱动 options，等价于原 el-select 的 remote 模式 -->
            <DsInput v-model="goodsKw" placeholder="输入商品名称/编号" clearable style="width: 180px" @keyup.enter="searchGoods(goodsKw)" />
            <DsSelect
              v-model="goodsId"
              :options="goodsOptions"
              filterable
              clearable
              placeholder="选择商品"
              style="width: 260px"
            />
          </div>
        </DsField>
        <DsField label="仓库">
          <DsSelect v-model="storesId" :options="warehouseOptions" filterable clearable placeholder="全部仓库" style="width: 160px" />
        </DsField>
        <DsField label="开始日期">
          <DsDatePicker v-model="startDate" type="date" style="width: 160px" />
        </DsField>
        <DsField label="结束日期">
          <DsDatePicker v-model="endDate" type="date" style="width: 160px" />
        </DsField>
        <DsField>
          <div class="btn-row">
            <DsButton variant="primary" :disabled="!goodsId" @click="query">查询</DsButton>
            <DsButton @click="reset">重置</DsButton>
          </div>
        </DsField>
      </div>

      <!-- 期间结存四大指标 -->
      <div class="metrics" v-if="computed_">
        <DsStatCard label="期初结存" :value="num(opening)" tone="neutral" />
        <DsStatCard label="本期收入" :value="num(income)" tone="success" />
        <DsStatCard label="本期发出" :value="num(outcome)" tone="warning" />
        <DsStatCard label="期末结存" :value="num(closing)" tone="brand" />
      </div>

      <DsAlert v-else-if="!loading" type="info" :closable="false" title="请选择商品并点击查询，查看该商品的期间结存与流水。" />

      <!-- 本期流水明细 -->
      <DsTable v-if="periodRows.length" :columns="cols" :data="periodRows" row-key="id" class="mt" striped :loading="loading">
        <template #business_type="{ row }">{{ bizType(row.business_type) }}</template>
        <template #enter_number="{ row }">{{ num(row.enter_number) }}</template>
        <template #out_number="{ row }">{{ num(row.out_number) }}</template>
        <template #balance_basics="{ row }">{{ num(row.balance_basics) }}</template>
        <template #createtime="{ row }">{{ fmtTime(row.createtime) }}</template>
      </DsTable>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 商品期间查询：1:1 还原原系统 goods/period.html 的期间结存视图。
 *
 * 计算口径（基于 kuerp_goods_log 收发明细）：
 * - 期初结存 = 查询起始日之前所有收发明细的 (入库 - 出库) 累计；
 * - 本期收入 = 范围内 enter_number 之和；本期发出 = 范围内 out_number 之和；
 * - 期末结存 = 期初 + 本期收入 - 本期发出。
 * 数据通过通用动态表接口 /kuerp/goods-log/index 拉取并按 goods_id 聚合。
 */
import { ref, computed } from 'vue';
import { message } from '@/utils/ui';
import request from '../utils/request';

const goodsId = ref(null);
const storesId = ref(null);
const goodsKw = ref('');
// 日期范围：DsDatePicker 无 range 模式，拆为起止两个日期字符串（YYYY-MM-DD）
const startDate = ref('');
const endDate = ref('');
const goodsList = ref([]);
const warehouses = ref([]);
const periodRows = ref([]);
const loading = ref(false);
const opening = ref(0);
const income = ref(0);
const outcome = ref(0);

const closing = computed(() => opening.value + income.value - outcome.value);
const computed_ = computed(() => periodRows.value.length > 0 || opening.value !== 0 || income.value !== 0);

/** 商品下拉选项：由关键字远程检索结果生成 */
const goodsOptions = computed(() =>
  goodsList.value.map((g) => ({ value: g.id, label: `${g.goods_name} (${g.goods_code})` })),
);

/** 仓库下拉选项 */
const warehouseOptions = computed(() =>
  warehouses.value.map((w) => ({ value: w.id, label: w.name || w.code })),
);

/** 流水明细列定义 */
const cols = [
  { key: 'purchase_code', title: '单据号', width: '160px' },
  { key: 'business_type', title: '业务类型', width: '120px', slot: true },
  { key: 'enter_number', title: '收入数量', width: '110px', align: 'right', slot: true },
  { key: 'out_number', title: '发出数量', width: '110px', align: 'right', slot: true },
  { key: 'balance_basics', title: '结存数量', width: '110px', align: 'right', slot: true },
  { key: 'createtime', title: '单据日期', width: '140px', slot: true },
];

/**
 * 把 'YYYY-MM-DD' 日期串转为秒级时间戳。
 * @param d 日期串；end=true 时取当天 23:59:59
 * @returns 秒级时间戳，空串返回 null
 */
function dayTs(d, end = false) {
  if (!d) return null;
  const ms = new Date(`${d}T00:00:00`).getTime();
  if (Number.isNaN(ms)) return null;
  return Math.floor(ms / 1000) + (end ? 86399 : 0);
}

/** 业务类型字典（与原系统 goods_log.business_type 对齐） */
const BIZ = {
  '1': '期初余额', '2': '采购', '3': '采购退回', '4': '销售', '5': '销售退回',
  '6': '调拨', '7': '成本调整', '8': '盘盈', '9': '其他入库', '10': '盘亏',
  '11': '其他出库', '12': '组装', '13': '组装', '14': '拆卸', '15': '拆卸', '17': '生产',
};
function bizType(t) { return BIZ[String(t)] || t; }

function num(v) { return Number(v || 0).toLocaleString('zh-CN', { maximumFractionDigits: 2 }); }
function fmtTime(s) {
  if (!s) return '-';
  const d = new Date(Number(s) * 1000);
  return d.toLocaleDateString('zh-CN');
}

/** 商品远程检索 */
async function searchGoods(k) {
  if (!k) return;
  const r = await request.get('/kuerp/goods/index', { params: { search: k, limit: 20 } });
  goodsList.value = r?.list || [];
}

/** 拉取仓库下拉 */
async function loadWarehouses() {
  const r = await request.get('/kuerp/warehouse/index', { params: { limit: 200 } });
  warehouses.value = r?.list || [];
}

/** 生成查询参数（含仓库过滤与日期范围） */
function baseParams(extra = {}) {
  const p = { filter: { goods_id: goodsId.value }, limit: 1000, ...extra };
  if (storesId.value) p.filter.stores_id = storesId.value;
  return p;
}

/** 执行期间查询 */
async function query() {
  if (!goodsId.value) { message.warning('请选择商品'); return; }
  loading.value = true;
  try {
    // 起始日（含）与结束日（含当天 23:59:59）
    const start = dayTs(startDate.value);
    const end = dayTs(endDate.value, true);

    // 期初：起始日之前所有记录（不含当天）
    const openingRows = await fetchLogs({ ...baseParams(), endtime: start ? start - 1 : undefined });
    const op = openingRows.reduce((s, r) => s + (Number(r.enter_number) || 0) - (Number(r.out_number) || 0), 0);

    // 本期：范围内记录
    const params = baseParams();
    if (start) params.starttime = start;
    if (end) params.endtime = end;
    const rows = await fetchLogs(params);

    const inc = rows.reduce((s, r) => s + (Number(r.enter_number) || 0), 0);
    const out = rows.reduce((s, r) => s + (Number(r.out_number) || 0), 0);

    opening.value = round2(op);
    income.value = round2(inc);
    outcome.value = round2(out);
    periodRows.value = rows;
  } finally {
    loading.value = false;
  }
}

/** 拉取收发明细（统一分页拉满 1000 行，前端聚合） */
async function fetchLogs(params) {
  const r = await request.get('/kuerp/goods-log/index', { params });
  return r?.list || [];
}

function round2(v) { return Math.round(v * 100) / 100; }

function reset() {
  startDate.value = '';
  endDate.value = '';
  goodsKw.value = '';
  storesId.value = null;
  periodRows.value = [];
  opening.value = income.value = outcome.value = 0;
}

loadWarehouses();
</script>

<style scoped>
.filter-bar { display: flex; flex-wrap: wrap; gap: 4px 16px; align-items: flex-end; }
.goods-pick { display: flex; gap: 6px; align-items: center; }
.btn-row { display: flex; gap: 8px; }
.metrics { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin: 12px 0 4px; }
.mt { margin-top: 12px; }
</style>
