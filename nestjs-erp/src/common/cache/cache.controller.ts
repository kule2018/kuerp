import { Controller, ForbiddenException, Get, Post, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { CurrentUser } from '../decorators/current-user.decorator';
import { ok } from '../response.interceptor';
import { CacheService } from './cache.service';

/**
 * 缓存运维接口。
 *
 * 路由挂在 /system/cache 而不是 /kuerp/...：
 * 缓存不是业务表，走 /kuerp/ 会被 RbacGuard 当成 kuerp_cache 表校验而误拦截。
 *
 * 仅超级管理员可访问：清缓存会短时抬高数据库压力，
 * 普通角色误点会造成全局性能抖动，因此不放开。
 */
@Controller('system/cache')
@UseGuards(JwtAuthGuard)
export class CacheController {
  constructor(private readonly cache: CacheService) {}

  /**
   * 查询缓存运行状态（容量、命中率、淘汰次数）。
   * @param user 当前登录用户
   * @returns 统计对象
   */
  @Get('stats')
  stats(@CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    return ok(this.cache.stats());
  }

  /**
   * 清空全部缓存。
   *
   * 使用场景：改了系统参数却不想等 TTL 自然过期；
   * 或怀疑某处缓存脏读时的手动兜底。
   *
   * @param user 当前登录用户
   * @returns { cleared: 被清空的条目数 }
   */
  @Post('clear')
  clear(@CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    const cleared = this.cache.clear();
    return ok({ cleared });
  }

  /**
   * 按前缀失效缓存（例如只清某个表的下拉选项）。
   *
   * @param prefix 前缀，如 `opt:kuerp_goods`
   * @param user 当前登录用户
   * @returns { removed: 被删除的条目数 }
   */
  @Post('evict')
  evict(@Query('prefix') prefix: string, @CurrentUser() user: any) {
    this.assertSuperAdmin(user);
    const p = String(prefix || '').trim();
    // 空前缀等价于清库，必须显式走 /clear，避免误操作
    if (!p) throw new ForbiddenException('prefix 不能为空，清空全部请调用 /system/cache/clear');
    return ok({ removed: this.cache.delByPrefix(p) });
  }

  /**
   * 仅超管可访问的断言。
   * @param user 当前登录用户
   */
  private assertSuperAdmin(user: any): void {
    if (Number(user?.id) !== 1) {
      throw new ForbiddenException('仅超级管理员可操作缓存');
    }
  }
}
