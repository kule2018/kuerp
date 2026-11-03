import { Global, Module } from '@nestjs/common';
import { SchedulerController } from './scheduler.controller';
import { SchedulerService } from './scheduler.service';
import { JobsRegistrar } from './jobs.registrar';

/**
 * 定时任务模块（全局）。
 *
 * SchedulerService 导出后，其它模块可注册自己的作业（例如未来的「报表预聚合」）；
 * JobsRegistrar 只负责注册内置的 5 个作业。
 */
@Global()
@Module({
  controllers: [SchedulerController],
  providers: [SchedulerService, JobsRegistrar],
  exports: [SchedulerService],
})
export class SchedulerModule {}
