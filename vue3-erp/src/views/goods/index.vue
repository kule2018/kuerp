<template>
  <div>
    <DsCard>
      <!-- 检索区（原 el-form inline） -->
      <div class="row mb">
        <DsField label="商品名称">
          <DsInput v-model="search" placeholder="支持名称/编号/条码" clearable style="width: 240px" @keyup.enter="load" />
        </DsField>
        <div class="row-btns">
          <DsButton variant="primary" @click="load">查询</DsButton>
          <DsButton variant="primary" @click="goEdit(0)">新增商品</DsButton>
        </div>
      </div>

      <DsTable :columns="columns" :data="list" :loading="loading" :striped="true">
        <!-- 状态列：上架 / 下架用标签区分 -->
        <template #status="{ row }">
          <DsTag :color="row.status === '1' ? 'success' : 'neutral'">{{ row.status === '1' ? '上架' : '下架' }}</DsTag>
        </template>
        <!-- 操作列 -->
        <template #_action="{ row }">
          <div class="ops">
            <DsButton variant="text" @click="goEdit(row.id)">编辑</DsButton>
            <DsButton variant="text" @click="onDel(row.id)">删除</DsButton>
          </div>
        </template>
      </DsTable>

      <DsPagination class="mt" layout="total, sizes, prev, pager, next" :total="total" :page-size="pageSize" :page-sizes="[10, 20, 50, 100]" @update:currentPage="onPage" @update:pageSize="onSize" />
    </DsCard>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { message, confirm } from '@/utils/ui';
import request from '../../utils/request';

const router = useRouter();
const list = ref([]);
const total = ref(0);
const search = ref('');
const loading = ref(false);
const page = ref(1);
const pageSize = ref(10);

/** DsTable 列配置：末列为操作区 */
const columns = [
  { key: 'goods_code', title: '编号', width: '120' },
  { key: 'goods_name', title: '名称', width: '160' },
  { key: 'goods_specification_id', title: '规格', width: '120' },
  { key: 'unit_id', title: '单位ID', width: '90' },
  { key: 'inventory', title: '库存', width: '100' },
  { key: 'market_sell_price', title: '零售价', width: '100' },
  { key: 'status', title: '状态', width: '80' },
  { key: '_action', title: '操作', width: '160' },
];

async function load() {
  loading.value = true;
  try {
    const r = await request.get('/kuerp/goods/index', { params: { page: page.value, limit: pageSize.value, search: search.value } });
    list.value = r?.list || [];
    total.value = r?.count || 0;
  } finally {
    loading.value = false;
  }
}
function onPage(p) { page.value = p; load(); }
function onSize(s) { pageSize.value = s; page.value = 1; load(); }
function goEdit(id) { router.push({ name: 'GoodsEdit', query: { id } }); }
async function onDel(id) {
  await confirm('确认删除该商品？', '提示', { type: 'warning' });
  await request.delete('/kuerp/goods/del', { data: { id } });
  message.success('已删除');
  load();
}
onMounted(load);
</script>

<style scoped>
.mt { margin-top: 12px; }
.mb { margin-bottom: 12px; }
/* 检索行与操作列按钮组 */
.row { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 12px; }
.row-btns { display: flex; gap: 8px; }
.ops { display: flex; gap: 4px; }
</style>
