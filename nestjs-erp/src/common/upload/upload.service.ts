import { Injectable, Logger } from '@nestjs/common';
import * as crypto from 'crypto';
import * as path from 'path';
import {
  ALLOWED_EXT_FLAT,
  UPLOAD_MAX_COUNT,
  UPLOAD_MAX_SIZE,
  UPLOAD_ROOT,
  UPLOAD_URL_PREFIX,
  dateSubDir,
  ensureDir,
  validateFile,
} from './upload.config';

// multer 2.x 未内置 .d.ts，且本项目的 tsc 开了 skipLibCheck，
// 这里用 require 拿到运行时对象即可（参数在下方 options 里已逐项声明）。
// eslint-disable-next-line @typescript-eslint/no-var-requires
const multer: any = require('multer');

/** 上传成功后的归一化描述（前端 BaseUpload 兼容 {url} 结构） */
export interface UploadedFileInfo {
  /** 可直接用于 <img src> 的相对地址，如 /uploads/2026/10/26/xxx.png */
  url: string;
  /** 原始文件名（仅回显用，不参与落盘） */
  name: string;
  /** 落盘后的文件名 */
  filename: string;
  /** 字节数 */
  size: number;
  /** 扩展名（小写，含点） */
  ext: string;
  /** MIME */
  mime: string;
}

/** 模块级日志器：createMulterOptions 是纯函数，没有 this，用它记录被拒绝的上传 */
const logger = new Logger('UploadService');

/**
 * 构造 multer 配置（供 MulterModule.register 与 FileInterceptor 共用）。
 *
 * 之所以抽成模块级纯函数而不是类方法：
 * MulterModule.registerAsync 的 useFactory 在动态模块作用域内解析依赖，
 * 注入本模块 providers 里的 UploadService 需要额外的 imports 转发，容易绕成循环依赖；
 * 而这份配置只依赖常量与 multer 运行时对象，做成纯函数最省事也最不容易出错。
 *
 * 为什么用 diskStorage 而不是内存存储：
 * ERP 的商品图集 / 原始单据附件常有几十张、单张数 MB，
 * 内存存储会把并发上传的峰值直接压到进程堆上，风险远大于落盘。
 *
 * @returns multer 可接受的 options 对象
 */
export function createMulterOptions() {
  return {
      storage: multer.diskStorage({
        /**
         * 决定落盘目录：uploads/yyyy/MM/dd（按日期分桶）
         * @param _req 原始请求（未使用）
         * @param _file 文件对象（未使用，目录与文件类型无关）
         * @param cb 回调
         */
        destination: (_req: any, _file: any, cb: (err: Error | null, dest: string) => void) => {
          const dir = path.join(UPLOAD_ROOT, dateSubDir());
          try {
            ensureDir(dir);
            cb(null, dir);
          } catch (e: any) {
            cb(e, '');
          }
        },

        /**
         * 决定文件名：时间戳-随机串-短哈希 + 原扩展名。
         * 完全不使用客户端文件名，避免 ../ 穿越与同名覆盖；
         * 随机串保证同毫秒多文件不冲突，短哈希便于人工排查时定位。
         * @param _req 原始请求
         * @param file multer 文件对象（含 originalname）
         * @param cb 回调
         */
        filename: (_req: any, file: any, cb: (err: Error | null, name: string) => void) => {
          const ext = path.extname(file.originalname || '').toLowerCase();
          const stamp = Date.now();
          const rand = crypto.randomBytes(6).toString('hex');
          cb(null, `${stamp}-${rand}${ext.slice(0, 12)}`);
        },
      }),

      limits: {
        fileSize: UPLOAD_MAX_SIZE,
        files: UPLOAD_MAX_COUNT,
      },

      /**
       * 类型闸门。
       * 校验不通过时回调 (null, false) 静默丢弃，而不是抛 Error——
       * 抛错会变成 500 且信息不友好；静默丢弃后由控制器返回明确的业务提示。
       */
      fileFilter: (_req: any, file: any, cb: (err: Error | null, accept: boolean) => void) => {
        const { ok, reason } = validateFile(file.originalname || '', file.mimetype || '');
        if (!ok) {
          // 挂到 file 上，控制器读不到 file 时也能给出原因
          file.__rejectReason = reason;
          logger.warn(`拒绝上传：${file.originalname} -> ${reason}`);
          cb(null, false);
          return;
        }
        cb(null, true);
      },
  };
}

/**
 * 上传服务：负责目录准备与结果归一化。
 *
 * 与 multer 的分工：
 * - multer 负责接收流并写盘（diskStorage 配置见 createMulterOptions）；
 * - 业务侧只关心 UploadedFileInfo，不感知磁盘路径。
 */
@Injectable()
export class UploadService {
  private readonly logger = new Logger(UploadService.name);

  constructor() {
    // 启动即建根目录：否则容器首启时首个上传会因目录不存在而失败
    ensureDir(UPLOAD_ROOT);
    this.logger.log(`上传根目录：${UPLOAD_ROOT}，访问前缀：${UPLOAD_URL_PREFIX}`);
  }

  /**
   * 暴露 multer 配置，便于外部（如测试或多存储策略）复用同一份规则。
   * @returns multer options
   */
  buildMulterOptions() {
    return createMulterOptions();
  }

  /**
   * 把 multer 的 file 对象归一化成前端可直接消费的结构。
   * @param file multer 写入后的文件对象（含 path/filename/size/mimetype/originalname）
   * @returns 归一化信息；file 为空时返回 null
   */
  normalize(file: any): UploadedFileInfo | null {
    if (!file || !file.filename) return null;
    // multer 给出的是绝对路径，这里反推出相对根目录的子路径再拼访问前缀
    const rel = path
      .relative(UPLOAD_ROOT, file.path)
      .split(path.sep)
      .join('/');
    return {
      url: `${UPLOAD_URL_PREFIX}/${rel}`,
      name: file.originalname || file.filename,
      filename: file.filename,
      size: Number(file.size || 0),
      ext: path.extname(file.filename).toLowerCase(),
      mime: file.mimetype || '',
    };
  }

  /** 允许的扩展名清单（供前端 accept 提示与文档展示） */
  allowedExt(): string[] {
    return ALLOWED_EXT_FLAT;
  }

  /** 单文件大小上限（字节） */
  maxSize(): number {
    return UPLOAD_MAX_SIZE;
  }
}
