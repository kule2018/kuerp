import { Controller, Post, Body } from '@nestjs/common';
import { OpenApiService } from './openapi.service';

/**
 * 开放对接 API 控制器（等价原系统 kuerp/third 的 Goods/Customers/Sales 三组接口）。
 *
 * 路由与原系统 Action 名 1:1（三方系统按原 API 文档无需改动即可接入）：
 *   POST /openapi/third/goods/goodsTypeList      商品分类
 *   POST /openapi/third/goods/getGoodsList       商品列表
 *   POST /openapi/third/goods/getGoodsInfo       商品详情
 *   POST /openapi/third/customers/getSalesList   职员列表
 *   POST /openapi/third/customers/getCustomersList 客户列表
 *   POST /openapi/third/customers/joinCustomers  添加客户
 *   POST /openapi/third/customers/customersInfo  客户详情
 *   POST /openapi/third/customers/editCustomers  编辑客户
 *   POST /openapi/third/customers/delCustomers   注销客户
 *   POST /openapi/third/sales/getSalesList       销货单列表
 *   POST /openapi/third/sales/sales              添加销货单
 *   POST /openapi/third/sales/salesInfo          销货单详情
 *   POST /openapi/third/sales/returnSales        添加销货退货单
 *   POST /openapi/third/sales/returnSalesInfo    销货退货单详情
 *
 * 响应结构与原系统一致：{ code, msg, time, data }；
 * 错误码：20 接口地址错误 / 21 账户不存在 / 22 账户状态异常 / 23 无效请求 /
 *         24 签名错误 / 25 参数错误 / 27 业务失败。全局响应拦截器对含 code+msg
 * 的对象直接透传，故各接口直接返回原风格结构。
 */
@Controller('openapi/third')
export class OpenApiController {
  constructor(private readonly svc: OpenApiService) {}

  // ===================== 商品 =====================

  /**
   * 商品分类列表。
   * @param body { accountId, sign, time, page, limit } 开放平台公共参数
   * @returns { code, msg, data: [{ id, name }] }
   */
  @Post('goods/goodsTypeList')
  goodsTypeList(@Body() body: any) {
    return this.svc.goodsTypeList(body);
  }

  /**
   * 商品列表（分页）。
   * @param body { accountId, sign, page, limit, keyword 可选 } 公共参数 + 分页
   * @returns { code, msg, data: { list, total } }
   */
  @Post('goods/getGoodsList')
  getGoodsList(@Body() body: any) {
    return this.svc.getGoodsList(body);
  }

  /**
   * 商品详情（含多单位、价格、库存）。
   * @param body { accountId, sign, goodsId 或 goodsCode }
   * @returns { code, msg, data: 商品对象 }
   */
  @Post('goods/getGoodsInfo')
  getGoodsInfo(@Body() body: any) {
    return this.svc.getGoodsInfo(body);
  }

  // ===================== 客户 =====================

  /**
   * 职员（业务员）列表。
   * @param body { accountId, sign }
   * @returns { code, msg, data: [{ id, name }] }
   */
  @Post('customers/getSalesList')
  staffList(@Body() body: any) {
    return this.svc.staffList(body);
  }

  /**
   * 客户列表（分页）。
   * @param body { accountId, sign, page, limit, keyword 可选 }
   * @returns { code, msg, data: { list, total } }
   */
  @Post('customers/getCustomersList')
  getCustomersList(@Body() body: any) {
    return this.svc.getCustomersList(body);
  }

  /**
   * 新增客户。
   * @param body { accountId, sign, customersName, mobile, address ... }
   * @returns { code, msg, data: { customersId } }
   */
  @Post('customers/joinCustomers')
  joinCustomers(@Body() body: any) {
    return this.svc.joinCustomers(body);
  }

  /**
   * 客户详情。
   * @param body { accountId, sign, customersId }
   * @returns { code, msg, data: 客户对象 }
   */
  @Post('customers/customersInfo')
  customersInfo(@Body() body: any) {
    return this.svc.customersInfo(body);
  }

  /**
   * 编辑客户。
   * @param body { accountId, sign, customersId, ...待改字段 }
   * @returns { code, msg }
   */
  @Post('customers/editCustomers')
  editCustomers(@Body() body: any) {
    return this.svc.editCustomers(body);
  }

  /**
   * 注销/删除客户。
   * @param body { accountId, sign, customersId }
   * @returns { code, msg }
   */
  @Post('customers/delCustomers')
  delCustomers(@Body() body: any) {
    return this.svc.delCustomers(body);
  }

  // ===================== 销货 =====================

  /**
   * 销货单列表（分页，可按日期区间过滤）。
   * @param body { accountId, sign, page, limit, startTime, endTime }
   * @returns { code, msg, data: { list, total } }
   */
  @Post('sales/getSalesList')
  getSalesList(@Body() body: any) {
    return this.svc.getSalesList(body);
  }

  /**
   * 新增销货单（含明细，服务端生成单号并过账）。
   * @param body { accountId, sign, customersId, data: [ { goodsId, number, price, storesId } ] }
   * @returns { code, msg, data: { salesId, salesCode } }
   */
  @Post('sales/sales')
  sales(@Body() body: any) {
    return this.svc.sales(body);
  }

  /**
   * 销货单详情（表头 + 明细）。
   * @param body { accountId, sign, salesId }
   * @returns { code, msg, data: 销货单对象 }
   */
  @Post('sales/salesInfo')
  salesInfo(@Body() body: any) {
    return this.svc.salesInfo(body);
  }

  /**
   * 新增销货退货单。
   * @param body { accountId, sign, customersId, data: [ { goodsId, number, price } ] }
   * @returns { code, msg, data: { returnId, returnCode } }
   */
  @Post('sales/returnSales')
  returnSales(@Body() body: any) {
    return this.svc.returnSales(body);
  }

  /**
   * 销货退货单详情。
   * @param body { accountId, sign, returnId }
   * @returns { code, msg, data: 退货单对象 }
   */
  @Post('sales/returnSalesInfo')
  returnSalesInfo(@Body() body: any) {
    return this.svc.returnSalesInfo(body);
  }
}
