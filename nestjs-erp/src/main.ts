import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger, HttpStatus } from '@nestjs/common';
import { NestExpressApplication } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';
import { HttpExceptionFilter } from './common/http-exception.filter';
import { ResponseInterceptor } from './common/response.interceptor';
import { UPLOAD_ROOT, UPLOAD_URL_PREFIX, ensureDir } from './common/upload/upload.config';
import { AuditInterceptor } from './common/audit/audit.interceptor';
import { AuditService } from './common/audit/audit.service';

/**
 * 应用启动入口
 * - 全局开启 class-validator 校验（transform 自动转换入参类型）
 * - 注册统一响应拦截器与统一异常过滤器（与原 FastAdmin 的 {code,msg,data} 风格对齐）
 * - 开启 CORS 以支持前后端分离部署
 * - 托管 /uploads 静态目录，供上传后的商品图、附件直接以 URL 访问
 */
async function bootstrap() {
  // 用 NestExpressApplication 而非默认 INestApplication，
  // 否则拿不到 useStaticAssets（express 适配器专有方法）
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { cors: true });
  const config = app.get(ConfigService);
  const prefix = config.get<string>('GLOBAL_PREFIX') || '';
  if (prefix) app.setGlobalPrefix(prefix);

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: false,
      forbidUnknownValues: false,
      errorHttpStatusCode: HttpStatus.BAD_REQUEST,
    }),
  );
  // 拦截器顺序：审计在外层（能测到完整耗时并把最终 code/msg 记下来），响应包装在内层
  app.useGlobalInterceptors(new AuditInterceptor(app.get(AuditService)), new ResponseInterceptor());
  app.useGlobalFilters(new HttpExceptionFilter());
  app.enableCors({ origin: true, credentials: true });

  // 静态资源：/uploads/yyyy/MM/dd/xxx.png -> <cwd>/uploads/yyyy/MM/dd/xxx.png
  // index:false 避免目录被当作站点首页；maxAge 让浏览器缓存 7 天，图片不必反复回源
  ensureDir(UPLOAD_ROOT);
  app.useStaticAssets(UPLOAD_ROOT, {
    prefix: `${UPLOAD_URL_PREFIX}/`,
    index: false,
    maxAge: 7 * 24 * 60 * 60 * 1000,
  });

  const port = config.get<number>('PORT') || 3000;
  await app.listen(port);
  Logger.log(`进销存 ERP API 已启动: http://localhost:${port}${prefix ? '/' + prefix : ''}`, 'Bootstrap');
  Logger.log(`静态资源目录: ${UPLOAD_ROOT} -> ${UPLOAD_URL_PREFIX}/`, 'Bootstrap');
}

bootstrap();
