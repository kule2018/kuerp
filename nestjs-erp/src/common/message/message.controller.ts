import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { CurrentUser } from '../decorators/current-user.decorator';
import { ok } from '../response.interceptor';
import { MessageService } from './message.service';

/**
 * 消息中心接口（站内信）。
 *
 * 权限：任意登录管理员均可访问自己的消息，因此只挂 JwtAuthGuard，不做 RBAC 表校验
 * （消息不是业务表，走 /kuerp/ 会被当成 kuerp_message 表拦截）。
 */
@Controller('system/message')
@UseGuards(JwtAuthGuard)
export class MessageController {
  constructor(private readonly svc: MessageService) {}

  /**
   * 分页查询当前用户的消息。
   * @param query page/limit/unread/type
   * @param user 当前登录用户
   * @returns { list, count }
   */
  @Get('index')
  async index(@Query() query: any, @CurrentUser() user: any) {
    return ok(
      await this.svc.list({
        page: Number(query.page) || 1,
        limit: Number(query.limit) || 20,
        unread: String(query.unread || '') === '1' || query.unread === true,
        type: query.type || '',
        toAdminId: Number(user?.id) || 0,
      }),
    );
  }

  /**
   * 未读条数（侧栏徽标）。
   * @param query type 可选
   * @param user 当前登录用户
   * @returns { count }
   */
  @Get('unread-count')
  async unread(@Query() query: any, @CurrentUser() user: any) {
    const count = await this.svc.unreadCount(Number(user?.id) || 0, query.type || '');
    return ok({ count });
  }

  /**
   * 标记单条已读。
   * @param body { id }
   * @param user 当前登录用户
   * @returns { success }
   */
  @Post('read')
  async read(@Body() body: any, @CurrentUser() user: any) {
    const success = await this.svc.markRead(Number(body?.id) || 0, Number(user?.id) || 0);
    return ok({ success });
  }

  /**
   * 全部标记已读。
   * @param user 当前登录用户
   * @returns { affected }
   */
  @Post('read-all')
  async readAll(@CurrentUser() user: any) {
    const affected = await this.svc.markAllRead(Number(user?.id) || 0);
    return ok({ affected });
  }

  /**
   * 删除一条消息（软删除）。
   * @param body { id }
   * @param user 当前登录用户
   * @returns { success }
   */
  @Post('del')
  async del(@Body() body: any, @CurrentUser() user: any) {
    const success = await this.svc.remove(Number(body?.id) || 0, Number(user?.id) || 0);
    return ok({ success });
  }
}
