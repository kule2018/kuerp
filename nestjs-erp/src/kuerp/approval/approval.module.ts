import { Module } from '@nestjs/common';
import { ApprovalController } from './approval.controller';
import { ApprovalService } from './approval.service';
import { TableModule } from '../table/table.module';

/**
 * 多级审批流模块。
 *
 * 依赖 TableModule 而非直接依赖 PostingService：
 * 最后一级通过时调用 TableService.examine()，让「审核 → 过账」这条链路
 * 保持唯一入口，避免审批流绕开结账守卫、库存校验等既有保护。
 * MessageModule 是 @Global 的，这里无需 import。
 */
@Module({
  imports: [TableModule],
  controllers: [ApprovalController],
  providers: [ApprovalService],
  exports: [ApprovalService],
})
export class ApprovalModule {}
