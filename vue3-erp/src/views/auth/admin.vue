<template>
  <DsCard>
    <template #title>
      <div class="head">
        <span>管理员管理</span>
        <div class="head-right">
          <DsInput v-model="search" placeholder="用户名 / 昵称" clearable style="width: 200px; margin-right: 10px" @keyup.enter="load" @clear="load" />
          <DsButton @click="load">查询</DsButton>
          <DsButton variant="primary" @click="openAdd">新增管理员</DsButton>
        </div>
      </div>
    </template>

    <DsTable :columns="columns" :data="list" :loading="loading" :striped="true">
      <!-- 最后登录时间：秒级时间戳转可读时间 -->
      <template #logintime="{ row }">{{ formatTime(row.logintime) }}</template>
      <!-- 状态 -->
      <template #status="{ row }">
        <DsTag :color="Number(row.status) === 1 ? 'success' : 'neutral'" size="sm">
          {{ Number(row.status) === 1 ? '正常' : '禁用' }}
        </DsTag>
      </template>
      <!-- 角色：group_ids → 角色名 -->
      <template #group_names="{ row }">
        <template v-if="row.group_ids && row.group_ids.length">
          <DsTag v-for="gid in row.group_ids" :key="gid" size="sm" color="info" style="margin-right: 4px">
            {{ groupName(gid) }}
          </DsTag>
        </template>
        <span v-else class="muted">未分配</span>
      </template>
      <!-- 操作列：内置 admin 禁止删除 -->
      <template #_action="{ row }">
        <div class="ops">
          <DsButton variant="text" @click="openEdit(row)">编辑</DsButton>
          <DsButton variant="text" @click="onResetPwd(row)">重置密码</DsButton>
          <DsButton variant="text" :disabled="row.username === 'admin'" @click="onDel(row)">删除</DsButton>
        </div>
      </template>
    </DsTable>

    <!-- 分页：与后端 list(page/limit) 对齐 -->
    <div class="pager">
      <DsPagination v-model:currentPage="page" :page-size="limit" :total="total" :page-sizes="[10, 20, 50, 100]" layout="total, sizes, prev, pager, next" @change="load" @update:pageSize="onLimit" />
    </div>

    <!-- 新增 / 编辑管理员：编辑时不改密码，重置密码走单独入口 -->
    <DsModal :title="editing ? '编辑管理员' : '新增管理员'" v-model="dialog" :width="520" @close="reset">
      <!-- 表单：原 el-form（label-width 90px）改为 DsField -->
      <DsField label="用户名" required>
        <DsInput v-model="form.username" maxlength="50" :disabled="editing" />
      </DsField>
      <DsField label="昵称"><DsInput v-model="form.nickname" maxlength="50" /></DsField>
      <DsField label="邮箱"><DsInput v-model="form.email" maxlength="100" /></DsField>
      <DsField v-if="!editing" label="初始密码" required>
        <DsInput v-model="form.password" maxlength="64" placeholder="默认 123456" type="password" />
      </DsField>
      <!-- 状态：原 el-radio-group，ds 用同 v-model 的多个 DsRadio 组成组 -->
      <DsField label="状态">
        <div class="radios">
          <DsRadio v-model="form.status" :value="1">正常</DsRadio>
          <DsRadio v-model="form.status" :value="0">禁用</DsRadio>
        </div>
      </DsField>
      <!-- 角色：绑定 auth_group（经 auth_group_access 关联），决定菜单/按钮/接口/数据权限 -->
      <DsField label="角色">
        <DsSelect v-model="form.group_ids" :options="groupOptions" multiple placeholder="请选择角色" clearable />
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
 * 管理员管理页：1:1 对应原系统 FastAdmin「管理员管理（admin/admin）」。
 * 权限文档（开发文档/14.权限设置说明.md）要求：新增管理员 → 绑定角色组 → 配置角色权限；
 * 角色组与权限节点分别由「角色管理」「权限规则」页维护，本页只负责管理员账号本身：
 *   - 新增（用户名/昵称/邮箱/初始密码/状态）
 *   - 编辑（不在此处改密码，避免误触；重置密码独立入口）
 *   - 重置密码（后端按新密码重新生成盐并加密）
 *   - 删除（软删除；内置 admin 账号禁止删除，保证始终可登录）
 */
import { ref, computed, onMounted } from 'vue';
import { message, confirm, prompt } from '@/utils/ui';
import request from '../../utils/request';

const list = ref([]);
const total = ref(0);
const page = ref(1);
const limit = ref(10);
const search = ref('');
const loading = ref(false);
const dialog = ref(false);
const editing = ref(false);
const saving = ref(false);
const form = ref({ username: '', nickname: '', email: '', password: '', status: 1, group_ids: [] });
/** 角色列表（id → 名称）与下拉选项 */
const groups = ref([]);
const groupOptions = computed(() => groups.value.map((g) => ({ value: g.id, label: g.name })));
function groupName(id) {
  const g = groups.value.find((x) => x.id === id);
  return g ? g.name : id;
}

/** DsTable 列配置 */
const columns = [
  { key: 'id', title: 'ID', width: '70' },
  { key: 'username', title: '用户名', width: '120' },
  { key: 'nickname', title: '昵称', width: '120' },
  { key: 'email', title: '邮箱', width: '160' },
  { key: 'logintime', title: '最后登录', width: '170' },
  { key: 'loginip', title: '最后登录IP', width: '140' },
  { key: 'status', title: '状态', width: '90', align: 'center' },
  { key: 'group_names', title: '角色', width: '180' },
  { key: '_action', title: '操作', width: '200' },
];

/** 秒级时间戳 → 可读时间（与系统其它页面 bigint 秒级约定一致） */
function formatTime(sec) {
  const n = Number(sec || 0);
  if (!n) return '-';
  const d = new Date(n * 1000);
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}

/** 拉取管理员列表（含关键字搜索） */
async function load() {
  loading.value = true;
  try {
    const r = await request.get('/system/admin/index', { params: { page: page.value, limit: limit.value, search: search.value } });
    list.value = r?.list || [];
    total.value = Number(r?.count || 0);
  } finally {
    loading.value = false;
  }
}

/** 切换每页条数：回到第一页重新加载 */
function onLimit(s) { limit.value = s; page.value = 1; load(); }

/** 打开新增对话框 */
function openAdd() {
  editing.value = false;
  form.value = { username: '', nickname: '', email: '', password: '', status: 1, group_ids: [] };
  dialog.value = true;
}

/** 打开编辑对话框：用户名不允许修改（登录唯一键），密码走重置入口 */
function openEdit(row) {
  editing.value = true;
  form.value = {
    id: row.id,
    username: row.username,
    nickname: row.nickname,
    email: row.email,
    status: Number(row.status),
    group_ids: Array.isArray(row.group_ids) ? row.group_ids : [],
  };
  dialog.value = true;
}

function reset() {
  form.value = { username: '', nickname: '', email: '', password: '', status: 1, group_ids: [] };
}

/** 提交新增/编辑 */
async function submit() {
  if (!form.value.username) {
    message.warning('请输入用户名');
    return;
  }
  if (!editing.value && !form.value.password) {
    message.warning('请输入初始密码');
    return;
  }
  saving.value = true;
  try {
    if (editing.value) {
      await request.post('/system/admin/edit', {
        id: form.value.id,
        nickname: form.value.nickname,
        email: form.value.email,
        status: form.value.status,
        group_ids: form.value.group_ids,
      });
      message.success('保存成功');
    } else {
      await request.post('/system/admin/add', { ...form.value });
      message.success('添加成功');
    }
    dialog.value = false;
    load();
  } finally {
    saving.value = false;
  }
}

/** 重置密码：输入新密码提交，后端重新生成盐并加密 */
async function onResetPwd(row) {
  const value = await prompt(`为「${row.username}」设置新密码`, '重置密码', {
    inputType: 'password',
    inputPattern: /^.{4,64}$/,
    inputErrorMessage: '密码长度 4-64 位',
  });
  await request.post('/system/admin/edit', { id: row.id, password: value });
  message.success('密码已重置');
}

/** 删除管理员（内置 admin 不允许删除） */
async function onDel(row) {
  if (row.username === 'admin') return;
  await confirm(`确认删除管理员「${row.username}」？`, '提示', { type: 'warning' });
  await request.post('/system/admin/del', { id: row.id });
  message.success('已删除');
  load();
}

onMounted(async () => {
  const r = await request.get('/kuerp/auth-group/index', { params: { page: 1, limit: 200 } });
  groups.value = r?.list || [];
  await load();
});
</script>

<style scoped>
.head { display: flex; align-items: center; justify-content: space-between; }
.head-right { display: flex; align-items: center; }
.pager { margin-top: 12px; }
/* 操作列按钮组与单选组 */
.ops { display: flex; gap: 4px; }
.radios { display: flex; gap: 16px; align-items: center; min-height: 32px; }
</style>
