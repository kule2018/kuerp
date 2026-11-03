import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * JWT 鉴权守卫：作用在需要登录的路由上。等效于原系统的登录态校验。
 */
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
