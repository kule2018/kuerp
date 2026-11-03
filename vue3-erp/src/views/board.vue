<template>
  <div>
    <DsCard>
      <template #title>
        <span>{{ title }}</span>
      </template>

      <DsAlert type="info" :closable="false" show-icon class="mb">
        <template #title>看板说明（见 开发文档/5.购货/10.以销定购看板.md、11.智能补货.md）</template>
        以销货订单的待发数量为驱动，对比当前库存，计算出建议采购量；勾选需要的商品后可一键生成购货订单。
      </DsAlert>

      <!-- 生成参数：供应商编号（原 el-form inline） -->
      <div class="ds-form ds-form--inline row mb">
        <DsField label="供应商编号">
          <DsInput v-model="supplyerCode" placeholder="可选，生成购货订单时带入" clearable style="width: 220px" />
        </DsField>
        <div class="row-btns">
          <DsButton :loading="loading" @click="load">刷新</DsButton>
          <DsButton variant="primary" :disabled="!selected.length" :loading="generating" @click="generate">
            生成购货订单（{{ selected.length }}）
          </DsButton>
          <DsButton variant="default" :loading="aiLoading" @click="doAiAdvice">AI 智能补货建议</DsButton>
        </div>
      </div>

      <!-- 建议采购明细：勾选行后可一键生成购货订单 -->
      <DsTable :columns="columns" :data="list" :loading="loading" :striped="true">
        <!-- 勾选列：受控复选框，选中项存原始行对象 -->
        <template #_sel="{ row }">
          <DsCheckbox :model-value="isSelected(row)" @change="(v) => toggleSelect(row, v)" />
        </template>
        <!-- 采购数量：可手工覆盖建议值 -->
        <template #buy_number="{ row }">
          <DsInput type="number" v-model="row.buy_number" size="sm" style="width: 120px" />
        </template>
        <!-- 采购单价：可手工填写 -->
        <template #unit_price="{ row }">
          <DsInput type="number" v-model="row.unit_price" size="sm" style="width: 120px" />
        </template>
      </DsTable>

      <!-- AI 补货建议弹窗：展示每个商品的紧急度/理由/风险与整体建议，可一键采纳勾选 -->
      <DsModal v-model="aiVisible" title="AI 智能补货建议" :width="880">
        <div v-if="aiLoading" class="ai-loading">AI 正在分析补货清单…</div>
        <template v-else-if="aiAdvice">
          <DsAlert v-if="aiAdvice.summary" type="success" :closable="false" class="mb">{{ aiAdvice.summary }}</DsAlert>
          <div v-for="it in aiAdvice.items" :key="it.goods_code" class="ai-item">
            <div class="ai-item-head">
              <span class="ai-name">{{ it.goods_name }}</span>
              <span class="ai-qty">建议采购 {{ it.suggest_number }}</span>
              <span v-if="it.recommended_supplier_name" class="ai-sup">推荐：{{ it.recommended_supplier_name }}</span>
              <span class="ai-urgency" :class="urgencyCls(it.urgency)">{{ it.urgency }}</span>
            </div>
            <div class="ai-line"><b>建议单价：</b>{{ it.unit_price != null ? '¥' + it.unit_price : '—' }}</div>
            <div class="ai-line"><b>理由：</b>{{ it.reason }}</div>
            <div class="ai-line"><b>风险：</b>{{ it.risk }}</div>
          </div>
          <div class="ai-actions">
            <DsButton variant="primary" @click="applyAdvice">采纳建议（勾选紧急/中项）</DsButton>
          </div>
        </template>
        <div v-else class="ai-loading">（无内容）</div>
      </DsModal>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 以销定购 / 智能补货看板页（数据面板「生成单据」能力）。
 * 功能：
 *  - 依据路由 meta.api 调用后端看板端点（GET /kuerp/boards/purchaseby 或 /kuerp/boards/replenishment），
 *    返回每商品的「待发数量 / 当前库存 / 建议采购量」；
 *  - 采购数量默认取建议采购量，可手动修改；采购单价可填；
 *  - 勾选行后一键生成购货订单（POST /kuerp/boards/generate），写入 kuerp_goods_purchase_order(+info)。
 * 复用同一页面承载两个看板，通过 meta.api 与 meta.title 区分。
 */
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { message, confirm } from '@/utils/ui';
import request from '../utils/request';

const route = useRoute();
const api = computed(() => route.meta.api || '/kuerp/boards/replenishment');
const title = computed(() => route.meta.title || '采购看板');

const list = ref([]);
const selected = ref([]);
const loading = ref(false);
const generating = ref(false);
const supplyerCode = ref('');

/** DsTable 列配置：首列为勾选框，数量与单价列为可编辑单元格 */
const columns = [
  { key: '_sel', title: '', width: '45' },
  { key: 'goods_code', title: '商品编号', width: '140' },
  { key: 'goods_name', title: '商品名称', width: '160' },
  { key: 'sale_number', title: '待发数量', width: '120', align: 'right' },
  { key: 'stock', title: '当前库存', width: '120', align: 'right' },
  { key: 'buy_number', title: '采购数量', width: '150' },
  { key: 'unit_price', title: '采购单价', width: '150' },
];

/** 拉取看板建议采购数据 */
async function load() {
  loading.value = true;
  try {
    const r = await request.get(api.value);
    // 采购数量/单价预置：数量默认建议采购量，便于直接勾选生成
    list.value = (Array.isArray(r) ? r : []).map((x) => ({
      ...x,
      buy_number: x.suggest_number || 0,
      unit_price: 0,
    }));
  } catch (e) {
    message.error(e?.response?.data?.msg || '加载失败');
  } finally {
    loading.value = false;
  }
}

/**
 * 判断某行是否已勾选。
 * @param row 看板数据行
 * @returns 已勾选为 true
 */
function isSelected(row) {
  return selected.value.includes(row);
}

/**
 * 勾选 / 取消勾选某行，同步维护选中行数组。
 * @param row 看板数据行
 * @param on 是否勾选
 * @returns 无
 */
function toggleSelect(row, on) {
  selected.value = on ? [...selected.value, row] : selected.value.filter((r) => r !== row);
}

/** 由勾选行生成购货订单 */
async function generate() {
  if (!selected.value.length) return;
  const rows = selected.value
    .filter((r) => r.buy_number > 0)
    .map((r) => ({
      goods_code: r.goods_code,
      number: r.buy_number,
      unit_price: r.unit_price || 0,
      supplyer_code: supplyerCode.value || undefined,
    }));
  if (!rows.length) {
    message.warning('请至少为一行填写大于 0 的采购数量');
    return;
  }
  try {
    await confirm(`将勾选的 ${rows.length} 个商品生成购货订单？`, '生成确认', { type: 'info' });
  } catch {
    return;
  }
  generating.value = true;
  try {
    const r = await request.post('/kuerp/boards/generate', { rows });
    message.success(`已生成购货订单：${r?.purchase_code || ''}`);
  } catch (e) {
    message.error(e?.response?.data?.msg || '生成失败');
  } finally {
    generating.value = false;
  }
}

onMounted(load);

/** ============== AI 智能补货建议 ============== */
const aiVisible = ref(false);
const aiAdvice = ref(null);
const aiLoading = ref(false);

/** 调用后端 AI 补货建议接口：把当前看板行发给模型，产出结构化建议 */
async function doAiAdvice() {
  if (!list.value.length) {
    message.warning('当前没有可分析的补货数据');
    return;
  }
  aiVisible.value = true;
  aiLoading.value = true;
  aiAdvice.value = null;
  try {
    const rows = list.value.map((r) => ({
      goods_code: r.goods_code,
      goods_name: r.goods_name,
      sale_number: r.sale_number,
      stock: r.stock,
      suggest_number: r.suggest_number,
    }));
    const r = await request.post('/ai/replenish-advice', { items: rows });
    aiAdvice.value = r || null;
  } catch (e) {
    message.error('AI 建议失败：' + (e?.response?.data?.msg || e.message || e));
  } finally {
    aiLoading.value = false;
  }
}

/** 紧急度 -> 样式类（高/中/低） */
function urgencyCls(u) {
  return { 高: 'u-high', 中: 'u-mid', 低: 'u-low' }[u] || 'u-mid';
}

/**
 * 采纳建议：自动勾选紧急/中等级商品，并把 AI 给出的单价写回对应行。
 * 采购单是整单单一供应商，因此推荐供应商在“用户未手选”时填到整单级 supplyerCode（generate 会带入采购单）。
 */
function applyAdvice() {
  const items = aiAdvice.value?.items || [];
  const map = new Map(
    items.filter((i) => i.urgency === '高' || i.urgency === '中').map((i) => [i.goods_code, i]),
  );
  const picked = [];
  for (const r of list.value) {
    const adv = map.get(r.goods_code);
    if (!adv) continue;
    if (adv.unit_price != null) r.unit_price = adv.unit_price;
    picked.push(r);
  }
  // 整单供应商：用户没手选时，取勾选项中第一个有推荐供应商的项
  if (!supplyerCode.value) {
    const rec = picked.map((r) => map.get(r.goods_code)?.recommended_supplier_code).find(Boolean);
    if (rec) supplyerCode.value = rec;
  }
  selected.value = picked;
  aiVisible.value = false;
  if (picked.length)
    message.success(`已勾选 ${picked.length} 个建议补货项${supplyerCode.value ? '（已带入推荐供应商）' : ''}，可点「生成购货订单」`);
  else message.warning('建议项中无紧急/中等级，未自动勾选');
}
</script>

<style scoped>
.mb { margin-bottom: 16px; }
/* 参数行：供应商输入 + 按钮组横向排列 */
.row { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 12px; }
.row-btns { display: flex; gap: 8px; }
/* AI 补货建议弹窗样式 */
.ai-loading { padding: 24px; text-align: center; color: var(--ds-text-3); }
.ai-item { border: 1px solid var(--ds-border); border-radius: var(--ds-radius-md); padding: 10px 12px; margin-bottom: 10px; }
.ai-item-head { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; }
.ai-name { font-weight: 600; }
.ai-qty { color: var(--ds-text-3); font-size: 13px; }
.ai-sup { color: var(--ds-brand, #4f46e5); font-size: 12px; background: var(--ds-bg-hover, #f3f4f6); padding: 1px 8px; border-radius: 8px; }
.ai-urgency { margin-left: auto; padding: 2px 8px; border-radius: 10px; font-size: 12px; }
.u-high { background: rgba(239, 68, 68, 0.12); color: #ef4444; }
.u-mid { background: rgba(245, 158, 11, 0.12); color: #f59e0b; }
.u-low { background: rgba(34, 197, 94, 0.12); color: #22c55e; }
.ai-line { font-size: 13px; color: var(--ds-text-2); line-height: 1.6; }
.ai-actions { margin-top: 12px; text-align: right; }
</style>
