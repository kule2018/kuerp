<template>
  <div>
    <!-- 主卡片：顶部检索与操作区 + 数据表格 -->
    <DsCard :pad="false">
      <!-- 顶部检索与操作区 -->
      <div class="toolbar">
        <DsInput
          v-model="search"
          class="search-input"
          placeholder="输入关键字回车搜索"
          clearable
          @keyup.enter="onSearch"
        />
        <DsButton variant="primary" @click="onSearch">查询</DsButton>
        <!-- 多字段筛选：等价原系统列表页的 layui-search 表单（按字段逐个过滤）；
             没有可筛选字段时整个入口一并隐藏，避免点开只有按钮的空面板 -->
        <DsButton v-if="filterFields.length" variant="default" @click="filterOpen = !filterOpen">
          {{ filterOpen ? '收起筛选' : '高级筛选' }}
        </DsButton>
        <DsButton variant="default" @click="load">刷新</DsButton>
        <!-- 按钮级权限：无 add 权限时隐藏新增（后端 RbacGuard 同样会拦，隐藏只为减少误点） -->
        <DsButton v-if="can('add')" variant="primary" @click="openAdd">新增</DsButton>
        <DsButton v-if="canMultiDel && can('del')" variant="danger" :disabled="!selected.length" @click="onMultiDel">批量删除</DsButton>
        <DsButton v-if="hasDeletetime" variant="default" @click="toggleRecycle">
          {{ recycleMode ? '返回正常列表' : '回收站' }}
        </DsButton>
        <DsButton v-if="recycleMode && selected.length" variant="primary" @click="onMultiReduction">批量还原</DsButton>
        <DsButton v-if="can('import')" variant="default" @click="openImport">导入</DsButton>
        <DsButton v-if="can('export')" variant="default" :loading="exporting" @click="exportCsv">导出 CSV</DsButton>
        <!-- 列显示/隐藏：勾选控制展示列，等价原系统「显示列」 -->
        <DsPopover trigger="click" placement="bottom-end">
          <template #reference>
            <DsButton variant="default">列设置</DsButton>
          </template>
          <div class="col-vis">
            <label v-for="c in displayColumns" :key="c.name" class="col-vis__item">
              <DsCheckbox v-model="colVis[c.name]" />
              <span>{{ c.label }}</span>
            </label>
          </div>
        </DsPopover>
      </div>

      <!--
        多字段筛选栏：等价原系统列表页的 layui-search 表单。
        字段按列元信息动态生成——外键/枚举列渲染下拉做精确匹配，其余列渲染文本框做 LIKE 模糊匹配，
        避免只能用一个全局关键字搜全部字符列的局限。
      -->
      <div v-if="filterOpen && filterFields.length" class="ds-form ds-form--inline filter-bar">
        <DsField v-for="f in filterFields" :key="f.name" :label="f.label">
          <DsSelect
            v-if="f.kind === 'select'"
            v-model="filterValues[f.name]"
            :options="f.options"
            clearable
            placeholder="全部"
            style="width: 180px"
            @change="onSearch"
          />
          <DsInput
            v-else
            v-model="filterValues[f.name]"
            :placeholder="f.label"
            clearable
            style="width: 180px"
            @keyup.enter="onSearch"
          />
        </DsField>
        <div class="filter-btns">
          <DsButton variant="primary" @click="onSearch">筛选</DsButton>
          <DsButton @click="resetFilter">重置</DsButton>
        </div>
      </div>

      <!-- 数据表格：列由后端 /columns 元信息动态生成，改用 DsTable 的列配置 + 插槽 -->
      <DsTable
        :columns="dsColumns"
        :data="sortedList"
        :row-key="meta.pk"
        :loading="loading"
        :striped="true"
        :sort-key="sortKey"
        :sort-order="sortOrder"
        :expandable="true"
        :expanded-keys="expandedKeys"
        @sort-change="onSortChange"
        @expand-change="onExpandChange"
        :key="tableKey"
      >
        <!-- 多选列：用受控复选框，勾选态存主键到 selected -->
        <template v-if="canMultiDel || recycleMode" #__sel="{ row }">
          <DsCheckbox :model-value="isSelected(row)" @change="toggleSelect(row)" />
        </template>
        <!-- 序号列：跨页连续编号 -->
        <template #__index="{ index }">{{ (page - 1) * pageSize + index + 1 }}</template>
        <!-- 审核状态列：用标签渲染，直观区分已审/未审 -->
        <template v-if="hasExamine" #[examineCol]="{ row }">
          <DsTag v-if="String(row[examineCol] ?? '0') === '1'" color="success" size="sm">已审</DsTag>
          <DsTag v-else color="neutral" size="sm" variant="outline">未审</DsTag>
        </template>
        <!-- 枚举列：值翻译为注释里的中文（如 0=禁用,1=启用），不再显示 0/1 裸数字 -->
        <template v-for="ec in enumDisplayCols" :key="'enum-' + ec" #[ec]="{ row }">
          <span>{{ enumText(ec, row[ec]) }}</span>
        </template>
        <!-- 省市区列：区域 id（kuerp_area）翻译为区域名称，不再显示裸 id -->
        <template v-for="rc in regionDisplayCols" :key="'region-' + rc" #[rc]="{ row }">
          <span>{{ row[rc] ? regionName(row[rc]) : '—' }}</span>
        </template>
        <!-- 外键列：列表单元格把 ID 翻译为关联表名称，等价原系统 formatter -->
        <template v-for="fc in fkDisplayCols" :key="fc" #[fc]="{ row }">
          <span>{{ fkLabel(fc, row[fc]) }}</span>
        </template>
        <!-- 图片列：渲染真实缩略图（原系统此处是 layui 的 image 列格式化），多图取首图并角标计数 -->
        <template v-for="ic in imageCols" :key="'img-' + ic" #[ic]="{ row }">
          <div v-if="imgList(row[ic]).length" class="cell-img">
            <img class="cell-img__thumb" :src="fileUrl(imgList(row[ic])[0])" alt="" loading="lazy" />
            <span v-if="imgList(row[ic]).length > 1" class="cell-img__count">{{ imgList(row[ic]).length }}</span>
          </div>
          <span v-else class="cell-img__none">—</span>
        </template>
        <!-- 操作列 -->
        <template #__action="{ row }">
          <template v-if="recycleMode">
            <DsButton variant="text" @click="onReduction(row)">还原</DsButton>
            <DsButton variant="text-danger" @click="onRealDel(row)">真实删除</DsButton>
          </template>
          <template v-else>
            <DsButton v-if="hasExamine && can('examine')" variant="text" @click="onExamine(row)">
              {{ String(row[examineCol] ?? '0') === '1' ? '反审' : '审核' }}
            </DsButton>
            <DsButton variant="text" @click="openPrint(row)">打印</DsButton>
            <DsButton v-if="can('edit')" variant="text" @click="openEdit(row)">编辑</DsButton>
            <DsButton v-if="can('del')" variant="text-danger" @click="onDel(row)">删除</DsButton>
          </template>
        </template>
        <!-- 行展开：查看该行全部字段明细，等价原系统列表行展开 -->
        <template #expand="{ row }">
          <div class="row-detail">
            <div v-for="c in meta.columns" :key="c.name" class="row-detail__item" v-show="!['id'].includes(c.name)">
              <span class="row-detail__k">{{ fieldLabel(c.name, c.comment) }}</span>
              <span class="row-detail__v">
                <!-- 图片字段在展开里给出全部原图，便于核对多图 -->
                <template v-if="isImageField(c.name) && imgList(row[c.name]).length">
                  <img
                    v-for="(u, ix) in imgList(row[c.name])"
                    :key="ix"
                    class="row-detail__img"
                    :src="fileUrl(u)"
                    alt=""
                  />
                </template>
                <template v-else>{{ fmtCell(c.name, row[c.name]) }}</template>
              </span>
            </div>
          </div>
        </template>
      </DsTable>

      <!-- 分页 -->
      <div class="pager">
        <DsPagination
          :current-page="page"
          :page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next"
          @update:currentPage="onPage"
          @update:pageSize="onSize"
        />
      </div>
    </DsCard>

    <!-- 新增 / 编辑对话框：表单字段同样动态生成 -->
    <DsModal v-model="dialog" :title="editing ? '编辑' : '新增'" :width="860" @close="resetForm">
      <div class="ds-form ds-form--2">
        <DsField
          v-for="col in formColumns"
          :key="col.name"
          :label="col.label"
          :required="col.required"
          :class="{ 'ds-form__full': col.wide }"
        >
          <!-- 图片字段：上传控件（goods_images 之类多图字段允许多选），等价原系统 layui upload -->
          <DsUploadField
            v-if="isImageField(col.name)"
            v-model="form[col.name]"
            :multiple="isMultiImageField(col.name)"
            :image="true"
            accept=".jpg,.jpeg,.png,.gif,.webp,.bmp,.svg"
            tip="支持 jpg / png / webp / gif / svg，单张不超过 10MB"
          />
          <!-- 附件字段：非图片文件上传（原始单据附件等） -->
          <DsUploadField
            v-else-if="isFileField(col.name)"
            v-model="form[col.name]"
            :image="false"
            accept=".pdf,.doc,.docx,.xls,.xlsx,.csv,.txt,.zip,.rar,.7z"
            tip="支持 PDF / Office / 压缩包，单个不超过 10MB"
          />
          <!-- 枚举/状态类字段给下拉（选项来自列注释，直接显示中文），避免手输 0/1 -->
          <DsSelect
            v-else-if="enumOptions[col.name]"
            v-model="form[col.name]"
            :options="enumOptions[col.name]"
          />
          <!-- 外键字段（如 suppliers_id / goods_code）走 /options 拿关联表下拉，等价原系统 selectpage -->
          <DsSelect
            v-else-if="refOptions[col.name] && refOptions[col.name].length"
            v-model="form[col.name]"
            :options="refOptions[col.name]"
            :placeholder="`选择${col.label}`"
            clearable
            filterable
          />
          <!-- 数值字段用数字输入框 -->
          <DsInput v-else-if="isNumeric(col.type)" v-model="form[col.name]" type="number" />
          <!-- 大文本 / text 列用多行输入 -->
          <DsInput
            v-else-if="col.wide"
            v-model="form[col.name]"
            type="textarea"
            :rows="3"
          />
          <DsInput v-else v-model="form[col.name]" :maxlength="col.maxLength || undefined" clearable />
        </DsField>
        <!-- 省/市/区：三级联动下拉（数据来自 kuerp_area，存区域 id），取代手输 0/数字 -->
        <DsField v-if="hasRegion" label="所在地区" class="ds-form__full">
          <div class="region-row">
            <DsSelect v-model="form.province" :options="regionOptions(1)" placeholder="省" filterable clearable />
            <DsSelect
              v-if="regionCols.includes('city')"
              v-model="form.city"
              :options="form.province ? regionChildren(form.province) : []"
              :placeholder="form.province ? '市' : '请先选择省'"
              filterable
              clearable
            />
            <DsSelect
              v-if="regionCols.includes('area')"
              v-model="form.area"
              :options="form.city ? regionChildren(form.city) : []"
              :placeholder="form.city ? '区' : '请先选择市'"
              filterable
              clearable
            />
          </div>
        </DsField>
      </div>
      <template #footer>
        <DsButton variant="default" @click="dialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="submit">保存</DsButton>
      </template>
    </DsModal>

    <!-- 导入对话框：支持 CSV 文件导入与 JSON 数组粘贴（字段名与列名一致） -->
    <DsModal v-model="importDialog" title="导入数据" :width="640" @close="importText = ''">
      <DsAlert type="info" :closable="false" show-icon
        description="支持两种方式：① 选择 CSV 文件（首行为列名，需与本表列名一致）；② 粘贴 JSON 数组，元素字段名需与本表列名一致，如 [{&quot;name&quot;:&quot;示例&quot;}]。非法字段会被自动忽略。" />
      <div class="import-row">
        <label class="form-label import-label">CSV 文件</label>
        <input type="file" accept=".csv" class="file-input" @change="onCsvFile" />
        <DsButton variant="text" @click="downloadTemplate">下载导入模板</DsButton>
      </div>
      <DsDivider>或粘贴 JSON 数组</DsDivider>
      <DsInput v-model="importText" type="textarea" :rows="8" placeholder='[{"name":"示例"}]' />
      <template #footer>
        <DsButton variant="default" @click="importDialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="importing" @click="submitImport">导入</DsButton>
      </template>
    </DsModal>
  </div>
</template>

<script setup>
/**
 * 通用动态表格页：1:1 还原原 FastAdmin 通用列表/表单能力（DeepSeek UI 风格版）。
 *
 * 能力清单（与原系统后台逐条对齐）：
 * - 列表/检索（关键字 + 分页）
 * - 新增/编辑（动态表单，枚举字段自动下拉）
 * - 删除（软删除走 deletetime）/ 批量删除
 * - 回收站 / 还原 / 真实删除（原系统 recyclebin/reduction/realdel）
 * - 审核/反审（单据状态列）
 * - 打印（跳转通用打印页）
 * - 导入（CSV 文件 / JSON 数组批量入库，字段名与列名一致）
 * - 导出（当前筛选结果导出 CSV，UTF-8 BOM 兼容 Excel）
 *
 * 通过 route.meta.api（如 /kuerp/goods-type）驱动任意 kuerp_* 表，
 * 列与表单字段均在运行期从后端 /columns 元信息动态生成。
 *
 * UI 说明：原 Element Plus 的 el-table / el-form / el-dialog 已替换为
 * ds 设计系统的 DsTable / DsModal 等。表格采用「列配置(dsColumns) + 插槽」驱动，
 * 多选用受控复选框（勾选主键存 selected）。
 */
import { ref, computed, watch, onMounted, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { message, confirm } from '@/utils/ui';
import request from '../utils/request';
import { loadPerms, usePerm } from '@/utils/perm';
import { parseComment, fieldLabel, isTimeField, fmtDateTime } from '@/utils/field-meta';
import { loadRegions, regionOptions, regionChildren, regionName } from '@/utils/region';

const route = useRoute();
const router = useRouter();
const api = route.meta.api || '/kuerp/goods'; // 表对应的接口前缀

// —— 按钮级权限 ——
// 权限集合全局加载一次（layout 里已加载，这里兜底：直接访问/刷新本页时也能拿到）
onMounted(() => { loadPerms(); });
const { hasPerm } = usePerm();
/**
 * 判断当前表是否可执行某动作。
 * @param action 动作名：add/edit/del/examine/import/export
 * @returns 是否有权限（权限未加载完成时返回 true，避免按钮闪烁）
 */
function can(action) {
  return hasPerm(api, action);
}

// —— 列表状态 ——
const list = ref([]);
const total = ref(0);
const search = ref('');
const loading = ref(false);
const page = ref(1);
const pageSize = ref(10);
const tableKey = ref(0); // 列变化时强制刷新表格
const selected = ref([]); // 多选项：存主键值数组（替代 el-table 的 selection-change）
const recycleMode = ref(false); // 是否处于回收站视图

// —— 表元信息（列定义）——
const meta = ref({ pk: 'id', columns: [] });
const hasDeletetime = ref(false);
const examineCol = ref('');
const enumOptions = ref({}); // 列名 -> 枚举选项 [{value,label}]（从列注释解析，如「状态:0=禁用,1=正常」）
const refOptions = ref({});  // 列名 -> 外键下拉选项 [{value,label}]（从 /options 解析）
const fkLabels = ref({});     // 列名 -> { value: label }，用于列表单元格把 ID 翻译为名称

/** 审核状态列探测（与原系统 examine_status/examine/status 对齐） */
const hasExamine = computed(() => !!examineCol.value);
/** 具备软删除才允许批量删除进回收站 */
const canMultiDel = computed(() => hasDeletetime.value && !recycleMode.value);

/**
 * 省市区联动探测：表里同时有 province / city 且都是 int（存 kuerp_area 的区域 id）
 * 才按「省市区联动下拉」渲染。kuerp_user_oauth 等表虽有同名列但是 varchar 存名称，不参与。
 */
const hasRegion = computed(() => {
  const find = (n) => meta.value.columns.find((c) => c.name === n);
  const p = find('province');
  const c = find('city');
  return !!(p && c && p.type === 'int' && c.type === 'int');
});
/** 本表实际存在的省市区列（渲染联动下拉与列表翻译时用） */
const regionCols = computed(() =>
  hasRegion.value ? ['province', 'city', 'area'].filter((n) => meta.value.columns.some((c) => c.name === n)) : [],
);

// 表格展示列：过滤主键/审计/操作人字段，最多展示 8 列（均可排序）。
// label 统一走 fieldLabel：注释优先 + 通用中文字典兜底，避免出现裸英文字段名
const displayColumns = computed(() =>
  meta.value.columns
    .filter((c) => !['id', 'admin_id', 'createtime', 'updatetime', 'deletetime'].includes(c.name))
    .slice(0, 8)
    .map((c) => ({ name: c.name, label: fieldLabel(c.name, c.comment), type: c.type, width: c.type === 'text' ? 200 : 120, sortable: true })),
);

// DsTable 列配置：多选列 + 序号列 + 动态数据列（按列显隐过滤）+ 操作列
const dsColumns = computed(() => {
  const cols = [];
  if (canMultiDel.value || recycleMode.value) cols.push({ key: '__sel', title: '', width: '42px', align: 'center' });
  cols.push({ key: '__index', title: '#', width: '52px', align: 'center' });
  displayColumns.value.forEach((c) => {
    if (colVis.value[c.name] === false) return; // 列显隐：未勾选则隐藏
    // 图片列收窄成缩略图宽度，避免一张图占掉半屏
    const w = isImageField(c.name) ? 96 : c.width || 120;
    cols.push({ key: c.name, title: c.label, width: w + 'px', sortable: !isImageField(c.name) });
  });
  cols.push({ key: '__action', title: '操作', width: '250px', align: 'right' });
  return cols;
});

// 列显示/隐藏状态（列名 -> 是否显示；默认全显）
const colVis = ref({});
// 排序状态（表头点击切换：无 -> 升 -> 降 -> 无）
const sortKey = ref('');
const sortOrder = ref('');
// 行展开：已展开的行主键集合
const expandedKeys = ref([]);
// 多字段筛选：面板开合 + 字段值（列名 -> 值）
const filterOpen = ref(false);
const filterValues = ref({});

/**
 * 筛选栏字段列表（按列元信息动态生成）。
 * 规则：外键列 / 枚举列 → 下拉（精确匹配 filter）；文本列 → 输入框（LIKE 模糊 like）；
 * 数值列与日期列不参与，避免出现「数字列模糊匹配」这类无意义条件。
 * 最多取 6 个字段，保持筛选区紧凑；字段顺序与列表展示列一致。
 * @returns {Array<{name:string,label:string,kind:'select'|'text',options?:Array}>}
 */
const filterFields = computed(() => {
  const out = [];
  for (const c of displayColumns.value) {
    const ref = refOptions.value[c.name];
    const enums = enumOptions.value[c.name];
    if (ref && ref.length) {
      out.push({ name: c.name, label: c.label, kind: 'select', options: ref });
    } else if (enums && enums.length) {
      out.push({ name: c.name, label: c.label, kind: 'select', options: enums });
    } else {
      if (isNumeric(c.type) || /_(time|date)$/i.test(c.name)) continue;
      out.push({ name: c.name, label: c.label, kind: 'text' });
    }
    if (out.length >= 6) break;
  }
  return out;
});

/**
 * 列表展示数据：支持表头点击排序（客户端排序，保证可见效果）。
 * 排序字段为空时直接返回原列表。
 */
const sortedList = computed(() => {
  if (!sortKey.value || !sortOrder.value) return list.value;
  const k = sortKey.value;
  const dir = sortOrder.value === 'asc' ? 1 : -1;
  return [...list.value].sort((a, b) => {
    const av = a[k];
    const bv = b[k];
    const an = Number(av);
    const bn = Number(bv);
    if (!Number.isNaN(an) && !Number.isNaN(bn) && av !== '' && bv !== '' && av != null && bv != null) {
      return (an - bn) * dir;
    }
    return String(av ?? '').localeCompare(String(bv ?? ''), 'zh-CN') * dir;
  });
});

/** 表头点击排序：同列循环 升→降→取消 */
function onSortChange(key) {
  if (sortKey.value !== key) {
    sortKey.value = key;
    sortOrder.value = 'asc';
  } else if (sortOrder.value === 'asc') {
    sortOrder.value = 'desc';
  } else if (sortOrder.value === 'desc') {
    sortKey.value = '';
    sortOrder.value = '';
  } else {
    sortOrder.value = 'asc';
  }
}

/** 行展开/收起：维护 expandedKeys */
function onExpandChange(key, expanded) {
  const i = expandedKeys.value.indexOf(key);
  if (expanded && i < 0) expandedKeys.value = [...expandedKeys.value, key];
  else if (!expanded && i >= 0) expandedKeys.value = expandedKeys.value.filter((x) => x !== key);
}

/**
 * 表单字段：过滤主键与审计字段，并把列元信息整理成表单需要的形状。
 *
 * 注意 label 取的必须是 comment——后端 /columns 返回的字段是
 * { name, type, nullable, default, comment, isPk, maxLength }，
 * 早期这里直接读 col.label 导致新增/编辑弹窗的字段标题全是空白。
 *
 * 另外补两个判断：
 *   wide    —— 是否整行展示（长文本、图片、附件这类撑满一行更好用）；
 *   required —— 数据库非空且无默认值，才在标签上打必填星号。
 */
const formColumns = computed(() =>
  meta.value.columns
    .filter((c) => !['id', 'admin_id', 'createtime', 'updatetime', 'deletetime'].includes(c.name))
    .filter((c) => !regionCols.value.includes(c.name)) // 省市区单独渲染为联动下拉
    .map((c) => ({
      ...c,
      label: fieldLabel(c.name, c.comment),
      // 枚举 / 外键列有下拉控件，半列足够，不必因列名或长度被判成整行
      wide:
        isWideField(c) && !enumOptions.value[c.name] && !refOptions.value[c.name],
      required: c.nullable === false && c.default === null && !c.isPk,
    })),
);

/**
 * 判断字段是否应整行展示。
 * 长文本、图片、附件放在半列里既看不清内容，也没法显示缩略图。
 *
 * 注意阈值不能按 varchar(255) 判定：业务表里 name / code / remark 多半是 varchar(255)，
 * 若把 >200 都算整行，两列网格会退化成一列一个字段，反而更难填。
 * 这里只认「明确的长内容」——大字段类型、图片附件、以及名字就能看出的备注类列。
 *
 * @param {object} col 列元信息（含 name / type / maxLength）
 * @returns {boolean} true 表示该字段占满一整行
 */
function isWideField(col) {
  const n = String(col.name || '').toLowerCase();
  // 大字段类型：内容本身是多行文本
  if (['text', 'mediumtext', 'longtext', 'blob', 'longblob'].includes(col.type)) return true;
  // 图片 / 附件：缩略图与文件列表需要横向空间
  if (isImageField(n) || isFileField(n)) return true;
  // 备注/地址/说明类字段即便建成了 varchar，内容也通常是长句
  if (/(remark|note|memo|address|content|description)$/.test(n)) return true;
  // 超长 varchar（如 1000 以上的简介列）才整行
  return Number(col.maxLength) > 500;
}

/** 哪些展示列是外键（有下拉选项），用于在列表单元格翻译 ID 为名称 */
const fkDisplayCols = computed(() => {
  const set = new Set(Object.keys(refOptions.value || {}));
  return displayColumns.value.map((c) => c.name).filter((n) => set.has(n));
});

/** 有枚举注释的展示列（排除审核列——它已用「已审/未审」标签渲染），单元格显示中文选项 */
const enumDisplayCols = computed(() =>
  displayColumns.value.map((c) => c.name).filter((n) => enumOptions.value[n] && n !== examineCol.value),
);

/** 省市区展示列：列表单元格把区域 id 翻译为区域名称 */
const regionDisplayCols = computed(() =>
  displayColumns.value.map((c) => c.name).filter((n) => regionCols.value.includes(n)),
);

/**
 * 枚举列取值翻译：值 → 注释里的中文选项（如 1 → 启用）。
 * 匹配统一转字符串比较，兼容 tinyint(1) 与 enum('0','1') 两种存法。
 * @param {string} col 列名
 * @param {any} val 原始值
 * @returns {string|any} 中文选项文本；未命中时原样返回
 */
function enumText(col, val) {
  const opts = enumOptions.value[col];
  if (!opts) return val;
  const hit = opts.find((o) => String(o.value) === String(val));
  return hit ? hit.label : val;
}

/** 外键列单元格翻译：有映射则显示名称，否则回退原始值 */
function fkLabel(col, val) {
  const m = fkLabels.value?.[col];
  if (m && Object.prototype.hasOwnProperty.call(m, val)) return m[val];
  return val;
}

/**
 * 行展开时的单元格格式化。
 * 0 要显示为 0（不能被 || 吞成 '—'），外键要翻译成名称，空值统一 '—'。
 * 原实现写成 `fkLabel(...) || val === 0 ? val : ...`，三元优先级导致外键永远显示原始 ID，
 * 这里改为显式分支修掉。
 * @param {string} col 列名
 * @param {any} val 值
 * @returns {string|number}
 */
function fmtCell(col, val) {
  // 枚举列优先翻译中文（0 也是合法枚举值，不能被空值判断吞掉）
  if (enumOptions.value[col]) {
    if (val === '' || val === null || val === undefined) return '—';
    return enumText(col, val);
  }
  // 时间戳列：0 / 空 视为未填写，不再显示裸 0
  if (isTimeField(col)) {
    if (val === 0 || val === '' || val === null || val === undefined) return '—';
    return fmtDateTime(val);
  }
  // 省市区列：区域 id 翻译为中文名称
  if (regionCols.value.includes(col)) {
    if (val === 0 || val === '' || val === null || val === undefined) return '—';
    return regionName(val);
  }
  if (val === 0) return 0;
  const label = fkLabel(col, val);
  return label === '' || label === null || label === undefined ? '—' : label;
}

/* ==================== 图片 / 附件字段支持 ==================== */// 背景：原系统大量表带图字段（goods_image 商品主图、goods_images 图集、kuerp_banner.image
// 轮播图、*_type_image 分类图标、kuerp_enclosure.image 原始单据附件），
// 通用页原先一律当普通文本渲染成一条 URL 字符串，既看不出图也没法上传。

/**
 * 判断某列是否为图片字段。
 * 按字段名关键字识别（与 db/schema.sql 里实际存在的列名对齐）：
 * image / images / img / photo / pic / avatar / headimgurl / logo / thumb / banner。
 * @param {string} name 列名
 * @returns {boolean}
 */
function isImageField(name) {
  return /(image|images|img|photo|pic|avatar|headimgurl|logo|thumb|banner)/i.test(String(name || ''));
}

/**
 * 判断是否多图字段（如 goods_images）。
 * @param {string} name 列名
 * @returns {boolean}
 */
function isMultiImageField(name) {
  return /images$/i.test(String(name || ''));
}

/**
 * 判断是否附件字段（非图片）。当前库里只有 kuerp_enclosure 一类，按后缀识别。
 * @param {string} name 列名
 * @returns {boolean}
 */
function isFileField(name) {
  const n = String(name || '');
  return /(file|files|attachment)$/i.test(n) && !isImageField(n);
}

/** API 根地址：把后端返回的相对地址（/uploads/...）拼成可访问 URL */
const API_BASE = (import.meta.env.VITE_API_BASE || 'http://localhost:3000').replace(/\/+$/, '');

/**
 * 相对地址转可访问 URL。已是绝对地址 / blob / data 的原样返回。
 * @param {string} u 地址
 * @returns {string}
 */
function fileUrl(u) {
  if (!u) return '';
  if (/^(https?:)?\/\//i.test(u) || u.startsWith('blob:') || u.startsWith('data:')) return u;
  return `${API_BASE}${u.startsWith('/') ? '' : '/'}${u}`;
}

/**
 * 把字段值拆成图片地址数组。
 * 兼容三种历史写法：单地址、JSON 数组字符串、英文逗号拼接。
 * @param {any} v 字段值
 * @returns {string[]}
 */
function imgList(v) {
  if (!v) return [];
  if (Array.isArray(v)) return v.filter(Boolean);
  const s = String(v).trim();
  if (!s) return [];
  if (s.startsWith('[')) {
    try {
      const arr = JSON.parse(s);
      return Array.isArray(arr) ? arr.filter(Boolean) : [];
    } catch {
      return [s];
    }
  }
  return s.split(',').map((x) => x.trim()).filter(Boolean);
}

/** 当前表里存在的图片列（列表缩略图与表单上传器都按它渲染） */
const imageCols = computed(() =>
  displayColumns.value.filter((c) => isImageField(c.name)).map((c) => c.name),
);

// —— 新增 / 编辑对话框 ——
const dialog = ref(false);
const editing = ref(false);
const saving = ref(false);
const form = ref({});

// —— 导入对话框 ——
const importDialog = ref(false);
const importText = ref('');
const importing = ref(false);
const exporting = ref(false); // 导出中状态

/** 某行是否已勾选（多选） */
function isSelected(row) {
  return selected.value.includes(row[meta.value.pk]);
}

/** 切换某行勾选态：在主键数组里增删 */
function toggleSelect(row) {
  const id = row[meta.value.pk];
  const i = selected.value.indexOf(id);
  if (i >= 0) selected.value.splice(i, 1);
  else selected.value.push(id);
}

/** 导出列：过滤主键与审计字段，导出完整数据（非仅前 8 列） */
const exportColumns = computed(() =>
  meta.value.columns.filter((c) => !['id', 'createtime', 'updatetime', 'deletetime'].includes(c.name)),
);

/** 秒级时间戳 -> YYYY-MM-DD（导出时日期列可读化） */
function fmtDate(v) {
  const n = Number(v);
  if (!n) return '';
  const d = new Date(n * 1000);
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}

/** 字段值转 CSV 单元格：时间戳列按列名格式化；含逗号/引号/换行的加引号并转义 */
function csvCell(v, name) {
  let s = v == null ? '' : String(v);
  if (isTimeField(name) && /^\d+$/.test(s)) s = fmtDateTime(s);
  if (/[",\r\n]/.test(s)) s = '"' + s.replace(/"/g, '""') + '"';
  return s;
}

/** 判断列是否为数值类型（用于渲染数字输入框） */
function isNumeric(type) {
  return ['int', 'bigint', 'tinyint', 'smallint', 'decimal', 'double', 'float'].includes(type);
}

/** 拉取表字段元信息，并解析枚举列注释 */
async function loadColumns() {
  const r = await request.get(`${api}/columns`);
  const cols = r?.columns || [];
  meta.value = { pk: r?.pk || 'id', columns: cols };
  hasDeletetime.value = cols.some((c) => c.name === 'deletetime');
  examineCol.value = ['examine_status', 'examine', 'status'].find((n) => cols.some((c) => c.name === n)) || '';
  // 列注释枚举解析：①「状态:0=禁用,1=正常」②「状态 枚举:0,1」统一为 [{value,label}]
  // 值统一存字符串，匹配时按 String() 比较，兼容 tinyint 与 enum('0','1') 两种存法
  const enums = {};
  cols.forEach((c) => {
    const { options } = parseComment(c.comment);
    if (options) enums[c.name] = options;
  });
  enumOptions.value = enums;
  refOptions.value = {};
  // 表里有省市区列时预载区域数据（表格翻译 + 表单联动下拉共用，只拉一次）
  if (hasRegion.value) loadRegions();
  // 初始化列显隐：展示列默认全部勾选
  const vis = {};
  displayColumns.value.forEach((c) => { vis[c.name] = true; });
  colVis.value = vis;
  // 换表后清空上一张表的筛选条件，避免带着旧字段名请求（会被后端白名单拒绝）
  filterValues.value = {};
  // 预先为展示列中的外键列拉下拉选项，供筛选栏渲染为下拉（失败不阻塞列表）
  await loadRefOptions(displayColumns.value);
  tableKey.value++;
}

/**
 * 为外键字段（*_id / *_code 且非枚举）加载关联表下拉选项。
 * 并发请求 /kuerp/:table/options?field=<列名>，命中才写入 refOptions（未命中保持普通输入框）。
 * @param {Array} [targets] 只加载指定列（默认加载全部表单列）；筛选栏初始化时传入展示列以省请求
 * @returns {Promise<void>}
 */
async function loadRefOptions(targets) {
  const source = Array.isArray(targets) && targets.length ? targets : formColumns.value;
  const fkCols = source.filter(
    (c) => !enumOptions.value[c.name] && /_(id|code)$/i.test(c.name) && !['createtime', 'updatetime', 'deletetime'].includes(c.name),
  );
  if (!fkCols.length) return;
  const map = {};
  const labels = {};
  await Promise.all(
    fkCols.map(async (c) => {
      try {
        const r = await request.get(`${api}/options`, { params: { field: c.name } });
        const opts = Array.isArray(r) ? r : [];
        if (opts.length) {
          map[c.name] = opts;
          labels[c.name] = Object.fromEntries(opts.map((o) => [o.value, o.label]));
        }
      } catch {
        /* 选项缺失不阻塞表单 */
      }
    }),
  );
  refOptions.value = map;
  fkLabels.value = labels;
}

/** 拉取列表数据（recycleMode 时查回收站） */
async function load() {
  loading.value = true;
  try {
    // 汇总多字段筛选：下拉走 filter（精确匹配），文本框走 like（模糊匹配）
    const filter = {};
    const like = {};
    for (const f of filterFields.value) {
      const v = filterValues.value[f.name];
      if (v === '' || v === undefined || v === null) continue;
      if (f.kind === 'select') filter[f.name] = v;
      else like[f.name] = v;
    }
    const params = { page: page.value, limit: pageSize.value, search: search.value };
    // 显式 JSON 字符串化：后端 filter/like 同时接受对象与 JSON 字符串，
    // 用字符串可避开 axios 对嵌套对象的括号序列化差异（like[col]=v → 由 qs 还原对象）
    if (Object.keys(filter).length) params.filter = JSON.stringify(filter);
    if (Object.keys(like).length) params.like = JSON.stringify(like);
    const url = recycleMode.value ? `${api}/recyclebin` : `${api}/index`;
    const r = await request.get(url, { params });
    list.value = r?.list || [];
    total.value = r?.count || 0;
  } finally {
    loading.value = false;
  }
}

function onSearch() { page.value = 1; load(); }
function onPage(p) { page.value = p; load(); }
function onSize(s) { pageSize.value = s; page.value = 1; load(); }

/** 重置筛选：清空多字段筛选条件与全局关键字后重新查询 */
function resetFilter() {
  filterValues.value = {};
  search.value = '';
  page.value = 1;
  load();
}

/** 切换回收站视图 */
function toggleRecycle() {
  recycleMode.value = !recycleMode.value;
  page.value = 1;
  selected.value = [];
  load();
}

/**
 * 省市区回填标志：openAdd / openEdit 整体赋值 form 会触发联动 watch，
 * 若不做标记，watch 会把刚回填的市/区当成「不属于新上级」清掉
 * （表现为：编辑弹窗第一次打开区是空的，关掉再开才有数据）。
 */
let regionRestoring = false;

/** 打开新增对话框：按列生成空表单 */
function openAdd() {
  editing.value = false;
  regionRestoring = true;
  form.value = {};
  formColumns.value.forEach((c) => { form.value[c.name] = formDefault(c); });
  regionCols.value.forEach((n) => { form.value[n] = ''; }); // 省市区默认空，走联动下拉
  nextTick(() => { regionRestoring = false; });
  dialog.value = true;
  loadRefOptions();
}

/** 表单字段默认值：时间戳与省市区列留空（避免出现裸 0），数值列 0，其余空串 */
function formDefault(c) {
  if (isTimeField(c.name)) return '';
  if (regionCols.value.includes(c.name)) return '';
  return isNumeric(c.type) ? 0 : '';
}

/** 打开编辑对话框：回填行数据 */
function openEdit(row) {
  editing.value = true;
  regionRestoring = true;
  const f = {};
  formColumns.value.forEach((c) => { f[c.name] = row[c.name] || formDefault(c); });
  regionCols.value.forEach((n) => { f[n] = row[n] || ''; }); // 0 视为未填写
  form.value = { ...f, [meta.value.pk]: row[meta.value.pk] };
  nextTick(() => { regionRestoring = false; });
  dialog.value = true;
  loadRefOptions();
}

// 省市区联动：上级变化时，下级若不再属于新上级则自动清空。
// 两个保护：① 回填期间（regionRestoring）不清空，避免编辑弹窗首次打开丢数据；
// ② 区域数据未就绪时（regionChildren 为空数组）不做子级校验，等数据到了由响应式刷新显示。
watch(
  () => form.value.province,
  (v) => {
    if (!hasRegion.value || regionRestoring) return;
    const children = regionChildren(v);
    if (form.value.city && children.length && !children.some((o) => String(o.value) === String(form.value.city))) {
      form.value.city = '';
    }
    if (form.value.area) form.value.area = '';
  },
);
watch(
  () => form.value.city,
  (v) => {
    if (!hasRegion.value || regionRestoring) return;
    const children = regionChildren(v);
    if (form.value.area && children.length && !children.some((o) => String(o.value) === String(form.value.area))) {
      form.value.area = '';
    }
  },
);

/** 提交新增/编辑 */
async function submit() {
  saving.value = true;
  try {
    if (editing.value) {
      const id = form.value[meta.value.pk];
      await request.post(`${api}/edit`, { id, ...form.value });
      message.success('保存成功');
    } else {
      await request.post(`${api}/add`, form.value);
      message.success('添加成功');
    }
    dialog.value = false;
    load();
  } finally {
    saving.value = false;
  }
}

function resetForm() { form.value = {}; }

/** 行内删除（软删除，走 deletetime） */
async function onDel(row) {
  await confirm('确认删除该记录？', '提示', { type: 'warning' });
  await request.post(`${api}/del`, { id: row[meta.value.pk] });
  message.success('已删除');
  load();
}

/** 批量删除（ids 数组，原系统 del 支持多选） */
async function onMultiDel() {
  const ids = selected.value;
  if (!ids.length) return;
  await confirm(`确认删除选中的 ${ids.length} 条记录？`, '提示', { type: 'warning' });
  await request.post(`${api}/del`, { ids });
  message.success('已删除');
  load();
}

/** 还原（回收站 -> 正常，deletetime 置 0） */
async function onReduction(row) {
  await request.post(`${api}/reduction`, { id: row[meta.value.pk] });
  message.success('已还原');
  load();
}

/** 批量还原 */
async function onMultiReduction() {
  const ids = selected.value;
  if (!ids.length) return;
  await request.post(`${api}/reduction`, { ids });
  message.success('已还原');
  load();
}

/** 真实删除（物理删除，不可恢复） */
async function onRealDel(row) {
  await confirm('真实删除将不可恢复，确认？', '警告', { type: 'warning' });
  await request.post(`${api}/realdel`, { id: row[meta.value.pk] });
  message.success('已真实删除');
  load();
}

/** 审核 / 反审：status 0=反审, 1=已审 */
async function onExamine(row) {
  const cur = String(row[examineCol.value] ?? '0');
  const next = cur === '1' ? 0 : 1;
  await request.post(`${api}/examine`, { id: row[meta.value.pk], status: next });
  message.success(next === 1 ? '已审核' : '已反审');
  load();
}

/** 跳转通用打印页（带表名与单据 id） */
function openPrint(row) {
  const t = (api.split('/').pop() || '').replace(/_/g, '-');
  router.push({ name: 'Print', query: { table: t, id: row[meta.value.pk] } });
}

/** 打开导入对话框 */
function openImport() { importDialog.value = true; }

/**
 * 通用 CSV 解析（兼容引号包裹、字段内逗号/换行、CRLF/LF）。
 * 首行作为列名；返回 { headers, rows }，rows 为对象数组。
 */
function parseCsv(text) {
  const rows = [];
  let field = '';
  let row = [];
  let inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (inQuotes) {
      if (ch === '"') {
        if (text[i + 1] === '"') { field += '"'; i++; }
        else inQuotes = false;
      } else field += ch;
    } else if (ch === '"') {
      inQuotes = true;
    } else if (ch === ',') {
      row.push(field); field = '';
    } else if (ch === '\n' || ch === '\r') {
      if (ch === '\r' && text[i + 1] === '\n') i++;
      row.push(field); field = '';
      if (row.length > 1 || row[0] !== '') rows.push(row);
      row = [];
    } else field += ch;
  }
  if (field !== '' || row.length) { row.push(field); rows.push(row); }
  if (!rows.length) return { headers: [], rows: [] };
  const headers = rows[0].map((h) => h.trim());
  const data = rows.slice(1).map((r) => {
    const o = {};
    headers.forEach((h, idx) => { if (h) o[h] = r[idx] ?? ''; });
    return o;
  });
  return { headers, rows: data };
}

/**
 * 校验导入行字段是否在表元信息内（防注入/非法字段），并剔除主键与审计字段。
 * @param rows 原始对象数组
 * @returns 清洗后可入库的行
 */
function sanitizeImport(rows) {
  const allowed = new Set(meta.value.columns.map((c) => c.name));
  const drop = new Set(['id', 'createtime', 'updatetime', 'deletetime']);
  return rows
    .map((r) => {
      const o = {};
      for (const k of Object.keys(r)) {
        if (!allowed.has(k) || drop.has(k)) continue;
        const v = r[k];
        o[k] = v === '' || v == null ? (isNumericType(k) ? 0 : '') : v;
      }
      return o;
    })
    .filter((r) => Object.keys(r).length > 0);
}

/** 列名是否为数值类型（用于空值归 0） */
function isNumericType(name) {
  const c = meta.value.columns.find((x) => x.name === name);
  return c ? isNumeric(c.type) : false;
}

/** 批量提交入库（CSV 或 JSON 通用） */
async function doImport(rows) {
  if (!rows.length) { message.warning('没有可导入的数据'); return; }
  importing.value = true;
  try {
    const clean = sanitizeImport(rows);
    if (!clean.length) { message.error('数据字段与本表列名不匹配，无法导入'); return; }
    const r = await request.post(`${api}/import`, { rows: clean });
    message.success(`导入完成，成功 ${r?.inserted ?? clean.length} 条`);
    importDialog.value = false;
    importText.value = '';
    load();
  } finally {
    importing.value = false;
  }
}

/** 选择 CSV 文件：读取文本解析后直接导入（原生 file input） */
async function onCsvFile(ev) {
  const f = ev.target?.files && ev.target.files[0];
  if (!f) return;
  const text = await f.text();
  const { rows } = parseCsv(text);
  if (!rows.length) { message.error('CSV 为空或解析失败'); return; }
  await doImport(rows);
  ev.target.value = ''; // 允许重复选择同一文件
}

/** 提交导入：JSON 数组路径 */
async function submitImport() {
  let rows;
  try {
    rows = JSON.parse(importText.value || '[]');
    if (!Array.isArray(rows) || !rows.length) throw new Error('空数据');
  } catch {
    message.error('JSON 解析失败，请检查格式（需为非空数组）');
    return;
  }
  await doImport(rows);
}

/** 下载导入模板：仅表头（列名 + 中文标签），方便用户按格式填表 */
function downloadTemplate() {
  const cols = exportColumns.value;
  if (!cols.length) return;
  const head = cols.map((c) => `${c.name}(${fieldLabel(c.name, c.comment)})`).join(',');
  const csv = '﻿' + head + '\r\n';
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `${route.meta.title || 'template'}_导入模板.csv`;
  a.click();
  URL.revokeObjectURL(url);
}

/** 导出当前筛选结果为 CSV（UTF-8 BOM 兼容 Excel） */
async function exportCsv() {
  exporting.value = true;
  try {
    // 拉取当前筛选条件下的全量数据（大 limit，单页导出）
    const r = await request.get(`${api}/index`, {
      params: { page: 1, limit: 100000, search: search.value },
    });
    const data = r?.list || [];
    if (!data.length) { message.warning('暂无数据可导出'); return; }
    const cols = exportColumns.value;
    const head = cols.map((c) => fieldLabel(c.name, c.comment)).join(',');
    const body = data.map((row) =>
      cols.map((c) => csvCell(enumOptions.value[c.name] ? enumText(c.name, row[c.name]) : row[c.name], c.name)).join(','),
    );
    const csv = '﻿' + [head, ...body].join('\r\n');
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${route.meta.title || 'export'}.csv`;
    a.click();
    URL.revokeObjectURL(url);
    message.success(`已导出 ${data.length} 条`);
  } catch (e) {
    message.error('导出失败：' + (e?.message || '接口错误'));
  } finally {
    exporting.value = false;
  }
}

onMounted(async () => {
  await loadColumns();
  await load();
});
</script>

<style scoped>
/* 省市区联动：三个下拉同行等分 */
.region-row {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
}
/* 顶部检索与操作区：横向排列、自动换行 */
.toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  padding: 16px 18px;
  border-bottom: 1px solid var(--ds-divider);
}
.toolbar .search-input { width: 240px; }

/* 表格下方分页区 */
.pager {
  /* 分页统一左对齐（与报表页/系统页一致），仅保留上间距 */
  margin-top: 12px;
}

/* 导入行：文件选择与标签同一行，标签宽度与字段标签对齐 */
.form-label {
  font-size: var(--ds-font-sm);
  font-weight: 500;
  color: var(--ds-text-2);
}
.import-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 14px 0;
}
.import-label { flex: none; }
.file-input {
  flex: 1;
  font-size: var(--ds-font-sm);
  color: var(--ds-text-2);
}

/* 多字段筛选栏：与工具栏同底色，换行排列，右侧独立操作按钮 */
.filter-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  gap: 12px 16px;
  padding: 14px 18px;
  background: var(--ds-bg-soft);
  border-bottom: 1px solid var(--ds-divider);
}
.filter-btns {
  display: flex;
  gap: 8px;
  margin-left: auto;
}

/* 列显示/隐藏面板 */
.col-vis {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 160px;
  max-height: 320px;
  overflow-y: auto;
  padding: 4px;
}
.col-vis__item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: var(--ds-font-sm);
  color: var(--ds-text-2);
  cursor: pointer;
}

/* 行展开明细：键值网格 */
.row-detail {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 6px 24px;
}
.row-detail__item {
  display: flex;
  gap: 8px;
  font-size: var(--ds-font-sm);
}
.row-detail__k { color: var(--ds-text-3); flex: none; min-width: 84px; }
.row-detail__v { color: var(--ds-text); word-break: break-all; }

/* 展开区里的原图：多图并排、定高裁切，不撑破明细网格 */
.row-detail__img {
  display: inline-block;
  width: 64px;
  height: 64px;
  object-fit: cover;
  border-radius: var(--ds-radius-sm);
  border: 1px solid var(--ds-border);
  background: var(--ds-bg-hover);
  margin: 0 6px 6px 0;
}

/* ===== 列表图片列缩略图 ===== */
.cell-img {
  position: relative;
  display: inline-flex;
}
.cell-img__thumb {
  width: 44px;
  height: 32px;
  object-fit: cover;
  border-radius: var(--ds-radius-xs);
  border: 1px solid var(--ds-border);
  background: var(--ds-bg-hover);
  display: block;
}
/* 多图角标：右下角小数字，提示「还有几张」 */
.cell-img__count {
  position: absolute;
  right: -5px;
  bottom: -5px;
  min-width: 16px;
  height: 16px;
  padding: 0 4px;
  border-radius: 8px;
  background: var(--ds-brand);
  color: #fff;
  font-size: 10px;
  line-height: 16px;
  text-align: center;
  font-variant-numeric: tabular-nums;
}
.cell-img__none { color: var(--ds-text-3); }
</style>
