import { Module } from '@nestjs/common';
import { FundsService } from './funds.service';
import { FundsController } from './funds.controller';

/**
 * 资金过账模块。
 *
 * 提供收付款单/核销单/转账单/其他收支单的审核过账与反审冲转，
 * 以及购货/销货/退货单据审核时的资金域联动（应收应付流水、往来余额、
 * 收付款状态、开票状态、采购销售费用、销售利润）。
 *
 * 被 TableModule 引入，由 TableService.examine() 在审核/反审时驱动。
 */
@Module({
  providers: [FundsService],
  controllers: [FundsController],
  exports: [FundsService],
})
export class FundsModule {}
