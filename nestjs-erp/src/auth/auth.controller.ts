import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto, ChangePwdDto } from './dto/login.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { ok } from '../common/response.interceptor';

/**
 * 认证接口：登录 / 当前用户 / 改密
 * 路由前缀保持与原系统 admin 模块一致（这里用 /auth）。
 */
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  /**
   * 账号密码登录，成功后返回 JWT 与用户基本信息。
   * @param dto { username 账号, password 密码 }
   * @returns { token, user: { id, username, nickname, avatar } }
   */
  @Post('login')
  async login(@Body() dto: LoginDto) {
    const data = await this.authService.login(dto.username, dto.password);
    return ok(data);
  }

  /**
   * 读取当前登录用户的资料（含角色、菜单树）。
   * @param userId 当前用户 ID（由 JWT 解出，不由前端传入）
   * @returns 用户资料对象
   */
  @UseGuards(JwtAuthGuard)
  @Get('profile')
  async profile(@CurrentUser('id') userId: number) {
    return ok(await this.authService.profile(userId));
  }

  /**
   * 当前用户权限集合（按钮级权限用）。
   * 返回 { isSuper, nodes, tables, menus }，口径与 RbacGuard 一致。
   */
  @UseGuards(JwtAuthGuard)
  @Get('perms')
  async perms(@CurrentUser('id') userId: number) {
    return ok(await this.authService.perms(userId));
  }

  /**
   * 修改本人密码（需先校验原密码）。
   * @param userId 当前用户 ID
   * @param dto { oldPassword 原密码, newPassword 新密码 }
   * @returns null
   */
  @UseGuards(JwtAuthGuard)
  @Post('change-pwd')
  async changePwd(@CurrentUser('id') userId: number, @Body() dto: ChangePwdDto) {
    await this.authService.changePassword(userId, dto.oldPassword, dto.newPassword);
    return ok(null, '密码已修改');
  }
}
