<template>
  <div class="uo">
    <!-- ===== 工具栏：检索 + 批量操作 ===== -->
    <DsCard class="toolbar">
      <div class="tb-left">
        <DsInput
          v-model="search"
          placeholder="订单号 / 收货人 / 电话"
          clearable
          style="width: 220px"
          @keyup.enter="onSearch"
          @clear="onSearch"
        />
        <DsSelect
          v-model="statusFilter"
          :options="statusFilterOptions"
          placeholder="全部状态"
          clearable
          style="width: 140px"
          @change="onSearch"
        />
        <DsButton variant="primary" @click="onSearch">查询</DsButton>
      </div>
      <div class="tb-right">
        <DsButton :disabled="!selected.length" @click="onBatchAudit">批量审核</DsButton>
        <DsButton :disabled="!selected.length" @click="openDeliver(selected.slice())">批量发货</DsButton>
        <DsButton variant="danger" :disabled="!selected.length" @click="onBatchDel">批量删除</DsButton>
      </div>
    </DsCard>

    <!-- ===== 订单列表 ===== -->
    <DsCard class="mt">
      <DsTable :columns="columns" :data="list" row-key="id" :loading="loading" striped>
        <template #__sel="{ row }">
          <DsCheckbox :model-value="isSelected(row)" @update:modelValue="() => toggleSel(row)" />
        </template>
        <template #order_num="{ row }">
          <DsButton variant="text" size="sm" @click="openDetail(row)">{{ row.order_num || '#' + row.id }}</DsButton>
        </template>
        <template #order_price="{ row }">{{ money(row.order_price) }}</template>
        <template #pay_status="{ row }">
          <DsTag :color="payColor(row.pay_status)" size="sm">{{ payText(row.pay_status) }}</DsTag>
        </template>
        <template #diver_type="{ row }">
          <DsTag :color="Number(row.diver_type) === 2 ? 'warning' : 'brand'" size="sm" variant="outline">
            {{ Number(row.diver_type) === 2 ? '到店自取' : '专业配送' }}
          </DsTag>
        </template>
        <template #status="{ row }">
          <DsTag :color="statusColor(row.status)" size="sm">{{ statusText(row.status) }}</DsTag>
        </template>
        <template #createtime="{ row }">{{ fmtTime(row.createtime) }}</template>
        <template #__action="{ row }">
          <DsButton variant="text" size="sm" @click="openDetail(row)">明细</DsButton>
          <DsButton v-if="canAudit(row)" variant="text" size="sm" @click="onAudit(row)">审核</DsButton>
          <DsButton v-if="canMakeSales(row)" variant="text" size="sm" @click="onToSales(row)">生成销货单</DsButton>
          <DsButton v-if="canDeliver(row)" variant="text" size="sm" @click="openDeliver([row.id])">发货</DsButton>
          <DsButton variant="text" size="sm" @click="openEdit(row)">编辑</DsButton>
          <DsButton variant="text-danger" size="sm" @click="onDel(row)">删除</DsButton>
        </template>
      </DsTable>

      <DsPagination
        class="mt"
        v-model:currentPage="page"
        v-model:pageSize="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @change="load"
      />
    </DsCard>

    <!-- ===== 订单明细抽屉 ===== -->
    <DsDrawer v-model="detailVisible" title="订单明细" :size="860">
      <div v-if="current" class="detail">
        <div class="section-title">收货信息</div>
        <div class="kv">
          <div><span class="k">订单号</span>{{ current.order_num || '-' }}</div>
          <div><span class="k">状态</span><DsTag :color="statusColor(current.status)" size="sm">{{ statusText(current.status) }}</DsTag></div>
          <div><span class="k">收货人</span>{{ current.name || '-' }}</div>
          <div><span class="k">联系电话</span>{{ current.phone || '-' }}</div>
          <div class="full"><span class="k">收货地址</span>{{ current.address || '-' }}</div>
          <div><span class="k">配送类型</span>{{ Number(current.diver_type) === 2 ? '到店自取' : '专业配送' }}</div>
          <div><span class="k">配送人</span>{{ current.diver_name || '-' }}</div>
          <div><span class="k">支付状态</span>{{ payText(current.pay_status) }}</div>
          <div><span class="k">订单总额</span>{{ money(current.order_price) }}</div>
          <div class="full"><span class="k">备注</span>{{ current.remark || '-' }}</div>
        </div>

        <div class="section-title mt">商品清单</div>
        <DsTable :columns="itemColumns" :data="items" row-key="id" striped>
          <template #goods_image="{ row }">
            <img v-if="row.goods_image" :src="row.goods_image" class="thumb" alt="" />
            <span v-else class="muted">无图</span>
          </template>
          <template #price="{ row }">{{ money(row.price) }}</template>
          <template #money="{ row }">{{ money(row.money) }}</template>
        </DsTable>

        <div class="detail-foot">
          <span>合计数量：<b>{{ totalNumber }}</b></span>
          <span>合计金额：<b>{{ money(current.order_price) }}</b></span>
        </div>
      </div>
    </DsDrawer>

    <!-- ===== 发货对话框（等价 deliver.html）===== -->
    <DsModal v-model="deliverVisible" title="订单发货" :width="560" @close="resetDeliver">
      <DsField label="发货方式">
        <DsSegmented v-model="deliverForm.send_type" :options="sendTypeOptions" block />
      </DsField>

      <!-- 专业配送：选择司机 -->
      <DsField v-if="deliverForm.send_type === 1" label="配送司机" class="mt">
        <DsSelect
          v-model="deliverForm.diver_id"
          :options="driverOptions"
          placeholder="请选择司机"
          filterable
          clearable
        />
      </DsField>

      <!-- 物流快递：选择快递公司 + 单号 -->
      <template v-else>
        <DsField label="快递公司" class="mt">
          <DsSelect
            v-model="deliverForm.express_code"
            :options="expressOptions"
            placeholder="请选择快递公司"
            filterable
            clearable
          />
        </DsField>
        <DsField label="快递单号" class="mt">
          <DsInput v-model="deliverForm.express_num" placeholder="请输入快递单号" />
        </DsField>
      </template>

      <DsAlert
        class="mt"
        type="info"
        :closable="false"
        show-icon
        description="发货前系统会自动校验：订单是否已审核、是否已生成销货单、是否已完成支付（若开启了「支付后发货」）。"
      />

      <template #footer>
        <DsButton variant="default" @click="deliverVisible = false">取消</DsButton>
        <DsButton variant="primary" :loading="delivering" @click="submitDeliver">确认发货</DsButton>
      </template>
    </DsModal>

    <!-- ===== 编辑对话框（等价 edit.html：仅收货信息可改）===== -->
    <DsModal v-model="editVisible" title="编辑订单" :width="560">
      <DsField label="收货人">
        <DsInput v-model="editForm.name" placeholder="请输入收货人" />
      </DsField>
      <DsField label="联系电话" class="mt">
        <DsInput v-model="editForm.phone" placeholder="请输入联系电话" />
      </DsField>
      <DsField label="收货地址" class="mt">
        <DsInput v-model="editForm.address" type="textarea" :rows="2" placeholder="请输入收货地址" />
      </DsField>
      <DsField label="备注" class="mt">
        <DsInput v-model="editForm.remark" type="textarea" :rows="2" placeholder="请输入备注" />
      </DsField>
      <template #footer>
        <DsButton variant="default" @click="editVisible = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="saveEdit">保存</DsButton>
      </template>
    </DsModal>
  </div>
</template>

<script setup>
/**
 * 订货单管理（PC 端专用页）。
 *
 * 对应原系统 application/admin/controller/kuerp/UserOrder.php 与
 * view/kuerp/user_order/{index,edit,deliver}.html，功能清单：
 *   - 订单列表（订单号 / 收货人 / 电话 / 状态 检索）+ 分页
 *   - 订单明细抽屉（表头收货信息 + 商品清单 + 合计）
 *   - 审核（status → 2 待发货，等价 UserOrder::examine）
 *   - 生成销货单（等价列表「生成销货单」→ goods_sales/add?order_id=x）
 *   - 发货（等价 UserOrder::deliver：司机配送 / 物流快递两种方式）
 *   - 编辑收货信息 / 删除（软删除）
 *
 * 与通用 crud-page 的差异：本页按「订单维度」而不是「明细行维度」展示，
 * 商品明细在抽屉中查看，动作按钮按订单状态动态显示，避免误操作。
 */
import { ref, reactive, computed, onMounted } from 'vue';
import request from '../utils/request';
import { message, confirm } from '../utils/ui';

const api = '/kuerp/user-order';

// —— 列表状态 ——
const list = ref([]);
const total = ref(0);
const page = ref(1);
const pageSize = ref(10);
const search = ref('');
const statusFilter = ref('');
const loading = ref(false);
const selected = ref([]);

/** 订单状态字典（与原系统 kuerp_user_order.status 注释一致） */
const STATUS = {
  0: { text: '待审核', color: 'warning' },
  1: { text: '已审核', color: 'brand' },
  2: { text: '待发货', color: 'brand' },
  3: { text: '待收货', color: 'warning' },
  4: { text: '已收货', color: 'success' },
  5: { text: '退款中', color: 'danger' },
  6: { text: '退款完成', color: 'danger' },
  7: { text: '交易取消', color: 'neutral' },
  8: { text: '交易完成', color: 'success' },
};

/** 支付状态字典 */
const PAY = {
  0: { text: '支付中', color: 'warning' },
  1: { text: '支付成功', color: 'success' },
  2: { text: '支付失败', color: 'danger' },
};

const statusFilterOptions = computed(() =>
  Object.keys(STATUS).map((k) => ({ value: k, label: STATUS[k].text })),
);

/** 列表列定义 */
const columns = [
  { key: '__sel', title: '', width: '42px', align: 'center', slot: true },
  { key: 'order_num', title: '订单号', width: '180px', slot: true },
  { key: 'name', title: '收货人', width: '100px' },
  { key: 'phone', title: '联系电话', width: '120px' },
  { key: 'address', title: '收货地址', width: '220px' },
  { key: 'order_price', title: '订单金额', width: '110px', align: 'right', slot: true },
  { key: 'pay_status', title: '支付状态', width: '100px', slot: true },
  { key: 'diver_type', title: '配送类型', width: '110px', slot: true },
  { key: 'status', title: '订单状态', width: '100px', slot: true },
  { key: 'createtime', title: '下单时间', width: '150px', slot: true },
  { key: '__action', title: '操作', width: '330px', align: 'right', slot: true },
];

/** 明细列定义 */
const itemColumns = [
  { key: 'goods_image', title: '图片', width: '70px', slot: true },
  { key: 'goods_name', title: '商品名称', width: '220px' },
  { key: 'attr_name', title: '属性', width: '110px' },
  { key: 'unit_name', title: '单位', width: '80px' },
  { key: 'price', title: '单价', width: '100px', align: 'right', slot: true },
  { key: 'number', title: '数量', width: '80px', align: 'right' },
  { key: 'money', title: '金额', width: '110px', align: 'right', slot: true },
];

// —— 展示辅助 ——
/** 秒级时间戳 → YYYY-MM-DD HH:mm */
function fmtTime(v) {
  const n = Number(v);
  if (!n) return '-';
  const d = new Date(n * 1000);
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}
/** 金额格式化（两位小数 + 千分位） */
function money(v) {
  const n = Number(v) || 0;
  return n.toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
/** 状态文案 */
function statusText(v) {
  return STATUS[Number(v)]?.text ?? `未知(${v})`;
}
/** 状态颜色 */
function statusColor(v) {
  return STATUS[Number(v)]?.color ?? 'neutral';
}
/** 支付状态文案 */
function payText(v) {
  return PAY[Number(v)]?.text ?? `未知(${v})`;
}
/** 支付状态颜色 */
function payColor(v) {
  return PAY[Number(v)]?.color ?? 'neutral';
}

// —— 勾选 ——
/** 某行是否已勾选 */
function isSelected(row) {
  return selected.value.includes(row.id);
}
/** 切换勾选态 */
function toggleSel(row) {
  const i = selected.value.indexOf(row.id);
  if (i >= 0) selected.value.splice(i, 1);
  else selected.value.push(row.id);
}

// —— 动作可用性（与原系统按钮显示条件一致）——
/** 待审核/已审核可再次审核推进到待发货 */
function canAudit(row) {
  return Number(row.status) <= 1;
}
/** 未生成销货单且处于待审核/已审核时可生成 */
function canMakeSales(row) {
  return Number(row.status) <= 2;
}
/** 待发货才可发货 */
function canDeliver(row) {
  return Number(row.status) === 2 || Number(row.status) === 1;
}

// —— 数据加载 ——
/** 拉取订单列表（支持关键字 + 状态过滤） */
async function load() {
  loading.value = true;
  try {
    const params = { page: page.value, limit: pageSize.value, search: search.value };
    if (statusFilter.value !== '' && statusFilter.value !== null) {
      params.filter = JSON.stringify({ status: String(statusFilter.value) });
    }
    const r = await request.get(`${api}/index`, { params });
    list.value = r?.list || [];
    total.value = r?.count || 0;
    // 清理已不在当前页的勾选项，避免误操作
    const ids = new Set(list.value.map((x) => x.id));
    selected.value = selected.value.filter((id) => ids.has(id));
  } finally {
    loading.value = false;
  }
}
/** 检索：重置到第一页 */
function onSearch() {
  page.value = 1;
  load();
}

// —— 明细抽屉 ——
const detailVisible = ref(false);
const current = ref(null);
const items = ref([]);
/** 明细合计数量 */
const totalNumber = computed(() =>
  items.value.reduce((s, r) => s + (Number(r.number) || 0), 0),
);

/**
 * 打开订单明细抽屉。
 * @param row 订单行
 */
async function openDetail(row) {
  current.value = { ...row };
  detailVisible.value = true;
  items.value = [];
  const r = await request.get('/kuerp/user-orderinfo/index', {
    params: { limit: 200, filter: JSON.stringify({ order_id: row.id }) },
  });
  items.value = r?.list || [];
}

// —— 审核 ——
/**
 * 单条审核。
 * @param row 订单行
 */
async function onAudit(row) {
  try {
    await confirm({
      title: '审核确认',
      message: `确认审核订单 ${row.order_num || row.id}？审核后状态将变为「待发货」。`,
    });
  } catch {
    return; // 用户取消
  }
  await request.post(`${api}/audit`, { ids: [row.id] });
  message.success('审核成功');
  load();
}

/** 批量审核 */
async function onBatchAudit() {
  if (!selected.value.length) return;
  try {
    await confirm({
      title: '批量审核',
      message: `确认审核选中的 ${selected.value.length} 个订单？`,
    });
  } catch {
    return;
  }
  await request.post(`${api}/audit`, { ids: selected.value.slice() });
  message.success('审核成功');
  selected.value = [];
  load();
}

// —— 生成销货单 ——
/**
 * 生成销货单（后端会写入 kuerp_user_ordersale 并把订单推进到待发货）。
 * @param row 订单行
 */
async function onToSales(row) {
  try {
    await confirm({
      title: '生成销货单',
      message: `确认为订单 ${row.order_num || row.id} 生成销货单？生成后可在「销货管理 → 销货单」中审核出库。`,
    });
  } catch {
    return;
  }
  const r = await request.post(`${api}/to-sales`, { id: row.id });
  message.success(`销货单已生成：${r?.purchase_code || r?.sales_id || ''}`);
  load();
}

// —— 发货 ——
const deliverVisible = ref(false);
const delivering = ref(false);
const deliverIds = ref([]);
const deliverForm = reactive({ send_type: 1, diver_id: null, express_code: '', express_num: '' });
const drivers = ref([]);
const expresses = ref([]);

const sendTypeOptions = [
  { label: '专业配送', value: 1 },
  { label: '物流快递', value: 2 },
];
const driverOptions = computed(() =>
  drivers.value.map((d) => ({ value: d.id, label: `${d.name}（${d.phone || '无电话'}）` })),
);
const expressOptions = computed(() =>
  expresses.value.map((e) => ({ value: e.code, label: e.name })),
);

/**
 * 打开发货对话框（等价 deliver.html）。
 * @param ids 订单 ID 数组
 */
async function openDeliver(ids) {
  if (!ids?.length) {
    message.warning('请先选择要发货的订单');
    return;
  }
  deliverIds.value = ids.slice();
  resetDeliver();
  deliverVisible.value = true;
  // 司机与快递公司字典按需加载（一次性缓存）
  if (!drivers.value.length) {
    const r = await request.get('/kuerp/driver/index', { params: { limit: 500 } });
    drivers.value = r?.list || [];
  }
  if (!expresses.value.length) {
    expresses.value = (await request.get(`${api}/express`)) || [];
  }
}

/** 重置发货表单 */
function resetDeliver() {
  deliverForm.send_type = 1;
  deliverForm.diver_id = null;
  deliverForm.express_code = '';
  deliverForm.express_num = '';
}

/** 提交发货 */
async function submitDeliver() {
  if (deliverForm.send_type === 1 && !deliverForm.diver_id) {
    message.warning('请选择配送司机');
    return;
  }
  if (deliverForm.send_type === 2 && !deliverForm.express_code) {
    message.warning('请选择快递公司');
    return;
  }
  delivering.value = true;
  try {
    await request.post(`${api}/deliver`, {
      ids: deliverIds.value,
      send_type: deliverForm.send_type,
      diver_id: deliverForm.diver_id,
      express_code: deliverForm.express_code,
      express_num: deliverForm.express_num,
    });
    message.success('发货成功');
    deliverVisible.value = false;
    selected.value = [];
    load();
  } finally {
    delivering.value = false;
  }
}

// —— 编辑收货信息 ——
const editVisible = ref(false);
const saving = ref(false);
const editForm = reactive({ id: 0, name: '', phone: '', address: '', remark: '' });

/**
 * 打开编辑对话框。
 * @param row 订单行
 */
function openEdit(row) {
  editForm.id = row.id;
  editForm.name = row.name || '';
  editForm.phone = row.phone || '';
  editForm.address = row.address || '';
  editForm.remark = row.remark || '';
  editVisible.value = true;
}

/** 保存收货信息 */
async function saveEdit() {
  saving.value = true;
  try {
    await request.post(`${api}/edit`, {
      id: editForm.id,
      name: editForm.name,
      phone: editForm.phone,
      address: editForm.address,
      remark: editForm.remark,
    });
    message.success('保存成功');
    editVisible.value = false;
    load();
  } finally {
    saving.value = false;
  }
}

// —— 删除 ——
/**
 * 删除单个订单（软删除，等价 UserOrder::del）。
 * @param row 订单行
 */
async function onDel(row) {
  try {
    await confirm({ title: '删除确认', message: `确认删除订单 ${row.order_num || row.id}？` });
  } catch {
    return;
  }
  await request.post(`${api}/del`, { id: row.id });
  message.success('删除成功');
  load();
}

/** 批量删除 */
async function onBatchDel() {
  if (!selected.value.length) return;
  try {
    await confirm({
      title: '批量删除',
      message: `确认删除选中的 ${selected.value.length} 个订单？`,
    });
  } catch {
    return;
  }
  await request.post(`${api}/del`, { ids: selected.value.slice() });
  message.success('删除成功');
  selected.value = [];
  load();
}

onMounted(load);
</script>

<style scoped>
/* flex 排版必须放在卡片内容区上：.toolbar 类挂在 DsCard 根元素，
   而卡片根本身是 flex column（.ds-card-c），在其上直接排会变成竖向居中堆叠 */
.toolbar :deep(.ds-card-c__body) {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
.tb-left,
.tb-right {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}
.mt {
  margin-top: 12px;
}
.section-title {
  font-weight: 600;
  font-size: 14px;
  margin-bottom: 10px;
  padding-left: 8px;
  border-left: 3px solid var(--ds-brand);
}
.kv {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px 20px;
  font-size: 13px;
}
.kv .full {
  grid-column: 1 / -1;
}
.kv .k {
  display: inline-block;
  width: 80px;
  color: var(--ds-text-3, #8a8f99);
}
.detail-foot {
  display: flex;
  justify-content: flex-end;
  gap: 26px;
  margin-top: 12px;
  font-size: 13px;
}
.thumb {
  width: 44px;
  height: 44px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid var(--ds-border, #e5e7eb);
}
.muted {
  color: var(--ds-text-3, #9aa0aa);
  font-size: 12px;
}
</style>
