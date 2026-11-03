import { Global, Module } from '@nestjs/common';
import { AuditController } from './audit.controller';
import { AuditService } from './audit.service';

/**
 * 操作审计模块（全局）。
 *
 * 标 @Global 的原因：AuditInterceptor 在 main.ts 里以 useGlobalInterceptors 注册，
 * 但它的依赖（AuditService）仍需由某个模块导出；标全局后任何模块都无需重复 import。
 */
@Global()
@Module({
  controllers: [AuditController],
  providers: [AuditService],
  exports: [AuditService],
})
export class AuditModule {}
