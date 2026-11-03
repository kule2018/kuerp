import {
  Controller,
  Get,
  HttpException,
  HttpStatus,
  Post,
  UploadedFile,
  UploadedFiles,
  UseFilters,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { ShopOrJwtGuard } from '../guards/shop-or-jwt.guard';
import { fail, ok } from '../response.interceptor';
import { UploadService } from './upload.service';
import { UploadExceptionFilter } from './upload.exception-filter';
import { UPLOAD_MAX_COUNT, UPLOAD_URL_PREFIX } from './upload.config';

/**
 * 文件上传接口。
 *
 * 路由刻意放在 /api/upload（不是 /kuerp/...）：
 * 1. 前端 DsUpload 组件的默认 action 就是 /api/upload；
 * 2. RBAC 守卫只拦 /kuerp/ 前缀，上传属框架能力，登录即可用。
 *
 * multer 的存储/校验配置统一在 upload.module.ts 通过 MulterModule.registerAsync 注入，
 * 因此这里调用 FileInterceptor 时不再传 localOptions（传了会覆盖全局配置）。
 *
 * 返回结构同时给出顶层 url 与标准 data.url，兼容两种前端解析习惯。
 */
@Controller('api/upload')
@UseGuards(ShopOrJwtGuard)
@UseFilters(UploadExceptionFilter)
export class UploadController {
  constructor(private readonly uploadService: UploadService) {}

  /**
   * 上传前的能力探测：前端据此渲染 accept 提示与大小上限文案。
   * 放在鉴权之后，避免未登录者探测服务端配置。
   */
  @Get('config')
  config() {
    return ok({
      urlPrefix: UPLOAD_URL_PREFIX,
      maxSize: this.uploadService.maxSize(),
      maxCount: UPLOAD_MAX_COUNT,
      accept: this.uploadService.allowedExt(),
    });
  }

  /**
   * 单文件上传（字段名 file）。
   * @param file multer 写入后的文件对象
   * @returns 成功 { code:1, data:{url,name,size,...}, url }；被类型闸门拦下时抛 400
   */
  @Post()
  @UseInterceptors(FileInterceptor('file'))
  single(@UploadedFile() file: any) {
    return this.handleOne(file);
  }

  /**
   * 多文件上传（字段名 files，最多 UPLOAD_MAX_COUNT 个）。
   * 用于商品图集、原始单据多附件这类场景，一次请求落多个文件。
   * @param files multer 文件数组
   * @returns 归一化后的文件信息数组
   */
  @Post('multi')
  @UseInterceptors(FilesInterceptor('files', UPLOAD_MAX_COUNT))
  multi(@UploadedFiles() files: any[]) {
    const list = Array.isArray(files) ? files : [];
    const infos = list.map((f) => this.uploadService.normalize(f)).filter(Boolean);
    if (!infos.length) {
      return fail(`没有可用的文件（仅支持 ${this.uploadService.allowedExt().join(' / ')}）`);
    }
    return ok(infos, `成功上传 ${infos.length} 个文件`);
  }

  /**
   * 兼容原 FastAdmin 的字段名 image。
   * 旧页面习惯用 `image` 作为上传字段，这里做一层兜底，减少前端改造量。
   */
  @Post('image')
  @UseInterceptors(FileInterceptor('image'))
  image(@UploadedFile() file: any) {
    return this.handleOne(file);
  }

  /**
   * 统一处理单文件结果。
   * @param file multer 文件对象（可能为 undefined：被 fileFilter 静默丢弃）
   * @returns 标准响应对象
   */
  private handleOne(file: any) {
    if (!file) {
      const mb = Math.round(this.uploadService.maxSize() / 1024 / 1024);
      throw new HttpException(
        `上传失败：文件类型不支持或超出大小限制（单文件上限 ${mb}MB）`,
        HttpStatus.BAD_REQUEST,
      );
    }
    const info = this.uploadService.normalize(file);
    if (!info) {
      throw new HttpException('上传失败：文件未正确落盘', HttpStatus.INTERNAL_SERVER_ERROR);
    }
    // 同时给顶层 url，兼容历史组件 data?.url 的解析方式
    return { code: 1, msg: '上传成功', data: info, url: info.url };
  }
}
