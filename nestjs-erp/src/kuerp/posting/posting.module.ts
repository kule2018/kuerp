import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PostingService } from './posting.service';
import { SummaryService } from './summary.service';
import { PostingController } from './posting.controller';
import { RbacGuard } from '../../common/guards/rbac.guard';

/**
 * 业务过账 / 看板模块：
 * - PostingService：审核单据联动库存、收发明细、移动平均成本，支持反审冲转；
 * - PostingController：以销定购 / 智能补货看板 + 生成购货订单。
 * 导出 PostingService 供 TableService 在 examine 时调用。
 */
@Module({
  imports: [TypeOrmModule],
  providers: [PostingService, SummaryService, RbacGuard],
  controllers: [PostingController],
  exports: [PostingService],
})
export class PostingModule {}
