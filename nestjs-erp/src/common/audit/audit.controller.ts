import { Controller, ForbiddenException, Get, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { CurrentUser } from '../decorators/current-user.decorator';
import { ok } from '../response.interceptor';
import { AuditService } from './audit.service';

/**
 * 操作日志查询接口。
 *
 * 路由挂在 /system/log 下而不是 /kuerp/...：
 * 审计日志不是业务表，走 /kuerp/ 会被 RbacGuard 当成 /kuerp/log 表去校验而误拦截。
 *
 * 访问控制：仅超级管理员（id=1）可读。
 * 理由：审计日志本身包含全公司操作痕迹，放开给普通角色等于把「谁在做什么」公开了。
 */
@Controller('system/log')
@UseGuards(JwtAuthGuard)
export class AuditController {
  constructor(private readonly audit: AuditService) {}

  /**
   * 分页查询操作日志。
   * @param query 查询条件（page/limit/search/module/action/failed/starttime/endtime）
   * @param user 当前登录用户
   * @returns { list, count }
   */
  @Get('index')
  async index(@Query() query: any, @CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    const data = await this.audit.list({
      page: Number(query.page) || 1,
      limit: Number(query.limit) || 20,
      search: query.search || '',
      module: query.module || '',
      action: query.action || '',
      failed: String(query.failed || '') === '1' || query.failed === true,
      starttime: query.starttime ? Number(query.starttime) : undefined,
      endtime: query.endtime ? Number(query.endtime) : undefined,
    });
    return ok(data);
  }

  /**
   * 模块与动作的候选值（供前端筛选下拉）。
   * @param user 当前登录用户
   * @returns { modules, actions }
   */
  @Get('facets')
  async facets(@CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    return ok(await this.audit.facets());
  }

  /**
   * 仅超管可访问的断言。
   * @param user 当前登录用户
   */
  private assertSuperAdmin(user: any): void {
    if (Number(user?.id) !== 1) {
      throw new ForbiddenException('仅超级管理员可查看操作日志');
    }
  }
}
