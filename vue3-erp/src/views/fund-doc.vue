<template>
  <div class="fund-doc">
    <!-- 顶部工具栏 -->
    <DsCard class="toolbar">
      <div class="tb-left">
        <DsButton variant="primary" @click="openAdd">新增单据</DsButton>
        <DsInput v-model="search" placeholder="搜索单据编号/备注" clearable style="width: 220px" @clear="load" @keyup.enter="load" />
        <DsButton @click="load">查询</DsButton>
      </div>
      <div class="tb-right">
        <span class="tb-tip">审核后自动过账资金（账户余额 / 收付款一览 / 往来单位欠款）</span>
      </div>
    </DsCard>

    <!-- 单据列表 -->
    <DsCard class="mt">
      <DsTable :columns="listCols" :data="list" row-key="id" :loading="loading">
        <template #__sel="{ row }">
          <DsCheckbox :model-value="isSelected(row)" @update:modelValue="(v) => toggleSel(row, v)" />
        </template>
        <template #purchase_time="{ row }">{{ fmtTime(row.purchase_time) }}</template>
        <template #__cp="{ row }">{{ counterpartyName(row) }}</template>
        <template #money="{ row }">{{ money(row.money) }}</template>
        <template #write_off="{ row }">{{ money(row.write_off) }}</template>
        <template #advance="{ row }">{{ money(row.advance) }}</template>
        <template #__status="{ row }">
          <DsTag :color="Number(row.examine_status) === 1 ? 'success' : 'neutral'" size="sm">
            {{ Number(row.examine_status) === 1 ? '已审核' : '未审' }}
          </DsTag>
        </template>
        <template #__remark="{ row }">{{ row.remarks || row.remark || row.note || '-' }}</template>
        <template #__op="{ row }">
          <DsButton variant="text" size="sm" @click="openEdit(row)">编辑</DsButton>
          <DsButton variant="text" size="sm" @click="onExamine(row)">
            {{ Number(row.examine_status) === 1 ? '反审' : '审核' }}
          </DsButton>
          <DsButton variant="text" size="sm" @click="openPrint(row)">打印</DsButton>
          <DsButton variant="text" size="sm" @click="onDel(row)">删除</DsButton>
        </template>
      </DsTable>
      <DsPagination class="mt" v-model:currentPage="page" v-model:pageSize="pageSize" :total="total" :page-sizes="[10, 20, 50, 100]" layout="total, sizes, prev, pager, next" @change="load" />
    </DsCard>

    <!-- ============ 单据编辑器对话框 ============ -->
    <DsModal v-model="dialog" :title="editing ? '编辑单据' : '新增单据'" :width="1080" @close="resetForm">
      <div class="doc-body">
        <!-- 表头表单 -->
        <div class="section-title">单据信息</div>
        <div class="ds-form ds-form--3 head-form">
          <!-- 核销单：业务类型为核心驱动字段（决定可选源单与过账口径），单独渲染 -->
          <DsField v-if="mode === 'writeoff'" label="业务类型">
            <DsSelect v-model="form.business_type" :options="WRITEOFF_TYPES" @change="onBizTypeChange" />
          </DsField>
          <DsField v-for="col in headFields" :key="col.name" :label="col.label">
            <!-- 日期字段：后端存秒级时间戳，日期控件用字符串，靠 purchaseTimeStr 桥接 -->
            <DsDatePicker
              v-if="col.name === 'purchase_time'"
              v-model="purchaseTimeStr"
              type="datetime"
              placeholder="选择单据日期"
            />
            <!-- 枚举字段 -->
            <DsSelect v-else-if="col.enum" v-model="form[col.name]" :options="enumOptions(col)" />
            <!-- 外键下拉字段 -->
            <DsSelect
              v-else-if="col.fk"
              v-model="form[col.name]"
              :options="fkOptions(col)"
              filterable
              clearable
              :placeholder="'请选择' + col.label"
            />
            <!-- 数值字段 -->
            <DsInput type="number" v-else-if="isNumeric(col.type)" v-model="form[col.name]" />
            <!-- 普通文本 -->
            <DsInput v-else v-model="form[col.name]" />
          </DsField>
        </div>

        <!-- 结算账户子表（收款单/付款单） -->
        <template v-if="mode === 'account'">
          <div class="section-title">
            结算账户
            <DsButton variant="text" @click="accountRows.push(newRow({ accounts_id: null, money: 0, settlementtype: null, number: '', remark: '' }))">+ 添加一行</DsButton>
          </div>
          <DsTable :columns="accountCols" :data="accountRows" row-key="_k" striped>
            <template #accounts_id="{ row }">
              <DsSelect v-model="row.accounts_id" :options="accountOptions" filterable placeholder="请选择账户" size="sm" style="width: 100%" />
            </template>
            <template #money="{ row }">
              <DsInput type="number" v-model="row.money" :min="0" size="sm" style="width: 100%" />
            </template>
            <template #settlementtype="{ row }">
              <DsSelect v-model="row.settlementtype" :options="settlementOptions" filterable clearable placeholder="可选" size="sm" style="width: 100%" />
            </template>
            <template #number="{ row }"><DsInput v-model="row.number" size="sm" /></template>
            <template #remark="{ row }"><DsInput v-model="row.remark" size="sm" /></template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeRow(accountRows, row)">删</DsButton>
            </template>
          </DsTable>
        </template>

        <!-- 核销源单子表（收款单/付款单：单列，top=1） -->
        <template v-if="mode === 'account'">
          <div class="section-title">
            核销源单
            <DsButton variant="text" @click="openSourcePicker('top')">选择源单</DsButton>
            <DsButton variant="text" @click="autoWriteOff">自动核销</DsButton>
            <span class="sec-tip">不选源单时，整笔金额自动记为{{ isCollection ? '预收款' : '预付款' }}</span>
          </div>
          <DsTable :columns="sourceCols" :data="sourceRows" row-key="_k" striped>
            <template #__type="{ row }">{{ sourceTypeName(row) }}</template>
            <template #money="{ row }">{{ money(row.money) }}</template>
            <template #write_off="{ row }">{{ money(row.write_off) }}</template>
            <template #write_off_price="{ row }">
              <DsInput type="number" v-model="row.write_off_price" :min="0" size="sm" style="width: 100%" @change="recalc" />
            </template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeRow(sourceRows, row, recalc)">删</DsButton>
            </template>
          </DsTable>
        </template>

        <!-- 核销单双列源单：上方（转出/预收预付应收期初）与下方（转入/应收应付） -->
        <template v-if="mode === 'writeoff'">
          <div class="section-title">
            {{ topLabel }}
            <DsButton variant="text" @click="openSourcePicker('top')">选择源单</DsButton>
            <DsButton variant="text" @click="autoWriteOff">自动核销</DsButton>
            <span class="sec-tip">核销金额以上下两方较小者为准</span>
          </div>
          <DsTable :columns="sourceCols" :data="topRows" row-key="_k" striped>
            <template #__type="{ row }">{{ sourceTypeName(row) }}</template>
            <template #money="{ row }">{{ money(row.money) }}</template>
            <template #write_off="{ row }">{{ money(row.write_off) }}</template>
            <template #write_off_price="{ row }">
              <DsInput type="number" v-model="row.write_off_price" :min="0" size="sm" style="width: 100%" @change="recalc" />
            </template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeSource(row, recalc)">删</DsButton>
            </template>
          </DsTable>
          <div class="totals">
            <span>{{ topLabel }}核销合计：<b>{{ money(topTotal) }}</b></span>
          </div>

          <div class="section-title">
            {{ bottomLabel }}
            <DsButton variant="text" @click="openSourcePicker('bottom')">选择源单</DsButton>
            <DsButton variant="text" @click="autoWriteOff">自动核销</DsButton>
          </div>
          <DsTable :columns="sourceCols" :data="bottomRows" row-key="_k" striped>
            <template #__type="{ row }">{{ sourceTypeName(row) }}</template>
            <template #money="{ row }">{{ money(row.money) }}</template>
            <template #write_off="{ row }">{{ money(row.write_off) }}</template>
            <template #write_off_price="{ row }">
              <DsInput type="number" v-model="row.write_off_price" :min="0" size="sm" style="width: 100%" @change="recalc" />
            </template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeSource(row, recalc)">删</DsButton>
            </template>
          </DsTable>
          <div class="totals">
            <span>{{ bottomLabel }}核销合计：<b>{{ money(bottomTotal) }}</b></span>
            <span>实际核销金额：<b>{{ money(totalWriteOff) }}</b></span>
          </div>
        </template>

        <!-- 收入明细子表（其他收入单） -->
        <template v-if="mode === 'income'">
          <div class="section-title">
            收入明细
            <DsButton variant="text" @click="incomeRows.push(newRow({ income_type_id: null, money: 0, remark: '' }))">+ 添加一行</DsButton>
          </div>
          <DsTable :columns="incomeCols" :data="incomeRows" row-key="_k" striped>
            <template #income_type_id="{ row }">
              <DsSelect v-model="row.income_type_id" :options="incomeTypeOptions" filterable placeholder="请选择收入类别" size="sm" style="width: 100%" />
            </template>
            <template #money="{ row }">
              <DsInput type="number" v-model="row.money" :min="0" size="sm" style="width: 100%" @change="recalc" />
            </template>
            <template #remark="{ row }"><DsInput v-model="row.remark" size="sm" /></template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeRow(incomeRows, row, recalc)">删</DsButton>
            </template>
          </DsTable>
        </template>

        <!-- 转账子表（资金转账单） -->
        <template v-if="mode === 'transfer'">
          <div class="section-title">
            转账明细
            <DsButton variant="text" @click="transferRows.push(newRow({ accounts_out_id: null, accounts_enter_id: null, settlementtype: null, settlement_number: '', money: 0, remark: '' }))">+ 添加一行</DsButton>
          </div>
          <DsTable :columns="transferCols" :data="transferRows" row-key="_k" striped>
            <template #accounts_out_id="{ row }">
              <DsSelect v-model="row.accounts_out_id" :options="accountOptions" filterable placeholder="请选择" size="sm" style="width: 100%" />
            </template>
            <template #accounts_enter_id="{ row }">
              <DsSelect v-model="row.accounts_enter_id" :options="accountOptions" filterable placeholder="请选择" size="sm" style="width: 100%" />
            </template>
            <template #settlementtype="{ row }">
              <DsSelect v-model="row.settlementtype" :options="settlementOptions" filterable clearable placeholder="可选" size="sm" style="width: 100%" />
            </template>
            <template #settlement_number="{ row }"><DsInput v-model="row.settlement_number" size="sm" /></template>
            <template #money="{ row }">
              <DsInput type="number" v-model="row.money" :min="0" size="sm" style="width: 100%" @change="recalc" />
            </template>
            <template #remark="{ row }"><DsInput v-model="row.remark" size="sm" /></template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeRow(transferRows, row, recalc)">删</DsButton>
            </template>
          </DsTable>
        </template>

        <!-- 支出明细子表（其他支出单） -->
        <template v-if="mode === 'expend'">
          <div class="section-title">
            支出明细
            <DsButton variant="text" @click="expendRows.push(newRow({ expend_type_id: null, suppliers_id: null, money: 0, remark: '', cost_id: null }))">+ 添加一行</DsButton>
            <span class="sec-tip">关联「采购销售费用」后，审核时将自动扣减该费用的未结金额</span>
          </div>
          <DsTable :columns="expendCols" :data="expendRows" row-key="_k" striped>
            <template #expend_type_id="{ row }">
              <DsSelect v-model="row.expend_type_id" :options="expendTypeOptions" filterable placeholder="请选择" size="sm" style="width: 100%" />
            </template>
            <template #suppliers_id="{ row }">
              <DsSelect v-model="row.suppliers_id" :options="supplierOptions" filterable clearable placeholder="可选" size="sm" style="width: 100%" />
            </template>
            <template #cost_id="{ row }">
              <DsSelect v-model="row.cost_id" :options="costOptions" filterable clearable placeholder="选填，来自采购销售费用清单" size="sm" style="width: 100%" @change="onCostPicked(row)" />
            </template>
            <template #money="{ row }">
              <DsInput type="number" v-model="row.money" :min="0" size="sm" style="width: 100%" @change="recalc" />
            </template>
            <template #remark="{ row }"><DsInput v-model="row.remark" size="sm" /></template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeRow(expendRows, row, recalc)">删</DsButton>
            </template>
          </DsTable>
        </template>

        <!-- 合计区 -->
        <div class="totals">
          <span>合计金额：<b>{{ money(totalMoney) }}</b></span>
          <span v-if="mode === 'writeoff'">核销金额：<b>{{ money(totalWriteOff) }}</b></span>
          <span v-if="mode === 'account'">核销金额：<b>{{ money(totalWriteOff) }}</b></span>
          <span v-if="mode === 'income'">已收金额：<b>{{ money(form.pay_money) }}</b></span>
          <span v-if="mode === 'income'">本次欠款：<b>{{ money(totalArrears) }}</b></span>
          <span v-if="mode === 'account'">{{ isCollection ? '预收款' : '预付款' }}：<b>{{ money(totalAdvance) }}</b></span>
          <span v-if="mode === 'expend'">欠款：<b>{{ money(totalArrears) }}</b></span>
        </div>
      </div>

      <template #footer>
        <DsButton @click="dialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="submit">保存</DsButton>
      </template>
    </DsModal>

    <!-- ============ 源单选择对话框 ============ -->
    <DsModal v-model="sourceDialog" title="选择核销源单" :width="860">
      <div class="src-filter">
        <span class="lbl">{{ counterpartyLabel }}</span>
        <DsSelect v-model="sourceFilter.counterparty" :options="counterpartyOptionItems" filterable clearable placeholder="全部" style="width: 220px" @change="loadSources" />
        <DsInput v-model="sourceFilter.keyword" placeholder="源单编号" clearable style="width: 200px" @keyup.enter="loadSources" />
        <DsButton @click="loadSources">查询</DsButton>
      </div>
      <div class="src-scroll">
        <DsTable :columns="pickCols" :data="sourceList" row-key="id" striped>
          <template #__sel="{ row }">
            <DsCheckbox :model-value="isPicked(row)" @update:modelValue="(v) => togglePicked(row, v)" />
          </template>
          <template #__type="{ row }">{{ sourceTypeName(row) }}</template>
          <template #purchase_time="{ row }">{{ fmtTime(row.purchase_time) }}</template>
          <template #price="{ row }">{{ money(row.price) }}</template>
          <template #write_off="{ row }">{{ money(row.write_off) }}</template>
        </DsTable>
      </div>
      <template #footer>
        <DsButton @click="sourceDialog = false">取消</DsButton>
        <DsButton variant="primary" @click="confirmSources">确定（已选 {{ picked.length }} 张）</DsButton>
      </template>
    </DsModal>
  </div>
</template>

<script setup>
/**
 * 资金单据编辑器（1:1 还原原系统收款单/付款单/核销单/转账单/其他支出单的录入界面）。
 *
 * 整体思路：
 *   1. 本页承载「列表 + 审核过账 + 带子表的单据编辑器」三合一，替代通用 crud-page
 *      （通用页只有扁平表单，无法录入结算账户 / 核销源单等子表数据）。
 *   2. 单据结构因 mode 而异（由路由 meta 配置）：
 *      - account  收款单/付款单：表头 + 结算账户子表 + 核销源单子表；
 *      - writeoff 核销单：表头 + 核销源单子表（按五种业务类型过滤源单）；
 *      - transfer 资金转账单：表头 + 转账明细子表（转出/转入账户）；
 *      - expend   其他支出单：表头 + 支出明细子表。
 *   3. 保存时按原系统 add() 语义自动汇总：
 *      money = 结算金额合计；write_off = 本次核销合计；
 *      advance = money - write_off（预收/预付）；business_type = 有源单 ? 2 : 1。
 *   4. 子表通过外键关联表头（collection_id / purchase_id + purchase_code），
 *      与后端 FundsService 过账时的关联字段一致。
 */
import { ref, reactive, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { message, confirm } from '@/utils/ui';
import request from '../utils/request';

const route = useRoute();
const router = useRouter();

// —— 路由 meta 配置（menus.js 的 d() 工厂注入）——
const api = route.meta.api || '/kuerp/collection';
const cfg = route.meta.fund || {};
const mode = cfg.mode || 'account'; // account / writeoff / transfer / expend
const isCollection = (cfg.prefix || '') === 'SK';
const codePrefix = cfg.prefix || 'SK';
const counterpartyLabel = cfg.counterparty === 'supplier' ? '供应商' : '客户';

// —— 列表状态 ——
const list = ref([]);
const total = ref(0);
const page = ref(1);
const pageSize = ref(20);
const search = ref('');
const loading = ref(false);
const selected = ref([]);

// —— 编辑器状态 ——
const dialog = ref(false);
const editing = ref(false);
const saving = ref(false);
const form = ref({});
const columns = ref([]);
const options = reactive({});
const accountRows = ref([]);
const sourceRows = ref([]);
const transferRows = ref([]);
const expendRows = ref([]);
const incomeRows = ref([]);  // 其他收入单明细（收入类别 + 金额）
const originalInfoIds = []; // 编辑时已存在的子表行 id（保存后统一清理）

// —— 采购销售费用清单（其他支出单可关联结清）——
/** 未结清费用：pay_money > 0 的 kuerp_cost 行 */
const unpaidCosts = computed(() => (options.cost || []).filter((c) => Number(c.raw?.pay_money) > 0));
/** 费用下拉显示文案：单号 + 来源单据号 + 未结金额 */
function costOptionLabel(c) {
  const r = c.raw || {};
  const biz = { 1: '采购', 2: '销售', 3: '采购退货', 4: '销售退货' }[Number(r.business_type)] || '';
  return `${biz}费用 ${r.purchase_code || ''}${r.purchase_number ? ' / ' + r.purchase_number : ''}`;
}
/** 选中费用后：自动带出支出类别为空、金额默认取未结余额 */
function onCostPicked(row) {
  if (!row.cost_id) return;
  const c = (options.cost || []).find((x) => x.id === Number(row.cost_id));
  if (!c) return;
  // 未选类别时用费用行自带的支出类别兜底
  if (!row.expend_type_id && c.raw?.expend_type_id) {
    row.expend_type_id = Number(c.raw.expend_type_id);
  }
  // 金额默认为该费用未结余额，用户可改小（部分结清）
  row.money = Number(c.raw.pay_money) || row.money || 0;
  recalc();
}

// —— 源单选择对话框状态 ——
const sourceDialog = ref(false);
const sourceList = ref([]);
const picked = ref([]);
const sourceFilter = reactive({ counterparty: null, keyword: '' });
// 核销单双列源单：当前正在为「上方(top=1)」还是「下方(top=2)」挑选源单
const sourceSide = ref('top');

/**
 * 核销单两列源单：按 writeoff_info.top 分列（1=上方/转出，2=下方/转入）。
 * 收款/付款单仅使用上方一列。
 */
const topRows = computed(() => sourceRows.value.filter((r) => Number(r.top || 1) === 1));
const bottomRows = computed(() => sourceRows.value.filter((r) => Number(r.top) === 2));
/** 上方/下方核销合计 */
const topTotal = computed(() => topRows.value.reduce((s, r) => s + (Number(r.write_off_price) || 0), 0));
const bottomTotal = computed(() => bottomRows.value.reduce((s, r) => s + (Number(r.write_off_price) || 0), 0));

/**
 * 核销单两列标题：随业务类型变化（对账原系统 writeoff 弹窗的上下两栏命名）。
 */
const topLabel = computed(() => {
  const bt = Number(form.value.business_type) || 1;
  return bt === 1 ? '预收单据' : bt === 2 ? '预付单据' : bt === 3 ? '应收单据' : bt === 4 ? '转出客户应收' : '转出供应商应付';
});
const bottomLabel = computed(() => {
  const bt = Number(form.value.business_type) || 1;
  return bt === 1 ? '应收单据' : bt === 2 ? '应付单据' : bt === 3 ? '应付单据' : bt === 4 ? '转入客户应收' : '转入供应商应付';
});

/** 子表行的本地唯一键计数器（DsTable 的 rowKey 用） */
let uid = 0;
/** 生成一个带唯一键的空子表行 */
function newRow(base) {
  return { _k: `r${++uid}`, ...base };
}

/** 删除某一行源单（按对象引用定位，供上下两列共用）；after 为删除后的回调 */
function removeSource(row, after) {
  const i = sourceRows.value.indexOf(row);
  if (i >= 0) sourceRows.value.splice(i, 1);
  if (typeof after === 'function') after();
}

// ————————————————————————————————————————————————
// 表格列定义（DsTable 以 columns 描述列；slot:true 表示用同名插槽渲染）
// ————————————————————————————————————————————————

/** 单据列表列 */
const listCols = [
  { key: '__sel', title: '', width: '46px', slot: true },
  { key: 'purchase_code', title: '单据编号', width: '160px' },
  { key: 'purchase_time', title: '单据日期', width: '120px', slot: true },
  { key: '__cp', title: counterpartyLabel, width: '150px', slot: true },
  { key: 'money', title: '金额', width: '120px', align: 'right', slot: true },
  { key: 'write_off', title: '核销', width: '110px', align: 'right', slot: true },
  { key: 'advance', title: '预付/预收', width: '120px', align: 'right', slot: true },
  { key: '__status', title: '状态', width: '90px', slot: true },
  { key: '__remark', title: '备注', width: '160px', slot: true },
  { key: '__op', title: '操作', width: '260px', align: 'right', slot: true },
];

/** 结算账户子表列 */
const accountCols = [
  { key: 'accounts_id', title: '结算账户', width: '180px', slot: true },
  { key: 'money', title: '金额', width: '140px', slot: true },
  { key: 'settlementtype', title: '结算方式', width: '150px', slot: true },
  { key: 'number', title: '结算号', width: '140px', slot: true },
  { key: 'remark', title: '备注', width: '140px', slot: true },
  { key: '__del', title: '', width: '60px', align: 'center', slot: true },
];

/** 核销源单子表列（收款/付款单与核销单上下两栏共用） */
const sourceCols = [
  { key: 'purchase_number', title: '源单编号', width: '150px' },
  { key: '__type', title: '源单类型', width: '110px', slot: true },
  { key: 'money', title: '单据金额', width: '110px', align: 'right', slot: true },
  { key: 'write_off', title: '未核销', width: '110px', align: 'right', slot: true },
  { key: 'write_off_price', title: '本次核销', width: '140px', slot: true },
  { key: '__del', title: '', width: '60px', align: 'center', slot: true },
];

/** 收入明细子表列 */
const incomeCols = [
  { key: 'income_type_id', title: '收入类别', width: '200px', slot: true },
  { key: 'money', title: '金额', width: '150px', slot: true },
  { key: 'remark', title: '备注', width: '180px', slot: true },
  { key: '__del', title: '', width: '60px', align: 'center', slot: true },
];

/** 转账明细子表列 */
const transferCols = [
  { key: 'accounts_out_id', title: '转出账户', width: '160px', slot: true },
  { key: 'accounts_enter_id', title: '转入账户', width: '160px', slot: true },
  { key: 'settlementtype', title: '结算方式', width: '140px', slot: true },
  { key: 'settlement_number', title: '结算号', width: '130px', slot: true },
  { key: 'money', title: '金额', width: '130px', slot: true },
  { key: 'remark', title: '备注', width: '130px', slot: true },
  { key: '__del', title: '', width: '60px', align: 'center', slot: true },
];

/** 支出明细子表列 */
const expendCols = [
  { key: 'expend_type_id', title: '支出类别', width: '160px', slot: true },
  { key: 'suppliers_id', title: '供应商', width: '160px', slot: true },
  { key: 'cost_id', title: '关联费用', width: '200px', slot: true },
  { key: 'money', title: '金额', width: '130px', slot: true },
  { key: 'remark', title: '备注', width: '150px', slot: true },
  { key: '__del', title: '', width: '60px', align: 'center', slot: true },
];

/** 源单选择弹窗列 */
const pickCols = [
  { key: '__sel', title: '', width: '46px', slot: true },
  { key: 'purchase_code', title: '源单编号', width: '150px' },
  { key: '__type', title: '类型', width: '120px', slot: true },
  { key: 'purchase_time', title: '单据日期', width: '115px', slot: true },
  { key: 'price', title: '单据金额', width: '110px', align: 'right', slot: true },
  { key: 'write_off', title: '未核销', width: '110px', align: 'right', slot: true },
];

// ————————————————————————————————————————————————
// 下拉选项（DsSelect 以 options 数组代替内联 el-option）
// ————————————————————————————————————————————————

/** 通用：{ id, label } 数组 → DsSelect 的 { value, label } 数组 */
function toOptions(arr) {
  return (arr || []).map((x) => ({ value: x.id, label: x.label }));
}
const accountOptions = computed(() => toOptions(options.accounts));
const settlementOptions = computed(() => toOptions(options.settlementtype));
const incomeTypeOptions = computed(() => toOptions(options.incomeType));
const expendTypeOptions = computed(() => toOptions(options.expendType));
const supplierOptions = computed(() => toOptions(options.suppliers));
const counterpartyOptionItems = computed(() => toOptions(counterpartyOptions.value));

/** 可关联费用选项：文案带未结金额，便于用户分辨 */
const costOptions = computed(() =>
  unpaidCosts.value.map((c) => ({
    value: c.id,
    label: `${costOptionLabel(c)}（未结 ${money(c.pay_money)}）`,
  })),
);

/**
 * 表头枚举列选项：枚举值数组 → [{ value, label }]。
 * @param col 列元数据
 * @returns 选项数组
 */
function enumOptions(col) {
  return (col.enum || []).map((v) => ({ value: v, label: v }));
}

/**
 * 表头外键列选项：按列的 fk 名从 options 取数据源并转成 DsSelect 结构。
 * @param col 列元数据
 * @returns 选项数组
 */
function fkOptions(col) {
  return toOptions(options[col.fk]);
}

/** 单据日期桥接：后端存秒级时间戳，日期控件用 'YYYY-MM-DD HH:mm' 字符串 */
const purchaseTimeStr = computed({
  get() {
    const t = Number(form.value?.purchase_time);
    if (!t) return '';
    const d = new Date(t * 1000);
    const p = (n) => String(n).padStart(2, '0');
    return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
  },
  set(v) {
    if (!v) { form.value.purchase_time = null; return; }
    const ms = new Date(String(v).replace(' ', 'T')).getTime();
    form.value.purchase_time = Number.isNaN(ms) ? null : Math.floor(ms / 1000);
  },
});

// ————————————————————————————————————————————————
// 行选择（DsTable 无内置多选，改为受控实现）
// ————————————————————————————————————————————————

/** 列表行是否已勾选 */
function isSelected(row) {
  return selected.value.some((r) => r.id === row.id);
}
/** 勾选/取消勾选列表行（selected 存整行对象） */
function toggleSel(row, on) {
  selected.value = on ? [...selected.value, row] : selected.value.filter((r) => r.id !== row.id);
}
/** 源单行是否已勾选 */
function isPicked(row) {
  return picked.value.some((r) => r.id === row.id);
}
/** 勾选/取消勾选源单行 */
function togglePicked(row, on) {
  picked.value = on ? [...picked.value, row] : picked.value.filter((r) => r.id !== row.id);
}

/**
 * 删除子表一行（按对象引用定位）。
 * @param arr 子表 ref 数组
 * @param row 待删除行
 * @param after 删除后的回调（如重算合计）
 */
function removeRow(arr, row, after) {
  const i = arr.value.indexOf(row);
  if (i >= 0) arr.value.splice(i, 1);
  if (typeof after === 'function') after();
}

/**
 * 自动核销：把本次可核销金额按源单日期从早到晚分摊（与原系统自动核销口径一致）。
 * - 收款/付款单：可核销金额 = 表头金额 - 已核销；
 * - 核销单：以上下两方较小者为准，两侧同步取该金额。
 */
function autoWriteOff() {
  const pool = sourceRows.value.filter((r) => Number(r.write_off) > 0);
  if (!pool.length) {
    message.warning('请先选择源单');
    return;
  }
  let rest =
    mode === 'writeoff'
      ? 0 // 核销单按两侧未核销余额的最小值分配
      : Math.max(0, (Number(totalMoney.value) || 0));
  if (mode === 'writeoff') {
    const topRest = topRows.value.reduce((s, r) => s + (Number(r.write_off) || 0), 0);
    const bottomRest = bottomRows.value.reduce((s, r) => s + (Number(r.write_off) || 0), 0);
    rest = Math.min(topRest, bottomRest);
  }
  // 先清零再按日期升序分摊
  pool.forEach((r) => (r.write_off_price = 0));
  pool
    .slice()
    .sort((a, b) => (Number(a.purchase_time) || 0) - (Number(b.purchase_time) || 0))
    .forEach((r) => {
      if (rest <= 0) return;
      const take = Math.min(rest, Number(r.write_off) || 0);
      r.write_off_price = Math.round(take * 10000) / 10000;
      rest = Math.round((rest - take) * 10000) / 10000;
    });
  // 核销单两侧需金额相等：按较小的一侧裁剪另一侧
  if (mode === 'writeoff') {
    const min = Math.min(topTotal.value, bottomTotal.value);
    [topRows.value, bottomRows.value].forEach((arr) => {
      let left = min;
      arr.forEach((r) => {
        const take = Math.min(left, Number(r.write_off_price) || 0);
        r.write_off_price = take;
        left = Math.round((left - take) * 10000) / 10000;
      });
    });
  }
  recalc();
  message.success('已按单据日期自动分摊核销金额');
}

/**
 * 源单对话框的往来单位下拉：核销单随业务类型切换（应收类=客户，应付类=供应商）。
 */
const counterpartyOptions = computed(() => {
  if (mode === 'writeoff') {
    const bt = Number(form.value.business_type) || 1;
    const isTop = sourceSide.value === 'top';
    // 各业务类型上下栏的往来单位维度：应收类(1,3,5)=客户，应付类(2,4,6)=供应商
    const dim = {
      1: { top: false, bottom: false }, // 预收冲应收：上下均客户
      2: { top: true, bottom: true },   // 预付冲应付：上下均供应商
      3: { top: false, bottom: true },  // 应收冲应付：上客户 / 下供应商
      4: { top: false, bottom: false }, // 应收转应收：上下均客户
      5: { top: true, bottom: true },   // 应付转应付：上下均供应商
    };
    const useSupplier = (dim[bt] || dim[1])[isTop ? 'top' : 'bottom'];
    return useSupplier ? options.suppliers || [] : options.customers || [];
  }
  return cfg.counterparty === 'supplier' ? options.suppliers || [] : options.customers || [];
});

/** 金额格式化 */
function money(v) {
  return '¥' + (Number(v) || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
/** 时间戳 -> 日期字符串 */
function fmtTime(v) {
  if (!v) return '-';
  const d = new Date(Number(v) * 1000);
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}
/** 是否数值列 */
function isNumeric(type) {
  return ['int', 'bigint', 'tinyint', 'smallint', 'decimal', 'double', 'float'].includes(type);
}

/** 核销单五种业务类型（与原系统 writeoff.business_type 枚举一致） */
const WRITEOFF_TYPES = [
  { value: '1', label: '预收冲应收' },
  { value: '2', label: '预付冲应付' },
  { value: '3', label: '应收冲应付' },
  { value: '4', label: '应收转应收' },
  { value: '5', label: '应付转应付' },
];

/** 切换核销业务类型：清空已选源单（不同类型源单池不同） */
function onBizTypeChange() {
  sourceRows.value = [];
  recalc();
}

/**
 * 表头可视字段：过滤系统字段与自动汇总字段（money/write_off/advance/discount 由页面计算）。
 * 同时解析枚举注释与外键映射。
 */
const headFields = computed(() => {
  const skip = new Set([
    'id', 'admin_id', 'createtime', 'updatetime', 'deletetime',
    'preparation_id', 'operation_id', 'examine_id', 'examine_time', 'examine_status',
    'print_num', 'money', 'write_off', 'advance', 'discount',
  ]);
  // 外键列 -> 下拉数据源（与原系统模型 getXxxList 对应）
  const fkMap = {
    customers_id: 'customers',
    customers_out_id: 'customers',
    customers_enter_id: 'customers',
    suppliers_id: 'suppliers',
    suppliers_out_id: 'suppliers',
    suppliers_enter_id: 'suppliers',
    supplyer_code: 'suppliers',
    account: 'accounts',
    accounts_id: 'accounts',
    staff_member_id: 'staff',
    sale_user: 'staff',
    settlementtype: 'settlementtype',
    expend_type_id: 'expendType',
    income_type_id: 'incomeType',
    cost_id: 'cost',
  };
  return columns.value
    .filter((c) => !skip.has(c.name))
    // 核销单的 business_type 由专用下拉渲染，避免重复
    .filter((c) => !(mode === 'writeoff' && c.name === 'business_type'))
    .map((c) => {
      const em = /枚举[:：]\s*([0-9A-Za-z_,，、]+)/.exec(c.comment || '');
      return {
        name: c.name,
        type: c.type,
        label: (c.comment || c.name).replace(/枚举[:：].*$/, '').trim() || c.name,
        enum: em ? em[1].split(/[,，、]/).map((s) => s.trim()).filter(Boolean) : null,
        fk: fkMap[c.name] || null,
      };
    });
});

/** 往来单位名称回显 */
function counterpartyName(row) {
  if (cfg.counterparty === 'supplier') return row.supplyer_code || row.suppliers_id || '-';
  return row.customers_id || '-';
}

/** 合计金额 */
const totalMoney = computed(() => {
  if (mode === 'account') return accountRows.value.reduce((s, r) => s + (Number(r.money) || 0), 0);
  if (mode === 'transfer') return transferRows.value.reduce((s, r) => s + (Number(r.money) || 0), 0);
  if (mode === 'expend') return expendRows.value.reduce((s, r) => s + (Number(r.money) || 0), 0);
  if (mode === 'income') return incomeRows.value.reduce((s, r) => s + (Number(r.money) || 0), 0);
  return Number(form.value.money) || 0;
});
/**
 * 核销合计：
 * - 收款/付款单：上方源单核销额之和；
 * - 核销单：以上下两方较小者为准（原系统按两方较小金额核销）。
 */
const totalWriteOff = computed(() => {
  if (mode === 'writeoff') return Math.min(topTotal.value, bottomTotal.value);
  return sourceRows.value.reduce((s, r) => s + (Number(r.write_off_price) || 0), 0);
});
/** 预收/预付 = 合计 - 核销 */
const totalAdvance = computed(() => Math.max(0, totalMoney.value - totalWriteOff.value));
/** 支出欠款 = 合计 - 已付 */
const totalArrears = computed(() => Math.max(0, totalMoney.value - (Number(form.value.pay_money) || 0)));

/** 重算表头汇总字段（money/write_off/advance/business_type） */
function recalc() {
  form.value.money = totalMoney.value;
  if (mode === 'account' || mode === 'writeoff') {
    form.value.write_off = totalWriteOff.value;
    if (mode === 'account') {
      form.value.advance = totalAdvance.value;
      form.value.business_type = sourceRows.value.length ? '2' : '1';
    }
  }
  if (mode === 'expend') {
    form.value.arrears = totalArrears.value;
    form.value.pay_status = totalArrears.value <= 0 ? '1' : '2';
  }
  if (mode === 'income') {
    // 其他收入单：money=明细合计、arrears=本次欠款、pay_status 1=全部收款 2=部分收款
    form.value.arrears = totalArrears.value;
    form.value.pay_money = Number(form.value.pay_money) || 0;
    form.value.pay_status = totalArrears.value <= 0 ? '1' : '2';
  }
}

/** 源单类型名称（writeoff_source.purchase_type: 1预收/2预付/3应收/4应付/5期初应收/6期初预付） */
function sourceTypeName(row) {
  const names = {
    1: '预收单', 2: '预付单', 3: '应收单', 4: '应付单',
    5: '期初应收', 6: '期初预付',
  };
  const base = names[Number(row.purchase_type)] || '源单';
  return Number(row.type) === 2 ? base + '(退货)' : base;
}

// =====================================================================
// 数据加载
// =====================================================================

/** 拉取表字段元信息 */
async function loadColumns() {
  const r = await request.get(`${api}/columns`);
  columns.value = r?.columns || [];
}

/** 拉取外键下拉数据 */
async function loadOptions() {
  const jobs = [];
  const add = (key, url, labelFn) =>
    jobs.push(
      request.get(url, { params: { limit: 500 } }).then((res) => {
        options[key] = (res?.list || []).map((x) => ({ id: x.id, label: labelFn(x), raw: x }));
      }).catch(() => {}),
    );
  add('customers', '/kuerp/customers/index', (x) => x.customer_name || x.name || String(x.id));
  add('suppliers', '/kuerp/suppliers/index', (x) => x.supplyer_name || x.name || x.supplyer_code || String(x.id));
  add('accounts', '/kuerp/accounts/index', (x) => `${x.account_name}(${x.account_coding})`);
  add('staff', '/kuerp/staff-member/index', (x) => x.staff_name || x.name || String(x.id));
  add('settlementtype', '/kuerp/settlementtype/index', (x) => x.name || String(x.id));
  add('expendType', '/kuerp/expend-type/index', (x) => x.name || String(x.id));
  add('incomeType', '/kuerp/income-type/index', (x) => x.name || String(x.id));
  add('cost', '/kuerp/cost/index', (x) => x.purchase_code || String(x.id));
  await Promise.all(jobs);
}

/** 拉取单据列表 */
async function load() {
  loading.value = true;
  try {
    const r = await request.get(`${api}/index`, {
      params: { page: page.value, limit: pageSize.value, search: search.value || undefined },
    });
    list.value = r?.list || [];
    total.value = r?.count || 0;
  } finally {
    loading.value = false;
  }
}

/**
 * 加载核销源单池（kuerp_writeoff_source）。
 * 核销单按 side（top/bottom）分别过滤：上方=预收/预付/应收/转出方，下方=应收/应付/转入方。
 */
async function loadSources() {
  // 按 mode/业务类型/所在列过滤可核销的源单类型
  let types = [1, 2, 3, 4, 5, 6];
  if (mode === 'account') types = isCollection ? [1, 3, 5] : [2, 4, 6];
  if (mode === 'writeoff') {
    const bt = Number(form.value.business_type) || 1;
    const isTop = sourceSide.value === 'top';
    // 上/下两列各自可选的源单类型（对应原系统核销弹窗的上下两栏）
    const map = {
      1: { top: [1, 5], bottom: [3] },   // 预收冲应收：上=预收(含期初)，下=应收
      2: { top: [2, 6], bottom: [4] },   // 预付冲应付：上=预付(含期初)，下=应付
      3: { top: [3], bottom: [4] },      // 应收冲应付：上=应收(客户)，下=应付(供应商)
      4: { top: [3], bottom: [3] },      // 应收转应收：上下均为应收，靠转出/转入客户区分
      5: { top: [4], bottom: [4] },      // 应付转应付：上下均为应付，靠转出/转入供应商区分
    };
    types = (map[bt] || map[1])[isTop ? 'top' : 'bottom'];
  }

  // 往来单位维度：应付/预付类(2,4,6)按供应商编号匹配，应收/预收类(1,3,5)按客户 ID 匹配。
  // 必须按当前栏位（top/bottom）的源单类型判定——例如「应收冲应付」(bt=3) 上方应收(客户)、下方应付(供应商）。
  const useSupplier = mode === 'writeoff'
    ? types.some((t) => [2, 4, 6].includes(Number(t)))
    : cfg.counterparty === 'supplier';

  // 走专用接口：后端已完成「未核销完」过滤（writeoff_log 口径）+ 类型/往来单位/关键字过滤
  const params = { kind: useSupplier ? 'cope' : 'receive', types: types.join(',') };
  if (sourceFilter.counterparty) {
    if (useSupplier) params.suppliers_id = sourceFilter.counterparty;
    else params.customers_id = sourceFilter.counterparty;
  }
  if (sourceFilter.keyword) params.keyword = sourceFilter.keyword;

  const r = await request.get('/kuerp/writeoff/sources', { params });
  sourceList.value = r?.rows || [];
}

/**
 * 打开源单选择对话框。
 * @param side 'top'=上方源单(writeoff_info.top=1) / 'bottom'=下方源单(top=2)
 */
function openSourcePicker(side = 'top') {
  if (mode === 'writeoff' && !form.value.business_type) {
    message.warning('请先选择核销业务类型');
    return;
  }
  sourceSide.value = side;
  sourceFilter.counterparty = null;
  sourceFilter.keyword = '';
  picked.value = [];
  sourceDialog.value = true;
  loadSources();
}

/**
 * 确认选择的源单：写入本次核销金额（默认未核销余额）。
 * 核销单按当前所在列打上 top 标记（1=上方、2=下方），供后端 FundsService 双向流水使用。
 */
function confirmSources() {
  const top = sourceSide.value === 'top' ? 1 : 2;
  for (const s of picked.value) {
    // 已选源单不重复添加（同一列内去重）
    if (sourceRows.value.some((r) => r.source_id === s.id && Number(r.top || 1) === top)) continue;
    sourceRows.value.push(newRow({
      source_id: s.id,
      top,
      purchase_number: s.purchase_code,
      purchase_type: s.purchase_type,
      type: s.type,
      money: Number(s.price) || 0,
      write_off: Number(s.write_off) || 0,
      write_off_price: Number(s.write_off) || 0,
      purchase_time: s.purchase_time,
    }));
  }
  sourceDialog.value = false;
  recalc();
}

// =====================================================================
// 新增 / 编辑 / 保存
// =====================================================================

/** 生成单据号：前缀 + 年月日时分秒 */
/**
 * 生成单据号：优先按「单号设置」规则生成（kuerp_prefix，与原系统 Thirds::getCodes
 * 口径一致：前缀 + 日期段 + 流水号，服务端自动查重递增）；
 * 规则未配置或请求失败时回退本地时间戳生成，保证离线可用。
 * @returns {Promise<string>} 单据编号
 */
async function genCode() {
  try {
    // 落库表名：/kuerp/collection → kuerp_collection
    const db = api.replace(/^\/kuerp\//, '').replace(/-/g, '_');
    const r = await request.get('/kuerp/prefix/gen-code', {
      params: { dbname: db, field: 'purchase_code' },
    });
    if (r?.code) return r.code;
  } catch { /* 规则未配置时回退本地生成 */ }
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  return `${codePrefix}${d.getFullYear()}${p(d.getMonth() + 1)}${p(d.getDate())}${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
}

/** 打开新增（async：单据号按「单号设置」规则异步生成） */
async function openAdd() {
  editing.value = false;
  originalInfoIds.length = 0;
  form.value = {
    purchase_code: await genCode(),
    purchase_time: Math.floor(Date.now() / 1000),
    examine_status: '0',
  };
  if (mode === 'writeoff') form.value.business_type = '1';
  if (mode === 'account' && !isCollection) form.value.business_type = '1';
  headFields.value.forEach((c) => {
    if (form.value[c.name] === undefined) form.value[c.name] = isNumeric(c.type) ? 0 : '';
  });
  accountRows.value = [];
  sourceRows.value = [];
  transferRows.value = [];
  expendRows.value = [];
  incomeRows.value = [];
  if (mode === 'income') form.value.business_type = '1';
  dialog.value = true;
}

/** 打开编辑：回填表头与子表 */
async function openEdit(row) {
  editing.value = true;
  originalInfoIds.length = 0;
  const f = {};
  headFields.value.forEach((c) => {
    f[c.name] = row[c.name] ?? (isNumeric(c.type) ? 0 : '');
  });
  // 日期选择器（value-format=X）需要字符串
  if (f.purchase_time !== undefined && f.purchase_time !== null && f.purchase_time !== '') {
    f.purchase_time = String(f.purchase_time);
  }
  f.id = row.id;
  form.value = f;

  // 回填子表
  accountRows.value = [];
  sourceRows.value = [];
  transferRows.value = [];
  expendRows.value = [];
  incomeRows.value = [];
  const infoApi = cfg.accountInfo || cfg.transferInfo || cfg.simpleInfo || cfg.sourceInfo;
  const linkField = mode === 'transfer' || mode === 'expend' || mode === 'income' ? 'purchase_id' : 'collection_id';
  try {
    const r = await request.get(`${infoApi}/index`, { params: { limit: 500 } });
    const rows = (r?.list || []).filter((x) => Number(x[linkField]) === Number(row.id));
    if (mode === 'account') {
      // account 模式有两个子表：先取账户行，再取源单行
      accountRows.value = rows;
      const sr = await request.get(`${cfg.sourceInfo}/index`, { params: { limit: 500 } });
      sourceRows.value = (sr?.list || []).filter((x) => Number(x.collection_id) === Number(row.id));
    } else if (mode === 'transfer') {
      transferRows.value = rows;
    } else if (mode === 'expend') {
      expendRows.value = rows;
    } else if (mode === 'income') {
      incomeRows.value = rows;
    } else {
      sourceRows.value = rows;
    }
    // 收集已存在子表行 id（按模式区分，确保编辑保存时两类子表都能被清理，避免源单重复累积）
    if (mode === 'account') {
      accountRows.value.forEach((x) => originalInfoIds.push(x.id));
      sourceRows.value.forEach((x) => originalInfoIds.push(x.id));
    } else if (mode === 'transfer') {
      transferRows.value.forEach((x) => originalInfoIds.push(x.id));
    } else if (mode === 'expend') {
      expendRows.value.forEach((x) => originalInfoIds.push(x.id));
    } else if (mode === 'income') {
      incomeRows.value.forEach((x) => originalInfoIds.push(x.id));
    } else {
      sourceRows.value.forEach((x) => originalInfoIds.push(x.id));
    }
  } catch { /* 子表加载失败不阻塞编辑 */ }
  dialog.value = true;
}

/** 校验单据合法性 */
function validate() {
  if (!form.value.purchase_time) {
    message.warning('请选择单据日期');
    return false;
  }
  if (mode === 'account' && !accountRows.value.length) {
    message.warning('请至少添加一行结算账户');
    return false;
  }
  if (mode === 'account' && accountRows.value.some((r) => !r.accounts_id)) {
    message.warning('请选择结算账户');
    return false;
  }
  if (mode === 'transfer') {
    if (!transferRows.value.length) {
      message.warning('请至少添加一行转账明细');
      return false;
    }
    if (transferRows.value.some((r) => !r.accounts_out_id || !r.accounts_enter_id)) {
      message.warning('请选择转出/转入账户');
      return false;
    }
    if (transferRows.value.some((r) => r.accounts_out_id === r.accounts_enter_id)) {
      message.warning('转出账户与转入账户不能相同');
      return false;
    }
  }
  // 核销金额不得超过源单未核销余额
  for (const r of sourceRows.value) {
    if (Number(r.write_off_price) > Number(r.write_off) + 1e-6) {
      message.warning(`源单 ${r.purchase_number} 本次核销金额不能大于未核销金额`);
      return false;
    }
  }
  // 核销单必须选择源单（核销金额 = 各源单本次核销合计，保存时自动汇总）
  if (mode === 'writeoff' && !sourceRows.value.length) {
    message.warning('请选择核销源单');
    return false;
  }
  // 核销单：上下两列都必须有源单，且两列核销金额必须相等
  if (mode === 'writeoff') {
    if (!topRows.value.length || !bottomRows.value.length) {
      message.warning('核销单需分别选择上方与下方源单');
      return false;
    }
    if (Math.abs(topTotal.value - bottomTotal.value) > 1e-6) {
      message.warning(`上方核销合计 ${topTotal.value} 与下方 ${bottomTotal.value} 不一致，请调整或点击自动核销`);
      return false;
    }
    // 应收转应收 / 应付转应付：转出单位不能等于转入单位
    const bt = Number(form.value.business_type) || 1;
    if (bt === 4 && form.value.customers_out_id && form.value.customers_out_id === form.value.customers_enter_id) {
      message.warning('转出客户与转入客户不能相同');
      return false;
    }
    if (bt === 5 && form.value.suppliers_out_id && form.value.suppliers_out_id === form.value.suppliers_enter_id) {
      message.warning('转出供应商与转入供应商不能相同');
      return false;
    }
  }
  if (mode === 'income' && !incomeRows.value.length) {
    message.warning('请至少添加一行收入明细');
    return false;
  }
  if (mode === 'income' && incomeRows.value.some((r) => !r.income_type_id)) {
    message.warning('请选择收入类别');
    return false;
  }
  return true;
}

/** 保存：先写表头，再写子表 */
async function submit() {
  if (!validate()) return;
  saving.value = true;
  try {
    const now = Math.floor(Date.now() / 1000);
    const payload = { ...form.value };
    // 汇总字段以页面计算为准
    payload.money = totalMoney.value;
    if (mode === 'account') {
      payload.write_off = totalWriteOff.value;
      payload.advance = totalAdvance.value;
      payload.business_type = sourceRows.value.length ? '2' : '1';
    }
    if (mode === 'writeoff') payload.write_off = totalWriteOff.value;
    if (mode === 'expend') {
      payload.arrears = totalArrears.value;
      payload.pay_status = totalArrears.value <= 0 ? '1' : '2';
    }
    if (mode === 'transfer') payload.money = totalMoney.value;
    payload.createtime = now;
    payload.updatetime = now;

    // 1) 表头
    let headerId;
    if (editing.value) {
      headerId = payload.id;
      const { id, ...rest } = payload;
      await request.post(`${api}/edit`, { id, ...rest });
      // 2) 清理旧子表行后重写（未审核单据的子表可整体重建）
      await clearInfoRows();
    } else {
      const res = await request.post(`${api}/add`, payload);
      headerId = res?.insertId;
    }

    // 3) 子表逐行写入
    const infoApi = cfg.accountInfo || cfg.transferInfo || cfg.simpleInfo || cfg.sourceInfo;
    const linkField = mode === 'transfer' || mode === 'expend' ? 'purchase_id' : 'collection_id';
    const writeRows = async (rows, extra) => {
      for (const r of rows) {
        const row = { ...r, ...extra };
        delete row.id;
        await request.post(`${infoApi}/add`, row);
      }
    };
    if (mode === 'account') {
      await writeRows(accountRows.value, {
        collection_id: headerId, purchase_code: payload.purchase_code, purchase_time: payload.purchase_time,
      });
      // 源单行（writeoff_info 结构）
      for (const r of sourceRows.value) {
        await request.post(`${cfg.sourceInfo}/add`, {
          collection_id: headerId,
          purchase_code: payload.purchase_code,
          purchase_time: payload.purchase_time,
          purchase_number: r.purchase_number,
          purchase_type: r.purchase_type,
          type: r.type,
          business_type: isCollection ? 3 : 4,
          money: r.money,
          write_off: r.write_off,
          write_off_price: r.write_off_price,
          source_id: r.source_id,
          // top：1=上方（转出/预收预付）、2=下方（转入/应收应付），由页面双列选择决定
          top: Number(r.top) || 1,
        });
      }
    } else if (mode === 'writeoff') {
      for (const r of sourceRows.value) {
        await request.post(`${infoApi}/add`, {
          collection_id: headerId,
          purchase_code: payload.purchase_code,
          purchase_time: payload.purchase_time,
          purchase_number: r.purchase_number,
          purchase_type: r.purchase_type,
          type: r.type,
          business_type: Number(form.value.business_type) || 1,
          money: r.money,
          write_off: r.write_off,
          write_off_price: r.write_off_price,
          source_id: r.source_id,
          top: Number(r.top) || 1,
        });
      }
    } else if (mode === 'transfer') {
      await writeRows(transferRows.value, {
        purchase_id: headerId, purchase_code: payload.purchase_code, purchase_time: payload.purchase_time,
      });
    } else if (mode === 'expend' || mode === 'income') {
      await writeRows(mode === 'income' ? incomeRows.value : expendRows.value, {
        purchase_id: headerId, purchase_code: payload.purchase_code, purchase_time: payload.purchase_time,
        business_type: '1',
      });
    }

    message.success(editing.value ? '保存成功' : `单据创建成功，编号 ${payload.purchase_code}`);
    dialog.value = false;
    load();
  } catch (e) {
    message.error('保存失败：' + (e?.message || '接口错误'));
  } finally {
    saving.value = false;
  }
}

/** 编辑保存前清理旧子表行 */
async function clearInfoRows() {
  const jobs = [];
  const tables = [];
  if (mode === 'account') tables.push(cfg.accountInfo, cfg.sourceInfo);
  else if (mode === 'transfer') tables.push(cfg.transferInfo);
  else if (mode === 'expend' || mode === 'income') tables.push(cfg.simpleInfo);
  else tables.push(cfg.sourceInfo);
  for (const t of tables) {
    if (!t) continue;
    jobs.push(
      request.post(`${t}/del`, { ids: originalInfoIds.slice() }).catch(() => {}),
    );
  }
  await Promise.all(jobs);
}

/** 重置表单 */
function resetForm() {
  form.value = {};
  accountRows.value = [];
  sourceRows.value = [];
  transferRows.value = [];
  expendRows.value = [];
  incomeRows.value = [];
}

// =====================================================================
// 列表行操作
// =====================================================================

/** 审核 / 反审：触发后端资金过账/冲转 */
async function onExamine(row) {
  const cur = Number(row.examine_status) || 0;
  const next = cur === 1 ? 0 : 1;
  const action = next === 1 ? '审核' : '反审';
  await confirm(`确认${action}单据 ${row.purchase_code}？${next === 1 ? '审核后将自动过账资金。' : ''}`, '提示', { type: 'warning' });
  await request.post(`${api}/examine`, { id: row.id, status: next });
  message.success(next === 1 ? '已审核并过账' : '已反审并冲转');
  load();
}

/** 删除单据 */
async function onDel(row) {
  await confirm(`确认删除单据 ${row.purchase_code}？`, '提示', { type: 'warning' });
  await request.post(`${api}/del`, { id: row.id });
  message.success('已删除');
  load();
}

/** 跳转通用打印页 */
function openPrint(row) {
  const t = (api.split('/').pop() || '').replace(/_/g, '-');
  router.push({ name: 'Print', query: { table: t, id: row.id } });
}

onMounted(async () => {
  await loadColumns();
  await loadOptions();
  await load();
});
</script>

<style scoped>
/* flex 排版放在卡片内容区上（.toolbar 挂在 DsCard 根，卡片根本身是 flex column） */
.toolbar :deep(.ds-card-c__body) { display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap; }
.tb-left { display: flex; gap: 10px; align-items: center; }
.tb-tip { color: #909399; font-size: 12px; }
.mt { margin-top: 12px; }
.doc-body { max-height: 62vh; overflow: auto; padding-right: 8px; }
.section-title { font-weight: 600; margin: 14px 0 8px; display: flex; align-items: center; gap: 8px; }
.sec-tip { font-weight: 400; font-size: 12px; color: #909399; }
/* 表头表单：栅格与行间距由全局 .ds-form--3 提供 */
.head-form { margin: 0; }
/* 源单弹窗表格滚动区：替代原 el-table 的 max-height 属性 */
.src-scroll { max-height: 420px; overflow: auto; }
.totals { margin-top: 14px; padding: 10px 12px; background: #f5f7fa; border-radius: 4px; display: flex; gap: 28px; }
.src-filter { display: flex; gap: 10px; align-items: center; margin-bottom: 12px; }
.src-filter .lbl { color: #606266; font-size: 13px; }
</style>
