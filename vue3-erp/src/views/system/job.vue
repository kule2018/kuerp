<template>
  <div class="job-page">
    <DsCard>
      <template #title>定时作业</template>

      <!-- 微信令牌状态条：小程序相关功能的前置条件 -->
      <div class="token">
        <DsTag :color="wechat.hasToken ? 'success' : 'warning'" size="sm">
          {{ wechat.hasToken ? 'access_token 有效' : 'access_token 未获取' }}
        </DsTag>
        <span v-if="wechat.hasToken" class="token__txt">
          剩余 {{ Math.floor(wechat.remain / 60) }} 分钟（{{ wechat.tokenMask }}）
        </span>
        <span v-else class="token__txt is-warn">{{ wechat.lastError || '尚未配置小程序 AppID / AppSecret' }}</span>
      </div>

      <DsTable :columns="cols" :data="jobs" row-key="name" :loading="loading" :striped="true" class="mt">
        <template #enabled="{ row }">
          <DsTag :color="row.enabled ? 'success' : 'neutral'" size="sm">{{ row.enabled ? '启用' : '停用' }}</DsTag>
        </template>

        <template #cron="{ row }">
          <span class="mono">{{ row.cron }}</span>
        </template>

        <template #nextRunAt="{ row }">
          <span class="mono">{{ row.nextRunAt ? fmtTime(row.nextRunAt) : '—' }}</span>
        </template>

        <template #lastRunAt="{ row }">
          <span class="mono">{{ row.lastRunAt ? fmtTime(row.lastRunAt) : '未执行' }}</span>
        </template>

        <template #lastMessage="{ row }">
          <span class="msg" :class="{ 'is-err': !row.lastSuccess }">{{ row.lastMessage || '—' }}</span>
        </template>

        <template #__job_op="{ row }">
          <DsButton size="sm" :loading="row.running" @click="runJob(row)">立即执行</DsButton>
        </template>
      </DsTable>

      <p class="tip">
        提示：作业开关在「系统参数 → 定时作业」里勾选（参数名 <code>job_*</code>）。
        停用 <code>job_wechat_token</code> 后小程序接口会退化为每次现取令牌，请求明显变慢。
      </p>
    </DsCard>

    <DsCard class="mt">
      <template #title>执行历史</template>
      <div class="log-bar">
        <DsSelect v-model="logJob" :options="jobOptions" placeholder="全部作业" clearable class="log-sel" @update:modelValue="loadLogs" />
        <DsButton @click="loadLogs">刷新</DsButton>
      </div>

      <DsTable :columns="logCols" :data="logs" row-key="id" :loading="logLoading" :striped="true" class="mt">
        <template #success="{ row }">
          <DsTag :color="row.success ? 'success' : 'danger'" size="sm">{{ row.success ? '成功' : '失败' }}</DsTag>
        </template>
        <template #createtime="{ row }">
          <span class="mono">{{ fmtTime(row.createtime) }}</span>
        </template>
        <template #message="{ row }">
          <span class="msg">{{ row.message }}</span>
        </template>
      </DsTable>

      <DsPagination
        class="mt"
        :current-page="logPage"
        :page-size="logSize"
        :total="logTotal"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @update:currentPage="onLogPage"
        @update:pageSize="onLogSize"
      />
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 定时作业管理页。
 *
 * 对应后端 GET /system/job/index（作业清单 + 微信令牌状态）、
 * POST /system/job/run（手动触发）、GET /system/job/logs（执行历史）。
 * 仅超级管理员可访问（后端强制）。
 *
 * 用途：运维时确认「作业有没有在跑、跑成功没有、下次什么时候跑」，
 * 以及在配置变更后手动补跑一次（例如刚导入商品预警设置，不想等到明天 08:00）。
 */
import { ref, computed, onMounted } from 'vue';
import { message } from '@/utils/ui';
import request from '@/utils/request';

/** 作业清单 */
const jobs = ref([]);
const loading = ref(false);

/** 微信令牌状态 */
const wechat = ref({ hasToken: false, remain: 0, tokenMask: '', lastError: '' });

/** 执行历史 */
const logs = ref([]);
const logTotal = ref(0);
const logPage = ref(1);
const logSize = ref(20);
const logJob = ref('');
const logLoading = ref(false);

/** 作业下拉选项（由作业清单派生） */
const jobOptions = computed(() => jobs.value.map((j) => ({ label: j.title, value: j.name })));

/** 作业表列配置 */
const cols = [
  { key: 'title', title: '作业', width: '180px' },
  { key: 'cron', title: 'Cron', width: '130px' },
  { key: 'enabled', title: '状态', width: '80px' },
  { key: 'nextRunAt', title: '下次执行', width: '168px' },
  { key: 'lastRunAt', title: '上次执行', width: '168px' },
  { key: 'lastMessage', title: '上次结果', width: '320px' },
  { key: '__job_op', title: '操作', width: '110px', align: 'right' },
];

/** 历史表列配置 */
const logCols = [
  { key: 'createtime', title: '执行时间', width: '168px' },
  { key: 'job_title', title: '作业', width: '160px' },
  { key: 'success', title: '结果', width: '80px' },
  { key: 'cost_ms', title: '耗时(ms)', width: '100px', align: 'right' },
  { key: 'message', title: '摘要', width: '420px' },
];

/**
 * 秒级时间戳转 YYYY-MM-DD HH:mm:ss。
 * @param {number} ts 时间戳
 * @returns {string} 格式化时间
 */
function fmtTime(ts) {
  const n = Number(ts);
  if (!n) return '—';
  const d = new Date(n * 1000);
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}

/**
 * 拉取作业清单与微信令牌状态。
 * @returns {Promise<void>}
 */
async function load() {
  loading.value = true;
  try {
    const r = await request.get('/system/job/index');
    jobs.value = r?.jobs || [];
    wechat.value = r?.wechat || wechat.value;
  } finally {
    loading.value = false;
  }
}

/**
 * 拉取执行历史。
 * @returns {Promise<void>}
 */
async function loadLogs() {
  logLoading.value = true;
  try {
    const params = { page: logPage.value, limit: logSize.value };
    if (logJob.value) params.name = logJob.value;
    const r = await request.get('/system/job/logs', { params });
    logs.value = r?.list || [];
    logTotal.value = Number(r?.count || 0);
  } finally {
    logLoading.value = false;
  }
}

/**
 * 翻页（历史）。
 * @param {number} p 页码
 */
function onLogPage(p) {
  logPage.value = p;
  loadLogs();
}

/**
 * 改每页条数（历史）。
 * @param {number} s 条数
 */
function onLogSize(s) {
  logSize.value = s;
  logPage.value = 1;
  loadLogs();
}

/**
 * 手动触发一个作业，随后刷新清单与历史。
 * @param {object} row 作业行
 * @returns {Promise<void>}
 */
async function runJob(row) {
  row.running = true;
  try {
    const r = await request.post('/system/job/run', { name: row.name });
    const res = r?.result;
    if (res?.message) message.success(res.message);
    else message.warning('作业正在执行中，请稍后刷新查看');
    await load();
    logJob.value = row.name;
    logPage.value = 1;
    await loadLogs();
  } finally {
    row.running = false;
  }
}

onMounted(() => {
  load();
  loadLogs();
});
</script>

<style scoped>
.job-page {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* 令牌状态条 */
.token {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  border-radius: var(--ds-radius);
  background: var(--ds-bg-soft);
  font-size: 13px;
}
.token__txt { color: var(--ds-text-2); }
.token__txt.is-warn { color: var(--ds-warning, #b45309); }

.mono {
  font-variant-numeric: tabular-nums;
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 12.5px;
}
.msg {
  display: inline-block;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 12.5px;
  color: var(--ds-text-2);
}
.msg.is-err { color: var(--ds-danger, #d93026); }

.tip {
  margin: 12px 0 0;
  font-size: 12px;
  line-height: 1.7;
  color: var(--ds-text-3);
}
.tip code {
  padding: 1px 5px;
  border-radius: 4px;
  background: var(--ds-bg-soft);
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
}

.log-bar {
  display: flex;
  align-items: center;
  gap: 8px;
}
.log-sel { width: 180px; }

.mt { margin-top: 12px; }
</style>
