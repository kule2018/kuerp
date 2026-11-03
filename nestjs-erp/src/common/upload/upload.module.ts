import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { UploadController } from './upload.controller';
import { UploadService, createMulterOptions } from './upload.service';
import { ShopModule } from '../../shop/shop.module';
import { AuthModule } from '../../auth/auth.module';
import { ShopOrJwtGuard } from '../guards/shop-or-jwt.guard';

/**
 * 文件上传模块（框架能力，非业务模块）。
 *
 * 供给关系：
 * - MulterModule 注册全局存储/校验策略（createMulterOptions）；
 * - UploadController 暴露 POST /api/upload、/api/upload/multi、/api/upload/image 与 GET /api/upload/config；
 * - UploadService 导出给其它模块（如 system 的 Logo 上传需要归一化结果时复用）。
 *
 * 静态访问由 main.ts 的 useStaticAssets 挂载，不在模块内声明。
 */
@Module({
  imports: [MulterModule.register(createMulterOptions()), ShopModule, AuthModule],
  controllers: [UploadController],
  providers: [UploadService, ShopOrJwtGuard],
  exports: [UploadService, MulterModule],
})
export class UploadModule {}
