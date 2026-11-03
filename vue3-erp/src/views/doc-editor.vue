<template>
  <div class="doc-editor">
    <!-- ============ 工具栏：检索 + 日期范围 + 新增 ============ -->
    <DsCard class="toolbar">
      <DsInput v-model="query.search" placeholder="检索单据编号/备注" clearable style="width: 220px" @keyup.enter="loadList" @clear="loadList" />
      <DsDatePicker v-model="startDate" type="date" placeholder="开始日期" style="width: 150px; margin-left: 8px" />
      <DsDatePicker v-model="endDate" type="date" placeholder="结束日期" style="width: 150px; margin-left: 8px" />
      <DsButton variant="primary" style="margin-left: 8px" @click="loadList">查询</DsButton>
      <!-- 对单/反对单（等价原系统 counter 批量按钮，仅 4 个购销单据表有 check_status 列） -->
      <template v-if="hasCheckStatus">
        <DsButton style="margin-left: 8px" @click="counterSelected(1)">对单</DsButton>
        <DsButton @click="counterSelected(2)">反对单</DsButton>
      </template>
      <DsButton v-if="can('add')" variant="primary" style="margin-left: auto" @click="openAdd">新增单据</DsButton>
      <DsButton v-if="can('add')" variant="default" style="margin-left: 8px" :loading="aiDrafting" @click="openAiDraft">AI 智能录入</DsButton>    </DsCard>

    <!-- ============ 单据列表 ============ -->
    <DsTable :columns="listCols" :data="list" row-key="id" class="list" :loading="loading">
      <template #__sel="{ row }">
        <DsCheckbox :model-value="isSelected(row)" @update:modelValue="(v) => toggleSel(row, v)" />
      </template>
      <template #purchase_time="{ row }">{{ fmtDate(row.purchase_time) }}</template>
      <template #__cp="{ row }">{{ counterpartyName(row) }}</template>
      <template #money_tax_price="{ row }">{{ money(row.money_tax_price) }}</template>
      <template #money="{ row }">{{ money(row.money) }}</template>
      <template #__examine="{ row }">
        <DsTag :color="examined(row) ? 'success' : 'neutral'" size="sm">{{ examined(row) ? '已审核' : '未审核' }}</DsTag>
      </template>
      <template #__check="{ row }">
        <DsTag :color="isChecked(row) ? 'warning' : 'neutral'" size="sm">{{ isChecked(row) ? '已对单' : '未对单' }}</DsTag>
      </template>
      <template #__op="{ row }">
        <DsButton v-if="can('edit')" variant="text" size="sm" @click="openEdit(row)">编辑</DsButton>
        <DsButton v-if="!examined(row) && can('examine')" variant="text" size="sm" @click="examine(row, 1)">审核</DsButton>
        <DsButton v-else-if="examined(row) && can('examine')" variant="text" size="sm" @click="examine(row, 0)">反审</DsButton>
        <!-- 多级审批：提交后由审批人在「审批待办」逐级通过，末级通过才真正过账 -->
        <DsButton v-if="!examined(row) && can('examine')" variant="text" size="sm" @click="submitApproval(row)">提交审批</DsButton>
        <DsButton variant="text" size="sm" @click="openApproval(row)">审批进度</DsButton>
        <DsButton v-if="hasCheckStatus" variant="text" size="sm" @click="counterRow(row, isChecked(row) ? 2 : 1)">
          {{ isChecked(row) ? '反对单' : '对单' }}
        </DsButton>
        <DsButton v-if="!examined(row) && can('del')" variant="text" size="sm" @click="remove(row)">删除</DsButton>
      </template>
    </DsTable>

    <!-- ============ 单据编辑器：表头 + 明细子表 ============ -->
    <DsModal :title="editing ? `编辑单据 ${form.purchase_code || ''}` : '新增单据'" v-model="dialog" :width="1180" @close="resetForm">
      <div class="editor">
        <!-- 表头区 -->
        <DsCard class="head-card">
          <div class="ds-form ds-form--inline head-form">
            <DsField label="单据编号">
              <DsInput :model-value="form.purchase_code || '（保存时自动生成）'" disabled style="width: 180px" />
            </DsField>
            <DsField label="单据日期">
              <DsDatePicker v-model="purchaseTimeStr" type="datetime" style="width: 180px" />
            </DsField>
            <DsField v-if="counterparty" :label="counterpartyLabel">
              <DsSelect v-model="form[cpField]" :options="cpOptionItems" filterable clearable placeholder="请选择" style="width: 200px" />
            </DsField>
            <!-- 其余表头字段由 /columns 自动生成 -->
            <DsField v-for="col in headFields" :key="col.name" :label="col.label">
              <DsSelect v-if="enumOptions(col).length" v-model="form[col.name]" :options="enumOptions(col)" size="sm" style="width: 150px" />
              <DsInput v-else v-model="form[col.name]" style="width: 150px" />
            </DsField>
          </div>
        </DsCard>

        <!-- 明细子表 -->
        <div class="info-bar">
          <span class="info-title">{{ bom ? bomTitle : '明细' }}</span>
          <DsButton size="sm" variant="primary" @click="pickDialog = true">选择商品</DsButton>
          <DsButton size="sm" @click="addBlankRow">空白行</DsButton>
          <!-- 组装单 / 拆卸单：模板能力（等价原系统 savetemp / gettemp） -->
          <template v-if="bom">
            <DsButton size="sm" @click="openSaveTemp">存为模板</DsButton>
            <DsButton size="sm" @click="openTempList">调用模板</DsButton>
          </template>
          <span v-if="bom" class="sec-tip">
            {{ bom === 'assemble' ? '组合件入库、子件出库；组合件成本=子件成本合计+费用' : '组合件出库、子件入库' }}
          </span>
        </div>
        <div class="info-scroll">
          <DsTable :columns="rowCols" :data="rows" row-key="_k" striped>
            <template #type="{ row }">
              <DsSelect v-model="row.type" :options="bomTypeOptions" size="sm" />
            </template>
            <template #__goods="{ row }">{{ row.goods_name || row.goods_code }}</template>
            <template #stores_out="{ row }">
              <DsSelect v-model="row.stores_out" :options="warehouseOptions" filterable size="sm" />
            </template>
            <template #stores_enter="{ row }">
              <DsSelect v-model="row.stores_enter" :options="warehouseOptions" filterable size="sm" />
            </template>
            <template #stores_id="{ row }">
              <DsSelect v-model="row.stores_id" :options="warehouseOptions" filterable size="sm" />
            </template>
            <template #invertory_stock="{ row }">
              <DsInput type="number" v-model="row.invertory_stock" size="sm" @change="calcProfit(row)" />
            </template>
            <template #profit="{ row }">
              <span :class="row.profit > 0 ? 'profit-up' : row.profit < 0 ? 'profit-down' : ''">{{ row.profit }}</span>
            </template>
            <template #money="{ row }">
              <DsInput type="number" v-model="row.money" size="sm" />
            </template>
            <template #goods_unit="{ row }">
              <DsSelect v-model="row.goods_unit" :options="unitOptionsOf(row)" size="sm" @change="onUnitChange(row)" />
            </template>
            <template #number="{ row }">
              <DsInput type="number" v-model="row.number" :min="0" size="sm" @change="calcRow(row, 'number')" />
            </template>
            <template #unit_cost="{ row }">
              <DsInput type="number" v-model="row.unit_cost" :min="0" size="sm" @change="calcCost(row)" />
            </template>
            <template #cost_money="{ row }">
              <DsInput type="number" v-model="row.cost_money" :min="0" size="sm" @change="calcUnitCost(row)" />
            </template>
            <template #unit_price="{ row }">
              <DsInput type="number" v-model="row.unit_price" :min="0" size="sm" @change="calcRow(row, 'unit_price')" />
            </template>
            <template #discount="{ row }">
              <DsInput type="number" v-model="row.discount" :min="0" :max="100" size="sm" @change="calcRow(row, 'discount')" />
            </template>
            <template #tax_rate="{ row }">
              <DsInput type="number" v-model="row.tax_rate" :min="0" size="sm" @change="calcRow(row, 'tax_rate')" />
            </template>
            <template #tax_included="{ row }">
              <DsInput type="number" v-model="row.tax_included" :min="0" size="sm" @change="calcRow(row, 'tax_included')" />
            </template>
            <template #all_money="{ row }">{{ money(row.all_money) }}</template>
            <template #money_tax_price="{ row }">{{ money(row.money_tax_price) }}</template>
            <template #__batch="{ row }">
              <DsButton v-if="row.batch_name" size="sm" @click="openBatch(row)">{{ row.batch_name }}</DsButton>
              <DsButton v-else size="sm" variant="default" @click="openBatch(row)">选择批次</DsButton>
            </template>
            <template #__serial="{ row }">
              <DsButton size="sm" variant="default" @click="openSerial(row)">
                {{ row._serials.length ? `${row._serials.length} 个` : '录入' }}
              </DsButton>
            </template>
            <template #remark="{ row }">
              <DsInput v-model="row.remark" size="sm" />
            </template>
            <template #__del="{ row }">
              <DsButton variant="text" size="sm" @click="removeRow(row)">删</DsButton>
            </template>
          </DsTable>
        </div>

        <!-- 合计行 -->
        <div class="totals">
          <span>合计数量：<b>{{ totals.number }}</b></span>
          <span v-if="bom">成本合计：<b>{{ money(totals.cost_money) }}</b></span>
          <span v-if="hasMoney">金额：<b>{{ money(totals.all_money) }}</b></span>
          <span v-if="hasMoney">税额：<b>{{ money(totals.tax_money) }}</b></span>
          <span v-if="hasMoney">价税合计：<b>{{ money(totals.money_tax_price) }}</b></span>
        </div>

        <!-- 采购/销售费用子表：仅购销退货类单据显示。
             费用行随单据审核写入 kuerp_cost，供【资金】→【采购销售费用清单】查询与结清 -->
        <div v-if="needCost" class="info-bar">
          <span class="info-title">{{ costTitle }}</span>
          <DsButton size="sm" variant="primary" @click="addCostRow">添加费用</DsButton>
          <span class="sec-tip">费用随单据审核写入采购销售费用清单，可在其他支出单中结清</span>
        </div>
        <DsTable v-if="needCost" :columns="costCols" :data="costRows" row-key="_k" striped class="info-table">
          <template #suppliers_id="{ row }">
            <DsSelect v-model="row.suppliers_id" :options="costUnitOptionItems" filterable clearable size="sm" style="width: 100%" />
          </template>
          <template #expend_type_id="{ row }">
            <DsSelect v-model="row.expend_type_id" :options="costTypeOptionItems" filterable clearable size="sm" style="width: 100%" />
          </template>
          <template #money="{ row }">
            <DsInput type="number" v-model="row.money" :min="0" size="sm" style="width: 100%" />
          </template>
          <template #remark="{ row }">
            <DsInput v-model="row.remark" size="sm" />
          </template>
          <template #__del="{ row }">
            <DsButton variant="text" size="sm" @click="removeCostRow(row)">删除</DsButton>
          </template>
        </DsTable>
      </div>
      <template #footer>
        <DsButton @click="dialog = false">取消</DsButton>
        <DsButton variant="primary" :loading="saving" @click="save">保存</DsButton>
      </template>
    </DsModal>

    <!-- ============ AI 智能录入（自然语言 → 结构化单据草稿）============ -->
    <DsModal v-model="aiDraftVisible" title="AI 智能录入" :width="640">
      <DsAlert
        type="info"
        :closable="false"
        show-icon
        title="用一句话开单"
        description="例如：向「华强供应商」采购 螺丝刀 100 个（单价 5 元）、扳手 20 个。AI 会解析往来单位、商品、数量与单价并生成草稿，你只需核对仓库后保存。"
      />
      <DsInput v-model="aiText" type="textarea" :rows="4" placeholder="描述开单需求…" style="margin-top: 10px" />
      <template #footer>
        <DsButton @click="aiDraftVisible = false">取消</DsButton>
        <DsButton variant="primary" :loading="aiDrafting" @click="generateAiDraft">生成草稿</DsButton>
      </template>
    </DsModal>

    <!-- ============ 存为模板（等价 Assemble::savetemp / Split::savetemp）============ -->
    <DsModal v-model="saveTempVisible" title="存为模板" :width="460">
      <DsField label="模板名称" required>
        <DsInput v-model="tempName" placeholder="请输入模板名称（不可重复）" />
      </DsField>
      <DsAlert
        class="mt8"
        type="info"
        :closable="false"
        show-icon
        :description="`将当前${bom === 'split' ? '拆卸' : '组装'}单的商品明细保存为模板，下次可直接调用，不生成库存流水。`"
      />
      <template #footer>
        <DsButton @click="saveTempVisible = false">取消</DsButton>
        <DsButton variant="primary" :loading="tempSaving" @click="submitSaveTemp">保存</DsButton>
      </template>
    </DsModal>

    <!-- ============ 调用模板（等价 AssembleTemp::gettemp）============ -->
    <DsModal v-model="tempListVisible" title="调用模板" :width="760">
      <DsTable :columns="tempCols" :data="tempList" row-key="id" striped :loading="tempLoading">
        <template #purchase_time="{ row }">{{ fmtDate(row.purchase_time) }}</template>
        <template #money="{ row }">{{ money(row.money) }}</template>
        <template #__op="{ row }">
          <DsButton variant="text" size="sm" @click="applyTemp(row)">调用</DsButton>
        </template>
      </DsTable>
      <DsEmpty v-if="!tempLoading && !tempList.length" title="暂无模板，可先在单据中点「存为模板」" />
      <template #footer>
        <DsButton @click="tempListVisible = false">关闭</DsButton>
      </template>
    </DsModal>

    <!-- ============ 商品选择对话框 ============ -->
    <DsModal title="选择商品" v-model="pickDialog" :width="720">
      <DsInput v-model="pickKeyword" placeholder="商品名称/编号/条码" clearable style="width: 260px" @keyup.enter="searchGoods" />
      <DsButton variant="primary" style="margin-left: 8px" @click="searchGoods">检索</DsButton>
      <DsTable :columns="pickCols" :data="pickList" row-key="id" class="pick-table" clickable @row-click="pickGoods">
        <template #purchase="{ row }">{{ money(row.purchase) }}</template>
        <template #market_sell_price="{ row }">{{ money(row.market_sell_price) }}</template>
        <template #batch="{ row }">
          <DsTag v-if="row.batch == 1" color="warning" size="sm">启</DsTag>
        </template>
        <template #serial="{ row }">
          <DsTag v-if="row.serial == 1" color="warning" size="sm">启</DsTag>
        </template>
        <template #__pick="{ row }">
          <DsButton variant="text" size="sm" @click="pickGoods(row)">选择</DsButton>
        </template>
      </DsTable>
    </DsModal>

    <!-- ============ 批次选择对话框 ============ -->
    <DsModal title="选择批次" v-model="batchDialog" :width="560">
      <DsTable :columns="batchCols" :data="batchList" row-key="id" clickable @row-click="chooseBatch">
        <template #manufacture="{ row }">{{ fmtDate(row.manufacture) }}</template>
        <template #validity="{ row }">{{ fmtDate(row.validity) }}</template>
        <template #__stock="{ row }">{{ batchStockOf(row) }}</template>
      </DsTable>
      <DsDivider>或新建批次</DsDivider>
      <div class="ds-form ds-form--inline head-form">
        <DsField label="批次名称">
          <DsInput v-model="batchForm.batch_name" style="width: 130px" />
        </DsField>
        <DsField label="生产日期">
          <DsDatePicker v-model="manufactureStr" type="date" style="width: 150px" />
        </DsField>
        <DsField label="保质期(天)">
          <DsInput type="number" v-model="batchForm.guarantee" :min="0" style="width: 100px" />
        </DsField>
        <DsField label="有效期至">
          <DsDatePicker v-model="validityStr" type="date" style="width: 150px" />
        </DsField>
        <DsField class="ds-field--nolabel">
          <DsButton variant="primary" @click="createBatch">新建并选用</DsButton>
        </DsField>
      </div>
    </DsModal>

    <!-- ============ 序列号录入对话框 ============ -->
    <DsModal title="录入序列号" v-model="serialDialog" :width="480">
      <DsAlert type="info" :closable="false" show-icon title="每行一个序列号" style="margin-bottom: 8px" />
      <DsInput v-model="serialText" type="textarea" :rows="10" placeholder="SN001&#10;SN002" />
      <template #footer>
        <DsButton @click="serialDialog = false">取消</DsButton>
        <DsButton variant="primary" @click="confirmSerial">确定</DsButton>
      </template>
    </DsModal>

    <!-- ============ 多级审批面板（进度 + 通过/驳回） ============ -->
    <ApprovalPanel
      v-model="approvalVisible"
      :doc-table="approvalTable"
      :doc-id="approvalDocId"
      :doc-code="approvalDocCode"
      @changed="loadList"
    />
  </div>
</template>

<script setup>
/**
 * 通用单据编辑器（doc-editor.vue）：
 * 1:1 还原原系统购货/销货/退货/订单/其他入出库/调拨/盘点/成本调整等单据页的
 * 「表头 + 明细子表」编辑能力（原通用 CRUD 页只有扁平表单，无法录入明细）。
 *
 * 能力：
 * - 表头字段由 /kuerp/:table/columns 自动生成（枚举解析 + 下拉映射）；
 * - 明细子表：商品选择（含属性/单位）、数量、单价、折扣、税率、金额公式
 *   （与原系统 formatInfo2 完全一致）、批次选择/新建、序列号录入；
 * - 盘点单自动带出系统库存并计算盈亏；成本调整单仅录金额；
 * - 保存：表头 + 明细两步写入（明细按单据编号/主键关联）；
 * - 审核/反审：触发后端 PostingService 过账/冲转（库存/批次/序列号/资金联动）。
 *
 * 配置（route.meta.doc，由 menus.js 的 g() 工厂注入）：
 *   info          明细表 API 前缀（如 goods-purchase-info）
 *   prefix        单据编号前缀（CG/XS/TH/...）
 *   counterparty  supplier=供应商 / customer=客户（''=无往来单位）
 *   counterpartyById  true=表头存 customers_id（ID）；false=存 supplyer_code（编号）
 *   shape         单据形态：goods=购销退货 / order=订单 / transfer=调拨 / stocktake=盘点 / adjust=成本调整
 *   priceBase     sell=默认取零售价 / purchase=默认取进价
 *   byId          true=明细按表头主键关联（调拨单 allocation_id）
 */
import { ref, reactive, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { message, confirm } from '@/utils/ui';
import request from '../utils/request';
import ApprovalPanel from '../components/biz/ApprovalPanel.vue';
import { loadPerms, usePerm } from '@/utils/perm';
import { fieldLabel, parseComment } from '@/utils/field-meta';

const route = useRoute();
const api = route.meta.api || '/kuerp/goods-purchase';

// —— 按钮级权限 ——
// 单据页的动作名与通用 CRUD 一致（add/edit/del/examine），
// 权限节点形如 kuerp/<表>:add；仅配了表级节点时 hasPerm 也会放行。
const { hasPerm } = usePerm();
onMounted(() => { loadPerms(); });
/**
 * 判断当前单据表是否可执行某动作。
 * @param action 动作名：add/edit/del/examine
 * @returns 是否有权限
 */
function can(action) {
  return hasPerm(api, action);
}
const doc = route.meta.doc || {};
const infoApi = '/kuerp/' + (doc.info || 'goods-purchase-info');
const shape = doc.shape || 'goods';
// 组装/拆卸单标志：assemble=组装单（子件出库+组合件入库）、split=拆卸单（组合件出库+子件入库）
const bom = doc.bom || '';
const bomTitle = bom === 'assemble' ? '组件信息（组合件 + 子件）' : '组件信息（组合件 + 子件）';
const counterparty = doc.counterparty || '';
const counterpartyById = !!doc.counterpartyById;
const prefix = doc.prefix || 'DOC';
const byId = !!doc.byId;
const priceBase = doc.priceBase || 'purchase';

/**
 * 出库类单据接口白名单：保存前做库存校验（等价原系统 checkPurchase/checkExchange）。
 * 销货单扣库存、调拨从转出仓扣、拆卸单组合件出库、其他出库单扣库存；
 * 购货类 / 销货退货 / 盘点 / 成本调整 / 组装单（子件出库但通常库存充足）不入白名单，
 * 避免在草稿阶段拦截正常录入。
 */
const OUTBOUND_APIS = ['/kuerp/goods-sales', '/kuerp/allocation', '/kuerp/split', '/kuerp/warehouse'];

/** 是否有金额字段（调拨/盘点/成本调整/组装拆卸无） */
const hasMoney = shape === 'goods' || shape === 'order';
/** 是否需要批次/序列号列（订单类不涉及库存，不显示） */
const needBatch = computed(() => sets.value.batch === 1 && shape !== 'order' && shape !== 'adjust');
const needSerial = computed(() => sets.value.serial === 1 && shape !== 'order' && shape !== 'adjust');

// —— 列表状态 ——
const list = ref([]);
const loading = ref(false);
const query = reactive({ search: '' });
// 列表日期筛选：DsDatePicker 无 range 模式，拆为起止两个日期字符串
const startDate = ref('');
const endDate = ref('');

// —— 编辑器状态 ——
const dialog = ref(false);
const editing = ref(false);
const saving = ref(false);
const headCols = ref([]);       // 表头列元数据（/columns）
const infoCols = ref([]);       // 明细列元数据
const form = ref({});           // 表头表单
const rows = ref([]);           // 明细行
const originalInfoIds = ref([]); // 编辑时已有明细ID（保存前删除重建）
const options = ref({ customers: [], suppliers: [], warehouses: [], units: [] });
const sets = ref({ batch: 0, serial: 0, taxes: 0 });
const goodsFlags = ref({});     // goods_code -> {batch, serial}

// —— 采购/销售费用子表（对应 kuerp_cost，原系统 cost_data 字段）——
const costRows = ref([]);        // 费用行
const costTypeOptions = ref([]); // 费用类别下拉（支出类别）
/** 是否需要费用子表：购销退货类单据（含金额）才支持费用录入 */
const needCost = computed(() => shape === 'goods' || shape === 'order');
/** 费用子表标题（按单据类型区分采购/销售费用） */
const costTitle = computed(() =>
  (doc.shape === 'goods' || doc.shape === 'order') && counterparty === 'supplier'
    ? '采购费用'
    : '销售费用',
);
/** 费用行往来单位下拉：采购类取供应商，销售类取客户（原系统 suppliers_id 即费用承担单位） */
const costUnitOptions = computed(() =>
  counterparty === 'supplier' ? options.value.suppliers : options.value.customers,
);
/** 费用行往来单位显示名 */
const costUnitLabel = (s) =>
  s.supplyer_name || s.customer_name || s.name || s.supplyer_code || s.id;

// —— 商品选择 ——
const pickDialog = ref(false);
const pickKeyword = ref('');
const pickList = ref([]);

// —— 批次 ——
const batchDialog = ref(false);
const batchRow = ref(null);     // 当前编辑的明细行
const batchList = ref([]);
const batchStocks = ref({});    // batch_id -> stock（当前仓库）
const batchForm = reactive({ batch_name: '', manufacture: null, guarantee: 0, validity: null });

// —— 序列号 ——
const serialDialog = ref(false);
const serialRow = ref(null);
const serialText = ref('');

const counterpartyLabel = counterparty === 'supplier' ? '供应商' : counterparty === 'customer' ? '客户' : '往来单位';
const cpField = counterparty === 'supplier' ? 'supplyer_code' : 'customers_id';
const cpOptions = computed(() => (counterparty === 'supplier' ? options.value.suppliers : options.value.customers));
const cpLabel = (c) => c.supplyer_name || c.customer_name || c.name || c.supplyer_code || c.id;
const cpValue = (c) => (counterpartyById ? c.id : c.supplyer_code || c.id);

/** 金额格式化（¥ 两位小数） */
function money(v) {
  return '¥' + (Number(v) || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
/** 秒级时间戳 → 日期串 */
function fmtDate(v) {
  if (!v) return '-';
  const d = new Date(Number(v) * 1000);
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}
/** 是否已审核 */
function examined(row) {
  return Number(row.examine_status) === 1;
}
/** 列表往来单位名称 */
function counterpartyName(row) {
  if (counterparty === 'supplier') return row.supplyer_code || '-';
  if (counterparty === 'customer') {
    const c = options.value.customers.find((x) => x.id === Number(row.customers_id));
    return c ? cpLabel(c) : row.customers_id || '-';
  }
  return '-';
}

/**
 * 把 'YYYY-MM-DD' 日期串转为秒级时间戳。
 * @param d 日期串；end=true 时取当天 23:59:59
 * @returns 秒级时间戳，空串返回 null
 */
function dayTs(d, end = false) {
  if (!d) return null;
  const ms = new Date(`${d}T00:00:00`).getTime();
  if (Number.isNaN(ms)) return null;
  return Math.floor(ms / 1000) + (end ? 86399 : 0);
}

/**
 * 秒级时间戳 → DsDatePicker 需要的日期/时间字符串。
 * @param ts 秒级时间戳
 * @param withTime true=返回 'YYYY-MM-DD HH:mm'，false=仅 'YYYY-MM-DD'
 * @returns 日期字符串，空值返回 ''
 */
function tsToStr(ts, withTime = false) {
  const t = Number(ts);
  if (!t) return '';
  const d = new Date(t * 1000);
  const p = (n) => String(n).padStart(2, '0');
  const date = `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
  return withTime ? `${date} ${p(d.getHours())}:${p(d.getMinutes())}` : date;
}

/** 单据日期桥接：表头存秒级时间戳，日期控件用字符串 */
const purchaseTimeStr = computed({
  get: () => tsToStr(form.value?.purchase_time, true),
  set: (v) => {
    if (!v) { form.value.purchase_time = null; return; }
    const ms = new Date(String(v).replace(' ', 'T')).getTime();
    form.value.purchase_time = Number.isNaN(ms) ? null : Math.floor(ms / 1000);
  },
});

/** 批次生产日期桥接 */
const manufactureStr = computed({
  get: () => tsToStr(batchForm.manufacture),
  set: (v) => { batchForm.manufacture = dayTs(v); },
});

/** 批次有效期桥接 */
const validityStr = computed({
  get: () => tsToStr(batchForm.validity),
  set: (v) => { batchForm.validity = dayTs(v); },
});

// ————————————————————————————————————————————————
// 表格列定义（DsTable 以 columns 描述列；slot:true 表示用同名插槽渲染）
// ————————————————————————————————————————————————

/** 单据列表列（对单列/金额列按单据能力动态增删） */
const listCols = computed(() => {
  const c = [];
  if (hasCheckStatus.value) c.push({ key: '__sel', title: '', width: '46px', slot: true });
  c.push({ key: 'purchase_code', title: '单据编号', width: '180px' });
  c.push({ key: 'purchase_time', title: '单据日期', width: '110px', slot: true });
  if (counterparty) c.push({ key: '__cp', title: counterpartyLabel, width: '160px', slot: true });
  c.push({ key: 'number', title: '数量', width: '90px' });
  if (hasMoney) c.push({ key: 'money_tax_price', title: '价税合计', width: '120px', align: 'right', slot: true });
  else c.push({ key: 'money', title: '费用', width: '120px', align: 'right', slot: true });
  c.push({ key: '__examine', title: '审核状态', width: '100px', slot: true });
  if (hasCheckStatus.value) c.push({ key: '__check', title: '对单状态', width: '100px', slot: true });
  c.push({ key: '__op', title: '操作', width: '320px', align: 'right', slot: true });
  return c;
});

/** 明细子表列（按单据形态 shape / bom / 批次序列号开关动态组合） */
const rowCols = computed(() => {
  const c = [];
  if (bom) c.push({ key: 'type', title: '类型', width: '110px', slot: true });
  c.push({ key: '__goods', title: '商品', width: '170px', slot: true });
  if (shape === 'transfer') {
    c.push({ key: 'stores_out', title: '调出仓库', width: '140px', slot: true });
    c.push({ key: 'stores_enter', title: '调入仓库', width: '140px', slot: true });
  } else {
    c.push({ key: 'stores_id', title: '仓库', width: '140px', slot: true });
  }
  if (shape === 'stocktake') {
    c.push({ key: 'stock', title: '系统库存', width: '90px', align: 'right' });
    c.push({ key: 'invertory_stock', title: '盘点数量', width: '120px', slot: true });
    c.push({ key: 'profit', title: '盈亏', width: '90px', align: 'right', slot: true });
  }
  if (shape === 'adjust') c.push({ key: 'money', title: '调整金额', width: '120px', slot: true });
  if (shape !== 'adjust') {
    c.push({ key: 'goods_unit', title: '单位', width: '110px', slot: true });
    c.push({ key: 'number', title: '数量', width: '110px', slot: true });
  }
  if (bom) {
    c.push({ key: 'unit_cost', title: '单位成本', width: '120px', slot: true });
    c.push({ key: 'cost_money', title: '成本金额', width: '120px', slot: true });
  }
  if (hasMoney) {
    c.push({ key: 'unit_price', title: '单价', width: '110px', slot: true });
    c.push({ key: 'discount', title: '折扣%', width: '90px', slot: true });
    c.push({ key: 'tax_rate', title: '税率%', width: '90px', slot: true });
    c.push({ key: 'tax_included', title: '含税单价', width: '110px', slot: true });
    c.push({ key: 'all_money', title: '金额', width: '110px', align: 'right', slot: true });
    c.push({ key: 'money_tax_price', title: '价税合计', width: '110px', align: 'right', slot: true });
  }
  if (needBatch.value) c.push({ key: '__batch', title: '批次', width: '150px', slot: true });
  if (needSerial.value) c.push({ key: '__serial', title: '序列号', width: '140px', slot: true });
  c.push({ key: 'remark', title: '备注', width: '140px', slot: true });
  c.push({ key: '__del', title: '', width: '60px', align: 'center', slot: true });
  return c;
});

/** 采购/销售费用子表列 */
const costCols = [
  { key: 'suppliers_id', title: '往来单位', width: '180px', slot: true },
  { key: 'expend_type_id', title: '费用类别', width: '160px', slot: true },
  { key: 'money', title: '金额', width: '140px', slot: true },
  { key: 'remark', title: '备注', width: '180px', slot: true },
  { key: '__del', title: '', width: '80px', align: 'center', slot: true },
];

/** 商品选择弹窗列 */
const pickCols = [
  { key: 'goods_code', title: '编号', width: '130px' },
  { key: 'goods_name', title: '名称', width: '180px' },
  { key: 'purchase', title: '进价', width: '100px', align: 'right', slot: true },
  { key: 'market_sell_price', title: '零售价', width: '100px', align: 'right', slot: true },
  { key: 'batch', title: '批次', width: '70px', slot: true },
  { key: 'serial', title: '序列号', width: '80px', slot: true },
  { key: '__pick', title: '', width: '80px', align: 'center', slot: true },
];

/** 批次选择弹窗列 */
const batchCols = [
  { key: 'batch_name', title: '批次', width: '150px' },
  { key: 'manufacture', title: '生产日期', width: '120px', slot: true },
  { key: 'validity', title: '有效期至', width: '120px', slot: true },
  { key: '__stock', title: '批次库存', width: '100px', align: 'right', slot: true },
];

// ————————————————————————————————————————————————
// 下拉选项（DsSelect 以 options 数组代替内联 el-option）
// ————————————————————————————————————————————————

/** 仓库选项 */
const warehouseOptions = computed(() =>
  options.value.warehouses.map((w) => ({ value: w.id, label: w.name || w.code })),
);
/** 组装/拆卸明细「类型」选项 */
const bomTypeOptions = [
  { value: '1', label: '组合件' },
  { value: '2', label: '子件' },
];
/** 往来单位选项 */
const cpOptionItems = computed(() =>
  cpOptions.value.map((c) => ({ value: cpValue(c), label: cpLabel(c) })),
);
/** 费用往来单位选项 */
const costUnitOptionItems = computed(() =>
  costUnitOptions.value.map((s) => ({ value: s.id, label: costUnitLabel(s) })),
);
/** 费用类别选项 */
const costTypeOptionItems = computed(() =>
  costTypeOptions.value.map((t) => ({ value: t.id, label: t.name })),
);

/**
 * 明细行单位选项：基本单位 + 多单位换算副单位（行级动态，故用函数而非计算属性）。
 * @param row 明细行
 * @returns 选项数组
 */
function unitOptionsOf(row) {
  return (row._units || []).map((u) => ({ value: u.id, label: u.name }));
}

/**
 * 表头 enum 列选项：{ 值: 文案 } → [{ value, label }]。
 * @param col 列元数据
 * @returns 选项数组
 */
function enumOptions(col) {
  if (col.enum && Object.keys(col.enum).length) {
    return Object.entries(col.enum).map(([value, label]) => ({ value: String(value), label: String(label) }));
  }
  return col.enumOpts || [];
}

// ————————————————————————————————————————————————
// 行操作（DsTable 无内置多选/索引插槽，改为受控实现）
// ————————————————————————————————————————————————

/** 该行是否已勾选 */
function isSelected(row) {
  return selected.value.some((r) => r.id === row.id);
}

/** 勾选/取消勾选一行（selected 存整行对象，供批量对单取 id） */
function toggleSel(row, on) {
  selected.value = on
    ? [...selected.value, row]
    : selected.value.filter((r) => r.id !== row.id);
}

/** 删除一行明细 */
function removeRow(row) {
  rows.value = rows.value.filter((r) => r !== row);
}

/** 删除一行费用 */
function removeCostRow(row) {
  costRows.value = costRows.value.filter((r) => r !== row);
}
const HEAD_SKIP = new Set([
  'id', 'admin_id', 'createtime', 'updatetime', 'deletetime',
  'purchase_code', 'purchase_type', 'purchase_time',
  'examine_status', 'examine_id', 'examine_time', 'operation_id', 'preparation_id', 'print_num',
  'number', 'all_money', 'tax_money', 'money_tax_price', 'real_money', 'arrears',
  'pay_money', 'pay_status', 'preferential_money', 'preferential_rate', 'dis_money',
  'supplyer_code', 'customers_id', 'remarks', 'remark', 'note',
  'cost_data', // 采购/销售费用：由专用子表维护，不自动渲染为输入框
]);
const headFields = computed(() =>
  headCols.value
    .filter((c) => !HEAD_SKIP.has(c.name))
    .map((c) => {
      // label 走 fieldLabel（注释优先 + 中文字典兜底），避免出现裸英文/枚举长注释；
      // 枚举注释（「单据类型:1=盘点,2=序列号盘点」）解析成下拉选项，值显示中文
      const { options } = parseComment(c.comment);
      return { ...c, label: fieldLabel(c.name, c.comment), enumOpts: options || [] };
    }),
);

// —— 对单（等价原系统 counter）：仅 4 个购销单据表有 check_status 列 ——
const selected = ref([]);
/** 当前单据表是否支持对单（表头元数据含 check_status） */
const hasCheckStatus = computed(() => headCols.value.some((c) => c.name === 'check_status'));
/** 行是否已对单（check_status 为 enum，回传可能是 '1' 或 1） */
const isChecked = (row) => String(row.check_status ?? '0') === '1';

/**
 * 批量对单/反对单（原系统列表工具栏按钮）。
 * @param status 1=对单（原系统 counter=1）、2=反对单（原系统 counter=2）
 */
async function counterSelected(status) {
  if (!selected.value.length) {
    message.warning('请先勾选单据');
    return;
  }
  await doCounter(
    selected.value.map((r) => r.id),
    status,
  );
}

/** 单行对单/反对单 */
async function counterRow(row, status) {
  await doCounter([row.id], status);
}

/**
 * 调用对单接口并刷新列表。
 * @param ids 主键数组
 * @param status 1=对单、2=反对单
 */
async function doCounter(ids, status) {
  const act = status === 1 ? '对单' : '反对单';
  await confirm(`确定${act}选中的 ${ids.length} 条单据？`, '提示', { type: 'warning' });
  await request.post(`${api}/counter`, { ids, counter: status });
  message.success(`${act}成功`);
  await loadList();
}

/** 明细合计 */
const totals = computed(() => {
  const t = { number: 0, all_money: 0, tax_money: 0, money_tax_price: 0, cost_money: 0 };
  for (const r of rows.value) {
    t.number += Number(r.number) || 0;
    t.all_money += Number(r.all_money) || 0;
    t.tax_money += Number(r.tax_money) || 0;
    t.money_tax_price += Number(r.money_tax_price) || 0;
    t.cost_money += Number(r.cost_money) || 0;
  }
  return t;
});

// ============================================================
// 数据加载
// ============================================================

/** 加载单据列表（关键字 + 日期范围） */
async function loadList() {
  loading.value = true;
  try {
    const params = { limit: 500 };
    if (query.search) params.search = query.search;
    const start = dayTs(startDate.value);
    const end = dayTs(endDate.value, true);
    if (start || end) {
      params.dateField = 'purchase_time';
      if (start) params.starttime = start;
      if (end) params.endtime = end;
    }
    const r = await request.get(`${api}/index`, { params });
    list.value = r?.list || [];
  } finally {
    loading.value = false;
  }
}

/** 加载下拉选项（往来单位/仓库/单位）与系统参数 */
async function loadOptions() {
  const jobs = [];
  if (counterparty === 'customer') jobs.push(['customers', '/kuerp/customers/index']);
  if (counterparty === 'supplier') jobs.push(['suppliers', '/kuerp/suppliers/index']);
  jobs.push(['warehouses', '/kuerp/stores/index']);
  jobs.push(['units', '/kuerp/unit/index']);
  // 费用类别（支出类别）：采购销售费用清单的费用分类来源
  jobs.push(['costTypes', '/kuerp/expend-type/index']);
  const res = await Promise.all(jobs.map(([, url]) => request.get(url, { params: { limit: 500 } })));
  jobs.forEach(([key], i) => {
    options.value[key] = res[i]?.list || [];
  });
  costTypeOptions.value = options.value.costTypes || [];
  // 系统参数：批次/序列号/税金开关
  const s = await request.get('/kuerp/sets/index', { params: { limit: 500 } });
  const map = {};
  (s?.list || []).forEach((x) => (map[x.name] = Number(x.is_checked) === 1 ? 1 : 0));
  sets.value = { batch: map.batch || 0, serial: map.serial || 0, taxes: map.taxes || 0 };
}

/** 加载表头/明细列元数据 */
async function loadColumns() {
  const [h, i] = await Promise.all([
    request.get(`${api}/columns`),
    request.get(`${infoApi}/columns`),
  ]);
  headCols.value = h?.columns || h || [];
  infoCols.value = i?.columns || i || [];
}

onMounted(async () => {
  await Promise.all([loadOptions(), loadColumns()]);
  await loadList();
});

// ============================================================
// 明细行：金额公式（与原系统 formatInfo2 一致）
// ============================================================

/** 明细/费用行的本地唯一键计数器（DsTable 的 rowKey 用） */
let uid = 0;

/** 新建一行空明细 */
function blankRow() {
  return {
    _k: `r${++uid}`,
    goods_code: '', goods_name: '', goods_id: 0, goods_attr: 0, goods_unit: 0, stores_id: null,
    number: 1, basic_nmber: 1, unit_price: 0, tax_included: 0, discount: 0,
    dis_money: 0, all_money: 0, tax_rate: 0, tax_money: 0, money_tax_price: 0,
    batch_id: 0, batch_name: '', manufacture: 0, guarantee: 0, validity: 0,
    period: '', _serials: [], _units: [], _rate: 1,
    remark: '',
    // 盘点专用
    stock: 0, invertory_stock: 0, profit: 0,
    // 成本调整专用
    money: 0,
    // 调拨专用
    stores_out: null, stores_enter: null,
    // 组装/拆卸专用：type=1组合件 / 2子件，unit_cost 单位成本、cost_money 成本金额
    type: '2', unit_cost: 0, cost_money: 0, allow_stock: 0,
  };
}
function addBlankRow() {
  rows.value.push(blankRow());
}

/**
 * 明细行金额重算（原系统 formatInfo2 的公式，1:1 还原）：
 *   价税合计(未折) = 含税单价 × 数量
 *   折扣额        = 价税合计(未折) / (100+税率) × 折扣率
 *   价税合计       = 价税合计(未折) × (100-折扣率) / 100
 *   金额          = 价税合计 × 100 / (100+税率)
 *   税额          = 金额 × 税率 / 100
 * 单价与含税单价互为换算：unit_price = tax_included × 100 / (100+税率)
 * 未启用税金时：税率/税额为 0，含税单价=单价，价税合计=金额。
 * @param row 明细行
 * @param field 触发字段（number/unit_price/tax_included/tax_rate/discount）
 */
function calcRow(row, field) {
  const rate = Number(row.tax_rate) || 0;
  const discount = Number(row.discount) || 0;
  const number = Number(row.number) || 0;
  if (field === 'unit_price') {
    row.tax_included = sets.value.taxes === 1 ? r2((Number(row.unit_price) * (100 + rate)) / 100) : Number(row.unit_price);
  } else if (field === 'tax_included') {
    row.unit_price = sets.value.taxes === 1 ? r2((Number(row.tax_included) * 100) / (100 + rate)) : Number(row.tax_included);
  }
  const taxIncluded = Number(row.tax_included) || 0;
  // 基本数量 = 数量 × 单位换算率（组装/拆卸明细列名为 basic_number，无 m 拼写）
  row.basic_nmber = r2(number * (row._rate || 1));
  row.basic_number = row.basic_nmber;
  if (sets.value.taxes !== 1) {
    // 未启用税金：价税合计=金额
    const gross = r2(taxIncluded * number);
    row.dis_money = r2((gross * discount) / 100);
    row.all_money = r2(gross - row.dis_money);
    row.money_tax_price = row.all_money;
    row.tax_money = 0;
    return;
  }
  const gross = r2(taxIncluded * number);
  row.dis_money = r2((gross / (100 + rate)) * discount);
  row.money_tax_price = r2(gross - (gross * discount) / 100);
  row.all_money = r2((row.money_tax_price * 100) / (100 + rate));
  row.tax_money = r2((row.all_money * rate) / 100);
}
/** 四舍五入 2 位 */
function r2(v) {
  return Math.round((Number(v) || 0) * 100) / 100;
}

/**
 * 组装/拆卸明细行成本重算（改单位成本 → 成本金额）。
 * 成本金额 = 单位成本 × 基本数量。
 * @param row 明细行
 */
function calcCost(row) {
  row.basic_nmber = r2((Number(row.number) || 0) * (row._rate || 1));
  row.basic_number = row.basic_nmber;
  row.cost_money = r2((Number(row.unit_cost) || 0) * row.basic_number);
}

/**
 * 组装/拆卸明细行单价反算（改成本金额 → 单位成本）。
 * @param row 明细行
 */
function calcUnitCost(row) {
  row.basic_nmber = r2((Number(row.number) || 0) * (row._rate || 1));
  row.basic_number = row.basic_nmber;
  row.unit_cost = row.basic_number ? r2((Number(row.cost_money) || 0) / row.basic_number) : 0;
}

// ============================================================
// 商品选择
// ============================================================

/** 检索商品 */
async function searchGoods() {
  const params = { limit: 50 };
  if (pickKeyword.value) params.search = pickKeyword.value;
  const r = await request.get('/kuerp/goods/index', { params });
  pickList.value = r?.list || [];
}

/** 选用商品：带出属性/单位/默认价，并初始化批次序列号标记 */
async function pickGoods(g) {
  const row = blankRow();
  row.goods_code = g.goods_code;
  row.goods_name = g.goods_name;
  row.goods_id = g.id;
  row.goods_unit = g.unit_id;
  row.stores_id = form.value.stores_id || null;
  row.unit_price = Number(priceBase === 'sell' ? g.market_sell_price : g.purchase) || 0;
  row.tax_included = row.unit_price;
  goodsFlags.value[g.goods_code] = { batch: Number(g.batch) === 1, serial: Number(g.serial) === 1 };
  // 盘点单：带出该系统库存
  if (shape === 'stocktake' && row.stores_id) {
    try {
      const st = await request.get('/kuerp/goods-stock/index', {
        params: { filter: JSON.stringify({ goods_code: g.goods_code, stores_id: row.stores_id }), limit: 1 },
      });
      row.stock = Number(st?.list?.[0]?.stock) || 0;
      row.invertory_stock = row.stock;
      calcProfit(row);
    } catch { /* 库存查询失败时按 0 处理 */ }
  }
  // 单位列表：基本单位 + 多单位换算（unit_conversion.advance_rate）
  row._units = [{ id: g.unit_id, name: '基本单位', rate: 1 }];
  if (Number(g.more_unit) === 1) {
    try {
      const uc = await request.get('/kuerp/unit-conversion/index', {
        params: { filter: JSON.stringify({ main_unit: g.unit_id }), limit: 100 },
      });
      const unitName = (id) => {
        const u = options.value.units.find((x) => x.id === id);
        return u ? u.name || u.code : String(id);
      };
      (uc?.list || []).forEach((c) => {
        row._units.push({ id: c.vice_unit, name: unitName(c.vice_unit), rate: Number(c.advance_rate) || 1 });
      });
    } catch { /* 单位换算缺失时仅用基本单位 */ }
  }
  calcRow(row, 'unit_price');
  // 组装/拆卸：默认按商品进价带出单位成本与成本金额
  if (bom) {
    row.unit_cost = Number(g.purchase) || 0;
    calcCost(row);
  }
  rows.value.push(row);
  pickDialog.value = false;
}

/** 切换单位：重算基本数量 */
function onUnitChange(row) {
  const u = row._units.find((x) => x.id === row.goods_unit);
  row._rate = u ? u.rate : 1;
  calcRow(row, 'number');
}

// ============================================================
// 批次选择 / 新建
// ============================================================

/** 打开批次选择：拉取该商品的批次主数据与当前仓库批次库存 */
async function openBatch(row) {
  batchRow.value = row;
  const goodsId = await goodsIdOf(row.goods_code);
  const r = await request.get('/kuerp/goods-batch/index', {
    params: { filter: JSON.stringify({ goods_id: goodsId }), limit: 200 },
  });
  batchList.value = r?.list || [];
  batchStocks.value = {};
  for (const b of batchList.value) {
    if (row.stores_id) {
      const st = await request.get('/kuerp/goods-batch-stock/index', {
        params: { filter: JSON.stringify({ batch_id: b.id, stores_id: row.stores_id }), limit: 1 },
      });
      batchStocks.value[b.id] = st?.list?.[0]?.stock || 0;
    }
  }
  batchForm.batch_name = '';
  batchForm.manufacture = null;
  batchForm.guarantee = 0;
  batchForm.validity = null;
  batchDialog.value = true;
}
/** 批次库存展示 */
function batchStockOf(b) {
  return batchStocks.value[b.id] ?? '-';
}

/** 选用已有批次 */
function chooseBatch(b) {
  if (!batchRow.value || !b) return;
  batchRow.value.batch_id = b.id;
  batchRow.value.batch_name = b.batch_name;
  batchRow.value.manufacture = b.manufacture;
  batchRow.value.guarantee = b.guarantee;
  batchRow.value.validity = b.validity;
  batchDialog.value = false;
}

/** 新建批次主数据并选用（对应原系统 add() 中的批次 find-or-create） */
async function createBatch() {
  if (!batchForm.batch_name) {
    message.warning('请输入批次名称');
    return;
  }
  const row = batchRow.value;
  const goodsId = await goodsIdOf(row.goods_code);
  const payload = {
    goods_id: goodsId,
    goods_code: row.goods_code,
    attribute_id: Number(row.goods_attr) || 0,
    stores_id: row.stores_id || 0,
    batch_name: batchForm.batch_name,
    manufacture: batchForm.manufacture || null,
    guarantee: batchForm.guarantee || null,
    validity: batchForm.validity || null,
  };
  const res = await request.post('/kuerp/goods-batch/add', payload);
  const id = res?.data?.id;
  if (!id) {
    message.error('批次创建失败');
    return;
  }
  row.batch_id = id;
  row.batch_name = batchForm.batch_name;
  row.manufacture = payload.manufacture;
  row.guarantee = payload.guarantee;
  row.validity = payload.validity;
  message.success('批次已创建');
  batchDialog.value = false;
}

// ============================================================
// 序列号录入
// ============================================================

/** 打开序列号录入 */
function openSerial(row) {
  serialRow.value = row;
  serialText.value = (row._serials || []).join('\n');
  serialDialog.value = true;
}

/** 确认序列号：写回行（period 存 JSON，与原系统序列化字段兼容） */
function confirmSerial() {
  const arr = serialText.value
    .split('\n')
    .map((s) => s.trim())
    .filter(Boolean);
  if (!arr.length) {
    message.warning('请输入至少一个序列号');
    return;
  }
  if (new Set(arr).size !== arr.length) {
    message.warning('序列号重复');
    return;
  }
  serialRow.value._serials = arr;
  serialRow.value.period = JSON.stringify(arr.map((s) => ({ serial: s, remark: '' })));
  serialDialog.value = false;
}

// ============================================================
// 保存 / 审核 / 删除
// ============================================================

/** 生成单据号：前缀 + 年月日时分秒 */
/**
 * 生成单据号：优先按「单号设置」规则生成（kuerp_prefix，与原系统 Thirds::getCodes
 * 口径一致：前缀 + 日期段 + 流水号，服务端自动查重递增）；
 * 规则未配置或请求失败时回退本地时间戳生成，保证离线可用。
 * @returns {Promise<string>} 单据编号
 */
async function genCode() {
  try {
    // 落库表名：/kuerp/goods-purchase → kuerp_goods_purchase
    const db = api.replace(/^\/kuerp\//, '').replace(/-/g, '_');
    const r = await request.get('/kuerp/prefix/gen-code', {
      params: { dbname: db, field: 'purchase_code' },
    });
    if (r?.code) return r.code;
  } catch { /* 规则未配置时回退本地生成 */ }
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  return `${prefix}${d.getFullYear()}${p(d.getMonth() + 1)}${p(d.getDate())}${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
}

/** 商品编号 → 商品ID（批次主数据关联用） */
async function goodsIdOf(code) {
  const r = await request.get('/kuerp/goods/index', { params: { search: code, limit: 1 } });
  return r?.list?.[0]?.id || 0;
}

/** 保存前校验 */
function validate() {
  if (!rows.value.length) {
    message.warning('请添加明细行');
    return false;
  }
  for (const [i, r] of rows.value.entries()) {
    if (!r.goods_code) {
      message.warning(`第 ${i + 1} 行未选择商品`);
      return false;
    }
    if (shape === 'transfer') {
      if (!r.stores_out || !r.stores_enter) {
        message.warning(`第 ${i + 1} 行请选择调出/调入仓库`);
        return false;
      }
    } else if (!r.stores_id) {
      message.warning(`第 ${i + 1} 行请选择仓库`);
      return false;
    }
    if (shape !== 'adjust' && !(Number(r.number) > 0)) {
      message.warning(`第 ${i + 1} 行数量必须大于 0`);
      return false;
    }
    // 批次管理商品必须选批次（对应原系统 add() 校验）
    const gf = goodsFlags.value[r.goods_code];
    if (needBatch.value && gf?.batch && !r.batch_id) {
      message.warning(`商品 ${r.goods_code} 启用批次管理，请选择生产批次`);
      return false;
    }
    if (needSerial.value && gf?.serial && !(r._serials || []).length) {
      message.warning(`商品 ${r.goods_code} 启用序列号管理，请录入序列号`);
      return false;
    }
  }
  // 组装/拆卸：必须同时存在组合件与子件（原系统校验：组合件/组合子件信息不能为空）
  if (bom) {
    if (!rows.value.some((r) => String(r.type) === '1')) {
      message.warning('组合件信息不能为空');
      return false;
    }
    if (!rows.value.some((r) => String(r.type) === '2')) {
      message.warning('组合子件信息不能为空');
      return false;
    }
  }
  return true;
}

/**
 * 保存单据：表头 + 明细两步写入（与原系统 add/edit 语义一致）。
 * 表头汇总数量/金额/价税合计；编辑模式先删除旧明细再重建。
 *
 * 保存前先做「出库库存校验」（等价原系统 checkPurchase/checkExchange）：
 * 仅对出库类单据（销货单 / 调拨单 / 拆卸单 / 其他出库单）校验，
 * 库存不足时二次确认，允许用户继续保存草稿（审核过账时仍会强校验）。
 */
async function save() {
  if (!validate()) return;
  // 出库库存预校验（不足时二次确认）
  if (OUTBOUND_APIS.includes(api)) {
    try {
      const r = await request.post('/kuerp/stock/check', {
        lines: rows.value
          .filter((x) => x.goods_code)
          .map((x) => ({
            goods_code: x.goods_code,
            goods_unit: x.goods_unit,
            goods_attr: x.goods_attr || null,
            stores_id: Number(x.stores_out) || Number(x.stores_id) || null,
            number: Number(x.number) || 0,
          })),
      });
      if (r && r.ok === false) {
        const tip = (r.list || [])
          .slice(0, 5)
          .map((x) => `${x.goods_code}（需 ${x.need}，库存 ${x.stock}）`)
          .join('、');
        await confirm({
          title: '库存不足',
          type: 'warning',
          message: `以下商品库存不足：${tip}。仍要继续保存吗？（审核过账时仍会校验库存）`,
        });
      }
    } catch (e) {
      // 用户取消：不保存
      if (String(e?.message || '') === 'user-cancelled') return;
      // 其他异常（如接口不可用）不阻塞保存
    }
  }
  saving.value = true;
  const now = Math.floor(Date.now() / 1000);
  try {
    // 1) 表头
    const head = { ...form.value };
    head.purchase_code = editing.value ? form.value.purchase_code : await genCode();
    head.purchase_time = form.value.purchase_time || now;
    head.number = totals.value.number;
    if (hasMoney.value) {
      head.all_money = r2(totals.value.all_money);
      head.tax_money = r2(totals.value.tax_money);
      head.money_tax_price = r2(totals.value.money_tax_price);
      head.real_money = r2(totals.value.money_tax_price);
      head.arrears = r2(totals.value.money_tax_price - (Number(head.pay_money) || 0));
    }
    // 费用行序列化为 JSON 存入表头 cost_data（后端审核时写入 kuerp_cost）
    head.cost_data = needCost.value ? JSON.stringify(costRows.value.map(costPayload)) : null;
    let headId = form.value.id;
    if (editing.value) {
      await request.post(`${api}/edit`, { ...head, id: headId });
    } else {
      const res = await request.post(`${api}/add`, head);
      headId = res?.insertId;
      if (!headId) {
        // 兜底：按单据号反查
        const q = await request.get(`${api}/index`, { params: { search: head.purchase_code, limit: 1 } });
        headId = q?.list?.[0]?.id;
      }
    }
    // 2) 明细：编辑模式先删旧行
    if (editing.value && originalInfoIds.value.length) {
      await request.post(`${infoApi}/del`, { ids: originalInfoIds.value.slice() });
    }
    for (const r of rows.value) {
      await request.post(`${infoApi}/add`, buildInfoRow(r, head.purchase_code, headId));
    }
    message.success('保存成功');
    dialog.value = false;
    await loadList();
  } catch (e) {
    message.error('保存失败：' + (e?.message || '接口错误'));
  } finally {
    saving.value = false;
  }
}

/** 组装明细行入库字段（按单据形态差异化） */
function buildInfoRow(r, code, headId) {
  const base = {
    purchase_code: code,
    purchase_time: form.value.purchase_time,
    goods_code: r.goods_code,
    goods_id: undefined,
    goods_attr: Number(r.goods_attr) || 0,
    goods_unit: r.goods_unit,
    stores_id: r.stores_id,
    remark: r.remark || '',
  };
  if (byId) base.allocation_id = headId; // 调拨单按表头主键关联
  if (shape === 'transfer') {
    return {
      ...base,
      stores_out: r.stores_out,
      stores_enter: r.stores_enter,
      number: r.number,
      goods_batch_id: r.batch_id || null,
      goods_batch_name: r.batch_name || null,
      goods_serial_id: (r._serials || []).join(','),
      remarks: r.remark || '',
    };
  }
  if (shape === 'stocktake') {
    return {
      purchase_code: code,
      purchase_time: form.value.purchase_time,
      goods_id: r.goods_id || undefined,
      stores_id: r.stores_id,
      goods_attr: Number(r.goods_attr) || 0,
      stock: r.stock,
      invertory_stock: r.invertory_stock,
      profit: r.profit,
    };
  }
  if (shape === 'adjust') {
    return {
      purchase_code: code,
      purchase_time: form.value.purchase_time,
      goods_id: r.goods_id || undefined,
      goods_unit: r.goods_unit,
      stores_id: r.stores_id,
      money: r.money,
      remark: r.remark || '',
    };
  }
  // 组装单 / 拆卸单：type=1 组合件、type=2 子件；cost_money 为该行成本
  if (bom) {
    return {
      purchase_code: code,
      purchase_time: form.value.purchase_time,
      business_type: '1',
      type: String(r.type || '2'),
      goods_id: r.goods_id || undefined,
      goods_code: r.goods_code,
      goods_attr: Number(r.goods_attr) || 0,
      goods_unit: r.goods_unit,
      stores_id: r.stores_id,
      allow_stock: Number(r.allow_stock) || 0,
      number: r.number,
      basic_number: r.basic_number || r.basic_nmber || r.number,
      unit_cost: r.unit_cost,
      cost_money: r.cost_money,
      batch_id: r.batch_id || null,
      batch: r.batch_name || null,
      manufacture: r.manufacture || null,
      guarantee: r.guarantee || null,
      validity: r.validity || null,
      period: r.period || null,
      remark: r.remark || '',
    };
  }
  // goods / order：完整金额字段
  return {
    ...base,
    number: r.number,
    basic_nmber: r.basic_nmber,
    unit_price: r.unit_price,
    discount: r.discount,
    dis_money: r.dis_money,
    all_money: r.all_money,
    tax_included: r.tax_included,
    tax_rate: r.tax_rate,
    tax_money: r.tax_money,
    money_tax_price: r.money_tax_price,
    batch_id: r.batch_id || null,
    batch_name: r.batch_name || null,
    manufacture: r.manufacture || null,
    guarantee: r.guarantee || null,
    validity: r.validity || null,
    period: r.period || null,
  };
}

/** 盘点行：盈亏 = 盘点数量 - 系统库存 */
function calcProfit(row) {
  row.profit = r2((Number(row.invertory_stock) || 0) - (Number(row.stock) || 0));
}

/** 审核/反审（触发后端过账/冲转） */
async function examine(row, status) {
  const act = status === 1 ? '审核' : '反审';
  try {
    await confirm({ title: '提示', message: `确定${act}单据 ${row.purchase_code}？`, type: 'warning' });
  } catch {
    return; // 用户取消
  }
  await request.post(`${api}/examine`, { id: row.id, status });
  message.success(`${act}成功`);
  await loadList();
}

/** 删除单据（未审核） */
async function remove(row) {
  try {
    await confirm({ title: '提示', message: `确定删除单据 ${row.purchase_code}？`, type: 'warning' });
  } catch {
    return; // 用户取消
  }
  await request.post(`${api}/del`, { id: row.id });
  message.success('删除成功');
  await loadList();
}

// ============================================================
// 多级审批（审批流配置见 kuerp_approval_flow，末级通过才真正过账）
// ============================================================

/** 审批面板可见性 */
const approvalVisible = ref(false);
/** 审批面板当前单据ID */
const approvalDocId = ref(0);
/** 审批面板当前单据编号 */
const approvalDocCode = ref('');
/**
 * 审批面板使用的单据表名：
 * 直接取路由 api（/kuerp/goods-purchase），后端会自行归一化为 goods_purchase，
 * 避免前端再维护一份「路由 → 物理表」的映射。
 */
const approvalTable = computed(() => String(route.meta.api || '').replace(/^\/kuerp\//, ''));

/**
 * 打开审批进度面板。
 * @param row 单据行
 */
function openApproval(row) {
  approvalDocId.value = Number(row.id) || 0;
  approvalDocCode.value = row.purchase_code || '';
  approvalVisible.value = true;
}

/**
 * 提交多级审批。
 *
 * 若该单据类型未配置审批流（或金额不落在任何区间），后端返回 needApproval=false，
 * 此时提示用户可直接点「审核」——保持旧行为，不让审批成为必须步骤。
 *
 * @param row 单据行
 */
async function submitApproval(row) {
  try {
    await confirm({ title: '提示', message: `确定提交单据 ${row.purchase_code} 审批？`, type: 'info' });
  } catch {
    return; // 用户取消
  }
  try {
    const r = await request.post('/kuerp/approval/submit', {
      doc_table: approvalTable.value,
      doc_id: row.id,
    });
    if (r?.needApproval) {
      message.success('已提交审批，请在「系统设置 → 审批待办」处理');
      await loadList();
    } else {
      message.info('该单据类型未配置审批流，可直接点「审核」完成过账');
    }
  } catch {
    // 错误提示由 request 拦截器统一弹出
  }
}

// ============================================================
// 编辑器打开 / 重置
// ============================================================

// ============================================================
// AI 智能录入：自然语言 → 结构化单据草稿（复用 /ai/structured + pickGoods 商品带出）
// ============================================================

/** AI 录入弹窗可见性 */
const aiDraftVisible = ref(false);
/** AI 录入文本 */
const aiText = ref('');
/** AI 生成中 */
const aiDrafting = ref(false);

/** 打开 AI 录入对话框 */
function openAiDraft() {
  aiText.value = '';
  aiDraftVisible.value = true;
}

/** 商品名称 → 商品对象（取首个匹配，用于带出价格/单位/批次） */
async function resolveGoods(name) {
  if (!name) return null;
  try {
    const r = await request.get('/kuerp/goods/index', { params: { search: name, limit: 10 } });
    const list = r?.list || [];
    return list.find((g) => g.goods_name === name) || list[0] || null;
  } catch {
    return null;
  }
}

/** 往来单位名称 → 编号/ID（按当前单据 counterparty 类型从下拉选项里模糊匹配） */
function resolveCpName(name) {
  if (!counterparty || !name) return null;
  const hit = cpOptions.value.find((c) => {
    const n = c.supplyer_name || c.customer_name || c.name || c.supplyer_code || '';
    return n && (n === name || n.includes(name) || name.includes(n));
  });
  return hit ? cpValue(hit) : null;
}

/**
 * 生成草稿：调 /ai/structured 解析自然语言 → 预填表头（往来单位/备注）→ 逐条解析商品并复用 pickGoods 加入明细。
 * 仓库等信息仍需用户在编辑器里确认/选择后保存。
 */
async function generateAiDraft() {
  const text = aiText.value.trim();
  if (!text) {
    message.warning('请描述开单需求');
    return;
  }
  aiDrafting.value = true;
  try {
    const docType =
      counterparty === 'supplier' ? '采购类单据' : counterparty === 'customer' ? '销售类单据' : '出入库单据';
    const r = await request.post('/ai/structured', {
      message: `请据此生成一张${docType}的草稿：${text}`,
      system:
        '你是进销存系统的单据录入助手。把用户用自然语言描述的开单需求解析为结构化草稿。' +
        '商品名称尽量贴近真实商品名；数量为数字；单价可空；无法识别的往来单位填空字符串。只返回 JSON。',
      schema: {
        counterparty: '往来单位名称（供应商或客户名，无法识别填空字符串）',
        remark: '单据备注',
        rows: [{ goods_name: '商品名称', number: '数量(数字)', unit_price: '单价(数字,可空)' }],
      },
    });
    const draft = r?.data || r || {};
    const rowsData = Array.isArray(draft.rows) ? draft.rows : [];
    if (!rowsData.length) {
      message.warning('AI 未解析出商品明细，请补充描述（如商品名称、数量）');
      return;
    }
    // 预填表头（与 openAdd 保持一致的默认字段）
    editing.value = false;
    const f = { purchase_code: '', purchase_time: Math.floor(Date.now() / 1000), purchase_type: '1' };
    const cp = resolveCpName(draft.counterparty);
    f[cpField] = cp != null ? cp : counterpartyById ? null : '';
    if (draft.remark) f.remark = draft.remark;
    form.value = f;
    rows.value = [];
    originalInfoIds.value = [];
    costRows.value = [];
    // 逐条解析商品并加入明细（复用 pickGoods 的商品带出逻辑）
    for (const rd of rowsData) {
      const g = await resolveGoods(rd.goods_name);
      if (!g) {
        message.warning(`未找到商品：${rd.goods_name}`);
        continue;
      }
      await pickGoods(g);
      const row = rows.value[rows.value.length - 1];
      if (rd.number) {
        row.number = Number(rd.number) || 1;
        calcRow(row, 'number');
      }
      if (rd.unit_price != null) {
        row.unit_price = Number(rd.unit_price) || 0;
        row.tax_included = row.unit_price;
        calcRow(row, 'unit_price');
      }
    }
    aiDraftVisible.value = false;
    dialog.value = true;
    message.success('已生成草稿，请核对仓库等信息后保存');
  } catch (e) {
    message.error('AI 生成失败：' + (e?.response?.data?.msg || e.message || e));
  } finally {
    aiDrafting.value = false;
  }
}

/** 新增：空表头 + 空明细 */
function openAdd() {
  editing.value = false;
  form.value = {
    purchase_code: '',
    purchase_time: Math.floor(Date.now() / 1000),
    purchase_type: '1',
    [cpField]: counterpartyById ? null : '',
  };
  rows.value = [];
  originalInfoIds.value = [];
  costRows.value = [];
  dialog.value = true;
}

/** 新增一行费用（默认带出单据的往来单位，与原系统表单默认值一致） */
function addCostRow() {
  costRows.value.push({
    _k: `c${++uid}`,
    suppliers_id: null,
    expend_type_id: null,
    money: 0,
    remark: '',
  });
}

/** 费用行序列化：仅保留后端 kuerp_cost 需要的字段 */
function costPayload(c) {
  return {
    suppliers_id: c.suppliers_id ? Number(c.suppliers_id) : null,
    expend_type_id: c.expend_type_id ? Number(c.expend_type_id) : null,
    money: Number(c.money) || 0,
    remark: c.remark || '',
  };
}

/** 编辑：回填表头与明细（明细按单据编号/主键拉取） */
async function openEdit(row) {
  editing.value = true;
  const head = await request.get(`${api}/get`, { params: { id: row.id } });
  form.value = { ...(head || row) };
  // 明细
  const infoParams = { limit: 500 };
  if (byId) infoParams.filter = JSON.stringify({ allocation_id: row.id });
  else infoParams.filter = JSON.stringify({ purchase_code: row.purchase_code });
  const ir = await request.get(`${infoApi}/index`, { params: infoParams });
  const infoRows = ir?.list || [];
  originalInfoIds.value = infoRows.map((x) => x.id);
  rows.value = infoRows.map((x) => {
    const r = blankRow();
    Object.assign(r, x);
    // 反填运行时字段
    r._serials = parseSerials(x.period || x.goods_serial_id);
    r._units = [{ id: x.goods_unit, name: '单位', rate: 1 }];
    r.stock = x.stock || 0;
    r.invertory_stock = x.invertory_stock || 0;
    r.profit = x.profit || 0;
    if (x.goods_code) goodsFlags.value[x.goods_code] = goodsFlags.value[x.goods_code] || { batch: 0, serial: 0 };
    return r;
  });
  // 费用行回填（表头 cost_data 为 JSON 字符串）
  costRows.value = parseCostData(head?.cost_data);
  dialog.value = true;
}

/** 解析表头已存费用行（JSON 字符串 → 数组） */
function parseCostData(raw) {
  if (!raw) return [];
  const s = String(raw).trim();
  if (!s.startsWith('[')) return [];
  try {
    const arr = JSON.parse(s);
    return (Array.isArray(arr) ? arr : []).map((x) => ({
      _k: `c${++uid}`,
      id: x.id,
      suppliers_id: x.suppliers_id ? Number(x.suppliers_id) : null,
      expend_type_id: x.expend_type_id ? Number(x.expend_type_id) : null,
      money: Number(x.money) || 0,
      remark: x.remark || '',
    }));
  } catch {
    return [];
  }
}

/** 解析已存序列号（JSON 或逗号分隔） */
function parseSerials(raw) {
  if (!raw) return [];
  const s = String(raw).trim();
  if (s.startsWith('[')) {
    try {
      const arr = JSON.parse(s);
      return (Array.isArray(arr) ? arr : [arr]).map((x) => (typeof x === 'string' ? x : x.serial)).filter(Boolean);
    } catch {
      /* 落到逗号解析 */
    }
  }
  return s.split(',').map((x) => x.trim()).filter(Boolean);
}

// ============================================================
// 组装单 / 拆卸单模板（1:1 还原原系统 savetemp / gettemp）
// ============================================================

/** 模板接口基址：/kuerp/assemble 或 /kuerp/split */
const tempBase = computed(() => `/kuerp/${bom === 'split' ? 'split' : 'assemble'}`);

/** 模板列表列定义 */
const tempCols = [
  { key: 'temp_name', title: '模板名称', width: '200px' },
  { key: 'purchase_code', title: '单据编号', width: '160px' },
  { key: 'purchase_time', title: '单据日期', width: '120px', slot: true },
  { key: 'money', title: '费用', width: '110px', align: 'right', slot: true },
  { key: 'remark', title: '备注', width: '180px' },
  { key: '__op', title: '操作', width: '90px', align: 'right', slot: true },
];

const saveTempVisible = ref(false);
const tempListVisible = ref(false);
const tempName = ref('');
const tempSaving = ref(false);
const tempLoading = ref(false);
const tempList = ref([]);

/** 打开「存为模板」对话框 */
function openSaveTemp() {
  if (!rows.value.length) {
    message.warning('请先录入商品明细');
    return;
  }
  tempName.value = '';
  saveTempVisible.value = true;
}

/**
 * 提交存为模板：表头沿用当前单据，明细整表提交。
 * 后端校验模板名唯一、单据编号非空、明细需选单位与仓库。
 */
async function submitSaveTemp() {
  if (!String(tempName.value || '').trim()) {
    message.warning('请输入模板名称');
    return;
  }
  tempSaving.value = true;
  try {
    await request.post(`${tempBase.value}/savetemp`, {
      temp_name: String(tempName.value).trim(),
      head: {
        purchase_code: form.value.purchase_code || '',
        purchase_time: Number(form.value.purchase_time) || Math.floor(Date.now() / 1000),
        money: Number(form.value.money) || 0,
        remark: form.value.remark || form.value.note || '',
      },
      rows: rows.value.map((r) => ({
        goods_code: r.goods_code,
        goods_unit: r.goods_unit,
        goods_attr: r.goods_attr || null,
        stores_id: r.stores_id,
        number: Number(r.number) || 0,
        allow_stock: Number(r.allow_stock) || 0,
        unit_cost: Number(r.unit_cost) || 0,
        cost_money: Number(r.cost_money) || 0,
        period: r.period || null,
        batch: r.batch || null,
        batch_id: r.batch_id || null,
        remark: r.remark || '',
      })),
    });
    message.success('模板保存成功');
    saveTempVisible.value = false;
  } finally {
    tempSaving.value = false;
  }
}

/** 打开模板列表 */
async function openTempList() {
  tempListVisible.value = true;
  tempLoading.value = true;
  try {
    tempList.value = (await request.get(`${tempBase.value}/temps`)) || [];
  } finally {
    tempLoading.value = false;
  }
}

/**
 * 调用模板：把模板明细回填到当前单据（保留当前表头，追加明细）。
 * @param t 模板行
 */
async function applyTemp(t) {
  const r = await request.get(`${tempBase.value}/temps/get`, { params: { id: t.id } });
  const info = r?.info || [];
  if (!info.length) {
    message.warning('模板无明细');
    return;
  }
  // 覆盖当前明细：模板即完整组件清单（组合件 + 子件），追加会造成重复组合件
  rows.value = [];
  for (const it of info) {
    const row = blankRow();
    row.goods_code = it.goods_code;
    row.goods_name = it.goods_name || it.goods_code;
    row.goods_id = it.goods_id;
    row.goods_unit = it.goods_unit;
    row.goods_attr = it.goods_attr ?? null;
    row.stores_id = it.stores_id;
    row.type = String(it.type || '2');
    row.number = Number(it.number) || 0;
    row.unit_cost = Number(it.unit_cost) || 0;
    row.cost_money = Number(it.cost_money) || 0;
    row.allow_stock = Number(it.allow_stock) || 0;
    row.remark = it.remark || '';
    row.batch = it.batch || null;
    row.batch_id = it.batch_id || null;
    row.period = it.period || null;
    // 单位下拉：至少保证当前单位可选
    row._units = [{ id: it.goods_unit, name: '基本单位', rate: 1 }];
    row._rate = 1;
    rows.value.push(row);
  }
  if (r?.temp?.money) form.value.money = Number(r.temp.money) || 0;
  tempListVisible.value = false;
  message.success(`已调用模板「${t.temp_name}」`);
}

/** 关闭对话框时重置 */
function resetForm() {
  form.value = {};
  rows.value = [];
  originalInfoIds.value = [];
  costRows.value = [];
}
</script>

<style scoped>
.doc-editor { display: flex; flex-direction: column; gap: 10px; }
.toolbar :deep(.ds-card-c__body) { display: flex; align-items: center; flex-wrap: wrap; gap: 10px; }
.editor { display: flex; flex-direction: column; gap: 10px; }
/* 表头表单：排版由全局 .ds-form--inline 负责（styles/form.css），这里只补上下留白 */
.head-form { margin: 0; }
/* 明细表格滚动区：替代原 el-table 的 height 属性 */
.info-scroll { max-height: 420px; overflow: auto; }
.info-bar { display: flex; align-items: center; gap: 8px; }
.info-title { font-weight: 600; }
.totals { display: flex; gap: 24px; justify-content: flex-end; padding: 6px 4px; font-size: 13px; }
.pick-table { margin-top: 10px; }
.profit-up { color: #f56c6c; font-weight: 600; }
.profit-down { color: #67c23a; font-weight: 600; }
/* 表单块间距（模板弹窗内提示条等） */
.mt8 { margin-top: 8px; }
</style>
