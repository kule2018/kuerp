import { Module } from '@nestjs/common';
import { ShopAuthService } from './shop-auth.service';
import { ShopService } from './shop.service';
import { ShopSmsService } from './shop-sms.service';
import { ShopWechatService } from './shop-wechat.service';
import {
  ShopAddressController,
  ShopCommonController,
  ShopConfigController,
  ShopIndexController,
  ShopSmsController,
  ShopUserController,
  ShopWeixinController,
} from './shop.controller';

/**
 * 订货通（微信小程序端）模块。
 *
 * 等价原系统 `application/api/controller/kuerp/order/*` 七组控制器：
 *   Common（初始化）/ Config（系统配置）/ Address（收货地址）/ Sms（验证码）/
 *   User（会员中心）/ Weixin（小程序登录与支付）/ Index（商品·购物车·订单）。
 *
 * 与后台管理端的区别：本模块面向 C 端会员，使用 `kuerp_user.token` 做令牌鉴权，
 * 响应码为订货通约定（200 成功 / 250 未登录 / 500 失败），不参与后台 RBAC 权限体系。
 *
 * 数据访问直接复用全局 DataSource（与 OpenApiModule 一致），
 * 因为订货通查询大量涉及多表联查与聚合，走通用动态表接口反而更低效。
 */
@Module({
  controllers: [
    ShopIndexController,
    ShopAddressController,
    ShopConfigController,
    ShopSmsController,
    ShopUserController,
    ShopWeixinController,
    ShopCommonController,
  ],
  providers: [ShopAuthService, ShopService, ShopSmsService, ShopWechatService],
  exports: [ShopService, ShopAuthService],
})
export class ShopModule {}
