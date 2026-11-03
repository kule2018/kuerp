<template>
  <div>
    <!-- 顶部概览卡：4 项基础经营指标（原 el-row/el-col + 手写统计块，改走 DsStatCard） -->
    <div class="grid4">
      <DsStatCard v-for="c in cards" :key="c.title" :label="c.title" :value="c.value" :tone="c.tone || 'neutral'">
        <span v-if="c.sub !== undefined" class="stat-sub">{{ c.sub }}</span>
      </DsStatCard>
    </div>

    <!-- 四大模块核心数据：购货 / 销货 / 仓库 / 资金 -->
    <div class="grid2 mt">
      <DsCard>
        <template #title>购货 / 销货</template>
        <DsDescriptions :column="2" :items="psItems" :data="flat" />
      </DsCard>
      <DsCard>
        <template #title>仓库 / 资金</template>
        <DsDescriptions :column="2" :items="wcItems" :data="flat" />
      </DsCard>
    </div>

    <!-- 快捷入口：直达高频单据页 -->
    <DsCard class="mt">
      <template #title>快捷操作</template>
      <div class="quick">
        <DsButton v-for="q in quick" :key="q.path" @click="router.push(q.path)">{{ q.label }}</DsButton>
      </div>
    </DsCard>

  </div>
</template>

<script setup>
/**
 * 数据面板（工作台）：汇总购货 / 销货 / 仓库 / 资金 四大模块核心经营指标 + 快捷入口。
 * 指标来自后端聚合接口 GET /kuerp/statistics/dashboard（与业务数据实时一致）。
 */
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import request from '../utils/request';

const router = useRouter();

/** 顶部 4 张概览卡（基础资料与预警） */
const cards = ref([
  { title: '商品总数', value: '-', sub: undefined },
  { title: '客户数', value: '-', sub: undefined },
  { title: '供应商数', value: '-', sub: undefined },
  { title: '库存预警', value: '-', sub: undefined, tone: 'warning' },
]);

/** 四大模块明细指标 */
const stats = ref({
  goods: { count: 0, warning: 0 },
  customers: { count: 0 },
  suppliers: { count: 0 },
  purchase: { count: 0, amount: 0 },
  sales: { count: 0, amount: 0 },
  warehouse: { kinds: 0, totalValue: 0 },
  capital: { receivable: 0, payable: 0, accountBalance: 0 },
});

/** 描述列表取数对象：把嵌套指标摊平，并统一按人民币格式化金额 */
const flat = computed(() => ({
  purchaseCount: stats.value.purchase.count,
  purchaseAmount: money(stats.value.purchase.amount),
  salesCount: stats.value.sales.count,
  salesAmount: money(stats.value.sales.amount),
  warehouseKinds: stats.value.warehouse.kinds,
  warehouseValue: money(stats.value.warehouse.totalValue),
  receivable: money(stats.value.capital.receivable),
  payable: money(stats.value.capital.payable),
  accountBalance: money(stats.value.capital.accountBalance),
}));

/** 购货 / 销货 描述项 */
const psItems = [
  { label: '购货单数', key: 'purchaseCount' },
  { label: '购货金额', key: 'purchaseAmount' },
  { label: '销货单数', key: 'salesCount' },
  { label: '销货金额', key: 'salesAmount' },
];

/** 仓库 / 资金 描述项 */
const wcItems = [
  { label: '库存种类', key: 'warehouseKinds' },
  { label: '库存总额', key: 'warehouseValue' },
  { label: '应收账款', key: 'receivable' },
  { label: '应付账款', key: 'payable' },
  { label: '账户余额', key: 'accountBalance' },
];

const quick = ref([
  { label: '商品管理', path: '/goods' },
  { label: '购货单', path: '/goods-purchase' },
  { label: '销货单', path: '/goods-sales' },
  { label: '收款单', path: '/collection' },
  { label: '付款单', path: '/payment' },
  { label: '库存查询', path: '/goods-stock' },
  { label: '结账/反结账', path: '/checkout' },
  { label: '数字大屏', path: '/screen' },
  { label: 'AI 对话', path: '/ai/playground' },
]);

/** 金额千分位格式化（人民币） */
function money(v) {
  const n = Number(v || 0);
  return '¥' + n.toLocaleString('zh-CN', { maximumFractionDigits: 2 });
}

/** 拉取数据面板聚合指标 */
async function load() {
  try {
    const r = await request.get('/kuerp/statistics/dashboard');
    if (r) {
      stats.value = r;
      cards.value[0].value = r.goods.count;
      cards.value[0].sub = `预警 ${r.goods.warning}`;
      cards.value[1].value = r.customers.count;
      cards.value[2].value = r.suppliers.count;
      cards.value[3].value = r.goods.warning;
      cards.value[3].sub = '项待处理';
    }
  } catch (e) {
    /* 指标加载失败保持占位，不阻塞页面 */
  }
}
onMounted(load);
</script>

<style scoped>
.stat-sub { color: var(--ds-text-3); font-size: 12px; }
.mt { margin-top: 16px; }
/* 顶部 4 张概览卡等分；窄屏自动降为两列 / 一列 */
.grid4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.grid2 { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
@media (max-width: 1100px) {
  .grid4 { grid-template-columns: repeat(2, 1fr); }
  .grid2 { grid-template-columns: 1fr; }
}
/* 快捷操作按钮组：自动换行 */
.quick { display: flex; flex-wrap: wrap; gap: 8px; }
</style>
