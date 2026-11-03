import { Body, Controller, ForbiddenException, Get, Post, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { CurrentUser } from '../decorators/current-user.decorator';
import { ok } from '../response.interceptor';
import { SchedulerService } from './scheduler.service';
import { WechatTokenService } from '../wechat/wechat-token.service';

/**
 * 定时作业管理接口。
 *
 * 权限：仅超级管理员。理由与操作日志一致——作业开关与手动触发会影响全系统的
 * 后台行为（例如关掉微信 token 刷新会让小程序接口集体变慢），不适合下放给普通角色。
 */
@Controller('system/job')
@UseGuards(JwtAuthGuard)
export class SchedulerController {
  constructor(
    private readonly scheduler: SchedulerService,
    private readonly wechat: WechatTokenService,
  ) {}

  /**
   * 作业清单（含下次执行时间、上次结果、开关状态）。
   * @param user 当前登录用户
   * @returns { jobs, wechat }
   */
  @Get('index')
  async index(@CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    return ok({ jobs: await this.scheduler.list(), wechat: this.wechat.status() });
  }

  /**
   * 手动触发一个作业（用于验证配置或补跑）。
   * @param body { name }
   * @param user 当前登录用户
   * @returns { result }
   */
  @Post('run')
  async run(@Body() body: any, @CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    const result = await this.scheduler.run(String(body?.name || ''), 'manual');
    return ok({ result });
  }

  /**
   * 作业执行历史。
   * @param query name/page/limit
   * @param user 当前登录用户
   * @returns { list, count }
   */
  @Get('logs')
  async logs(@Query() query: any, @CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    const data = await this.scheduler.logs({
      name: query.name || '',
      page: Number(query.page) || 1,
      limit: Number(query.limit) || 20,
    });
    return ok(data);
  }

  /**
   * 仅超管可访问的断言。
   * @param user 当前登录用户
   */
  private assertSuperAdmin(user: any): void {
    if (Number(user?.id) !== 1) {
      throw new ForbiddenException('仅超级管理员可管理定时作业');
    }
  }
}
