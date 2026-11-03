import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { SystemModule } from './system/system.module';
import { AiModule } from './ai/ai.module';
import { KuerpModule } from './kuerp/kuerp.module';
import { OpenApiModule } from './openapi/openapi.module';
import { ShopModule } from './shop/shop.module';
import { UploadModule } from './common/upload/upload.module';
import { AuditModule } from './common/audit/audit.module';
import { MessageModule } from './common/message/message.module';
import { WechatModule } from './common/wechat/wechat.module';
import { SchedulerModule } from './common/scheduler/scheduler.module';
import { CacheModule } from './common/cache/cache.module';
import { HealthModule } from './common/health/health.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, envFilePath: ['.env', '.env.example'] }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (cfg: ConfigService) => ({
        type: 'mysql',
        host: cfg.get('DB_HOST'),
        port: Number(cfg.get('DB_PORT') || 3306),
        username: cfg.get('DB_USER'),
        password: cfg.get('DB_PASSWORD'),
        database: cfg.get('DB_NAME'),
        charset: cfg.get('DB_CHARSET') || 'utf8mb4',
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        autoLoadEntities: true,
        synchronize: cfg.get('DB_SYNCHRONIZE') === 'true',
        timezone: '+08:00',
        extra: { supportBigNumbers: true, bigNumberStrings: false },
      }),
    }),
    AuthModule,
    SystemModule,
    AiModule,
    KuerpModule,
    OpenApiModule,
    ShopModule,
    UploadModule,
    AuditModule,
    // 基础设施：进程内缓存 / 健康检查 / 消息中心 / 微信令牌 / 定时作业
    CacheModule,
    HealthModule,
    MessageModule,
    WechatModule,
    SchedulerModule,
  ],
})
export class AppModule {}
