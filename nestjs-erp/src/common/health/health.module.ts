import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';

/**
 * 健康检查模块。
 *
 * 只有控制器没有服务：探针逻辑足够简单，直接注入 DataSource 执行 `SELECT 1` 即可，
 * 不必再抽一层 Service（多一层只增加阅读成本）。
 */
@Module({
  controllers: [HealthController],
})
export class HealthModule {}
