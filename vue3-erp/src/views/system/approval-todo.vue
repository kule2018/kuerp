<template>
  <div class="todo-page">
    <DsCard>
      <!-- 筛选区：单据类型 + 刷新 -->
      <div class="filters">
        <DsSelect
          v-model="docTable"
          :options="typeOptions"
          placeholder="全部单据类型"
          clearable
          class="f-sel"
        />
        <div class="f-btns">
          <DsButton variant="primary" @click="onSearch">查询</DsButton>
          <DsButton @click="reset">重置</DsButton>
          <DsButton @click="load">刷新</DsButton>
        </div>
        <span class="hint">共 {{ total }} 条待办</span>
      </div>

      <DsTable :columns="cols" :data="list" row-key="id" :loading="loading" :striped="true" class="mt">
        <template #__doc_code="{ row }">
          <span class="mono">{{ row.doc_code || '#' + row.doc_id }}</span>
        </template>

        <template #__doc_table="{ row }">
          <DsTag color="brand" size="sm">{{ tableLabel(row.doc_table) }}</DsTag>
        </template>

        <template #__level="{ row }">
          <span class="lv">第 {{ row.level }} / {{ row.total_level }} 级</span>
        </template>

        <template #__time="{ row }">
          <span class="time">{{ fmtTime(row.createtime) }}</span>
        </template>

        <template #__action="{ row }">
          <DsButton variant="text" size="sm" @click="openPanel(row)">详情</DsButton>
          <DsButton variant="text" size="sm" @click="openAct(row, 'approve')">通过</DsButton>
          <DsButton variant="text" size="sm" @click="openAct(row, 'reject')">驳回</DsButton>
        </template>
      </DsTable>

      <DsPagination
        v-if="total > 0"
        class="mt"
        :current-page="page"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @update:current-page="onPage"
        @update:page-size="onSize"
      />
    </DsCard>

    <!-- 审批详情面板（复用组件，内部自带通过/驳回） -->
    <ApprovalPanel
      v-model="panelVisible"
      :doc-table="current.doc_table"
      :doc-id="current.doc_id"
      :doc-code="current.doc_code"
      @changed="load"
    />

    <!-- 快捷通过/驳回弹窗：只填意见，减少一次跳转 -->
    <DsModal v-model="actVisible" :title="actKind === 'approve' ? '审批通过' : '审批驳回'" :width="460">
      <p class="act-tip">
        单据 <b>{{ current.doc_code || '#' + current.doc_id }}</b>
        （第 {{ current.level }}/{{ current.total_level }} 级）
      </p>
      <DsInput
        v-model="remark"
        type="textarea"
        :rows="3"
        :placeholder="actKind === 'reject' ? '驳回意见（必填）' : '审批意见（可选）'"
      />
      <template #footer>
        <DsButton @click="actVisible = false">取消</DsButton>
        <DsButton
          :variant="actKind === 'reject' ? 'danger' : 'primary'"
          :loading="acting"
          @click="submitAct"
        >{{ actKind === 'approve' ? '确认通过' : '确认驳回' }}</DsButton>
      </template>
    </DsModal>
  </div>
</template>

<script setup lang="ts">
/**
 * 审批待办页。
 *
 * 【用途】
 * 汇总「当前登录用户角色范围内」所有处于待审状态的单据审批记录，
 * 支持直接通过/驳回，或打开审批详情看完整流转链。
 *
 * 【与消息中心的联动】
 * 审批流每次推进都会给下一级审批人写一条 type=approval 的消息，
 * 消息里的 link 指向本页（/approval-todo），点击即可到达。
 *
 * 【为什么不在前端按角色过滤】
 * 角色集合（kuerp_auth_group_access）以后端为准，前端不知道当前用户属于哪些组；
 * 后端 /kuerp/approval/todo 已按 role_id 过滤，前端只负责展示。
 */
import { onMounted, reactive, ref } from 'vue';
import ApprovalPanel from '../../components/biz/ApprovalPanel.vue';
import { message } from '../../utils/ui';
import request from '../../utils/request';

/** 一条待办记录 */
interface TodoRow {
  id: number;
  doc_table: string;
  doc_id: number;
  doc_code: string;
  level: number;
  total_level: number;
  result: string;
  createtime: number;
  updatetime: number;
}

/**
 * 单据表名 -> 中文名。
 * 只列已配置审批流的常见单据；未列出的直接显示原始表名（避免瞎猜中文名）。
 */
const TABLE_LABEL: Record<string, string> = {
  goods_purchase_order: '购货订单',
  goods_sales_order: '销货订单',
  goods_purchase: '购货单',
  goods_sales: '销货单',
  goods_exchange: '购货退货单',
  goods_sales_exchange: '销货退货单',
  allocation: '调拨单',
  assemble: '组装单',
  split: '拆卸单',
  adjustment: '成本调整单',
  inventory: '盘点单',
  warehousing: '其他入库单',
  warehouse: '其他出库单',
  collection: '收款单',
  payment: '付款单',
  income: '其他收入单',
  expenditure: '其他支出单',
};

/** 单据类型下拉选项 */
const typeOptions = Object.entries(TABLE_LABEL).map(([value, label]) => ({ value, label }));

/** 表格列 */
const cols = [
  { key: '__doc_code', title: '单据编号', width: '160px' },
  { key: '__doc_table', title: '单据类型', width: '120px' },
  { key: '__level', title: '审批级次', width: '120px' },
  { key: '__time', title: '提交时间', width: '160px' },
  { key: '__action', title: '操作', width: '190px', align: 'right' as const },
];

/** 列表数据 */
const list = ref<TodoRow[]>([]);
/** 总数 */
const total = ref(0);
/** 加载中 */
const loading = ref(false);
/** 分页 */
const page = ref(1);
const pageSize = ref(20);
/** 单据类型筛选 */
const docTable = ref('');

/** 当前操作的记录（详情面板与快捷弹窗共用） */
const current = reactive<Partial<TodoRow>>({});
/** 详情面板可见 */
const panelVisible = ref(false);
/** 快捷操作弹窗可见 */
const actVisible = ref(false);
/** 快捷操作类型 */
const actKind = ref<'approve' | 'reject'>('approve');
/** 审批意见 */
const remark = ref('');
/** 提交中 */
const acting = ref(false);

/** 表名转中文 */
function tableLabel(t: string): string {
  return TABLE_LABEL[t] || t;
}

/**
 * 秒级时间戳格式化。
 * @param ts 秒级时间戳
 * @returns yyyy-MM-dd HH:mm
 */
function fmtTime(ts: number): string {
  if (!ts) return '—';
  const d = new Date(Number(ts) * 1000);
  const p = (n: number): string => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}

/** 拉取待办列表 */
async function load(): Promise<void> {
  loading.value = true;
  try {
    const params: Record<string, any> = { page: page.value, limit: pageSize.value };
    if (docTable.value) params.doc_table = docTable.value;
    const r = await request.get('/kuerp/approval/todo', { params });
    list.value = Array.isArray(r?.list) ? r.list : [];
    total.value = Number(r?.count) || 0;
  } catch {
    list.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
}

/** 查询（回到第一页） */
function onSearch(): void {
  page.value = 1;
  load();
}

/** 重置筛选 */
function reset(): void {
  docTable.value = '';
  page.value = 1;
  load();
}

/** 翻页 */
function onPage(p: number): void {
  page.value = p;
  load();
}

/** 改每页条数 */
function onSize(s: number): void {
  pageSize.value = s;
  page.value = 1;
  load();
}

/**
 * 打开审批详情面板。
 * @param row 行数据
 */
function openPanel(row: TodoRow): void {
  Object.assign(current, row);
  panelVisible.value = true;
}

/**
 * 打开快捷操作弹窗。
 * @param row 行数据
 * @param kind approve=通过 reject=驳回
 */
function openAct(row: TodoRow, kind: 'approve' | 'reject'): void {
  Object.assign(current, row);
  actKind.value = kind;
  remark.value = '';
  actVisible.value = true;
}

/** 提交快捷操作 */
async function submitAct(): Promise<void> {
  if (acting.value) return;
  if (actKind.value === 'reject' && !remark.value.trim()) {
    message.warning('驳回请填写意见，便于提交人修改');
    return;
  }
  acting.value = true;
  try {
    const r = await request.post(`/kuerp/approval/${actKind.value}`, {
      doc_table: current.doc_table,
      doc_id: current.doc_id,
      remark: remark.value.trim(),
    });
    if (actKind.value === 'approve') {
      message.success(r?.posted ? '审批通过，单据已审核并过账' : '审批通过，已转下一级');
    } else {
      message.success('已驳回');
    }
    actVisible.value = false;
    await load();
  } catch {
    // 错误提示由 request 拦截器统一弹出
  } finally {
    acting.value = false;
  }
}

onMounted(load);
</script>

<style scoped>
.todo-page { display: flex; flex-direction: column; gap: 12px; }
.filters { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.f-sel { width: 200px; }
.f-btns { display: flex; gap: 8px; }
.hint { font-size: var(--ds-font-xs); color: var(--ds-text-3); margin-left: auto; }
.mono { font-variant-numeric: tabular-nums; }
.lv { color: var(--ds-text-2); }
.time { color: var(--ds-text-3); font-variant-numeric: tabular-nums; }
.act-tip { margin: 0 0 12px; font-size: var(--ds-font-sm); color: var(--ds-text-2); }
.mt { margin-top: 12px; }
</style>
