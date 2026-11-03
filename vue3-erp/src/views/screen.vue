<template>
  <div class="screen">
    <!-- 顶部标题栏 -->
    <div class="screen-head">
      <h1>进销存数据大屏</h1>
      <span class="time">{{ now }}</span>
    </div>

    <!-- 核心指标卡 -->
    <div class="kpi-row">
      <div class="kpi" v-for="k in kpis" :key="k.label">
        <div class="kpi-label">{{ k.label }}</div>
        <div class="kpi-value" :style="{ color: k.color }">{{ k.value }}</div>
      </div>
    </div>

    <div class="chart-row">
      <!-- 销售趋势（按销货订单金额，纯 SVG 折线） -->
      <div class="panel">
        <div class="panel-title">销售趋势（近 12 笔销货订单金额）</div>
        <svg v-if="salesTrend.length" viewBox="0 0 600 220" class="chart">
          <polyline :points="trendPoints" fill="none" stroke="#e74c3c" stroke-width="2.5" />
          <circle v-for="(p, i) in trendDots" :key="i" :cx="p.x" :cy="p.y" r="3" fill="#e74c3c" />
        </svg>
        <DsEmpty v-else title="暂无销货订单数据"  />
      </div>

      <!-- 商品分类占比（条形） -->
      <div class="panel">
        <div class="panel-title">商品分类数量占比</div>
        <div v-if="typeBars.length" class="bars">
          <div v-for="b in typeBars" :key="b.label" class="bar-row">
            <span class="bar-label">{{ b.label }}</span>
            <div class="bar-track">
              <div class="bar-fill" :style="{ width: b.pct + '%' }" />
            </div>
            <span class="bar-num">{{ b.value }}</span>
          </div>
        </div>
        <DsEmpty v-else title="暂无商品数据"  />
      </div>
    </div>

    <div class="chart-row">
      <!-- 库存 TOP10 -->
      <div class="panel">
        <div class="panel-title">库存数量 TOP10</div>
        <div v-if="stockBars.length" class="bars">
          <div v-for="b in stockBars" :key="b.label" class="bar-row">
            <span class="bar-label" :title="b.label">{{ b.label }}</span>
            <div class="bar-track">
              <div class="bar-fill green" :style="{ width: b.pct + '%' }" />
            </div>
            <span class="bar-num">{{ b.value }}</span>
          </div>
        </div>
        <DsEmpty v-else title="暂无库存数据"  />
      </div>

      <!-- 资金账户余额 -->
      <div class="panel">
        <div class="panel-title">资金账户余额</div>
        <DsTable :columns="accountCols" :data="accounts" row-key="id" striped>
          <template #balance="{ row }">
            <span class="money">¥{{ fmt(row.balance) }}</span>
          </template>
        </DsTable>
        <DsEmpty v-if="!accounts.length" title="暂无账户数据"  />
      </div>
    </div>

    <!-- 预警列表 -->
    <div class="panel wide">
      <div class="panel-title">库存预警（库存低于预警线）</div>
      <DsTable :columns="warnCols" :data="warnings" row-key="id" striped />
      <DsEmpty v-if="!warnings.length" title="暂无预警商品"  />
    </div>
  </div>
</template>

<script setup>
/**
 * 数字大屏：图形化展示进销存核心经营数据（1:1 还原原系统「数字大屏」页）。
 * 数据全部来自通用动态表接口（/kuerp/:table/index），图表用纯 SVG/CSS 绘制，
 * 不引入额外图表库，保持前端依赖轻量。
 */
import { ref, computed, onMounted, onUnmounted } from 'vue';
import request from '../utils/request';

const now = ref('');
let timer = null;

// —— KPI 指标 ——
const kpis = ref([
  { label: '商品总数', value: '0', color: '#409eff' },
  { label: '客户总数', value: '0', color: '#67c23a' },
  { label: '供应商总数', value: '0', color: '#e6a23c' },
  { label: '库存预警', value: '0', color: '#f56c6c' },
]);

// —— 销售趋势（金额序列）——
const salesTrend = ref([]);
const trendPoints = computed(() =>
  salesTrend.value.map((v, i) => {
    const max = Math.max(...salesTrend.value, 1);
    const x = salesTrend.value.length > 1 ? (i / (salesTrend.value.length - 1)) * 580 + 10 : 300;
    const y = 200 - (v / max) * 170;
    return `${x},${y}`;
  }).join(' '),
);
const trendDots = computed(() =>
  salesTrend.value.map((v, i) => {
    const max = Math.max(...salesTrend.value, 1);
    const x = salesTrend.value.length > 1 ? (i / (salesTrend.value.length - 1)) * 580 + 10 : 300;
    const y = 200 - (v / max) * 170;
    return { x, y };
  }),
);

// —— 资金账户表格列（余额列用插槽高亮） ——
const accountCols = [
  { key: 'account_name', title: '账户' },
  { key: 'balance', title: '余额', align: 'right', slot: true },
];

// —— 库存预表格列 ——
const warnCols = [
  { key: 'goods_name', title: '商品' },
  { key: 'stock', title: '当前库存', align: 'right', width: '120px' },
  { key: 'min_stock', title: '预警线', align: 'right', width: '120px' },
];

// —— 分类占比 / 库存 TOP10 / 账户 / 预警 ——
const typeBars = ref([]);
const stockBars = ref([]);
const accounts = ref([]);
const warnings = ref([]);

/** 数字千分位格式化 */
function fmt(n) {
  return Number(n || 0).toLocaleString('zh-CN', { maximumFractionDigits: 2 });
}

/** 拉取某表列表的便捷方法 */
async function fetchTable(api, limit = 100, extra = {}) {
  const r = await request.get(`${api}/index`, { params: { page: 1, limit, ...extra } });
  return r?.list || [];
}

onMounted(async () => {
  // 时钟
  const tick = () => { now.value = new Date().toLocaleString('zh-CN', { hour12: false }); };
  tick();
  timer = setInterval(tick, 1000);

  try {
    // KPI：商品/客户/供应商总数（index 接口返回 count）
    const cnt = async (api) => {
      const r = await request.get(`${api}/index`, { params: { page: 1, limit: 1 } });
      return Number(r?.count || 0);
    };
    const [gc, cc, sc] = await Promise.all([cnt('/kuerp/goods'), cnt('/kuerp/customers'), cnt('/kuerp/suppliers')]);
    kpis.value[0].value = fmt(gc);
    kpis.value[1].value = fmt(cc);
    kpis.value[2].value = fmt(sc);

    // 库存预警：商品库存低于预警线（min_stock > 0 且 stock < min_stock）
    const goodsAll = await fetchTable('/kuerp/goods', 500);
    warnings.value = goodsAll.filter(
      (g) => Number(g.min_stock) > 0 && Number(g.stock) < Number(g.min_stock),
    );
    kpis.value[3].value = fmt(warnings.value.length);

    // 销售趋势：近 12 笔销货订单金额（all_money 为单据金额列）
    const orders = await fetchTable('/kuerp/goods-sales-order', 12, { sort: 'id', order: 'DESC' });
    salesTrend.value = orders
      .slice(0, 12)
      .reverse()
      .map((o) => Number(o.all_money || o.real_money || 0));

    // 商品分类占比
    const goodsList = await fetchTable('/kuerp/goods', 200);
    const byType = {};
    goodsList.forEach((g) => {
      const key = g.goods_type_id || g.type_id || '未分类';
      byType[key] = (byType[key] || 0) + 1;
    });
    const maxType = Math.max(...Object.values(byType), 1);
    typeBars.value = Object.entries(byType)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 8)
      .map(([label, value]) => ({ label: `分类${label}`, value, pct: (value / maxType) * 100 }));

    // 库存 TOP10（kuerp_goods_stock 无商品名列，用 goods_code 标识）
    const stocks = await fetchTable('/kuerp/goods-stock', 200);
    stockBars.value = stocks
      .map((s) => ({ label: s.goods_code || `商品${s.goods_id}`, value: Number(s.number || 0) }))
      .sort((a, b) => b.value - a.value)
      .slice(0, 10)
      .map((s, _, arr) => ({ ...s, pct: (s.value / Math.max(...arr.map((x) => x.value), 1)) * 100 }));

    // 账户余额
    accounts.value = await fetchTable('/kuerp/accounts', 50);
  } catch (e) {
    // 大屏为展示型页面，单表异常不影响整体渲染
    console.warn('大屏数据加载异常', e);
  }
});

onUnmounted(() => { if (timer) clearInterval(timer); });
</script>

<style scoped>
/* 大屏整体为深色底，与原系统数字大屏风格一致 */
.screen { background: #0b1a2a; min-height: calc(100vh - 60px); margin: -20px; padding: 16px 20px; color: #dbe7f3; }
.screen-head { display: flex; align-items: baseline; justify-content: space-between; }
.screen-head h1 { font-size: 26px; letter-spacing: 4px; margin: 0; color: #fff; }
.time { color: #7f9bb9; font-size: 13px; }
.kpi-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin: 16px 0; }
.kpi { background: linear-gradient(180deg, #14293f, #0f2135); border: 1px solid #1e3a55; border-radius: 8px; padding: 14px 18px; }
.kpi-label { font-size: 13px; color: #8fb0cc; }
.kpi-value { font-size: 30px; font-weight: 700; margin-top: 6px; }
.chart-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px; }
.panel { background: #0f2135; border: 1px solid #1e3a55; border-radius: 8px; padding: 14px 16px; }
.panel.wide { margin-bottom: 14px; }
.panel-title { font-size: 15px; font-weight: 600; color: #cfe2f5; margin-bottom: 10px; }
.chart { width: 100%; height: 220px; }
.bars { display: flex; flex-direction: column; gap: 8px; }
.bar-row { display: flex; align-items: center; gap: 10px; font-size: 12px; }
.bar-label { width: 110px; text-align: right; color: #9db8d2; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.bar-track { flex: 1; background: #14293f; border-radius: 3px; height: 14px; overflow: hidden; }
.bar-fill { height: 100%; background: linear-gradient(90deg, #e74c3c, #f39c12); border-radius: 3px; }
.bar-fill.green { background: linear-gradient(90deg, #27ae60, #2ecc71); }
.bar-num { width: 60px; color: #dbe7f3; }
/* 大屏内的表格/空态配色覆写为深色（覆盖 ds 组件的 CSS 变量作用域） */
.panel :deep(.ds-table-wrap) { --ds-bg-elevated: #0f2135; --ds-bg-soft: #14293f; --ds-bg-hover: #16304a; --ds-border: #1e3a55; --ds-divider: #1e3a55; --ds-text: #dbe7f3; --ds-text-2: #9db8d2; --ds-text-3: #7f9bb9; }
.panel :deep(.ds-table) { background: transparent; }
.panel :deep(.ds-table th), .panel :deep(.ds-table td) { border-color: #1e3a55; }
.panel :deep(.ds-table-empty) { color: #7f9bb9; }
.panel :deep(.ds-empty__desc) { color: #7f9bb9; }
.money { color: #e74c3c; font-weight: 600; }
</style>
