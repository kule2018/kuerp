import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RbacGuard } from '../../common/guards/rbac.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ok } from '../../common/response.interceptor';
import { BizService } from './biz.service';

/**
 * 进销存业务扩展控制器（1:1 还原原系统各控制器的非 CRUD Action）。
 *
 * 路由全部挂在 /kuerp/<模块>/<动作> 三段式下，与通用动态表 TableController 的
 * /kuerp/:table/<标准动作> 不冲突（标准动作为 index/get/columns/add/edit/del/
 * recyclebin/reduction/realdel/import/counter/examine）。
 *
 * 路由清单：
 *   GET  /kuerp/goods/unit              商品单位与价格（getUnit）
 *   GET  /kuerp/goods/sale-unit         商品售价（按客户等级，getSaleUnit）
 *   GET  /kuerp/goods/serial            可用序列号（getSerial）
 *   POST /kuerp/goods/serial-build      序列号录入归一化（period）
 *   GET  /kuerp/goods/scan              扫码定位商品（getGoods）
 *   GET  /kuerp/goods/menu              商品类别树（getMenu）
 *   GET  /kuerp/customers/receiving-address  客户收货地址（getReceivingAddress）
 *   GET  /kuerp/branch/list             门店/仓库分支（getBranch）
 *   GET  /kuerp/writeoff/sources        核销源单（choselist/chosereceivable/chosecopewith/choseadvancelist）
 *   POST /kuerp/user-order/audit        订货单审核（UserOrder::examine）
 *   POST /kuerp/user-order/deliver      订货单发货（UserOrder::deliver）
 *   POST /kuerp/:kind/savetemp          组装/拆卸存为模板（savetemp）
 *   GET  /kuerp/:kind/temps             模板列表（AssembleTemp::index）
 *   GET  /kuerp/:kind/temps/get         模板详情（AssembleTemp::gettemp）
 *   POST /kuerp/stock/check             库存校验（checkPurchase/checkExchange/checkInventory）
 *
 * 全部接口需 JWT 鉴权 + RBAC 节点校验（非超管按 kuerp/<模块> 节点放行）。
 */
@UseGuards(JwtAuthGuard, RbacGuard)
@Controller('kuerp')
export class BizController {
  constructor(private readonly biz: BizService) {}

  // ================= 商品 =================

  /**
   * 商品单位与价格（批量）。
   * GET /kuerp/goods/unit?rows=[{"goods_id":1,"goods_attr":0}]
   * @param rowsJSON 商品行数组（JSON 字符串，也可用 goods_id 单查）
   * @param goods_id 单个商品 ID（rows 为空时生效）
   * @param mode purchase=采购价（默认）/ sale=按客户等级售价
   * @param customers_id mode=sale 时的客户
   */
  @Get('goods/unit')
  async goodsUnit(
    @Query('rows') rowsJSON?: string,
    @Query('goods_id') goodsId?: string,
    @Query('mode') mode?: string,
    @Query('customers_id') customersId?: string,
  ) {
    const rows = this.parseRows(rowsJSON, goodsId);
    return ok(
      await this.biz.goodsUnits(rows, {
        priceField: mode === 'sale' ? 'auto' : 'market_sell_price',
        customersId,
      }),
    );
  }

  /** 商品售价（按客户等级切换价格口径，等价 getSaleUnit） */
  @Get('goods/sale-unit')
  async goodsSaleUnit(
    @Query('rows') rowsJSON?: string,
    @Query('goods_id') goodsId?: string,
    @Query('customers_id') customersId?: string,
  ) {
    const rows = this.parseRows(rowsJSON, goodsId);
    return ok(await this.biz.goodsUnits(rows, { priceField: 'auto', customersId }));
  }

  /** 可用序列号（等价 getSerial） */
  @Get('goods/serial')
  async goodsSerial(
    @Query('goods_code') goodsCode?: string,
    @Query('stores_id') storesId?: string,
    @Query('attribute_id') attributeId?: string,
  ) {
    return ok(await this.biz.goodsSerial({ goods_code: goodsCode, stores_id: storesId, attribute_id: attributeId }));
  }

  /** 序列号录入归一化（等价 Goods::period） */
  @Post('goods/serial-build')
  async goodsSerialBuild(@Body() body: any) {
    return ok(await this.biz.buildSerial(body));
  }

  /** 扫码定位商品（等价 getGoods） */
  @Get('goods/scan')
  async goodsScan(@Query('code') code?: string) {
    return ok(await this.biz.goodsByCode(String(code || '')));
  }

  /** 商品类别树（等价 getMenu） */
  @Get('goods/menu')
  async goodsMenu() {
    return ok(await this.biz.goodsMenu());
  }

  // ================= 往来单位 =================

  /** 客户收货地址（等价 getReceivingAddress） */
  @Get('customers/receiving-address')
  async receivingAddress(@Query('customers_id') customersId?: string) {
    return ok(await this.biz.receivingAddress(customersId));
  }

  /** 门店 / 仓库分支列表（等价 getBranch） */
  @Get('branch/list')
  async branchList(@Query('keyword') keyword?: string) {
    return ok(await this.biz.branchList(keyword));
  }

  // ================= 核销源单 =================

  /**
   * 核销源单列表。
   * GET /kuerp/writeoff/sources?kind=receive&customers_id=1&keyword=&start=&end=
   * kind: receive 应收 / cope 应付 / advance 预收 / advanceOut 预付
   */
  @Get('writeoff/sources')
  async writeoffSources(@Query() q: any) {
    return ok(await this.biz.writeoffSources(q));
  }

  // ================= 订货通订单 =================

  /**
   * 订货单审核（等价 UserOrder::examine，status → 2 待发货）。
   * POST /kuerp/user-order/audit  body: { ids: number[] }
   */
  @Post('user-order/audit')
  async userOrderAudit(@Body() body: { ids?: number[]; id?: number }, @CurrentUser() user: any) {
    const ids = this.normalizeIds(body);
    return ok(await this.biz.userOrderExamine(ids, Number(user?.id) || 0), '审核成功');
  }

  /**
   * 订货单发货（等价 UserOrder::deliver）。
   * POST /kuerp/user-order/deliver
   * body: { ids, send_type: 1=司机配送 2=快递, diver_id, express_code, express_num }
   */
  @Post('user-order/deliver')
  async userOrderDeliver(
    @Body() body: any,
    @CurrentUser() user: any,
  ) {
    const ids = this.normalizeIds(body);
    return ok(await this.biz.userOrderDeliver(ids, body, Number(user?.id) || 0));
  }

  /**
   * 订货单生成销货单（等价列表「生成销货单」→ goods_sales/add?order_id=x）。
   * POST /kuerp/user-order/to-sales  body: { id } 或 { ids: [单个] }
   */
  @Post('user-order/to-sales')
  async userOrderToSales(@Body() body: any, @CurrentUser() user: any) {
    const ids = this.normalizeIds(body);
    if (!ids.length) return ok(null, '缺少订单 ID');
    return ok(await this.biz.userOrderToSales(ids[0], Number(user?.id) || 0), '销货单已生成');
  }

  /** 快递公司字典（等价 deliver.html 的 express_list） */
  @Get('user-order/express')
  async expressList() {
    return ok(await this.biz.expressList());
  }

  // ================= 组装 / 拆卸模板 =================

  /**
   * 存为模板（等价 Assemble::savetemp / Split::savetemp）。
   * POST /kuerp/assemble/savetemp 或 /kuerp/split/savetemp
   * body: { temp_name, head: {...}, rows: [...] }
   */
  @Post('assemble/savetemp')
  async assembleSaveTemp(@Body() body: any, @CurrentUser() user: any) {
    return ok(await this.biz.saveTemp('assemble', body, Number(user?.id) || 0), '模板保存成功');
  }

  /**
   * 保存拆卸单模板（等价 SplitTemp::savetemp）。
   * @param body { name 模板名, data 明细行 }
   * @param user 当前登录用户（记录创建人）
   * @returns 保存结果
   */
  @Post('split/savetemp')
  async splitSaveTemp(@Body() body: any, @CurrentUser() user: any) {
    return ok(await this.biz.saveTemp('split', body, Number(user?.id) || 0), '模板保存成功');
  }

  /** 模板列表（等价 AssembleTemp/SplitTemp::index） */
  @Get('assemble/temps')
  async assembleTemps() {
    return ok(await this.biz.listTemps('assemble'));
  }

  /**
   * 拆卸单模板列表。
   * @returns 模板数组
   */
  @Get('split/temps')
  async splitTemps() {
    return ok(await this.biz.listTemps('split'));
  }

  /** 模板详情（等价 AssembleTemp::gettemp） */
  @Get('assemble/temps/get')
  async assembleTempGet(@Query('id') id?: string) {
    return ok(await this.biz.getTemp('assemble', id));
  }

  /**
   * 拆卸单模板详情。
   * @param id 模板 ID（缺省则返回空模板）
   * @returns 模板对象（含明细）
   */
  @Get('split/temps/get')
  async splitTempGet(@Query('id') id?: string) {
    return ok(await this.biz.getTemp('split', id));
  }

  // ================= 库存校验 =================

  /**
   * 单据出库库存校验（等价 checkPurchase / checkExchange / checkInventory）。
   * POST /kuerp/stock/check  body: { lines: [{ goods_code, goods_unit, goods_attr, stores_id, number }] }
   */
  @Post('stock/check')
  async stockCheck(@Body() body: { lines?: any[] }) {
    return ok(await this.biz.checkStock(body?.lines || []));
  }

  // ================= 私有工具 =================

  /**
   * 解析商品行入参：优先 JSON 字符串，其次单 goods_id。
   * @param rowsJSON 形如 [{"goods_id":1}] 的 JSON
   * @param goodsId 单个商品 ID
   */
  private parseRows(rowsJSON?: string, goodsId?: string): Array<{ goods_id: any; goods_attr?: any }> {
    if (rowsJSON) {
      try {
        const arr = JSON.parse(rowsJSON);
        if (Array.isArray(arr)) return arr;
      } catch {
        /* 解析失败回落单 ID */
      }
    }
    if (goodsId) return [{ goods_id: Number(goodsId) }];
    return [];
  }

  /**
   * 归一化批量 ID 入参：支持 { ids: [] } 与 { id }。
   * @param body 请求体
   */
  private normalizeIds(body: any): number[] {
    const raw = body?.ids ?? body?.id;
    if (Array.isArray(raw)) return raw.map((v: any) => Number(v)).filter((v) => v > 0);
    const one = Number(raw);
    return one > 0 ? [one] : [];
  }
}
