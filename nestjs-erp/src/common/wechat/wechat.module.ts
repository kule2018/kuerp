import { Global, Module } from '@nestjs/common';
import { WechatTokenService } from './wechat-token.service';

/**
 * 微信基础设施模块（全局）。
 *
 * 只放与具体业务无关的微信能力（当前是 access_token 缓存）。
 * 订货通模块的登录/支付仍在 ShopModule 内，避免把 C 端业务耦合进公共层。
 */
@Global()
@Module({
  providers: [WechatTokenService],
  exports: [WechatTokenService],
})
export class WechatModule {}
