import { Global, Module } from '@nestjs/common';
import { CacheService } from './cache.service';
import { CacheController } from './cache.controller';

/**
 * 内存缓存模块。
 *
 * 声明为 @Global()：缓存是横切基础设施，业务模块（表格、过账、权限）都要用，
 * 全局注册后各模块无需 imports 即可注入 CacheService，避免在十多个 module 里重复声明。
 */
@Global()
@Module({
  controllers: [CacheController],
  providers: [CacheService],
  exports: [CacheService],
})
export class CacheModule {}
