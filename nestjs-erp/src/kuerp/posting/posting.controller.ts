import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RbacGuard } from '../../common/guards/rbac.guard';
import { ok } from '../../common/response.interceptor';
import { PostingService } from './posting.service';

/**
 * 看板 / 采购生成控制器（数据面板「生成单据」能力，见开发文档 5.购货/10.以销定购看板.md、11.智能补货.md）。
 * 路由前缀 /kuerp/boards，与通用动态表 /kuerp/:table/* 三段静态路径不冲突。
 * 全部接口需 JWT 鉴权 + RBAC 节点校验。
 */
@Controller('kuerp/boards')
@UseGuards(JwtAuthGuard, RbacGuard)
export class PostingController {
  constructor(private readonly svc: PostingService) {}

  /** 智能补货看板：销货订单待发量 - 当前库存 = 建议采购量 */
  @Get('replenishment')
  async replenishment() {
    return ok(await this.svc.replenishmentBoard());
  }

  /** 以销定购看板：以销定购驱动采购建议 */
  @Get('purchaseby')
  async purchaseby() {
    return ok(await this.svc.purchaseByBoard());
  }

  /**
   * 由看板勾选生成购货订单。
   * body: { rows: [{ goods_code, number, unit_price?, supplyer_code? }] }
   */
  @Post('generate')
  async generate(@Body() body: { rows: any[] }) {
    return ok(await this.svc.generatePurchaseOrder(body?.rows || []), '已生成购货订单');
  }
}
