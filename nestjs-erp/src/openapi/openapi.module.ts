import { Module } from '@nestjs/common';
import { OpenApiController } from './openapi.controller';
import { OpenApiService } from './openapi.service';
import { TableModule } from '../kuerp/table/table.module';

/**
 * 开放对接 API 模块（等价原系统 application/api/controller/kuerp/third/*）。
 *
 * 面向三方系统（线上商城 / CRM / OA）提供商品、客户、销货单的只读与写入接口，
 * 鉴权方式与原系统 1:1：account + request_time(300s 时效) + MD5 签名
 * （签名算法：参与签名的参数 ksort 后按 k=v 用 & 拼接，末尾拼 key=<salt> 后取 MD5，
 *   salt 为 kuerp_third_account 表中该账户的密钥），错误码 20-27 与原系统一致。
 *
 * 写入类接口（下单/退货）复用通用单号规则引擎（TableService.genCodeByRule）
 * 与审核过账引擎（TableService.examine → PostingService/FundsService），
 * 保证开放单据与后台手工单据走同一套库存/资金过账链路。
 */
@Module({
  imports: [TableModule],
  controllers: [OpenApiController],
  providers: [OpenApiService],
})
export class OpenApiModule {}
