import { Controller, Get, HttpCode, ServiceUnavailableException } from '@nestjs/common';
import { DataSource } from 'typeorm';

/**
 * 健康检查接口（公开，无需登录）。
 *
 * 【为什么单独做一个 /health 而不是复用业务接口】
 * 容器编排（docker-compose healthcheck / K8s probe）需要一个**无鉴权**的探针：
 * 用 /kuerp/xxx 之类的业务接口会被 JwtAuthGuard 挡成 401，
 * 探针会把「服务正常但需要登录」误判为「服务挂了」，进而反复重启容器。
 *
 * 【为什么探针要连数据库】
 * 只看进程存活是不够的——NestJS 在数据库断开时进程照样活着，
 * 但所有业务接口都会 500。带上 `SELECT 1` 才能真正反映「能否对外提供服务」。
 */
@Controller('health')
export class HealthController {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 存活 + 依赖检查。
   *
   * @returns { status, uptime, db, timestamp }
   * @throws ServiceUnavailableException 数据库不可用时返回 503
   */
  @Get()
  @HttpCode(200)
  async check() {
    const startedAt = Date.now();
    let db = 'down';
    try {
      await this.dataSource.query('SELECT 1');
      db = 'up';
    } catch {
      db = 'down';
    }

    // 数据库不可用直接 503：让编排层知道「这个实例不应接收流量」，
    // 仅返回 200 + db:down 会让负载均衡继续把请求打进来
    if (db !== 'up') {
      throw new ServiceUnavailableException({
        status: 'error',
        db,
        timestamp: Math.floor(Date.now() / 1000),
      });
    }

    return {
      status: 'ok',
      db,
      // 数据库往返耗时（毫秒），用于区分「慢」与「不通」
      dbLatencyMs: Date.now() - startedAt,
      uptimeSec: Math.round(process.uptime()),
      timestamp: Math.floor(Date.now() / 1000),
    };
  }
}
