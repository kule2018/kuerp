import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ok } from '../../common/response.interceptor';
import { ApprovalService, ApprovalUser } from './approval.service';

/**
 * 多级审批流控制器。
 *
 * 路由清单（挂在 /kuerp/approval/*，与通用表 /kuerp/:table/<标准动作> 不冲突）：
 *   POST /kuerp/approval/submit    提交审批（按金额生成审批链）
 *   POST /kuerp/approval/approve   审批通过（最后一级通过时自动过账）
 *   POST /kuerp/approval/reject    审批驳回
 *   GET  /kuerp/approval/status    某单据的审批进度（前端画进度条）
 *   GET  /kuerp/approval/history   某单据的审批历史
 *   GET  /kuerp/approval/todo      我的待办
 *
 * 鉴权说明：这里**只挂 JwtAuthGuard，不挂 RbacGuard**。
 * 原因：approval 不是业务表，rbac 节点里不存在 kuerp/approval；
 * 若强行挂上，非超管会被菜单级节点鉴权直接拦死，而审批权限本应由
 * kuerp_approval_flow.role_id 精细控制（见 ApprovalService.canApprove）。
 */
@Controller('kuerp/approval')
@UseGuards(JwtAuthGuard)
export class ApprovalController {
  constructor(private readonly svc: ApprovalService) {}

  /**
   * 提交审批。
   * @param body { doc_table, doc_id }
   * @param user 当前用户
   */
  @Post('submit')
  async submit(@Body() body: any, @CurrentUser() user: ApprovalUser) {
    const docTable = body?.doc_table || body?.docTable;
    const docId = Number(body?.doc_id ?? body?.docId ?? 0);
    return ok(await this.svc.submit(docTable, docId, user));
  }

  /**
   * 审批通过。
   * @param body { doc_table, doc_id, remark }
   * @param user 当前用户
   */
  @Post('approve')
  async approve(@Body() body: any, @CurrentUser() user: ApprovalUser) {
    const docTable = body?.doc_table || body?.docTable;
    const docId = Number(body?.doc_id ?? body?.docId ?? 0);
    return ok(await this.svc.approve(docTable, docId, user, body?.remark || ''));
  }

  /**
   * 审批驳回。
   * @param body { doc_table, doc_id, remark }
   * @param user 当前用户
   */
  @Post('reject')
  async reject(@Body() body: any, @CurrentUser() user: ApprovalUser) {
    const docTable = body?.doc_table || body?.docTable;
    const docId = Number(body?.doc_id ?? body?.docId ?? 0);
    return ok(await this.svc.reject(docTable, docId, user, body?.remark || ''));
  }

  /**
   * 审批进度。
   * @param q { doc_table, doc_id }
   */
  @Get('status')
  async status(@Query() q: any) {
    return ok(await this.svc.status(q?.doc_table || q?.docTable, Number(q?.doc_id ?? q?.docId ?? 0)));
  }

  /**
   * 审批历史。
   * @param q { doc_table, doc_id }
   */
  @Get('history')
  async history(@Query() q: any) {
    return ok(await this.svc.history(q?.doc_table || q?.docTable, Number(q?.doc_id ?? q?.docId ?? 0)));
  }

  /**
   * 我的待办。
   * @param q { page, limit, doc_table }
   * @param user 当前用户
   */
  @Get('todo')
  async todo(@Query() q: any, @CurrentUser() user: ApprovalUser) {
    return ok(
      await this.svc.todo(user, {
        page: Number(q?.page) || 1,
        limit: Number(q?.limit) || 20,
        docTable: q?.doc_table || q?.docTable || '',
      }),
    );
  }
}
