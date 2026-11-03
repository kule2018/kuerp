import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpStatus,
  Logger,
} from '@nestjs/common';

/**
 * multer 异常过滤器。
 *
 * 为什么需要它：
 * multer 超限（LIMIT_FILE_SIZE / LIMIT_FILE_COUNT / LIMIT_UNEXPECTED_FILE）抛的是
 * 普通 Error 子类（MulterError），不继承 HttpException，会被全局过滤器兜成
 * 「服务器内部错误」500 → 前端只能看到一条无意义的报错。
 * 这里把这些已知错误翻译成可读的业务提示。
 *
 * 只在 UploadController 上挂载，不污染全局。
 */
@Catch()
export class UploadExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(UploadExceptionFilter.name);

  /** MulterError code -> 中文提示 */
  private static readonly MESSAGES: Record<string, string> = {
    LIMIT_FILE_SIZE: '文件超出大小限制',
    LIMIT_FILE_COUNT: '文件数量超出限制',
    LIMIT_UNEXPECTED_FILE: '上传字段名不正确（单文件用 file，多文件用 files）',
    LIMIT_PART_COUNT: '表单分段数量超出限制',
    LIMIT_FIELD_KEY: '表单字段名过长',
    LIMIT_FIELD_VALUE: '表单字段值过大',
    LIMIT_FIELD_COUNT: '表单字段数量超出限制',
  };

  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response: any = ctx.getResponse();
    const code = String(exception?.code || '');
    const msg = UploadExceptionFilter.MESSAGES[code];

    if (msg) {
      // 已知的 multer 限制错误：业务可读提示，HTTP 仍返回 200 由前端按 code 判断
      response.status(HttpStatus.OK).json({ code: 0, msg, data: null });
      return;
    }

    // 其它异常（含 HttpException）交回全局过滤器语义：直接按原状输出
    const status = exception?.getStatus?.() ?? HttpStatus.INTERNAL_SERVER_ERROR;
    const fallback = exception?.message || '上传失败';
    if (!exception?.getStatus?.()) {
      this.logger.error(`[Upload] ${exception?.stack || fallback}`);
    }
    response.status(HttpStatus.OK).json({ code: 0, msg: fallback, data: null });
    void status;
  }
}
