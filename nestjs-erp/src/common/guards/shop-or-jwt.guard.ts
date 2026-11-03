import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ShopAuthService } from '../../shop/shop-auth.service';

/**
 * 通用鉴权守卫：一套守卫同时兼容两种令牌，
 *  1) 订货通会员令牌（kuerp_user.token，UUID 明文，小程序端通过 token 头携带）；
 *  2) 后台 JWT（管理员/职员，Authorization: Bearer）。
 *
 * 小程序端（Uniapp）登录拿的是订货通 UUID 令牌，而后台管理端走 JWT。
 * 先按订货通令牌查库校验，命中即放行；未命中再退化为 passport-jwt 校验，
 * 确保 C 端与后台都能访问同一组 /shop、/ai、/api/upload 接口。
 */
@Injectable()
export class ShopOrJwtGuard extends AuthGuard('jwt') {
  constructor(private readonly shopAuth: ShopAuthService) {
    super();
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest();
    const token = this.shopAuth.pickToken(req, (req as any).body);
    if (token) {
      const user = await this.shopAuth.init(token);
      if (user) {
        (req as any).user = user;
        return true;
      }
    }
    // 退化为后台 JWT（管理员/职员）；无效令牌会由 passport 抛出 401
    return (await super.canActivate(context)) as boolean;
  }
}
