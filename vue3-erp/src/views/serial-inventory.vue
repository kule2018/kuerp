<template>
  <div class="serial-inventory">
    <!-- ============ 工具栏 ============ -->
    <DsCard class="toolbar">
      <DsInput v-model="search" placeholder="检索盘点编号" clearable style="width: 220px" @keyup.enter="loadList" @clear="loadList" />
      <DsButton variant="primary" style="margin-left: 8px" @click="loadList">查询</DsButton>
      <DsButton variant="primary" style="margin-left: auto" @click="openAdd">新增序列号盘点</DsButton>
    </DsCard>

    <!-- ============ 盘点单列表 ============ -->
    <DsTable :columns="listCols" :data="list" row-key="id" :loading="loading">
      <template #purchase_time="{ row }">{{ fmtDate(row.purchase_time) }}</template>
      <template #store_type="{ row }">
        <DsTag :color="Number(row.store_type) === 1 ? 'info' : 'success'" size="sm">
          {{ Number(row.store_type) === 1 ? '全部仓库' : '单仓' }}
        </DsTag>
      </template>
      <template #action="{ row }">
        <DsButton variant="text" size="sm" @click="openView(row)">查看</DsButton>
        <DsButton variant="text" size="sm" @click="remove(row)">删除</DsButton>
      </template>
    </DsTable>

    <!-- ============ 新增盘点弹窗 ============ -->
    <DsModal v-model="dialog" title="新增序列号盘点" :width="1180">
      <div class="ds-form ds-form--inline head-form">
        <DsField label="盘点编号">
          <DsInput v-model="form.purchase_code" style="width: 200px" />
        </DsField>
        <DsField label="盘点时间">
          <DsDatePicker v-model="purchaseTimeStr" type="datetime" style="width: 190px" />
        </DsField>
        <DsField label="盘点仓库">
          <DsSelect v-model="form.store_type" :options="storeTypeOptions" style="width: 140px" @change="loadStock" />
        </DsField>
        <DsField v-if="Number(form.store_type) === 2" label="仓库">
          <DsSelect
            v-model="form.stores_id"
            :options="warehouseOptions"
            filterable
            clearable
            placeholder="请选择仓库"
            style="width: 180px"
            @change="loadStock"
          />
        </DsField>
        <DsField>
          <DsButton variant="primary" @click="loadStock">加载在库序列号</DsButton>
        </DsField>
      </div>

      <div class="table-scroll">
        <DsTable :columns="rowCols" :data="rows" row-key="_k" striped>
          <template #stores_id="{ row }">{{ storeName(row.stores_id) }}</template>
          <template #profit="{ row }">
            <span :class="row.profit > 0 ? 'up' : row.profit < 0 ? 'down' : ''">{{ row.profit }}</span>
          </template>
          <template #_serials="{ row }">
            <DsButton size="sm" variant="default" @click="openSerial(row)">
              {{ row._serials.length ? `${row._serials.length} 个` : '录入' }}
            </DsButton>
          </template>
        </DsTable>
      </div>

      <div class="totals">
        <span>系统库存合计：<b>{{ totals.stock }}</b></span>
        <span>盘点库存合计：<b>{{ totals.inventory }}</b></span>
        <span>盘盈合计：<b class="up">{{ totals.up }}</b></span>
        <span>盘亏合计：<b class="down">{{ totals.down }}</b></span>
      </div>

      <template #footer>
        <DsButton @click="dialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="save">保存盘点</DsButton>
      </template>
    </DsModal>

    <!-- ============ 序列号录入 ============ -->
    <DsModal v-model="serialDialog" title="录入盘点序列号" :width="520">
      <DsAlert type="info" :closable="false" show-icon title="每行一个序列号，系统自动与在库序列号比对" style="margin-bottom: 8px" />
      <div class="sys-list">
        <span class="sys-title">在库序列号（系统）：</span>
        <DsTag v-for="s in serialRow?._system || []" :key="s" size="sm" class="sys-tag">{{ s }}</DsTag>
        <span v-if="!(serialRow?._system || []).length">—</span>
      </div>
      <DsInput v-model="serialText" type="textarea" :rows="10" placeholder="SN001&#10;SN002" />
      <template #footer>
        <DsButton @click="serialDialog = false">取消</DsButton>
        <DsButton variant="primary" @click="confirmSerial">确定</DsButton>
      </template>
    </DsModal>

    <!-- ============ 查看历史盘点明细 ============ -->
    <DsModal v-model="viewDialog" :title="`盘点明细 ${current?.purchase_code || ''}`" :width="980">
      <div class="table-scroll">
        <DsTable :columns="viewCols" :data="viewRows" row-key="id" striped>
          <template #stores_id="{ row }">{{ storeName(row.stores_id) }}</template>
        </DsTable>
      </div>
    </DsModal>
  </div>
</template>

<script setup>
/**
 * 序列号盘点（对应开发文档 7.仓库/12.序列号盘点.md）：
 * 对启用序列号管理的商品，按仓库逐个录入实盘序列号，系统自动与在库序列号比对，
 * 得出「匹配 / 盘盈 / 盘亏 / 盈亏」并落库 kuerp_inventory_serial_info。
 *
 * 整体思路：
 *   1. 先据表头的「盘点仓库」口径（全部仓库 / 单仓）从 kuerp_goods_serial 聚合出
 *      各商品在各仓的「系统在库序列号」（store_status=1 表示在库）；
 *   2. 用户逐行录入实盘序列号，页面与系统序列号做集合比对：
 *        匹配   = 实盘 ∩ 系统（数量）
 *        盘盈   = 实盘 - 系统（多出来的序列号数）
 *        盘亏   = 系统 - 实盘（缺失的序列号数）
 *        盈亏   = 盘点库存 - 系统库存 = 盘盈 - 盘亏
 *   3. 保存时表头写 kuerp_inventory_serial（含盘点结果摘要），明细逐行写
 *      kuerp_inventory_serial_info。
 */
import { ref, reactive, computed, onMounted } from 'vue';
import { message, confirm } from '@/utils/ui';
import request from '../utils/request';

const API = '/kuerp/inventory-serial';
const INFO_API = '/kuerp/inventory-serial-info';

// —— 表格列定义（DsTable 以 columns 数组描述列，slot:true 表示用同名插槽渲染） ——

/** 盘点单列表列 */
const listCols = [
  { key: 'purchase_code', title: '盘点编号', width: '200px' },
  { key: 'purchase_time', title: '盘点时间', width: '120px', slot: true },
  { key: 'store_type', title: '盘点仓库', width: '120px', slot: true },
  { key: 'result', title: '盘点结果', width: '240px' },
  { key: 'action', title: '操作', width: '120px', align: 'right', slot: true },
];

/** 新增盘点明细列 */
const rowCols = [
  { key: 'goods_code', title: '商品编号', width: '130px' },
  { key: 'goods_name', title: '商品名称', width: '160px' },
  { key: 'stores_id', title: '仓库', width: '130px', slot: true },
  { key: 'stock', title: '系统库存', width: '90px', align: 'right' },
  { key: '_serials', title: '盘点序列号', width: '180px', slot: true },
  { key: 'invertory_stock', title: '盘点库存', width: '90px', align: 'right' },
  { key: 'profit', title: '盈亏', width: '90px', align: 'right', slot: true },
  { key: 'matching', title: '匹配', width: '80px', align: 'right' },
  { key: 'inventory', title: '盘盈', width: '80px', align: 'right' },
  { key: 'loss', title: '盘亏', width: '80px', align: 'right' },
];

/** 历史盘点明细列 */
const viewCols = [
  { key: 'goods_id', title: '商品ID', width: '90px' },
  { key: 'stores_id', title: '仓库', width: '130px', slot: true },
  { key: 'stock', title: '系统库存', width: '90px', align: 'right' },
  { key: 'invertory_stock', title: '盘点库存', width: '90px', align: 'right' },
  { key: 'profit', title: '盈亏', width: '80px', align: 'right' },
  { key: 'matching', title: '匹配', width: '80px', align: 'right' },
  { key: 'inventory', title: '盘盈', width: '80px', align: 'right' },
  { key: 'loss', title: '盘亏', width: '80px', align: 'right' },
  { key: 'period_period', title: '盘点序列号', width: '220px' },
];

// —— 列表状态 ——
const list = ref([]);
const loading = ref(false);
const search = ref('');

// —— 弹窗状态 ——
const dialog = ref(false);
const saving = ref(false);
const form = ref({});
const rows = ref([]);
const warehouses = ref([]);

// —— 序列号录入 ——
const serialDialog = ref(false);
const serialRow = ref(null);
const serialText = ref('');

// —— 历史明细查看 ——
const viewDialog = ref(false);
const viewRows = ref([]);
const current = ref(null);

/**
 * 盘点时间的字符串桥接。
 * 后端 kuerp_inventory_serial.purchase_time 存秒级时间戳，而 DsDatePicker 的
 * modelValue 约定为 'YYYY-MM-DD HH:mm' 字符串，这里用可写计算属性双向转换。
 */
const purchaseTimeStr = computed({
  get() {
    const t = Number(form.value?.purchase_time);
    if (!t) return '';
    const d = new Date(t * 1000);
    const p = (n) => String(n).padStart(2, '0');
    return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
  },
  set(v) {
    if (!v) { form.value.purchase_time = 0; return; }
    const ms = new Date(String(v).replace(' ', 'T')).getTime();
    form.value.purchase_time = Number.isNaN(ms) ? 0 : Math.floor(ms / 1000);
  },
});

/** 盘点仓库口径选项 */
const storeTypeOptions = [
  { value: '1', label: '全部仓库' },
  { value: '2', label: '单仓' },
];

/** 仓库下拉选项（DsSelect 以 options 数组代替内联 el-option） */
const warehouseOptions = computed(() =>
  warehouses.value.map((w) => ({ value: w.id, label: w.name })),
);

/** 合计：系统库存 / 盘点库存 / 盘盈 / 盘亏 */
const totals = computed(() => {
  const t = { stock: 0, inventory: 0, up: 0, down: 0 };
  for (const r of rows.value) {
    t.stock += Number(r.stock) || 0;
    t.inventory += Number(r.invertory_stock) || 0;
    t.up += Number(r.inventory) || 0;
    t.down += Number(r.loss) || 0;
  }
  return t;
});

/** 秒级时间戳 → 日期串 */
function fmtDate(v) {
  if (!v) return '-';
  const d = new Date(Number(v) * 1000);
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}
/** 仓库ID → 名称 */
function storeName(id) {
  const w = warehouses.value.find((x) => String(x.id) === String(id));
  return w ? w.name : id || '-';
}

/** 生成盘点编号：XLHPD + 年月日时分秒 */
function genCode() {
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  return `XLHPD${d.getFullYear()}${p(d.getMonth() + 1)}${p(d.getDate())}${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
}

// ============================================================
// 数据加载
// ============================================================

/** 加载盘点单列表 */
async function loadList() {
  loading.value = true;
  try {
    const r = await request.get(`${API}/index`, { params: { limit: 500, search: search.value || undefined } });
    list.value = r?.list || [];
  } finally {
    loading.value = false;
  }
}

/** 加载仓库下拉 */
async function loadWarehouses() {
  const r = await request.get('/kuerp/stores/index', { params: { limit: 500 } });
  warehouses.value = (r?.list || []).map((x) => ({ id: x.id, name: x.name || x.store_code || String(x.id) }));
}

/**
 * 加载在库序列号：按商品 + 仓库聚合 store_status=1（在库）的序列号。
 * 聚合结果作为「系统库存 / 系统序列号」基准，供录入实盘序列号后比对。
 */
async function loadStock() {
  const params = { limit: 1000, filter: JSON.stringify({ store_status: 1 }) };
  const r = await request.get('/kuerp/goods-serial/index', { params });
  const all = r?.list || [];
  // 单仓口径下过滤所选仓库
  const filtered = Number(form.value.store_type) === 2 && form.value.stores_id
    ? all.filter((x) => Number(x.stores_id) === Number(form.value.stores_id))
    : all;

  // 按 (商品编号 + 仓库 + 属性) 聚合
  const map = new Map();
  for (const s of filtered) {
    const key = `${s.goods_code}|${s.stores_id || 0}|${s.attribute_id || 0}`;
    if (!map.has(key)) {
      map.set(key, {
        _k: key,
        goods_code: s.goods_code,
        goods_name: s.goods_name || '',
        goods_id: s.goods_id || 0,
        stores_id: s.stores_id || 0,
        goods_attr: Number(s.attribute_id) || 0,
        goods_type: 0,
        _system: [],
        _serials: [],
        stock: 0,
        invertory_stock: 0,
        profit: 0,
        matching: 0,
        inventory: 0,
        loss: 0,
        period_period: '',
      });
    }
    const row = map.get(key);
    if (s.serial) row._system.push(String(s.serial));
  }
  const out = [...map.values()];
  out.forEach((row) => {
    row.stock = row._system.length;
    row.invertory_stock = row.stock; // 默认实盘 = 系统，待用户录入后重算
    row._serials = row._system.slice();
    recalcRow(row);
  });
  // 商品名称：按编号批量回查
  const codes = [...new Set(out.map((r) => r.goods_code).filter(Boolean))];
  if (codes.length) {
    const g = await request.get('/kuerp/goods/index', { params: { limit: 500 } });
    const gm = {};
    (g?.list || []).forEach((x) => (gm[x.goods_code] = x));
    out.forEach((r) => {
      const info = gm[r.goods_code];
      if (info) {
        r.goods_name = info.goods_name || r.goods_name;
        r.goods_id = info.id;
        r.goods_type = info.goods_type_id || 0;
      }
    });
  }
  rows.value = out;
  if (!out.length) message.info('当前条件下没有在库序列号');
}

// ============================================================
// 序列号录入与比对
// ============================================================

/** 打开序列号录入 */
function openSerial(row) {
  serialRow.value = row;
  serialText.value = (row._serials || []).join('\n');
  serialDialog.value = true;
}

/** 确认录入：与系统序列号做集合比对，算出匹配/盘盈/盘亏/盈亏 */
function confirmSerial() {
  if (!serialRow.value) return;
  const arr = serialText.value.split('\n').map((s) => s.trim()).filter(Boolean);
  if (new Set(arr).size !== arr.length) {
    message.warning('序列号重复');
    return;
  }
  serialRow.value._serials = arr;
  serialRow.value.period_period = arr.join(',');
  recalcRow(serialRow.value);
  serialDialog.value = false;
}

/**
 * 单行比对重算（集合运算）：
 *   匹配 = 实盘 ∩ 系统；盘盈 = 实盘 - 系统；盘亏 = 系统 - 实盘；
 *   盘点库存 = 实盘数量；盈亏 = 盘点库存 - 系统库存（等价于 盘盈 - 盘亏）。
 * @param row 明细行
 */
function recalcRow(row) {
  const sys = new Set(row._system || []);
  const act = new Set(row._serials || []);
  let matching = 0;
  act.forEach((s) => {
    if (sys.has(s)) matching += 1;
  });
  const inventory = act.size - matching; // 盘盈：实盘有而系统无
  const loss = sys.size - matching;      // 盘亏：系统有而实盘无
  row.invertory_stock = act.size;
  row.matching = matching;
  row.inventory = inventory;
  row.loss = loss;
  row.profit = inventory - loss;
}

// ============================================================
// 新增 / 保存 / 删除 / 查看
// ============================================================

/** 打开新增 */
function openAdd() {
  form.value = {
    purchase_code: genCode(),
    purchase_time: Math.floor(Date.now() / 1000),
    store_type: '1',
    stores_id: null,
  };
  rows.value = [];
  dialog.value = true;
}

/** 保存盘点：表头 + 明细（明细逐行写 inventory_serial_info） */
async function save() {
  if (!rows.value.length) {
    message.warning('请先加载在库序列号');
    return;
  }
  saving.value = true;
  try {
    const head = { ...form.value };
    const up = totals.value.up;
    const down = totals.value.down;
    head.result = `盘盈 ${up} 个，盘亏 ${down} 个，匹配 ${rows.value.reduce((s, r) => s + (Number(r.matching) || 0), 0)} 个`;
    const res = await request.post(`${API}/add`, head);
    const headId = res?.insertId || res?.data?.id;
    const code = head.purchase_code;
    for (const r of rows.value) {
      await request.post(`${INFO_API}/add`, {
        purchase_code: code,
        purchase_time: head.purchase_time,
        goods_type: r.goods_type || 0,
        goods_id: r.goods_id || 0,
        stores_id: r.stores_id || 0,
        goods_attr: r.goods_attr || 0,
        stock: r.stock,
        invertory_stock: r.invertory_stock,
        profit: r.profit,
        period_period: r.period_period || '',
        matching: r.matching,
        inventory: r.inventory,
        loss: r.loss,
      });
    }
    void headId;
    message.success('盘点保存成功');
    dialog.value = false;
    await loadList();
  } catch (e) {
    message.error('保存失败：' + (e?.message || '接口错误'));
  } finally {
    saving.value = false;
  }
}

/** 删除盘点单 */
async function remove(row) {
  await confirm(`确认删除盘点单 ${row.purchase_code}？`, '提示', { type: 'warning' });
  await request.post(`${API}/del`, { id: row.id });
  message.success('删除成功');
  await loadList();
}

/** 查看历史盘点明细（按盘点编号拉取） */
async function openView(row) {
  current.value = row;
  const r = await request.get(`${INFO_API}/index`, {
    params: { limit: 500, filter: JSON.stringify({ purchase_code: row.purchase_code }) },
  });
  viewRows.value = r?.list || [];
  viewDialog.value = true;
}

onMounted(async () => {
  await loadWarehouses();
  await loadList();
});
</script>

<style scoped>
.serial-inventory { display: flex; flex-direction: column; gap: 10px; }
.toolbar :deep(.ds-card-c__body) { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
/* 表头表单：排版由全局 .ds-form--inline 负责 */
.head-form { margin-bottom: 12px; }
/* 明细表格固定高度并滚动，替代原 el-table 的 height 属性 */
.table-scroll { max-height: 420px; overflow: auto; }
.totals { display: flex; gap: 24px; justify-content: flex-end; padding: 8px 4px; font-size: 13px; }
.up { color: #f56c6c; font-weight: 600; }
.down { color: #67c23a; font-weight: 600; }
.sys-list { margin-bottom: 8px; }
.sys-title { font-size: 13px; color: #606266; margin-right: 6px; }
.sys-tag { margin-right: 4px; margin-bottom: 4px; }
</style>
