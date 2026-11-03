import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RbacGuard } from '../../common/guards/rbac.guard';
import { ok } from '../../common/response.interceptor';
import { FundsService } from './funds.service';

/**
 * 资金过账控制器。
 *
 * 职责：暴露资金过账/冲转的手动触发接口。常规流程下 TableService.examine()
 * 会在审核/反审时自动调用 FundsService，本控制器用于：
 *   1. 数据修复场景（如历史单据补过账 / 重新冲转）；
 *   2. 与库存过账引擎（PostingController）保持对称的手动运维入口。
 * 路由前缀 /kuerp/funds，与通用动态表 /kuerp/:table/* 三段静态路径不冲突。
 * 全部接口需 JWT 鉴权 + RBAC 节点校验。
 */
@UseGuards(JwtAuthGuard, RbacGuard)
@Controller('kuerp/funds')
export class FundsController {
  constructor(private readonly funds: FundsService) {}

  /**
   * 手动过账：对指定单据执行资金过账（幂等，已过账则跳过）。
   * POST /kuerp/funds/post  body: { table, id }
   * @param table 单据表名（如 collection / kuerp_payment / goods_purchase）
   * @param id 单据主键
   */
  @Post('post')
  async post(@Body('table') table: string, @Body('id') id: number) {
    return ok(await this.funds.post(table, Number(id)));
  }

  /**
   * 手动冲转：对指定单据执行资金反审冲转（幂等，未审核则跳过）。
   * POST /kuerp/funds/unpost  body: { table, id }
   * @param table 单据表名
   * @param id 单据主键
   */
  @Post('unpost')
  async unpost(@Body('table') table: string, @Body('id') id: number) {
    return ok(await this.funds.unpost(table, Number(id)));
  }
}
