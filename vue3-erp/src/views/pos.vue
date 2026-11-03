<template>
  <div class="pos" @keydown="onKeydown" tabindex="0">
    <!-- 左侧：商品检索与购物车 -->
    <DsCard class="left">
      <DsInput v-model="keyword" :placeholder="`输入商品名称/编号/条码，回车检索（${modeLabel}）`" clearable @keyup.enter="searchGoods">
        <template #append>
          <DsButton @click="searchGoods">检索</DsButton>
        </template>
      </DsInput>

      <!-- 检索结果 -->
      <div v-if="goodsList.length" class="goods-result">
        <div
          v-for="g in goodsList"
          :key="g.id"
          class="goods-item"
          @click="addToCart(g)"
        >
          <div class="g-name">{{ g.goods_name || g.goods_code }}</div>
          <div class="g-meta">
            {{ g.goods_code }} · 零售价 {{ money(g.market_sell_price) }}
            <template v-if="!isExchange && stockMap[g.id] !== undefined">
              · 库存 {{ stockMap[g.id] }}
            </template>
          </div>
        </div>
      </div>

      <!-- 购物车 -->
      <div class="cart-scroll">
        <DsTable :columns="cartCols" :data="cart" row-key="id" class="cart">
          <template #price="{ row }">
            <DsInput type="number" v-model="row.price" :min="0" size="sm" @change="recalc" />
          </template>
          <template #qty="{ row }">
            <DsInput type="number" v-model="row.qty" :min="1" size="sm" @change="recalc" />
          </template>
          <template #amount="{ row }">{{ money(row.price * row.qty) }}</template>
          <template #stock="{ row }">
            <span :class="{ 'stock-warn': stockMap[row.id] !== undefined && stockMap[row.id] < row.qty }">
              {{ stockMap[row.id] ?? '-' }}
            </span>
          </template>
          <template #del="{ row }">
            <DsButton variant="text" size="sm" @click="removeCart(row)">删</DsButton>
          </template>
        </DsTable>
      </div>
    </DsCard>

    <!-- 右侧：结算面板 -->
    <DsCard class="right">
      <div class="field">
        <span class="lbl">客户</span>
        <DsSelect v-model="form.customers_id" :options="customerOptions" filterable clearable placeholder="散客" style="width: 100%" />
      </div>

      <div class="field">
        <span class="lbl">仓库</span>
        <DsSelect
          v-model="form.stores_id"
          :options="warehouseOptions"
          filterable
          placeholder="请选择仓库"
          style="width: 100%"
          @change="onStoreChange"
        />
      </div>
      <div class="field">
        <span class="lbl">收款方式</span>
        <DsSegmented v-model="form.payType" :options="payOptions" size="sm" />
      </div>
      <div class="field">
        <span class="lbl">优惠(元)</span>
        <DsInput type="number" v-model="discount" :min="0" :controls="false" style="width: 100%" @change="recalc" />
      </div>

      <DsDivider />

      <div class="amount-row"><span>商品种类</span><b>{{ cart.length }}</b></div>
      <div class="amount-row"><span>合计数量</span><b>{{ totalQty }}</b></div>
      <div class="amount-row total"><span>应收金额</span><b>{{ money(payable) }}</b></div>
      <div class="amount-row"><span>实收金额</span>
        <DsInput type="number" v-model="received" :min="0" :controls="false" style="width: 140px" />
      </div>
      <div class="amount-row"><span>找零</span><b>{{ money(change) }}</b></div>

      <!-- 操作区：挂单(F7) / 源单(F8) / 结账(F9)，还原原系统收银台快捷键 -->
      <div class="ops">
        <DsButton size="lg" @click="hangOrder">挂单 (F7)</DsButton>
        <DsButton size="lg" @click="hangPopVisible = !hangPopVisible">源单 (F8)</DsButton>
      </div>

      <DsButton variant="primary" size="lg" class="settle" :loading="submitting" :disabled="!cart.length" @click="settle">
        结账 (F9) {{ money(payable) }}
      </DsButton>
      <DsButton size="lg" class="clear" @click="clearCart">清空</DsButton>
    </DsCard>

    <!-- 源单（挂单）列表：原系统为 popover 浮层，ds 体系下改用弹窗承载 -->
    <DsModal v-model="hangPopVisible" title="源单列表（挂单）" :width="360">
      <ul class="hang-list">
        <li v-if="!hangList.length" class="hang-empty">暂无源单</li>
        <li v-for="h in hangList" :key="h.id" class="hang-item">
          <span class="hang-take" @click="takeHang(h)">{{ h.id }} - {{ h.time }}（{{ h.goods.length }} 项）</span>
          <DsButton variant="text" size="sm" @click="delHang(h)">删除</DsButton>
        </li>
      </ul>
      <template #footer>
        <DsButton @click="hangPopVisible = false">关闭</DsButton>
      </template>
    </DsModal>

    <!-- 结账成功小票（还原原系统结账弹层，支持直接打印） -->
    <DsModal v-model="receiptVisible" title="结账成功" :width="620">
      <div id="pos-receipt" class="receipt">
        <h3>零售{{ isExchange ? '退货' : '销货' }}小票</h3>
        <p>单据编号：{{ receipt.purchase_code }}</p>
        <p>单据日期：{{ receipt.date }}</p>
        <p>客户名称：{{ receipt.cname }}</p>
        <table class="receipt-table">
          <thead>
            <tr><th>商品</th><th>单价</th><th>数量</th><th>金额</th></tr>
          </thead>
          <tbody>
            <tr v-for="(g, i) in receipt.goods" :key="i">
              <td>{{ g.goods_name }}</td>
              <td>{{ money(g.price) }}</td>
              <td>{{ g.qty }}</td>
              <td>{{ money(g.price * g.qty) }}</td>
            </tr>
          </tbody>
        </table>
        <p>单据金额：{{ money(receipt.order_money) }}</p>
        <p>优惠金额：{{ money(receipt.discount) }}</p>
        <p>实收金额：{{ money(receipt.received) }}</p>
        <p>找零：{{ money(receipt.change) }}</p>
        <p>备注信息：{{ receipt.note || '-' }}</p>
      </div>
      <template #footer>
        <DsButton @click="receiptVisible = false">关闭</DsButton>
        <DsButton variant="primary" @click="printReceipt">打印</DsButton>
      </template>
    </DsModal>
  </div>
</template>

<script setup>
/**
 * 收银台（零售 POS）：1:1 还原原系统 retail/goods_sales/retail.html 的收银界面。
 *
 * 流程：
 * 1. 按名称/编号/条码检索商品（kuerp_goods）；
 * 2. 加入购物车，可改单价/数量；
 * 3. 选客户、仓库、收款方式、优惠；
 * 4. 挂单(F7)：当前整单压入内存态挂单列表，便于先服务下一位顾客；
 *    源单(F8)：弹出挂单列表，点某条整单取回购物车继续结账，也可删除；
 * 5. 结账(F9)：校验库存（零售退货不校验）与实收金额后，
 *    先写单据表头（kuerp_goods_sales / kuerp_goods_sales_exchange），
 *    再逐行写明细（*_info，通过 purchase_code 关联），最后弹小票。
 * 表头与明细的关联字段为 purchase_code（与原系统一致）。
 *
 * 模式：route.meta.mode = 'sale'（零售单，默认）/ 'exchange'（零售退货单）。
 * 退货单走 kuerp_goods_sales_exchange，purchase_type=0，商品为入库方向故不校验库存。
 */
import { ref, reactive, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { message } from '@/utils/ui';
import request from '../utils/request';

const route = useRoute();
/** 收银模式：sale=零售单 / exchange=零售退货单 */
const mode = route.meta.mode || 'sale';
const isExchange = computed(() => mode === 'exchange');
const modeLabel = computed(() => (isExchange.value ? '零售退货' : '零售'));

// —— 单据落库目标：随模式切换表名、编号前缀与类型 ——
const DOC = computed(() =>
  isExchange.value
    ? { head: '/kuerp/goods-sales-exchange', info: '/kuerp/goods-sales-exchange-info', prefix: 'XSTH', purchaseType: '0' }
    : { head: '/kuerp/goods-sales', info: '/kuerp/goods-sales-info', prefix: 'XS', purchaseType: '1' },
);

const keyword = ref('');
const goodsList = ref([]);
const cart = ref([]);
const customers = ref([]);
const warehouses = ref([]);
const discount = ref(0);
const received = ref(0);
const submitting = ref(false);

/** 当前仓库下各商品库存 { goodsId: stock }，用于加购提示与结账前校验 */
const stockMap = ref({});

/** 挂单列表（与原系统一致：仅前端内存态，刷新即失效） */
const hangList = ref([]);
const hangPopVisible = ref(false);

/** 结账成功小票 */
const receiptVisible = ref(false);
const receipt = reactive({
  purchase_code: '', date: '', cname: '', goods: [],
  order_money: 0, discount: 0, received: 0, change: 0, note: '',
});

const form = reactive({ customers_id: null, stores_id: null, payType: 'cash' });

/** 收款方式选项 */
const payOptions = [
  { value: 'cash', label: '现金' },
  { value: 'wechat', label: '微信' },
  { value: 'alipay', label: '支付宝' },
  { value: 'bank', label: '银行卡' },
];

/** 客户下拉选项 */
const customerOptions = computed(() =>
  customers.value.map((c) => ({ value: c.id, label: c.customer_name })),
);

/** 仓库下拉选项 */
const warehouseOptions = computed(() =>
  warehouses.value.map((w) => ({ value: w.id, label: w.name || w.code })),
);

/** 购物车列定义 */
const cartCols = [
  { key: 'goods_name', title: '商品', width: '150px' },
  { key: 'price', title: '单价', width: '100px', slot: true },
  { key: 'qty', title: '数量', width: '100px', slot: true },
  { key: 'amount', title: '小计', width: '100px', align: 'right', slot: true },
  { key: 'stock', title: '库存', width: '80px', align: 'right', slot: true },
  { key: 'del', title: '', width: '60px', align: 'center', slot: true },
];

/** 从购物车移除一行并重算 */
function removeCart(row) {
  cart.value = cart.value.filter((c) => c !== row);
  recalc();
}

/** 应收 = 商品金额合计 - 优惠 */
const payable = computed(() =>
  Math.max(0, cart.value.reduce((s, r) => s + r.price * r.qty, 0) - (discount.value || 0)),
);
const totalQty = computed(() => cart.value.reduce((s, r) => s + (Number(r.qty) || 0), 0));
const change = computed(() => Math.max(0, (received.value || 0) - payable.value));

/** 金额格式化 */
function money(v) {
  return '¥' + (Number(v) || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

/** 检索商品 */
async function searchGoods() {
  if (!keyword.value.trim()) return;
  const r = await request.get('/kuerp/goods/index', {
    params: { search: keyword.value.trim(), limit: 20 },
  });
  goodsList.value = r?.list || [];
  if (!goodsList.value.length) message.info('未找到商品');
  // 顺带刷新当前仓库下的库存展示
  await loadStock();
}

/**
 * 拉取当前仓库的全量库存，写入 stockMap。
 * 库存查询失败不阻断收银（退化为不展示库存、不校验）。
 */
async function loadStock() {
  if (!form.stores_id) {
    stockMap.value = {};
    return;
  }
  try {
    // filter 走 JSON 字符串（TableService 精确过滤，参数化防注入）
    const r = await request.get('/kuerp/goods-stock/index', {
      params: { filter: JSON.stringify({ stores_id: form.stores_id }), limit: 500 },
    });
    const map = {};
    (r?.list || []).forEach((s) => { map[s.goods_id] = Number(s.stock) || 0; });
    stockMap.value = map;
  } catch {
    stockMap.value = {};
  }
}

/** 仓库切换：重新拉取库存 */
async function onStoreChange() {
  await loadStock();
}

/** 加入购物车（同一商品累加数量） */
function addToCart(g) {
  const exist = cart.value.find((c) => c.id === g.id);
  if (exist) { exist.qty += 1; }
  else {
    cart.value.push({
      id: g.id,
      goods_code: g.goods_code,
      goods_name: g.goods_name,
      goods_unit: g.unit_id,
      price: Number(g.market_sell_price) || 0,
      qty: 1,
    });
  }
  recalc();
}

function recalc() {}

/** 拉取客户/仓库下拉 */
async function loadOptions() {
  try {
    const [c, w] = await Promise.all([
      request.get('/kuerp/customers/index', { params: { limit: 200 } }),
      request.get('/kuerp/warehouse/index', { params: { limit: 200 } }),
    ]);
    customers.value = c?.list || [];
    warehouses.value = w?.list || [];
  } catch { /* 下拉失败不影响收银 */ }
}

/**
 * 生成单据号：优先按「单号设置」规则生成（零售单/零售退货单走 order_code 规则，
 * 与原系统 kuerp_prefix type=28/29 口径一致），规则未配置或请求失败时回退本地生成。
 * @returns {Promise<string>} 单据编号
 */
async function genCode() {
  try {
    // 落库表名：/kuerp/goods-sales → kuerp_goods_sales
    const db = DOC.value.head.replace(/^\/kuerp\//, '').replace(/-/g, '_');
    const r = await request.get('/kuerp/prefix/gen-code', {
      params: { dbname: db, field: 'order_code' },
    });
    if (r?.code) return r.code;
  } catch { /* 规则未配置时回退本地生成 */ }
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  const stamp = `${d.getFullYear()}${p(d.getMonth() + 1)}${p(d.getDate())}${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
  return DOC.value.prefix + stamp;
}

/**
 * 挂单（F7）：把当前整单压入挂单列表并清空购物车。
 * 与原系统一致：必须已选客户且购物车非空；挂单仅存内存，刷新页面即失效。
 */
function hangOrder() {
  hangPopVisible.value = false;
  if (!form.customers_id) { message.warning('请选择客户'); return; }
  if (!cart.value.length) { message.warning('请选择商品数据'); return; }
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  const customer = customers.value.find((c) => c.id === form.customers_id);
  hangList.value.push({
    id: 'NO.' + (hangList.value.length + 1),
    time: `${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`,
    customers_id: form.customers_id,
    customers_name: customer?.customer_name || '',
    goods: cart.value.map((g) => ({ ...g })),
  });
  clearCart();
  message.success('已挂单，可按 F8 取回');
}

/**
 * 源单取单（F8）：把挂单整单写回购物车（同名商品合并数量），并从挂单列表移除。
 * @param h 挂单记录
 */
function takeHang(h) {
  h.goods.forEach((g) => {
    const exist = cart.value.find((c) => c.id === g.id);
    if (exist) exist.qty += Number(g.qty) || 1;
    else cart.value.push({ ...g });
  });
  form.customers_id = h.customers_id;
  delHang(h);
  hangPopVisible.value = false;
  recalc();
  message.success(`已取回源单 ${h.id}`);
}

/** 删除挂单记录 */
function delHang(h) {
  hangList.value = hangList.value.filter((x) => x.id !== h.id);
}

/** 结账前校验：库存不足拦截（零售退货为入库方向，不校验） */
async function checkStock() {
  if (isExchange.value) return true;
  for (const it of cart.value) {
    const stock = stockMap.value[it.id];
    if (stock !== undefined && stock < Number(it.qty)) {
      message.error(`「${it.goods_name}」库存不足（现有 ${stock}，需 ${it.qty}）`);
      return false;
    }
  }
  return true;
}

/** 结账：表头 + 明细两步写入（purchase_code 关联），成功后弹小票 */
async function settle() {
  hangPopVisible.value = false;
  if (!cart.value.length) return;
  if (!form.stores_id) { message.warning('请选择仓库'); return; }
  // 原系统约束：实收金额不得小于应收金额
  if ((received.value || 0) < payable.value) {
    message.warning('实际收款金额小于应收金额');
    return;
  }
  if (!(await checkStock())) return;

  submitting.value = true;
  const code = await genCode();
  const now = Math.floor(Date.now() / 1000);
  const totalMoney = payable.value;
  try {
    // 1) 写单据表头（零售单同时写 order_code/order_time/order_type，与原系统零售口径一致）
    await request.post(DOC.value.head + '/add', {
      purchase_code: code,
      order_code: code,
      order_type: 2,
      order_time: now,
      purchase_type: DOC.value.purchaseType,
      purchase_time: now,
      customers_id: form.customers_id || 0,
      sale_user: 0,
      stores_id: form.stores_id,
      number: totalQty.value,
      all_money: totalMoney,
      money_tax_price: totalMoney,
      real_money: totalMoney,
      pay_money: received.value || totalMoney,
      pay_status: (received.value || 0) >= totalMoney ? '1' : '0',
      examine_status: 0,
      createtime: now,
      updatetime: now,
    });
    // 2) 逐行写明细（关联同一 purchase_code）
    for (const it of cart.value) {
      const amt = it.price * it.qty;
      await request.post(DOC.value.info + '/add', {
        purchase_code: code,
        purchase_type: DOC.value.purchaseType,
        purchase_time: now,
        customers_id: form.customers_id || 0,
        goods_code: it.goods_code,
        goods_unit: it.goods_unit || 0,
        stores_id: form.stores_id,
        number: it.qty,
        unit_price: it.price,
        all_money: amt,
        money_tax_price: amt,
        basic_nmber: it.qty,
        remark: '',
      });
    }
    // 3) 组装小票内容
    const customer = customers.value.find((c) => c.id === form.customers_id);
    Object.assign(receipt, {
      purchase_code: code,
      date: new Date().toLocaleString('zh-CN'),
      cname: customer?.customer_name || '散客',
      goods: cart.value.map((g) => ({ ...g })),
      order_money: totalMoney,
      discount: discount.value || 0,
      received: received.value || totalMoney,
      change: change.value,
      note: '',
    });
    receiptVisible.value = true;
    clearCart();
    received.value = 0;
    discount.value = 0;
  } catch (e) {
    message.error('结算失败：' + (e?.message || '接口错误'));
  } finally {
    submitting.value = false;
  }
}

function clearCart() { cart.value = []; }

/** 打印小票：隐藏 iframe 承载小票内容，避免影响主界面 */
function printReceipt() {
  const html = document.getElementById('pos-receipt');
  if (!html) return;
  const frame = document.createElement('IFRAME');
  frame.setAttribute('style', 'width:0;height:0;position:absolute;left:-2000px;top:-2000px');
  document.body.appendChild(frame);
  const doc = frame.contentWindow.document;
  doc.write('<html><head><title>打印小票</title></head><body>' + html.outerHTML + '</body></html>');
  doc.close();
  frame.contentWindow.focus();
  frame.contentWindow.print();
  document.body.removeChild(frame);
}

/**
 * 快捷键（还原原系统 retail.html 的 keyUp 逻辑）：
 * F7 挂单 / F8 源单 / F9 结账 / F10 打印小票 / Esc 关闭源单浮层。
 * @param e 键盘事件
 */
function onKeydown(e) {
  const code = e.keyCode || e.which;
  if (code === 118) { e.preventDefault(); hangOrder(); }        // F7
  else if (code === 119) { e.preventDefault(); hangPopVisible.value = !hangPopVisible.value; } // F8
  else if (code === 120) { e.preventDefault(); settle(); }      // F9
  else if (code === 121) { if (receiptVisible.value) printReceipt(); } // F10
  else if (code === 27) { hangPopVisible.value = false; }       // Esc
}

onMounted(loadOptions);
</script>

<style scoped>
.pos { display: flex; gap: 12px; height: calc(100vh - 140px); outline: none; }
.left { flex: 1.4; display: flex; flex-direction: column; }
.right { flex: 1; }
.goods-result { margin-top: 8px; max-height: 150px; overflow: auto; border: 1px solid #ebeef5; border-radius: 4px; }
.goods-item { padding: 8px 10px; cursor: pointer; border-bottom: 1px solid #f2f2f2; }
.goods-item:hover { background: #f5f7fa; }
.g-name { font-weight: 600; }
.g-meta { font-size: 12px; color: #888; }
.cart { margin-top: 8px; }
/* 购物车表格固定高度滚动，替代原 el-table 的 height 属性 */
.cart-scroll { margin-top: 8px; max-height: 360px; overflow: auto; }
.stock-warn { color: #f56c6c; font-weight: 600; }
.field { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
.lbl { width: 70px; color: #606266; font-size: 13px; }
.amount-row { display: flex; justify-content: space-between; align-items: center; padding: 6px 0; }
.amount-row.total { font-size: 18px; color: #f56c6c; }
.ops { display: flex; gap: 10px; margin-top: 10px; }
.ops > * { flex: 1; }
.settle { width: 100%; margin-top: 10px; }
.clear { width: 100%; margin-top: 8px; margin-left: 0; }
.hang-list { list-style: none; margin: 0; padding: 0; max-height: 240px; overflow: auto; }
.hang-empty { text-align: center; color: #999; padding: 12px 0; }
.hang-item { display: flex; justify-content: space-between; align-items: center; padding: 6px 4px; border-bottom: 1px solid #f2f2f2; }
.hang-take { cursor: pointer; font-size: 13px; }
.hang-take:hover { color: #409eff; }
.receipt h3 { text-align: center; margin: 0 0 12px; }
.receipt p { margin: 4px 0; font-size: 13px; }
.receipt-table { width: 100%; border-collapse: collapse; margin: 8px 0; font-size: 13px; }
.receipt-table th, .receipt-table td { border: 1px solid #ddd; padding: 4px 6px; text-align: left; }
</style>
