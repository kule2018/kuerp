import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TableService } from './table.service';
import { TableController } from './table.controller';
import { RbacGuard } from '../../common/guards/rbac.guard';
import { PostingModule } from '../posting/posting.module';
import { FundsModule } from '../funds/funds.module';

/**
 * 通用动态表模块：向全部 159 张 kuerp_* 表提供统一 CRUD/审核接口。
 * 与资料/购货/销货/仓库/资金等具体业务共用同一套实现，保证接口 1:1。
 * RbacGuard 提供角色节点鉴权（等效原系统 $auth->check）。
 * 导入 PostingModule 以便 TableService.examine 审核时联动库存过账；
 * 导入 FundsModule 以便审核时联动资金过账（收付款/核销/转账/收支/购销单据资金域）。
 */
@Module({
  imports: [TypeOrmModule, PostingModule, FundsModule],
  providers: [TableService, RbacGuard],
  controllers: [TableController],
  exports: [TableService],
})
export class TableModule {}
