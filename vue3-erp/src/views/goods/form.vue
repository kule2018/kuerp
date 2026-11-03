<template>
  <DsCard>
    <template #title>
      <div class="head">
        <span>{{ id ? '编辑商品' : '新增商品' }}</span>
        <div>
          <DsButton variant="primary" :loading="loading" @click="onSave">保存</DsButton>
          <DsButton @click="$router.back()">返回</DsButton>
        </div>
      </div>
    </template>

    <DsTabs v-model="tab" :items="tabs" variant="line" class="mb" />

    <!-- ==================== 基本信息 ==================== -->
    <div v-if="tab === 'base'" class="grid-3">
      <DsField label="商品编号">
        <DsInput v-model="form.goods_code" placeholder="留空系统生成" />
      </DsField>
      <DsField label="商品名称">
        <DsInput v-model="form.goods_name" />
      </DsField>
      <DsField label="商品条码">
        <DsInput v-model="form.goods_barcode" />
      </DsField>
      <DsField label="规格型号">
        <DsInput v-model="form.goods_specification_id" />
      </DsField>
      <DsField label="商品类别">
        <DsSelect v-model="form.goods_type_id" :options="typeOptions" filterable style="width: 100%" />
      </DsField>
      <DsField label="计量单位">
        <DsSelect v-model="form.unit_id" :options="unitOptions" filterable style="width: 100%" />
      </DsField>
      <DsField label="首选仓库">
        <DsSelect v-model="form.manager_warehouse_id" :options="storeOptions" clearable style="width: 100%" />
      </DsField>
      <DsField label="首选入库单位">
        <DsSelect v-model="form.warehousing" :options="unitOptions" clearable style="width: 100%" />
      </DsField>
      <DsField label="首选出库单位">
        <DsSelect v-model="form.warehouse" :options="unitOptions" clearable style="width: 100%" />
      </DsField>
    </div>

    <template v-if="tab === 'base'">
      <DsDivider align="left">属性与开关</DsDivider>
      <div class="grid-4">
        <DsField label="多计量单位">
          <DsSwitch v-model="fMoreUnit" />
        </DsField>
        <DsField label="多单位组">
          <DsSelect v-model="form.more_unit_id" :options="unitConvOptions" clearable filterable style="width: 100%" />
        </DsField>
        <DsField label="多属性">
          <DsSwitch v-model="fMoreAttribute" />
        </DsField>
        <DsField label="辅助属性">
          <DsSelect v-model="form.auxiliary" :options="auxOptions" clearable style="width: 100%" />
        </DsField>
        <DsField label="批次保质期">
          <DsSwitch v-model="fBatch" />
        </DsField>
        <DsField label="保质期天数">
          <DsInput type="number" v-model="form.shelf_life" :min="0" style="width: 100%" />
        </DsField>
        <DsField label="预警天数">
          <DsInput type="number" v-model="form.early_warning" :min="0" style="width: 100%" />
        </DsField>
        <DsField label="序列号">
          <DsSwitch v-model="fSerial" />
        </DsField>
      </div>

      <div class="grid-4">
        <DsField label="状态">
          <DsSegmented v-model="form.status" :options="statusOptions" size="sm" />
        </DsField>
        <DsField label="常用商品">
          <DsSwitch v-model="fIsOfften" />
        </DsField>
        <DsField label="订货通显示">
          <DsSwitch v-model="fOrderStatus" />
        </DsField>
        <DsField label="促销商品">
          <DsSwitch v-model="fPromotion" />
        </DsField>
      </div>

      <DsField label="商品主图">
        <DsUploadField
          v-model="form.goods_image"
          accept=".jpg,.jpeg,.png,.gif,.webp,.bmp"
          tip="列表与订货通小程序展示用，建议正方形，单张不超过 10MB"
        />
      </DsField>
      <DsField label="商品图集">
        <DsUploadField
          v-model="form.goods_images"
          multiple
          accept=".jpg,.jpeg,.png,.gif,.webp,.bmp"
          tip="可多选，详情轮播用；保存为逗号分隔的地址串（与原系统格式一致）"
        />
      </DsField>
      <DsField label="备注">
        <DsInput v-model="form.note" type="textarea" />
      </DsField>
    </template>

    <!-- ==================== 价格 ==================== -->
    <div v-if="tab === 'price'" class="grid-3">
      <DsField label="零售价">
        <DsInput type="number" v-model="form.market_sell_price" :min="0" style="width: 100%" />
      </DsField>
      <DsField label="批发价">
        <DsInput type="number" v-model="form.wholesale_price" :min="0" style="width: 100%" />
      </DsField>
      <DsField label="VIP会员价">
        <DsInput type="number" v-model="form.vip_price" :min="0" style="width: 100%" />
      </DsField>
      <DsField label="折扣率1(%)">
        <DsInput type="number" v-model="form.discount" :min="0" :max="100" style="width: 100%" />
      </DsField>
      <DsField label="折扣率2(%)">
        <DsInput type="number" v-model="form.discount2" :min="0" :max="100" style="width: 100%" />
      </DsField>
      <DsField label="预计采购价">
        <DsInput type="number" v-model="form.purchase" :min="0" style="width: 100%" />
      </DsField>
    </div>

    <!-- ==================== 期初与预警 ==================== -->
    <template v-if="tab === 'stock'">
      <div class="grid-3">
        <DsField label="期初数量">
          <DsInput type="number" v-model="form.period" :min="0" style="width: 100%" />
        </DsField>
        <DsField label="单位成本">
          <DsInput type="number" v-model="form.unit_cost" :min="0" style="width: 100%" @change="calcPeriodPrice" />
        </DsField>
        <DsField label="期初总价">
          <DsInput type="number" v-model="form.price" :min="0" style="width: 100%" />
        </DsField>
        <DsField label="库存预警">
          <DsSwitch v-model="fStockWarning" />
        </DsField>
        <DsField label="最低库存">
          <DsInput type="number" v-model="form.min_stock" :min="0" style="width: 100%" />
        </DsField>
        <DsField label="最高库存">
          <DsInput type="number" v-model="form.max_stock" :min="0" style="width: 100%" />
        </DsField>
        <DsField label="分仓预警">
          <DsSwitch v-model="fBranch" />
        </DsField>
      </div>

        <!-- 分仓库存预警子表：写入 kuerp_goods_stock_warning（库存预警报表与智能补货的数据源） -->
        <div class="sub-title">
          分仓预警设置
          <DsButton variant="text" @click="fillWarningRows">按仓库列表填充</DsButton>
          <span class="sec-tip">仅「分仓预警」开启时生效；智能补货按此处的最低库存计算建议采购量</span>
        </div>
        <DsTable :columns="warnCols" :data="warningRows" row-key="stores_id" striped>
          <template #stores_id="{ row }">
            <DsSelect v-model="row.stores_id" :options="storeOptions" size="sm" style="width: 100%" />
          </template>
          <template #status="{ row }">
            <DsSelect v-model="row.status" :options="warnStatusOptions" size="sm" style="width: 100%" />
          </template>
          <template #stock_warning="{ row }">
            <DsSwitch :model-value="rowOn(row, 'stock_warning')" @update:modelValue="(v) => rowSet(row, 'stock_warning', v)" />
          </template>
          <template #min_stock="{ row }">
            <DsInput type="number" v-model="row.min_stock" :min="0" size="sm" style="width: 100%" />
          </template>
          <template #max_stock="{ row }">
            <DsInput type="number" v-model="row.max_stock" :min="0" size="sm" style="width: 100%" />
          </template>
          <template #op="{ row }">
            <DsButton variant="text" size="sm" @click="removeWarning(row)">删</DsButton>
          </template>
        </DsTable>
    </template>
  </DsCard>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { message } from '@/utils/ui';
import request from '../../utils/request';

const route = useRoute();
const router = useRouter();
const id = Number(route.query.id) || 0;
const loading = ref(false);
const tab = ref('base');

// —— 下拉选项数据源 ——
const types = ref([]);        // 商品类别
const units = ref([]);        // 计量单位
const unitConvs = ref([]);    // 单位换算（多计量）
const auxiliaries = ref([]);  // 辅助属性
const stores = ref([]);       // 仓库
const warningRows = ref([]);  // 分仓预警子表

/**
 * 商品表单默认值（覆盖 kuerp_goods 主要业务字段）。
 * 说明：enum 字段统一以字符串 '0'/'1' 交互，与数据库 enum 一一对应。
 */
const form = ref({
  goods_code: '', goods_name: '', goods_barcode: '', goods_specification_id: '',
  goods_type_id: null, unit_id: null, manager_warehouse_id: null,
  warehousing: null, warehouse: null,
  more_unit: '2', more_unit_id: null, more_attribute: '0', auxiliary: null,
  batch: 0, shelf_life: 0, early_warning: 0, serial: 0,
  status: '1', is_offten: '0', order_status: '1', promotion: '0',
  market_sell_price: 0, wholesale_price: 0, vip_price: 0,
  discount: 0, discount2: 0, purchase: 0,
  period: 0, unit_cost: 0, price: 0,
  stock_warning: '0', min_stock: 0, max_stock: 0, branch: '0',
  goods_image: '', goods_images: '', note: '',
});

/** 选项卡定义（DsTabs 无内容插槽，面板按当前值条件渲染） */
const tabs = [
  { value: 'base', label: '基本信息' },
  { value: 'price', label: '价格' },
  { value: 'stock', label: '期初/预警' },
];

/**
 * enum 字段桥接为 DsSwitch 的布尔值。
 * 数据库这些字段为 enum('0','1')（more_unit 为 '1'/'2'），而 DsSwitch 只接受布尔，
 * 因此用可写计算属性在「布尔开关」与「字符串枚举」之间双向转换。
 * @param field 表单字段名
 * @param onVal 开启时写入的值
 * @param offVal 关闭时写入的值
 * @returns 可写计算属性
 */
function flag(field, onVal = '1', offVal = '0') {
  return computed({
    get: () => String(form.value[field]) === String(onVal),
    set: (v) => { form.value[field] = v ? onVal : offVal; },
  });
}

const fMoreUnit = flag('more_unit', '1', '2');
const fMoreAttribute = flag('more_attribute');
const fBatch = flag('batch');
const fSerial = flag('serial');
const fIsOfften = flag('is_offten');
const fOrderStatus = flag('order_status');
const fPromotion = flag('promotion');
const fStockWarning = flag('stock_warning');

/** 分仓预警开关：开启时若子表为空则自动按仓库列表填充 */
const fBranch = computed({
  get: () => String(form.value.branch) === '1',
  set: (v) => {
    form.value.branch = v ? '1' : '0';
    if (v && !warningRows.value.length) fillWarningRows();
  },
});

/** 上下架状态选项（DsSegmented 代替 el-radio-group） */
const statusOptions = [
  { value: '1', label: '上架' },
  { value: '0', label: '下架' },
];

// —— 下拉选项（DsSelect 以 options 数组代替内联 el-option） ——
const typeOptions = computed(() => types.value.map((t) => ({ value: t.id, label: t.supplier_type_name })));
const unitOptions = computed(() => units.value.map((u) => ({ value: u.id, label: u.name })));
const unitConvOptions = computed(() => unitConvs.value.map((u) => ({ value: u.id, label: unitConvLabel(u) })));
const auxOptions = computed(() => auxiliaries.value.map((a) => ({ value: a.id, label: a.name })));
const storeOptions = computed(() => stores.value.map((s) => ({ value: s.id, label: s.name })));

/** 分仓预警「状态」列选项 */
const warnStatusOptions = [
  { value: '1', label: '正常' },
  { value: '0', label: '关仓' },
];

/** 分仓预警子表列定义 */
const warnCols = [
  { key: 'stores_id', title: '仓库', width: '180px', slot: true },
  { key: 'status', title: '状态', width: '120px', slot: true },
  { key: 'stock_warning', title: '启用预警', width: '110px', slot: true },
  { key: 'min_stock', title: '最低库存', width: '150px', slot: true },
  { key: 'max_stock', title: '最高库存', width: '150px', slot: true },
  { key: 'op', title: '', width: '70px', align: 'center', slot: true },
];

/** 子表行 enum 字段的布尔读取（供 DsSwitch 的 :model-value） */
function rowOn(row, key) {
  return String(row[key]) === '1';
}

/** 子表行 enum 字段的布尔写回（供 DsSwitch 的 @update:modelValue） */
function rowSet(row, key, v) {
  row[key] = v ? '1' : '0';
}

/** 删除一行分仓预警设置 */
function removeWarning(row) {
  warningRows.value = warningRows.value.filter((r) => r !== row);
}

/** 下拉数据加载：类别 / 单位 / 单位换算 / 辅助属性 / 仓库 */
async function loadOptions() {
  const [t, u, uc, a, s] = await Promise.all([
    request.get('/kuerp/goods-type/index', { params: { limit: 500 } }),
    request.get('/kuerp/unit/index', { params: { limit: 500 } }),
    request.get('/kuerp/unit-conversion/index', { params: { limit: 500 } }),
    request.get('/kuerp/auxiliary/index', { params: { limit: 500 } }),
    request.get('/kuerp/stores/index', { params: { limit: 500 } }),
  ]);
  types.value = t?.list || [];
  units.value = u?.list || [];
  unitConvs.value = uc?.list || [];
  auxiliaries.value = a?.list || [];
  stores.value = s?.list || [];
}

/** 单位换算项显示名：主单位 -> 副单位(换算率) */
function unitConvLabel(u) {
  const main = (units.value.find((x) => x.id === u.main_unit) || {}).name || u.main_unit;
  const vice = (units.value.find((x) => x.id === u.vice_unit) || {}).name || u.vice_unit;
  return `1${main}=${u.advance_rate}${vice}`;
}

/** 期初总价 = 期初数量 × 单位成本（与商品期间期初口径一致） */
function calcPeriodPrice() {
  form.value.price = Math.round((Number(form.value.period) || 0) * (Number(form.value.unit_cost) || 0) * 10000) / 10000;
}

/** 按仓库列表填充分仓预警行（已存在的仓库跳过） */
function fillWarningRows() {
  for (const s of stores.value) {
    if (warningRows.value.some((r) => r.stores_id === s.id)) continue;
    warningRows.value.push({
      stores_id: s.id,
      status: '1',
      stock_warning: '0',
      min_stock: Number(form.value.min_stock) || 0,
      max_stock: Number(form.value.max_stock) || 0,
    });
  }
}

onMounted(async () => {
  await loadOptions();
  if (!id) return;
  const data = await request.get('/kuerp/goods/get', { params: { id } });
  if (data) form.value = { ...form.value, ...data };
  // 回填分仓预警子表
  const w = await request.get('/kuerp/goods-stock-warning/index', { params: { limit: 500, filter: JSON.stringify({ goods_id: id }) } });
  warningRows.value = (w?.list || []).map((r) => ({
    id: r.id,
    stores_id: r.stores_id,
    status: String(r.status ?? '1'),
    stock_warning: String(r.stock_warning ?? '0'),
    min_stock: Number(r.min_stock) || 0,
    max_stock: Number(r.max_stock) || 0,
  }));
});

async function onSave() {
  loading.value = true;
  try {
    let goodsId = id;
    if (id) {
      await request.post('/kuerp/goods/edit', { id, ...form.value });
    } else {
      const r = await request.post('/kuerp/goods/add', form.value);
      // 新增接口返回 { insertId }，用于回写分仓预警子表的外键
      goodsId = Number(r?.insertId) || 0;
    }
    // 分仓预警子表：先删后插（子表无独立更新接口，整体重写）
    if (goodsId) {
      const old = await request.get('/kuerp/goods-stock-warning/index', { params: { limit: 500, filter: JSON.stringify({ goods_id: goodsId }) } });
      for (const r of old?.list || []) {
        await request.post('/kuerp/goods-stock-warning/del', { ids: [r.id] });
      }
      for (const r of warningRows.value) {
        await request.post('/kuerp/goods-stock-warning/add', {
          goods_id: goodsId,
          goods_code: form.value.goods_code,
          stores_id: r.stores_id,
          status: r.status,
          stock_warning: r.stock_warning,
          min_stock: r.min_stock,
          max_stock: r.max_stock,
        });
      }
    }
    message.success('保存成功');
    router.back();
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped>
.head { display: flex; align-items: center; justify-content: space-between; }
/* 表单栅格：替代原 el-row / el-col 布局。
   行间距必须给值，否则多行字段会上下贴死（原来写成 gap: 0 16px）。 */
.grid-3 { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 18px 20px; align-items: start; }
.grid-4 { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 18px 20px; align-items: start; }
@media (max-width: 1280px) { .grid-4 { grid-template-columns: repeat(3, minmax(0, 1fr)); } }
@media (max-width: 1000px) { .grid-3, .grid-4 { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
@media (max-width: 640px) { .grid-3, .grid-4 { grid-template-columns: minmax(0, 1fr); } }
/* 同一区块里的多段栅格之间留白，避免上下两块字段糊在一起 */
.grid-3 + .grid-3, .grid-3 + .grid-4, .grid-4 + .grid-4, .grid-4 + .grid-3 { margin-top: 18px; }
/* 栅格后面紧跟的整宽字段（主图 / 图集 / 备注）同样要留白 */
.grid-3 + .ds-field, .grid-4 + .ds-field { margin-top: 18px; }
.mb { margin-bottom: 12px; }
.sub-title { margin: 12px 0 8px; font-weight: 600; }
.sec-tip { margin-left: 12px; font-weight: 400; font-size: 12px; color: #909399; }
</style>
