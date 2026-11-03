import * as fs from 'fs';
import * as path from 'path';

/**
 * 上传模块配置（全部可由环境变量覆盖，便于容器化部署时改挂载点）
 *
 * 设计要点：
 * 1. 存储根目录默认 ./uploads，落在应用工作目录下；容器部署时挂 volume 即可持久化。
 * 2. 访问前缀默认 /uploads，与 main.ts 里 useStaticAssets 的挂载点保持一致。
 * 3. 白名单同时约束「扩展名」与「MIME」：前者防伪造后缀，后者防改扩展名的可执行文件。
 * 4. 一律不落原文件名，文件名由服务端生成（时间戳 + 随机串），从根上杜绝路径穿越。
 */

/** 上传根目录（绝对路径） */
export const UPLOAD_ROOT = path.resolve(process.env.UPLOAD_DIR || 'uploads');

/** 静态访问前缀（不带结尾斜杠） */
export const UPLOAD_URL_PREFIX = (process.env.UPLOAD_URL_PREFIX || '/uploads').replace(/\/+$/, '');

/** 单文件大小上限（字节），默认 10MB */
export const UPLOAD_MAX_SIZE = Number(process.env.UPLOAD_MAX_SIZE || 10 * 1024 * 1024);

/** 单次多文件上传的数量上限 */
export const UPLOAD_MAX_COUNT = Number(process.env.UPLOAD_MAX_COUNT || 20);

/**
 * 扩展名白名单：分组便于后续按需放开。
 * 图片用于商品主图/图集/轮播/Logo；文档用于原始单据附件；压缩包用于批量导入包。
 */
export const ALLOWED_EXT: Record<string, string[]> = {
  image: ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.svg'],
  doc: ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.csv', '.txt'],
  archive: ['.zip', '.rar', '.7z'],
};

/** 允许上传的全部扩展名（扁平化） */
export const ALLOWED_EXT_FLAT = Object.values(ALLOWED_EXT).reduce<string[]>((a, b) => a.concat(b), []);

/**
 * 扩展名 -> 允许的 MIME 前缀。
 * 之所以用前缀而非精确列表：浏览器/系统给出的 MIME 存在变体（如 image/jpg 与 image/jpeg），
 * 用前缀匹配更稳；对 excel 这类 MIME 混乱的类型则退化为「仅校验扩展名」。
 */
export const MIME_BY_EXT: Record<string, string[]> = {
  '.jpg': ['image/'],
  '.jpeg': ['image/'],
  '.png': ['image/'],
  '.gif': ['image/'],
  '.webp': ['image/'],
  '.bmp': ['image/'],
  '.svg': ['image/'],
  '.pdf': ['application/pdf'],
  '.txt': ['text/plain'],
  '.csv': ['text/csv', 'application/vnd.ms-excel', 'text/plain'],
  '.doc': ['application/msword', 'application/octet-stream'],
  '.docx': ['application/vnd.openxmlformats-officedocument.wordprocessingml', 'application/octet-stream'],
  '.xls': ['application/vnd.ms-excel', 'application/octet-stream'],
  '.xlsx': ['application/vnd.openxmlformats-officedocument.spreadsheetml', 'application/octet-stream'],
  '.zip': ['application/zip', 'application/x-zip', 'application/octet-stream'],
  '.rar': ['application/vnd.rar', 'application/x-rar', 'application/octet-stream'],
  '.7z': ['application/x-7z-compressed', 'application/octet-stream'],
};

/**
 * 确保某目录存在（递归创建）。
 * @param dir 目标绝对路径
 */
export function ensureDir(dir: string): void {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
}

/**
 * 按日期生成相对目录，形如 2026/10/26。
 * 作用：单目录文件数过万后 ext4/NTFS 的目录项检索会明显变慢，按天分桶是最省事的缓解。
 * @param d 时间对象，默认当前时间
 * @returns 相对路径（以 / 分隔，跨平台一致）
 */
export function dateSubDir(d = new Date()): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}/${m}/${day}`;
}

/**
 * 校验扩展名与 MIME 是否在白名单内。
 * @param originalName 客户端原始文件名（只取扩展名，不参与落盘命名）
 * @param mimeType 客户端声明的 MIME
 * @returns 合法返回 { ok: true, ext }，否则 { ok: false, reason }
 */
export function validateFile(
  originalName: string,
  mimeType: string,
): { ok: boolean; ext: string; reason?: string } {
  const ext = path.extname(originalName || '').toLowerCase();
  if (!ext) return { ok: false, ext: '', reason: '文件缺少扩展名' };
  if (!ALLOWED_EXT_FLAT.includes(ext)) {
    return { ok: false, ext, reason: `不支持的文件类型：${ext}` };
  }
  const allowMimes = MIME_BY_EXT[ext];
  // 有 MIME 约束则做前缀匹配；客户端未带 MIME 时（部分代理会丢）只信扩展名
  if (allowMimes && mimeType) {
    const hit = allowMimes.some((m) => mimeType.toLowerCase().startsWith(m));
    if (!hit) return { ok: false, ext, reason: `文件内容与扩展名不匹配：${mimeType}` };
  }
  return { ok: true, ext };
}
