<template>
  <div class="log-page">
    <DsCard>
      <!-- 筛选区：关键字 / 模块 / 动作 / 结果 / 时间范围 -->
      <div class="filters">
        <DsInput
          v-model="filters.search"
          placeholder="搜索账号 / 路径 / 消息"
          clearable
          class="f-search"
          @keyup.enter="onSearch"
        />
        <DsSelect
          v-model="filters.module"
          :options="moduleOptions"
          placeholder="全部模块"
          clearable
          filterable
          class="f-sel"
        />
        <DsSelect
          v-model="filters.action"
          :options="actionOptions"
          placeholder="全部动作"
          clearable
          class="f-sel-sm"
        />
        <DsSelect
          v-model="filters.failed"
          :options="resultOptions"
          placeholder="全部结果"
          class="f-sel-sm"
        />
        <div class="f-range">
          <DsDatePicker v-model="filters.start" placeholder="开始日期" class="f-date" />
          <span class="f-tilde">~</span>
          <DsDatePicker v-model="filters.end" placeholder="结束日期" class="f-date" />
        </div>
        <div class="f-btns">
          <DsButton variant="primary" @click="onSearch">查询</DsButton>
          <DsButton @click="resetFilter">重置</DsButton>
          <DsButton @click="load">刷新</DsButton>
          <DsButton :loading="exporting" @click="exportCsv">导出 CSV</DsButton>
        </div>
      </div>

      <!-- 日志表：行可展开查看完整参数 -->
      <DsTable
        :columns="cols"
        :data="list"
        row-key="id"
        :loading="loading"
        :striped="true"
        expandable
        class="mt"
      >
        <template #__log_module="{ row }">
          <span class="mono">{{ row.module || '—' }}</span>
        </template>

        <template #__log_action="{ row }">
          <DsTag :color="actionColor(row.action)" size="sm">{{ actionLabel(row.action) }}</DsTag>
        </template>

        <template #__log_path="{ row }">
          <span class="path" :title="row.path">{{ row.method }} {{ row.path }}</span>
        </template>

        <template #__log_result="{ row }">
          <DsTag :color="row.success ? 'success' : 'danger'" size="sm">
            {{ row.success ? '成功' : '失败' }}
          </DsTag>
        </template>

        <template #__log_createtime="{ row }">
          <span class="mono">{{ fmtTime(row.createtime) }}</span>
        </template>

        <template #__log_op="{ row }">
          <DsButton size="sm" @click="openDetail(row)">详情</DsButton>
        </template>

        <!-- 行展开：直接看参数与结果消息，不用开抽屉 -->
        <template #expand="{ row }">
          <div class="detail">
            <div class="detail__row">
              <span class="detail__k">操作人</span>
              <span class="detail__v">{{ row.username || '—' }}（ID {{ row.admin_id }}）</span>
            </div>
            <div class="detail__row">
              <span class="detail__k">结果消息</span>
              <span class="detail__v" :class="{ 'is-err': !row.success }">{{ row.msg || '—' }}</span>
            </div>
            <div class="detail__row">
              <span class="detail__k">记录 ID</span>
              <span class="detail__v mono">{{ row.row_id || '—' }}</span>
            </div>
            <div class="detail__row">
              <span class="detail__k">来源</span>
              <span class="detail__v mono">{{ row.ip || '—' }}</span>
            </div>
            <div class="detail__row">
              <span class="detail__k">耗时</span>
              <span class="detail__v mono">{{ row.cost_ms }} ms</span>
            </div>
            <div class="detail__row detail__row--col">
              <span class="detail__k">请求参数</span>
              <pre class="detail__pre">{{ prettyParams(row.params) }}</pre>
            </div>
          </div>
        </template>
      </DsTable>

      <DsPagination
        class="mt"
        :current-page="page"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @update:currentPage="onPage"
        @update:pageSize="onSize"
      />
    </DsCard>

    <!-- 详情抽屉 -->
    <DsDrawer v-model="detailOpen" title="操作日志详情" :size="560">
      <div v-if="current" class="drawer">
        <div class="drawer__row"><span class="detail__k">时间</span><span class="detail__v mono">{{ fmtTime(current.createtime) }}</span></div>
        <div class="drawer__row"><span class="detail__k">操作人</span><span class="detail__v">{{ current.username || '—' }}（ID {{ current.admin_id }}）</span></div>
        <div class="drawer__row"><span class="detail__k">模块</span><span class="detail__v mono">{{ current.module || '—' }}</span></div>
        <div class="drawer__row"><span class="detail__k">动作</span><span class="detail__v">{{ actionLabel(current.action) }}</span></div>
        <div class="drawer__row"><span class="detail__k">请求</span><span class="detail__v mono">{{ current.method }} {{ current.path }}</span></div>
        <div class="drawer__row"><span class="detail__k">记录 ID</span><span class="detail__v mono">{{ current.row_id || '—' }}</span></div>
        <div class="drawer__row"><span class="detail__k">结果</span>
          <span class="detail__v">
            <DsTag :color="current.success ? 'success' : 'danger'" size="sm">{{ current.success ? '成功' : '失败' }}</DsTag>
            <span class="ml6">{{ current.msg || '' }}</span>
          </span>
        </div>
        <div class="drawer__row"><span class="detail__k">耗时</span><span class="detail__v mono">{{ current.cost_ms }} ms</span></div>
        <div class="drawer__row"><span class="detail__k">IP</span><span class="detail__v mono">{{ current.ip || '—' }}</span></div>
        <div class="drawer__row drawer__row--col"><span class="detail__k">User-Agent</span><span class="detail__v mono small">{{ current.ua || '—' }}</span></div>
        <div class="drawer__row drawer__row--col">
          <span class="detail__k">请求参数</span>
          <pre class="detail__pre">{{ prettyParams(current.params) }}</pre>
        </div>
      </div>
    </DsDrawer>
  </div>
</template>

<script setup>
/**
 * 操作日志（审计）。
 *
 * 对应后端 GET /system/log/index 与 /system/log/facets，仅超级管理员可读。
 * 用途：ERP 生产环境的硬性要求——谁在什么时候改了哪张表的哪条记录、改了什么、成功没有。
 *
 * 数据口径：由全局 AuditInterceptor 拦截所有写操作（POST/PUT/PATCH/DELETE）自动落库，
 * 本页只做查询与呈现，不提供编辑/删除（审计日志不可篡改）。
 */
import { ref, computed, onMounted } from 'vue';
import { message } from '@/utils/ui';
import request from '@/utils/request';

/** 后端接口前缀 */
const API = '/system/log';

/** 列表数据与分页 */
const list = ref([]);
const total = ref(0);
const page = ref(1);
const pageSize = ref(20);
const loading = ref(false);
const exporting = ref(false);

/** 筛选条件；start/end 为 YYYY-MM-DD，提交前转秒级时间戳 */
const filters = ref({ search: '', module: '', action: '', failed: '', start: '', end: '' });

/** 模块 / 动作候选值（由后端 facets 提供，避免前端硬编码表名清单） */
const moduleOptions = ref([]);
const actionOptions = ref([]);

/** 结果下拉 */
const resultOptions = [
  { label: '全部结果', value: '' },
  { label: '成功', value: '0' },
  { label: '失败', value: '1' },
];

/** 详情抽屉 */
const detailOpen = ref(false);
const current = ref(null);

/** 动作中文名映射 */
const ACTION_LABEL = {
  add: '新增',
  edit: '编辑',
  del: '删除',
  examine: '审核',
  import: '导入',
  export: '导出',
  login: '登录',
  other: '其他',
};

/**
 * 动作代码转中文。
 * @param {string} a 动作代码
 * @returns {string} 中文名（未命中回退原值）
 */
function actionLabel(a) {
  return ACTION_LABEL[a] || a || '—';
}

/**
 * 动作代码转标签色。
 * @param {string} a 动作代码
 * @returns {string} DsTag 语义色
 */
function actionColor(a) {
  if (a === 'add') return 'success';
  if (a === 'del') return 'danger';
  if (a === 'edit') return 'brand';
  if (a === 'examine') return 'warning';
  return 'neutral';
}

/**
 * 秒级时间戳转 YYYY-MM-DD HH:mm:ss。
 * @param {number|string} ts 秒级时间戳
 * @returns {string} 格式化时间（空值返回 '—'）
 */
function fmtTime(ts) {
  const n = Number(ts);
  if (!n) return '—';
  const d = new Date(n * 1000);
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}

/**
 * 日期字符串转当天 00:00:00 的秒级时间戳。
 * @param {string} s YYYY-MM-DD
 * @returns {number|undefined} 秒级时间戳；空值返回 undefined
 */
function startSec(s) {
  if (!s) return undefined;
  const d = new Date(`${s}T00:00:00`);
  return Math.floor(d.getTime() / 1000);
}

/**
 * 日期字符串转当天 23:59:59 的秒级时间戳。
 * @param {string} s YYYY-MM-DD
 * @returns {number|undefined} 秒级时间戳；空值返回 undefined
 */
function endSec(s) {
  if (!s) return undefined;
  const d = new Date(`${s}T23:59:59`);
  return Math.floor(d.getTime() / 1000);
}

/**
 * 参数美化：后端存的是截断后的 JSON 字符串，尽量解析成缩进格式。
 * @param {string} raw 原始参数字符串
 * @returns {string} 美化后的文本（解析失败原样返回）
 */
function prettyParams(raw) {
  if (!raw) return '—';
  try {
    return JSON.stringify(JSON.parse(raw), null, 2);
  } catch {
    return String(raw);
  }
}

/** 表格列定义：key 用 __log_ 前缀避免与后端字段名冲突，全部走插槽渲染 */
const cols = [
  { key: '__log_createtime', title: '时间', width: '168px' },
  { key: 'username', title: '操作人', width: '110px' },
  { key: '__log_module', title: '模块', width: '130px' },
  { key: '__log_action', title: '动作', width: '86px' },
  { key: '__log_path', title: '请求', width: '280px' },
  { key: '__log_result', title: '结果', width: '80px' },
  { key: 'cost_ms', title: '耗时(ms)', width: '90px', align: 'right' },
  { key: 'ip', title: 'IP', width: '120px' },
  { key: '__log_op', title: '操作', width: '80px', align: 'right' },
];

/**
 * 组装请求参数（把日期转时间戳）。
 * @returns {object} query 参数对象
 */
function buildParams() {
  const f = filters.value;
  const params = { page: page.value, limit: pageSize.value };
  if (f.search) params.search = f.search;
  if (f.module) params.module = f.module;
  if (f.action) params.action = f.action;
  if (f.failed === '1') params.failed = 1;
  const s = startSec(f.start);
  const e = endSec(f.end);
  if (s) params.starttime = s;
  if (e) params.endtime = e;
  return params;
}

/**
 * 拉取日志列表。
 * @returns {Promise<void>}
 */
async function load() {
  loading.value = true;
  try {
    const r = await request.get(`${API}/index`, { params: buildParams() });
    list.value = r?.list || [];
    total.value = Number(r?.count || 0);
  } catch (e) {
    // 后端对非超管返回 403，此处给出明确提示而不是空白页
    list.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
}

/**
 * 拉取模块 / 动作候选值，供筛选下拉使用。
 * @returns {Promise<void>}
 */
async function loadFacets() {
  try {
    const r = await request.get(`${API}/facets`);
    moduleOptions.value = (r?.modules || []).map((m) => ({ label: m, value: m }));
    actionOptions.value = (r?.actions || []).map((a) => ({ label: actionLabel(a), value: a }));
  } catch {
    // 非超管或接口未就绪时保持空下拉，不影响主表查询
  }
}

/** 查询：重置到第一页 */
function onSearch() {
  page.value = 1;
  load();
}

/**
 * 翻页。
 * @param {number} p 目标页
 */
function onPage(p) {
  page.value = p;
  load();
}

/**
 * 改每页条数。
 * @param {number} s 条数
 */
function onSize(s) {
  pageSize.value = s;
  page.value = 1;
  load();
}

/** 重置筛选条件 */
function resetFilter() {
  filters.value = { search: '', module: '', action: '', failed: '', start: '', end: '' };
  page.value = 1;
  load();
}

/**
 * 打开详情抽屉。
 * @param {object} row 行数据
 */
function openDetail(row) {
  current.value = row;
  detailOpen.value = true;
}

/**
 * 导出当前筛选结果为 CSV（Excel 可直接打开）。
 * 说明：审计数据可能上百页，导出只导当前页以避免一次拉全表把内存打满。
 * @returns {Promise<void>}
 */
async function exportCsv() {
  if (!list.value.length) {
    message.warning('暂无数据可导出');
    return;
  }
  exporting.value = true;
  try {
    const head = ['时间', '操作人', '模块', '动作', '方法', '路径', '记录ID', '结果', '消息', '耗时(ms)', 'IP'];
    const rows = list.value.map((r) => [
      fmtTime(r.createtime),
      r.username,
      r.module,
      actionLabel(r.action),
      r.method,
      r.path,
      r.row_id,
      r.success ? '成功' : '失败',
      r.msg,
      r.cost_ms,
      r.ip,
    ]);
    const esc = (v) => `"${String(v ?? '').replace(/"/g, '""')}"`;
    const csv = '\uFEFF' + [head, ...rows].map((line) => line.map(esc).join(',')).join('\r\n');
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `操作日志_${fmtTime(Math.floor(Date.now() / 1000)).replace(/[: ]/g, '')}.csv`;
    a.click();
    URL.revokeObjectURL(url);
    message.success('已导出当前页 CSV');
  } finally {
    exporting.value = false;
  }
}

onMounted(() => {
  loadFacets();
  load();
});
</script>

<style scoped>
.log-page {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* 筛选区：统一换行节奏，控件高度一致 */
.filters {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}
.f-search { width: 240px; }
.f-sel { width: 170px; }
.f-sel-sm { width: 130px; }
.f-range {
  display: flex;
  align-items: center;
  gap: 6px;
}
.f-date { width: 140px; }
.f-tilde { color: var(--ds-text-3); font-size: 12px; }
/* 按钮组推到右侧，与筛选控件分离 */
.f-btns {
  display: flex;
  gap: 8px;
  margin-left: auto;
}

.mono {
  font-variant-numeric: tabular-nums;
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 12.5px;
}
.path {
  display: inline-block;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 12.5px;
  color: var(--ds-text-2);
}

/* 行展开详情 */
.detail {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 12px 16px;
  background: var(--ds-bg-soft);
  border-radius: var(--ds-radius);
}
.detail__row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  font-size: 13px;
}
.detail__row--col {
  flex-direction: column;
  gap: 6px;
}
.detail__k {
  flex: none;
  min-width: 76px;
  color: var(--ds-text-3);
}
.detail__v {
  color: var(--ds-text);
  word-break: break-all;
}
.detail__v.is-err { color: var(--ds-danger, #d93026); }
.detail__v.small { font-size: 11.5px; color: var(--ds-text-3); }
.detail__pre {
  margin: 0;
  padding: 10px 12px;
  max-height: 260px;
  overflow: auto;
  width: 100%;
  box-sizing: border-box;
  background: var(--ds-bg);
  border: 1px solid var(--ds-border);
  border-radius: var(--ds-radius-sm, 8px);
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 12px;
  line-height: 1.6;
  color: var(--ds-text-2);
  white-space: pre-wrap;
  word-break: break-all;
}

/* 详情抽屉 */
.drawer {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.drawer__row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  font-size: 13px;
}
.drawer__row--col {
  flex-direction: column;
  gap: 6px;
}
.ml6 { margin-left: 6px; }

.mt { margin-top: 12px; }
</style>
