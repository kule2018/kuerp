import { Module } from '@nestjs/common';
import { BizController } from './biz.controller';
import { BizService } from './biz.service';

/**
 * 业务扩展模块。
 *
 * 把原系统散落在各控制器里的「取数辅助 / 弹窗选择 / 业务动作」接口
 * 统一收敛到 /kuerp/<模块>/<动作>，与通用动态表接口互补：
 *   - TableModule  负责标准 CRUD（index/get/add/edit/del/examine…）
 *   - BizModule    负责单据所需的联动取数与业务动作（单位价格、序列号、
 *                  核销源单、订货单发货、组装拆卸模板、库存校验…）
 */
@Module({
  controllers: [BizController],
  providers: [BizService],
  exports: [BizService],
})
export class BizModule {}
