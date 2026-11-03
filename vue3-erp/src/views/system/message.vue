<template>
  <div class="msg-page">
    <DsCard>
      <!-- 工具栏：未读切换 / 类型筛选 / 全部已读 / 刷新 -->
      <div class="bar">
        <DsTabs v-model="tab" :items="tabs" variant="pill" />
        <DsSelect
          v-model="type"
          :options="typeOptions"
          placeholder="全部类型"
          clearable
          class="type-sel"
          @update:modelValue="onSearch"
        />
        <div class="bar__btns">
          <DsButton :disabled="!unreadCount" @click="markAll">全部标记已读</DsButton>
          <DsButton variant="primary" @click="load">刷新</DsButton>
        </div>
      </div>

      <div v-if="loading" class="hint">加载中…</div>

      <DsEmpty v-else-if="!list.length" :title="tab === 'unread' ? '没有未读消息' : '暂无消息'" />

      <!-- 消息列表：每条一张卡片，未读加左侧色条与加粗标题 -->
      <div v-else class="list">
        <div
          v-for="m in list"
          :key="m.id"
          class="item"
          :class="[`is-${m.level || 'info'}`, { 'is-read': m.is_read }]"
        >
          <div class="item__bar"></div>
          <div class="item__body">
            <div class="item__head">
              <span class="item__title">{{ m.title }}</span>
              <DsTag :color="typeColor(m.type)" size="sm">{{ typeLabel(m.type) }}</DsTag>
              <span v-if="!m.is_read" class="dot" title="未读"></span>
              <span class="item__time">{{ fmtTime(m.createtime) }}</span>
            </div>
            <p v-if="m.content" class="item__content">{{ m.content }}</p>
            <div class="item__foot">
              <DsButton v-if="m.link" size="sm" @click="openLink(m)">查看详情</DsButton>
              <DsButton v-if="!m.is_read" size="sm" variant="text" @click="markOne(m)">标为已读</DsButton>
              <DsButton size="sm" variant="text" @click="remove(m)">删除</DsButton>
            </div>
          </div>
        </div>
      </div>

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
  </div>
</template>

<script setup>
/**
 * 消息中心。
 *
 * 数据来源：GET /system/message/index（含广播消息），标记已读/删除走同名 POST 接口。
 * 消息由三类来源产生：
 *   1) 定时作业：库存预警、批次保质期、应收逾期（每日）；
 *   2) 审批流：待我审批 / 我提交的被驳回；
 *   3) 系统事件（预留）。
 * 点击「查看详情」按消息里的 link 跳到对应业务页（link 存的是前端路由路径）。
 */
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { message } from '@/utils/ui';
import request from '@/utils/request';
import { useMessageStore } from '@/store/message';

const router = useRouter();
const msgStore = useMessageStore();

/** 选项卡：全部 / 未读 */
const tab = ref('all');
const tabs = [
  { value: 'all', label: '全部消息' },
  { value: 'unread', label: '未读' },
];

/** 类型筛选 */
const type = ref('');
const typeOptions = [
  { label: '库存预警', value: 'stock_warning' },
  { label: '批次保质期', value: 'batch_expiry' },
  { label: '应收逾期', value: 'ar_due' },
  { label: '审批通知', value: 'approval' },
  { label: '系统消息', value: 'system' },
];

/** 列表与分页 */
const list = ref([]);
const total = ref(0);
const page = ref(1);
const pageSize = ref(20);
const loading = ref(false);

/** 未读条数（顶部按钮可用性 + 与侧栏徽标同步） */
const unreadCount = computed(() => msgStore.unread);

/** 类型中文名 */
const TYPE_LABEL = {
  stock_warning: '库存预警',
  batch_expiry: '批次预警',
  ar_due: '应收逾期',
  approval: '审批',
  system: '系统',
};

/**
 * 类型代码转中文。
 * @param {string} t 类型代码
 * @returns {string} 中文名
 */
function typeLabel(t) {
  return TYPE_LABEL[t] || t || '系统';
}

/**
 * 类型代码转标签色。
 * @param {string} t 类型代码
 * @returns {string} 语义色
 */
function typeColor(t) {
  if (t === 'stock_warning') return 'warning';
  if (t === 'batch_expiry') return 'warning';
  if (t === 'ar_due') return 'danger';
  if (t === 'approval') return 'brand';
  return 'neutral';
}

/**
 * 秒级时间戳转「刚刚 / N 分钟前 / MM-DD HH:mm」。
 * @param {number} ts 秒级时间戳
 * @returns {string} 展示文案
 */
function fmtTime(ts) {
  const n = Number(ts);
  if (!n) return '';
  const diff = Math.floor(Date.now() / 1000) - n;
  if (diff < 60) return '刚刚';
  if (diff < 3600) return `${Math.floor(diff / 60)} 分钟前`;
  if (diff < 86400) return `${Math.floor(diff / 3600)} 小时前`;
  const d = new Date(n * 1000);
  const p = (x) => String(x).padStart(2, '0');
  return `${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}

/**
 * 拉取消息列表。
 * @returns {Promise<void>}
 */
async function load() {
  loading.value = true;
  try {
    const params = { page: page.value, limit: pageSize.value };
    if (tab.value === 'unread') params.unread = 1;
    if (type.value) params.type = type.value;
    const r = await request.get('/system/message/index', { params });
    list.value = r?.list || [];
    total.value = Number(r?.count || 0);
  } finally {
    loading.value = false;
  }
}

/** 切换筛选后回到第一页并重查 */
function onSearch() {
  page.value = 1;
  load();
}

/**
 * 翻页。
 * @param {number} p 页码
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

/**
 * 标记单条已读（同时刷新徽标）。
 * @param {object} m 消息
 * @returns {Promise<void>}
 */
async function markOne(m) {
  await request.post('/system/message/read', { id: m.id });
  m.is_read = 1;
  await msgStore.refresh();
}

/**
 * 全部标记已读。
 * @returns {Promise<void>}
 */
async function markAll() {
  await request.post('/system/message/read-all');
  message.success('已全部标记为已读');
  await msgStore.refresh();
  load();
}

/**
 * 删除一条消息（广播消息后端不允许删，会返回 success=false）。
 * @param {object} m 消息
 * @returns {Promise<void>}
 */
async function remove(m) {
  const r = await request.post('/system/message/del', { id: m.id });
  if (r?.success) {
    message.success('已删除');
    load();
    msgStore.refresh();
  } else {
    message.warning('广播消息不可删除，可标记为已读');
  }
}

/**
 * 跳转到消息关联的业务页，并顺手标记已读。
 * @param {object} m 消息
 * @returns {Promise<void>}
 */
async function openLink(m) {
  if (!m.is_read) await markOne(m);
  const link = String(m.link || '').trim();
  if (link) router.push(link.startsWith('/') ? link : `/${link}`);
}

onMounted(() => {
  load();
  msgStore.refresh();
});
</script>

<style scoped>
.msg-page {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* 顶部工具条：左筛选右操作 */
.bar {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}
.type-sel { width: 150px; }
.bar__btns {
  display: flex;
  gap: 8px;
  margin-left: auto;
}

.hint {
  padding: 28px 0;
  text-align: center;
  color: var(--ds-text-3);
  font-size: 13px;
}

.list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 14px;
}

/* 消息卡片：左侧竖条按级别着色，未读加浅底 */
.item {
  display: flex;
  gap: 0;
  border: 1px solid var(--ds-border);
  border-radius: var(--ds-radius);
  overflow: hidden;
  background: var(--ds-bg);
  transition: border-color var(--ds-dur-fast) var(--ds-ease), box-shadow var(--ds-dur-fast) var(--ds-ease);
}
.item:hover {
  border-color: var(--ds-border-strong, var(--ds-border));
  box-shadow: var(--ds-shadow-sm, 0 1px 4px rgba(0, 0, 0, 0.04));
}
.item.is-read { opacity: 0.78; }

.item__bar {
  flex: none;
  width: 3px;
  background: var(--ds-border);
}
.item.is-info .item__bar { background: var(--ds-brand); }
.item.is-warn .item__bar { background: var(--ds-warning, #d97706); }
.item.is-danger .item__bar { background: var(--ds-danger, #d93026); }

.item__body {
  flex: 1;
  min-width: 0;
  padding: 12px 14px;
}

.item__head {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.item__title {
  font-size: 14px;
  color: var(--ds-text);
  font-weight: 500;
}
.item.is-read .item__title { font-weight: 400; }
.item__time {
  margin-left: auto;
  font-size: 12px;
  color: var(--ds-text-3);
  font-variant-numeric: tabular-nums;
}

/* 未读小圆点 */
.dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--ds-brand);
  display: inline-block;
}

.item__content {
  margin: 6px 0 0;
  font-size: 13px;
  line-height: 1.6;
  color: var(--ds-text-2);
  word-break: break-all;
}

.item__foot {
  display: flex;
  gap: 6px;
  margin-top: 8px;
}

.mt { margin-top: 12px; }
</style>
