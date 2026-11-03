import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';

/**
 * 统一异常过滤器：把异常包成与原系统一致的 { code: 0, msg, data: null }
 */
@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response: any = ctx.getResponse();
    const request = ctx.getRequest();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let msg = '服务器内部错误';

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res: any = exception.getResponse();
      msg = (res && res.message) || exception.message || '请求错误';
      if (Array.isArray(msg)) msg = msg.join('; ');
      // passport-jwt 对过期/非法 token 抛的是默认英文「Unauthorized」，
      // 统一换成用户能看懂的提示；策略里自定义的「登录已过期/账号不可用」原样保留
      if (status === HttpStatus.UNAUTHORIZED && msg === 'Unauthorized') {
        msg = '登录已过期，请重新登录';
      }
    } else if (exception instanceof Error) {
      msg = exception.message;
      this.logger.error(`[Unhandled] ${exception.stack}`);
    }

    const body = { code: 0, msg, data: null };
    // 保留真实 HTTP 状态码（401/403/400…），不再把错误包成 200——
    // 否则 RBAC 守卫抛出的 403（越权）、Passport 的 401（未登录）会被静默成
    // 「成功响应」，导致接口权限/登录失效「看起来没生效」。
    // 前端响应拦截器会按真实状态码提示（401 跳登录页、其它弹错误文案）。
    response.status(status).json(body);
  }
}
