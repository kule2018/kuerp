import { Module } from '@nestjs/common';
import { TableModule } from './table/table.module';
import { PostingModule } from './posting/posting.module';
import { BizModule } from './biz/biz.module';
import { ApprovalModule } from './approval/approval.module';

/**
 * 进销存业务聚合模块。
 *
 * 采用「通用动态表」方案：TableController 以 /kuerp/:table/<action> 路由
 * 对全部 kuerp_* 表（商品/类别/单位/仓库/客户/供应商/购货/销货/仓库/资金/报表…）
 * 统一暴露 index/get/add/edit/del/examine 接口，与原 FastAdmin 接口 1:1 对齐。
 *
 * 需要特殊业务逻辑的表（如购货/销货审核联动库存、资金核销）在后续阶段以
 * 专用控制器叠加在同一 /kuerp/<模块> 命名空间下，静态路由优先于动态路由，互不冲突。
 * PostingModule 提供审核过账引擎与以销定购/智能补货看板（/kuerp/boards/*）。
 */
@Module({
  imports: [TableModule, PostingModule, BizModule, ApprovalModule],
})
export class KuerpModule {}
