<template>
  <div>
    <DsCard>
      <template #title>
        <div style="display:flex;justify-content:space-between;align-items:center">
          <span>系统参数</span>
          <DsButton variant="primary" :loading="saving" @click="save">保存</DsButton>
        </div>
      </template>

      <DsAlert type="info" :closable="false" show-icon class="mb">
        <template #title>系统参数（见 开发文档/3.设置/1.系统参数.md）</template>
        按参数类型分组维护。开关类参数用右侧开关控制；文本类参数直接编辑取值。标记为「不允许修改」的参数为只读。
      </DsAlert>

      <div>
        <DsCard v-for="g in groups" :key="g.type" class="group">
          <template #title><span>{{ g.label }}</span></template>
          <!--
            参数行（原 el-form + el-form-item，label-width 180px）：
            ds 的 DsField 是「标签在上」布局，这里按原系统横向排版用自定义行 + 固定宽标签，
            保持参数名 / 开关 / 取值 / 说明 四段对齐。
          -->
          <div v-for="item in g.items" :key="item.id" class="param">
            <span class="param-label">{{ item.nickname || item.name }}</span>
            <div class="param-ctl">
              <!-- 开关：原 el-switch 的 active-value=1 / inactive-value=0，ds 开关只认布尔，故在此转换 -->
              <DsSwitch
                :model-value="Number(item.is_checked) === 1"
                :disabled="isLocked(item)"
                @change="(v) => (item.is_checked = v ? 1 : 0)"
              />
              <DsInput v-model="item.value" :disabled="isLocked(item)" placeholder="参数取值" class="value-input" />
              <span class="explain">{{ item.explain }}</span>
            </div>
          </div>
        </DsCard>

        <!-- 单号设置：自定义各单据编号的组合规则（前缀 + 日期段 + 流水号） -->
        <DsCard class="group">
          <template #title>
            <div style="display:flex;justify-content:space-between;align-items:center">
              <span>单号设置</span>
              <DsButton variant="primary" :loading="prefixSaving" @click="savePrefix">保存单号规则</DsButton>
            </div>
          </template>
          <DsAlert type="warning" :closable="false" show-icon class="mb">
            勾选表示该日期段参与编号；「起始数」为流水号起点，「数字长度」为流水号补零位数。
            已产生数据的单据不可再修改其组合规则（服务端强校验）。
          </DsAlert>
          <!-- 单号规则表：前缀 + 日期段勾选 + 流水号，示例实时预览 -->
          <DsTable :columns="prefixColumns" :data="prefixes" :loading="loading" :striped="true">
            <!-- 前缀 -->
            <template #prefix="{ row }">
              <DsInput v-model="row.prefix" size="sm" maxlength="10" />
            </template>
            <!-- 日期段：'1'=参与编号，'2'=不参与（与原系统枚举一致，ds 复选框只认布尔故转换） -->
            <template v-for="seg in DATE_SEGS" :key="seg.key" #[seg.key]="{ row }">
              <DsCheckbox
                :model-value="String(row[seg.key]) === '1'"
                @change="(v) => (row[seg.key] = v ? '1' : '2')"
              />
            </template>
            <!-- 流水号起始值与补零长度 -->
            <template #start="{ row }">
              <DsInput type="number" v-model="row.start" size="sm" style="width:100%" />
            </template>
            <template #strlen="{ row }">
              <DsInput type="number" v-model="row.strlen" size="sm" style="width:100%" />
            </template>
            <!-- 示例：按当前规则实时拼接 -->
            <template #_example="{ row }">
              <span class="mono">{{ prefixExample(row) }}</span>
            </template>
          </DsTable>
        </DsCard>
      </div>
    </DsCard>
  </div>
</template>

<script setup>
/**
 * 系统参数分组表单页（对应 开发文档/3.设置/1.系统参数.md）。
 * 功能：
 *  - 拉取 kuerp_sets 全部参数（GET /kuerp/sets/index）；
 *  - 按 type 分组（1=基础参数 / 2=功能参数 / 3=价格取数优先级 / 4=订货通小程序）渲染为可编辑表单；
 *  - 每项含开关（is_checked，是否启用）与取值（value）；is_edit=1 的参数只读；
 *  - 保存：逐条 POST /kuerp/sets/edit 回写 value 与 is_checked；
 *  - 单号设置（kuerp_prefix）：维护各单据编号的前缀 + 日期段 + 流水号规则，
 *    示例实时预览，保存走 POST /kuerp/sets/prefix-save（已产生数据的单据服务端禁止改规则）。
 */
import { ref, computed, onMounted } from 'vue';
import { message } from '@/utils/ui';
import request from '../utils/request';

const loading = ref(false);
const saving = ref(false);
const prefixSaving = ref(false);
const items = ref([]);
/** 单号规则列表（kuerp_prefix） */
const prefixes = ref([]);

/** 参与编号的日期段定义（值 '1'=参与，'2'=不参与，与原系统枚举一致） */
const DATE_SEGS = [
  { key: 'year', label: '年' },
  { key: 'month', label: '月' },
  { key: 'day', label: '日' },
  { key: 'hour', label: '时' },
  { key: 'minute', label: '分' },
  { key: 'second', label: '秒' },
];

/** 单号规则表列配置：单据名 + 前缀 + 6 个日期段 + 起始数/长度/示例 */
const prefixColumns = [
  { key: 'name', title: '单据', width: '120' },
  { key: 'prefix', title: '前缀', width: '100' },
  ...DATE_SEGS.map((s) => ({ key: s.key, title: s.label, width: '56', align: 'center' })),
  { key: 'start', title: '起始数', width: '96' },
  { key: 'strlen', title: '数字长度', width: '96' },
  { key: '_example', title: '示例', width: '180' },
];

const TYPE_LABEL = {
  1: '基础参数',
  2: '功能参数',
  3: '价格取数优先级',
  4: '订货通小程序',
  5: '定时作业',
};

/** 按 type 分组成表单分区 */
const groups = computed(() => {
  const map = new Map();
  for (const it of items.value) {
    const t = Number(it.type) || 1;
    if (!map.has(t)) map.set(t, []);
    map.get(t).push(it);
  }
  return [...map.entries()]
    .sort((a, b) => a[0] - b[0])
    .map(([type, list]) => ({ type, label: TYPE_LABEL[type] || `参数组 ${type}`, items: list }));
});

/** 是否锁定不可修改（is_edit=1 表示不允许修改） */
function isLocked(item) {
  return Number(item.is_edit) === 1;
}

/** 拉取全部系统参数与单号规则 */
async function load() {
  loading.value = true;
  try {
    const [sets, prefix] = await Promise.all([
      request.get('/kuerp/sets/index', { params: { limit: 500 } }),
      request.get('/kuerp/prefix/index', { params: { limit: 200 } }),
    ]);
    items.value = Array.isArray(sets?.list) ? sets.list : Array.isArray(sets) ? sets : [];
    prefixes.value = (Array.isArray(prefix?.list) ? prefix.list : []).map((p) => ({
      id: p.id,
      name: p.name,
      prefix: p.prefix,
      year: String(p.year),
      month: String(p.month),
      day: String(p.day),
      hour: String(p.hour),
      minute: String(p.minute),
      second: String(p.second),
      start: Number(p.start) || 0,
      strlen: Number(p.strlen) || 1,
    }));
  } catch (e) {
    message.error(e?.response?.data?.msg || '加载失败');
  } finally {
    loading.value = false;
  }
}

/**
 * 生成单号示例（与原系统 example 生成口径一致）：
 * 前缀 + 勾选的日期段（YYYY/MM/DD/HH/mm/ss）+ 补零后的起始数。
 * @param row 单号规则行
 * @returns 示例编号字符串
 */
function prefixExample(row) {
  const d = new Date();
  const p2 = (n) => String(n).padStart(2, '0');
  const segs = {
    year: String(d.getFullYear()),
    month: p2(d.getMonth() + 1),
    day: p2(d.getDate()),
    hour: p2(d.getHours()),
    minute: p2(d.getMinutes()),
    second: p2(d.getSeconds()),
  };
  let code = String(row.prefix || '');
  for (const s of DATE_SEGS) {
    if (String(row[s.key]) === '1') code += segs[s.key];
  }
  const len = Math.max(1, Number(row.strlen) || 1);
  code += String(Math.max(0, Number(row.start) || 0)).padStart(len, '0');
  return code;
}

/** 保存单号组合规则 */
async function savePrefix() {
  prefixSaving.value = true;
  try {
    const r = await request.post('/kuerp/sets/prefix-save', {
      rows: prefixes.value.map((p) => ({
        id: p.id,
        prefix: p.prefix,
        year: p.year,
        month: p.month,
        day: p.day,
        hour: p.hour,
        minute: p.minute,
        second: p.second,
        start: p.start,
        strlen: p.strlen,
      })),
    });
    message.success(`单号规则已保存（更新 ${r?.updated ?? 0} 条）`);
  } catch (e) {
    message.error(e?.response?.data?.msg || e?.message || '保存失败');
  } finally {
    prefixSaving.value = false;
  }
}

/** 保存：逐条回写 value 与 is_checked */
async function save() {
  saving.value = true;
  let done = 0;
  try {
    for (const it of items.value) {
      if (isLocked(it)) continue;
      await request.post('/kuerp/sets/edit', {
        id: it.id,
        value: it.value,
        is_checked: Number(it.is_checked),
      });
      done++;
    }
    message.success(`已保存 ${done} 项参数`);
  } catch (e) {
    message.error(e?.response?.data?.msg || '保存失败');
  } finally {
    saving.value = false;
  }
}

onMounted(load);
</script>

<style scoped>
.mb { margin-bottom: 16px; }
.group { margin-bottom: 16px; }
.value-input { width: 260px; margin-left: 12px; }
.explain { margin-left: 12px; color: var(--ds-text-3); font-size: 12px; }
.mono { font-family: Consolas, Monaco, monospace; font-size: 13px; }
/* 参数行：固定宽标签 + 右侧控件区（还原原系统 label-width=180px 的横向排版） */
.param { display: flex; align-items: center; gap: 12px; padding: 6px 0; }
.param-label { flex: 0 0 180px; color: var(--ds-text-2); font-size: 13px; }
.param-ctl { display: flex; align-items: center; gap: 4px; flex-wrap: wrap; }
</style>
