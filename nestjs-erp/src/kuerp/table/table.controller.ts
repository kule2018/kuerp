import { Controller, Get, Post, Delete, Body, Query, Param, UseGuards, BadRequestException } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RbacGuard } from '../../common/guards/rbac.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ok } from '../../common/response.interceptor';
import { TableService } from './table.service';

/**
 * 通用动态表控制器：以 /kuerp/:table/<action> 形式对任意 kuerp_* 表暴露标准接口。
 * 路由与原系统 FastAdmin 通用控制器 1:1 对齐：
 *   GET    /kuerp/goods/index        列表/检索
 *   GET    /kuerp/goods/get          详情
 *   GET    /kuerp/goods/columns      字段元信息（前端动态渲染）
 *   GET    /kuerp/goods/recyclebin   回收站列表
 *   POST   /kuerp/goods/add          新增
 *   POST   /kuerp/goods/edit         编辑
 *   POST   /kuerp/goods/del          删除（支持 { id } 或 { ids: [] }）
 *   DELETE /kuerp/goods/del          删除（兼容 DELETE 调用方）
 *   POST   /kuerp/goods/reduction    还原（支持批量）
 *   POST   /kuerp/goods/realdel      真实删除（支持批量）
 *   POST   /kuerp/goods/import       批量导入（JSON 数组）
 *   POST   /kuerp/goods/examine      审核/反审
 *   POST   /kuerp/initialize         重新初始化（高危，需 confirm=INIT）
 * 全部接口需 JWT 鉴权。
 */
@Controller('kuerp')
@UseGuards(JwtAuthGuard, RbacGuard)
export class TableController {
  constructor(private readonly svc: TableService) {}

  /** 列表 / 检索 */
  @Get(':table/index')
  async index(@Param('table') table: string, @Query() q: any, @CurrentUser() user: any) {
    // 数据权限：超管(id=1)与全量权限用户传 1（不附加 owner 过滤）；
    // 其余用户按所属角色最小 data_scope 决定（2=仅本人创建数据）。
    const dataScope = user && Number(user.id) !== 1 ? await this.svc.dataScopeOf(Number(user.id)) : 1;
    return ok(await this.svc.index(table, { ...q, dataScope, userId: user?.id }));
  }

  /** 列出所有业务表（前端导航用，路径为 /kuerp/tables，单段不与 :table/index 冲突） */
  @Get('tables')
  async tables() {
    return ok(await this.svc.listTables());
  }

  /** 各业务表数据量统计（数据管理页用） */
  @Get('tables/stats')
  async tableStats() {
    return ok(await this.svc.tableStats());
  }

  /**
   * 按「单号设置」规则生成下一个单据编号（等价原系统 Thirds::getCodes）。
   * GET /kuerp/prefix/gen-code?dbname=kuerp_goods_purchase&field=purchase_code
   * 规则来自 kuerp_prefix：前缀 + 日期段 + 流水号（起始数/位数），自动查重递增。
   */
  @Get('prefix/gen-code')
  async genCode(@Query('dbname') dbname: string, @Query('field') field: string) {
    if (!dbname || !field) throw new BadRequestException('缺少 dbname 或 field');
    return ok(await this.svc.genCodeByRule(dbname, field));
  }

  /** 详情 */
  @Get(':table/get')
  async get(@Param('table') table: string, @Query('id') id: string) {
    if (!id) throw new BadRequestException('缺少 id');
    return ok(await this.svc.get(table, Number(id)));
  }

  /** 表字段元信息（前端动态渲染列表列/表单用） */
  @Get(':table/columns')
  async columns(@Param('table') table: string) {
    return ok(await this.svc.columns(table));
  }

  /**
   * 外键字段下拉选项（等价原系统 selectpage / getSuppliers 等）。
   * GET /kuerp/:table/options?field=suppliers_id
   * 命中关联表时返回 [{ value, label }]，否则返回空数组。
   */
  @Get(':table/options')
  async options(@Param('table') table: string, @Query('field') field: string) {
    if (!field) throw new BadRequestException('缺少 field');
    return ok(await this.svc.fieldOptions(table, field));
  }

  /** 新增（admin_id 等操作人字段由登录态自动注入，表单不再手填；表无此列时 service 会忽略） */
  @Post(':table/add')
  async add(@Param('table') table: string, @Body() dto: any, @CurrentUser() user: any) {
    if (dto && dto.admin_id === undefined && user?.id) dto.admin_id = user.id;
    return ok(await this.svc.add(table, dto), '添加成功');
  }

  /** 编辑 */
  @Post(':table/edit')
  async edit(@Param('table') table: string, @Body() body: any) {
    if (!body || body.id === undefined) throw new BadRequestException('缺少 id');
    const { id, ...dto } = body;
    return ok(await this.svc.edit(table, Number(id), dto), '保存成功');
  }

  /**
   * 删除（等价原系统 del）。
   * 支持单条 { id } 与批量 { ids: [] }；同时兼容 DELETE(body/query) 与 POST 两种调用方式，
   * 避免部分 HTTP 客户端/代理丢弃 DELETE body 导致批量删除失效。
   */
  @Delete(':table/del')
  async delDelete(@Param('table') table: string, @Body() body: any, @Query('id') qid?: string) {
    return this.doDel(table, body?.id ?? body?.ids ?? qid);
  }

  /**
   * 删除（POST 形态，等价原系统 del）。
   *
   * 与 DELETE 形态并存的原因：部分 HTTP 客户端 / 网关会丢弃 DELETE 的请求体，
   * 而原系统的删除参数都在 body 里（id 或 ids）。保留 POST 入口可避免
   * 第三方系统按原文档接入时「传了 id 却被当成没传」。
   *
   * @param table 表名（连字符或下划线均可）
   * @param body { id 单条 } 或 { ids 批量 }
   * @param qid 兼容用：id 也可放 querystring
   * @returns null
   */
  @Post(':table/del')
  async delPost(@Param('table') table: string, @Body() body: any, @Query('id') qid?: string) {
    return this.doDel(table, body?.id ?? body?.ids ?? qid);
  }

  /** 删除公共逻辑：归一化 id / ids 入参 */
  private async doDel(table: string, raw: any) {
    if (raw === undefined || raw === null || raw === '') {
      throw new BadRequestException('缺少 id');
    }
    await this.svc.del(table, raw);
    return ok(null, '删除成功');
  }

  /** 回收站列表（等价原系统 recyclebin） */
  @Get(':table/recyclebin')
  async recyclebin(@Param('table') table: string, @Query() q: any) {
    return ok(await this.svc.recyclebin(table, q));
  }

  /** 还原（等价原系统 reduction，支持批量） */
  @Post(':table/reduction')
  async reduction(@Param('table') table: string, @Body() body: any) {
    const raw = body?.id ?? body?.ids;
    if (raw === undefined || raw === null || raw === '') {
      throw new BadRequestException('缺少 id');
    }
    await this.svc.reduction(table, raw);
    return ok(null, '还原成功');
  }

  /** 真实删除（等价原系统 realdel，支持批量，不可恢复） */
  @Post(':table/realdel')
  async realdel(@Param('table') table: string, @Body() body: any) {
    const raw = body?.id ?? body?.ids;
    if (raw === undefined || raw === null || raw === '') {
      throw new BadRequestException('缺少 id');
    }
    await this.svc.realdel(table, raw);
    return ok(null, '已真实删除');
  }

  /** 批量导入（等价原系统 import） */
  @Post(':table/import')
  async import(@Param('table') table: string, @Body() body: { rows: Record<string, any>[] }) {
    if (!body?.rows) throw new BadRequestException('缺少 rows');
    return ok(await this.svc.import(table, body.rows), '导入成功');
  }

  /**
   * 重新初始化（等价原系统 Initialization）：清空全部业务单据数据。
   * 高危操作：必须显式传入 confirm=INIT 才执行；保留系统参数/单号设置等配置表。
   */
  @Post('initialize')
  async initialize(@Body() body: { confirm?: string }) {
    if (body?.confirm !== 'INIT') {
      throw new BadRequestException('危险操作：请传 confirm=INIT 确认');
    }
    const tables: any[] = await this.svc.listRawTables();
    // 配置类表不清空（系统参数/单号/AI/账户框架等基础数据保留）
    const keep = new Set([
      'kuerp_sets', 'kuerp_prefix', 'kuerp_admin',
      'kuerp_ai_model_config', 'kuerp_ai_prompt_template', 'kuerp_ai_call_log', 'kuerp_ai_tool_call_log',
    ]);
    let truncated = 0;
    for (const t of tables) {
      if (keep.has(t.table)) continue;
      await this.svc.truncateTable(t.table);
      truncated++;
    }
    return ok({ truncated }, `已清空 ${truncated} 张业务表`);
  }

  /** 当前结账日期（数据面板 / 结账页读取） */
  @Get('checkout/current')
  async checkoutCurrent() {
    const cd = await this.svc.getCheckoutDate();
    return ok({ checktime: cd, checkdate: cd ? new Date(cd * 1000).toISOString().slice(0, 10) : null });
  }

  /** 结账：归档账期（endDate 格式 YYYY-MM-DD） */
  @Post('checkout/settle')
  async checkoutSettle(@Body() body: { endDate?: string }, @CurrentUser() user: any) {
    if (!body?.endDate) throw new BadRequestException('缺少 endDate');
    // 记录操作人（prepare/操作人字段）
    const r = await this.svc.settleCheckout(body.endDate, user?.id ?? 0);
    return ok(r, '结账成功');
  }

  /** 反结账：清除结账记录与归档明细 */
  @Post('checkout/unsettle')
  async checkoutUnsettle() {
    return ok(await this.svc.unsettleCheckout(), '已反结账');
  }

  /** 数据面板（工作台）核心指标聚合 */
  @Get('statistics/dashboard')
  async dashboardStats() {
    return ok(await this.svc.dashboardStats());
  }

  /**
   * 保存单号组合规则（kuerp_prefix，见 3.设置/1.系统参数.md「单号设置」）。
   * POST /kuerp/sets/prefix-save  body: { rows: [{ id, prefix, year, ..., strlen }] }
   * 已产生数据的单据不可再修改其组合规则（服务端强校验）。
   */
  @Post('sets/prefix-save')
  async savePrefixRules(@Body() body: { rows?: Array<Record<string, any>> }) {
    if (!body?.rows) throw new BadRequestException('缺少 rows');
    return ok(await this.svc.savePrefixRules(body.rows), '单号规则已保存');
  }

  /**
   * 对单 / 反对单（等价原系统 GoodsPurchase::counter 等 4 个购销单据控制器）。
   * POST /kuerp/:table/counter  body: { id } 或 { ids: [] }, counter: 1|2
   * counter=1 对单（仅未对单行）、counter=2 反对单（仅已对单行）；
   * 已结账单据不可（反）对单；同步记录最后操作人。
   */
  @Post(':table/counter')
  async counter(
    @Param('table') table: string,
    @Body() body: { id?: number; ids?: number[]; counter?: number },
    @CurrentUser() user: any,
  ) {
    const raw = body?.id ?? body?.ids;
    if (raw === undefined || raw === null || (typeof raw !== 'number' && !Array.isArray(raw))) {
      throw new BadRequestException('缺少 id');
    }
    // 原系统口径：counter=1 对单，counter=2 反对单（0 亦按反对单处理）
    const c = body?.counter === 1 ? 1 : 0;
    const r = await this.svc.counter(table, raw as number | number[], c, user?.id ?? 0);
    return ok(r, c === 1 ? '对单成功' : '已反对单');
  }

  /** 审核 / 反审（等价原系统 examine，status 0=反审, 1=已审） */
  @Post(':table/examine')
  async examine(
    @Param('table') table: string,
    @Body() body: { id: number; status?: number },
  ) {
    if (!body || body.id === undefined) throw new BadRequestException('缺少 id');
    return ok(
      await this.svc.examine(table, Number(body.id), body.status ?? 1),
      '审核成功',
    );
  }
}
