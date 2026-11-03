import { Global, Module } from '@nestjs/common';
import { MessageController } from './message.controller';
import { MessageService } from './message.service';

/**
 * 消息中心模块（全局）。
 *
 * 标 @Global：定时作业（库存预警/保质期/账期）与审批流都要写消息，
 * 把这些跨模块依赖收敛为全局可注入，避免每个模块都 imports 一次。
 */
@Global()
@Module({
  controllers: [MessageController],
  providers: [MessageService],
  exports: [MessageService],
})
export class MessageModule {}
