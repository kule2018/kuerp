<template>
  <DsCard>
    <template #title>
      <div class="head">
        <span>角色管理</span>
        <DsButton variant="primary" @click="openAdd">新增角色</DsButton>
      </div>
    </template>

    <DsTable :columns="columns" :data="list" :loading="loading" :striped="true">
      <!-- 序号列 -->
      <template #_index="{ index }">{{ index + 1 }}</template>
      <!-- 权限节点数：'*' 表示全部权限 -->
      <template #rules="{ row }">
        <DsTag v-if="String(row.rules || '').trim() === '*'" color="success" size="sm">全部</DsTag>
        <span v-else>{{ String(row.rules || '').split(',').filter(Boolean).length }}</span>
      </template>
      <!-- 状态 -->
      <template #status="{ row }">
        <DsTag :color="Number(row.status) === 1 ? 'success' : 'neutral'" size="sm">
          {{ Number(row.status) === 1 ? '正常' : '禁用' }}
        </DsTag>
      </template>
      <!-- 数据权限 -->
      <template #data_scope="{ row }">
        <DsTag :color="Number(row.data_scope) === 2 ? 'warning' : 'info'" size="sm">
          {{ Number(row.data_scope) === 2 ? '仅本人数据' : '全部数据' }}
        </DsTag>
      </template>
      <!-- 操作列 -->
      <template #_action="{ row }">
        <div class="ops">
          <DsButton variant="text" @click="openEdit(row)">编辑</DsButton>
          <DsButton variant="text" @click="onDel(row)">删除</DsButton>
        </div>
      </template>
    </DsTable>

    <!-- 新增 / 编辑角色：rules 用权限节点复选框树编辑，避免手输节点名出错 -->
    <DsModal :title="editing ? '编辑角色' : '新增角色'" v-model="dialog" :width="780" @close="reset">
      <!-- 表单：原 el-form（label-width 90px）改为 DsField -->
      <DsField label="角色名称" required>
        <DsInput v-model="form.name" maxlength="50" />
      </DsField>
      <!-- 状态：原 el-radio-group，ds 用同 v-model 的多个 DsRadio 组成组 -->
      <DsField label="状态">
        <div class="radios">
          <DsRadio v-model="form.status" :value="1">正常</DsRadio>
          <DsRadio v-model="form.status" :value="0">禁用</DsRadio>
        </div>
      </DsField>
      <DsField label="数据权限">
        <DsSelect v-model="form.data_scope" :options="dataScopeOptions" />
      </DsField>
      <DsField label="权限节点">
        <div class="rule-box">
          <!-- 工具条：全选（受控+半选）、已选计数、关键字搜索 -->
          <div class="rule-toolbar">
            <DsCheckbox :model-value="allChecked" :indeterminate="indeterminate" @change="onAllChange">全选</DsCheckbox>
            <span class="rule-count">已选 {{ form.rules.length }} / {{ ruleNodes.length }} 项</span>
            <DsInput v-model="keyword" placeholder="搜索权限名称或节点" size="sm" class="rule-search" />
          </div>
          <!-- 两类权限分开管理：menu=菜单/页面(同时即接口权限)；action=按钮 -->
          <DsTabs v-model="activeTab" variant="pill" :items="tabItems" class="rule-tabs" />
          <div class="rule-body">
            <!-- 菜单 / 页面权限：按模块分组 -->
            <template v-if="activeTab === 'menu'">
              <div v-for="g in menuGroups" :key="g.title" class="grp">
                <div class="grp-head">
                  <DsCheckbox size="sm" :model-value="grpAll(g.items)" :indeterminate="grpSome(g.items)" @change="toggleGrp(g.items, $event)">
                    {{ g.title }}
                  </DsCheckbox>
                  <DsTag size="sm" color="neutral">{{ g.items.length }}</DsTag>
                </div>
                <div class="grp-grid">
                  <DsCheckbox v-for="n in g.items" :key="n.name" v-model="form.rules" :value="n.name" :title="n.name" size="sm">
                    {{ n.label }}
                  </DsCheckbox>
                </div>
              </div>
            </template>
            <!-- 按钮权限：按业务表分组，一组即一张表的操作按钮 -->
            <template v-else>
              <div v-for="g in actionGroups" :key="g.key" class="grp">
                <div class="grp-head">
                  <DsCheckbox size="sm" :model-value="grpAll(g.items)" :indeterminate="grpSome(g.items)" @change="toggleGrp(g.items, $event)">
                    {{ g.title }}
                  </DsCheckbox>
                  <DsTag size="sm" color="neutral">{{ g.group }}</DsTag>
                </div>
                <div class="grp-grid">
                  <DsCheckbox v-for="n in g.items" :key="n.name" v-model="form.rules" :value="n.name" :title="n.name" size="sm">
                    {{ n.label }}
                  </DsCheckbox>
                </div>
              </div>
            </template>
            <div v-if="activeTab === 'menu' && !menuGroups.length" class="rule-empty">没有匹配的权限节点</div>
            <div v-if="activeTab === 'action' && !actionGroups.length" class="rule-empty">没有匹配的权限节点</div>
          </div>
        </div>
      </DsField>
      <template #footer>
        <DsButton @click="dialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="submit">保存</DsButton>
      </template>
    </DsModal>
  </DsCard>
</template>

<script setup>
/**
 * 角色管理页：1:1 还原原系统「角色管理（auth/group）」。
 * 数据落在 kuerp_auth_group 表，权限以逗号分隔节点名存于 rules 列；
 * 节点清单来自 kuerp_auth_rule（权限规则页维护），此处用复选框树编辑，避免手输错误。
 * RbacGuard 依 rules 命中请求路径 kuerp/<table> 放行/拦截。
 */
import { ref, computed, onMounted } from 'vue';
import { message, confirm } from '@/utils/ui';
import request from '../../utils/request';
import { menus } from '../../menus';

const list = ref([]);
const ruleNodes = ref([]);
const loading = ref(false);
const dialog = ref(false);
const editing = ref(false);
const saving = ref(false);
const form = ref({ name: '', status: 1, rules: [], data_scope: 1 });
/** 数据权限选项：1=全部数据，2=仅本人创建数据 */
const dataScopeOptions = [
  { value: 1, label: '全部数据' },
  { value: 2, label: '仅本人数据' },
];

/* ============ 权限节点分组元数据 ============
 * 菜单节点（type=menu）与按钮节点（type=action）共用 kuerp_auth_rule，
 * 这里从菜单唯一事实源（menus.js）提取两份映射，用于把生硬的节点名
 * 翻译成中文标题并归入对应模块，解决「分不清哪个是什么权限」的问题：
 *   nodeMeta  菜单节点名 -> { title 菜单标题, group 所属模块 }
 *   tableMeta 业务表名   -> { title 菜单标题, group 所属模块 }（按钮节点按表归组）
 */
const nodeMeta = {};
const tableMeta = {};
(function buildMeta() {
  const put = (m, group) => {
    if (m.perm && !nodeMeta[m.perm]) nodeMeta[m.perm] = { title: m.title, group };
    if (m.api && m.api.startsWith('/kuerp/')) {
      const t = m.api.slice('/kuerp/'.length).replace(/-/g, '_');
      if (!tableMeta[t]) tableMeta[t] = { title: m.title, group };
    }
  };
  menus.forEach((g) => {
    if (g.children) g.children.forEach((m) => put(m, g.title));
    else put(g, '基础功能'); // 顶层叶子：工作台 / 数字大屏 / 打印中心
  });
})();

/** 按钮动作名 -> 中文 */
const ACTION_LABELS = { add: '新增', edit: '编辑', del: '删除', examine: '审核', import: '导入', export: '导出' };

/** 权限节点编辑区状态：关键字过滤 + 当前 Tab */
const keyword = ref('');
const activeTab = ref('menu');

/** DsTable 列配置 */
const columns = [
  { key: '_index', title: '#', width: '50' },
  { key: 'name', title: '角色名称', width: '140' },
  { key: 'rules', title: '权限节点数', width: '100', align: 'center' },
  { key: 'data_scope', title: '数据权限', width: '100', align: 'center' },
  { key: 'status', title: '状态', width: '90', align: 'center' },
  { key: '_action', title: '操作', width: '160' },
];

/** 拉取角色列表 */
async function load() {
  loading.value = true;
  try {
    const r = await request.get('/kuerp/auth-group/index', { params: { page: 1, limit: 200 } });
    list.value = r?.list || [];
  } finally {
    loading.value = false;
  }
}

/** 拉取全部权限节点（供复选框树） */
async function loadRules() {
  const r = await request.get('/kuerp/auth-rule/index', { params: { page: 1, limit: 500 } });
  ruleNodes.value = r?.list || [];
}

// —— 全选逻辑 ——
const allChecked = computed({
  get: () => ruleNodes.value.length > 0 && form.value.rules.length === ruleNodes.value.length,
  set: (v) => { form.value.rules = v ? ruleNodes.value.map((r) => r.name) : []; },
});
const indeterminate = computed(
  () => form.value.rules.length > 0 && form.value.rules.length < ruleNodes.value.length,
);
function onAllChange(v) { allChecked.value = v; }

/** Tab 标签（带节点数，便于感知两类权限的规模） */
const tabItems = computed(() => {
  const menuCount = ruleNodes.value.filter((n) => n.type !== 'action').length;
  const actCount = ruleNodes.value.filter((n) => n.type === 'action').length;
  return [
    { label: `菜单 / 页面权限 (${menuCount})`, value: 'menu' },
    { label: `按钮权限 (${actCount})`, value: 'action' },
  ];
});

/** 关键字是否命中（标题或节点名，忽略大小写） */
function hit(name, label, kw) {
  return !kw || name.toLowerCase().includes(kw) || String(label).toLowerCase().includes(kw);
}

/**
 * 菜单 / 页面权限节点：按所属模块分组（顺序与菜单一致，未知节点归入「其他 / 接口」）。
 * 勾选 menu 节点即同时授予该页面的菜单可见性与后端接口访问权。
 */
const menuGroups = computed(() => {
  const kw = keyword.value.trim().toLowerCase();
  const map = new Map();
  ruleNodes.value
    .filter((n) => n.type !== 'action')
    .forEach((n) => {
      const meta = nodeMeta[n.name] || {};
      const label = meta.title || n.title || n.name;
      if (!hit(n.name, label, kw)) return;
      const group = meta.group || '其他 / 接口';
      if (!map.has(group)) map.set(group, []);
      map.get(group).push({ name: n.name, label });
    });
  const arr = [...map.entries()].map(([title, items]) => ({ title, items }));
  // 把「其他 / 接口」放到最后
  return arr.sort((a, b) => (a.title === '其他 / 接口') - (b.title === '其他 / 接口'));
});

/** 按钮权限节点：按业务表分组，动作翻译为中文（新增/编辑/删除/审核…） */
const actionGroups = computed(() => {
  const kw = keyword.value.trim().toLowerCase();
  const map = new Map();
  ruleNodes.value
    .filter((n) => n.type === 'action')
    .forEach((n) => {
      const m = n.name.match(/^kuerp\/(.+?):(\w+)$/);
      const table = m ? m[1] : '_other';
      const action = m ? m[2] : n.name;
      const label = ACTION_LABELS[action] || action;
      if (!hit(n.name, label, kw)) return;
      if (!map.has(table)) map.set(table, []);
      map.get(table).push({ name: n.name, label });
    });
  return [...map.entries()]
    .map(([table, items]) => ({
      key: table,
      title: (tableMeta[table] && tableMeta[table].title) || table,
      group: (tableMeta[table] && tableMeta[table].group) || '其他',
      items,
    }))
    .sort((a, b) => (a.group + a.title).localeCompare(b.group + b.title, 'zh'));
});

/** 组级勾选状态：全部选中 / 部分选中（半选） */
function grpAll(items) { return items.every((i) => form.value.rules.includes(i.name)); }
function grpSome(items) {
  const c = items.filter((i) => form.value.rules.includes(i.name)).length;
  return c > 0 && c < items.length;
}
/** 勾选/取消整组 */
function toggleGrp(items, v) {
  const names = items.map((i) => i.name);
  if (v) form.value.rules = [...new Set([...form.value.rules, ...names])];
  else form.value.rules = form.value.rules.filter((n) => !names.includes(n));
}

/** 打开新增对话框 */
function openAdd() {
  editing.value = false;
  form.value = { name: '', status: 1, rules: [], data_scope: 1 };
  dialog.value = true;
}

/** 打开编辑对话框：rules 字符串还原为数组 */
function openEdit(row) {
  editing.value = true;
  const rules = String(row.rules || '') === '*'
    ? ruleNodes.value.map((r) => r.name)
    : String(row.rules || '').split(',').filter(Boolean);
  form.value = { id: row.id, name: row.name, status: Number(row.status), rules, data_scope: Number(row.data_scope || 1) };
  dialog.value = true;
}

function reset() { form.value = { name: '', status: 1, rules: [], data_scope: 1 }; }

/** 提交新增/编辑 */
async function submit() {
  if (!form.value.name) {
    message.warning('请输入角色名称');
    return;
  }
  saving.value = true;
  try {
    const payload = {
      name: form.value.name,
      status: form.value.status,
      rules: form.value.rules.join(','),
      data_scope: Number(form.value.data_scope) || 1,
    };
    if (editing.value) {
      await request.post('/kuerp/auth-group/edit', { id: form.value.id, ...payload });
      message.success('保存成功');
    } else {
      await request.post('/kuerp/auth-group/add', payload);
      message.success('添加成功');
    }
    dialog.value = false;
    load();
  } finally {
    saving.value = false;
  }
}

/** 删除角色 */
async function onDel(row) {
  await confirm(`确认删除角色「${row.name}」？`, '提示', { type: 'warning' });
  await request.post('/kuerp/auth-group/del', { id: row.id });
  message.success('已删除');
  load();
}

onMounted(async () => {
  await loadRules();
  await load();
});
</script>

<style scoped>
.head { display: flex; align-items: center; justify-content: space-between; }
.ops { display: flex; gap: 4px; }
.radios { display: flex; gap: 16px; align-items: center; min-height: 32px; }

/* 权限节点选择区：工具条（全选/计数/搜索）+ Tab + 分组列表 */
.rule-box { border: 1px solid var(--ds-border); border-radius: var(--ds-radius); padding: 10px 12px; }
.rule-toolbar { display: flex; align-items: center; gap: 12px; }
.rule-count { font-size: var(--ds-font-sm); color: var(--ds-text-3, var(--ds-text-2)); }
.rule-search { margin-left: auto; width: 200px; }
.rule-tabs { margin: 8px 0 4px; }
.rule-body { max-height: 330px; overflow: auto; display: flex; flex-direction: column; gap: 12px; padding: 0 2px 2px; }
.grp {
  /* 组头 sticky 时背后滚过的内容会透出来叠字，必须用不透明底色 */
  background: var(--ds-bg-elevated);
  border-radius: 6px;
}
.grp-head {
  display: flex; align-items: center; gap: 8px;
  padding: 5px 8px; border-radius: 6px;
  background: var(--ds-bg-soft);
  position: sticky; top: 0; z-index: 1;
}
.grp-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 4px 10px; padding: 6px 4px 0 26px; }
.rule-empty { text-align: center; color: var(--ds-text-3, var(--ds-text-2)); font-size: var(--ds-font-sm); padding: 24px 0; }
</style>
