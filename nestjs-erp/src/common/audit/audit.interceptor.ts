import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { AuditService } from './audit.service';

/** 需要跳过审计的路径前缀（登录涉及密码、上传是二进制、AI 有独立调用日志） */
const SKIP_PREFIX = ['/auth/login', '/auth/change-pwd', '/api/upload', '/ai/'];

/** 需要脱敏的字段名（小写比较） */
const SENSITIVE_KEYS = ['password', 'pwd', 'oldpassword', 'newpassword', 'confirmpassword', 'token', 'secret', 'api_key', 'apikey'];

/** 归一到动作词的映射表：把各种 action 名收敛成有限的几个类别，便于筛选统计 */
const ACTION_ALIAS: Record<string, string> = {
  add: 'add',
  create: 'add',
  edit: 'edit',
  update: 'edit',
  save: 'edit',
  del: 'del',
  delete: 'del',
  remove: 'del',
  examine: 'examine',
  audit: 'examine',
  approve: 'examine',
  reject: 'examine',
  import: 'import',
  export: 'export',
  reduction: 'restore',
  realdel: 'del',
};

/**
 * 操作审计拦截器（全局）。
 *
 * 只记录「写操作」：POST / PUT / PATCH / DELETE。
 * 理由：GET 是查询，ERP 里查询量远大于写入，全记会让日志表迅速膨胀，
 * 而真正需要追责的是「谁改了数据」。
 *
 * 记录时机：在响应成功或抛错之后（tap），此时能拿到最终 code/msg 与真实耗时。
 * 写库是 fire-and-forget：AuditService.write 内部已吞掉异常，不会反过来影响业务响应。
 */
@Injectable()
export class AuditInterceptor implements NestInterceptor {
  constructor(private readonly audit: AuditService) {}

  intercept(ctx: ExecutionContext, next: CallHandler): Observable<any> {
    const req = ctx.switchToHttp().getRequest();
    const method = String(req.method || '').toUpperCase();
    const path = String(req.path || req.url || '');

    // 非写操作 / 跳过项：直接放行，零开销
    if (!['POST', 'PUT', 'PATCH', 'DELETE'].includes(method)) return next.handle();
    if (SKIP_PREFIX.some((p) => path.startsWith(p))) return next.handle();

    const started = Date.now();
    const base = this.buildBase(req, path, method);

    return next.handle().pipe(
      tap({
        next: (body: any) => {
          // ResponseInterceptor 已把结果包成 { code, msg, data }，code=1 视为成功
          const success = body && typeof body === 'object' ? Number(body.code) === 1 : true;
          const msg = (body && typeof body === 'object' && body.msg) || '';
          void this.audit.write({ ...base, success, msg: String(msg), costMs: Date.now() - started });
        },
        error: (err: any) => {
          void this.audit.write({
            ...base,
            success: false,
            msg: String(err?.message || '请求异常'),
            costMs: Date.now() - started,
          });
        },
      }),
    );
  }

  /**
   * 组装日志的公共字段（模块 / 动作 / 操作人 / IP 等）。
   * @param req express 请求
   * @param path 请求路径
   * @param method HTTP 方法
   * @returns 除 success/msg/costMs 外的日志字段
   */
  private buildBase(req: any, path: string, method: string) {
    const segs = path.split('/').filter(Boolean);
    // /kuerp/<table>/<action>：第一段是表名（连字符转下划线，与后端表名一致）
    let module = segs[0] || '';
    let action = '';
    if (segs[0] === 'kuerp' && segs.length >= 3) {
      module = String(segs[1]).replace(/-/g, '_');
      action = segs[2];
    } else if (segs.length >= 3) {
      // /system/admin/add -> system:admin
      module = `${segs[0]}:${segs[1]}`;
      action = segs[2];
    } else if (segs.length >= 2) {
      module = segs[0];
      action = segs[1];
    }

    const body = req.body && typeof req.body === 'object' ? req.body : {};
    return {
      adminId: Number(req.user?.id || 0),
      username: String(req.user?.username || ''),
      module,
      action: ACTION_ALIAS[action] || (action ? action : 'other'),
      method,
      path,
      rowId: String(body.id ?? body.ids ?? ''),
      params: safeStringify(body),
      ip: clientIp(req),
      ua: String(req.headers?.['user-agent'] || '').slice(0, 300),
    };
  }
}

/**
 * 取客户端真实 IP：优先 X-Forwarded-For 的第一段（反代/容器场景），否则用 socket 地址。
 * @param req express 请求
 * @returns IP 字符串
 */
function clientIp(req: any): string {
  const xff = String(req.headers?.['x-forwarded-for'] || '');
  if (xff) return xff.split(',')[0].trim().slice(0, 60);
  return String(req.ip || req.socket?.remoteAddress || '').slice(0, 60);
}

/**
 * 参数序列化（脱敏 + 限长）。
 * 为什么不直接 JSON.stringify：上传类请求的 body 里可能有巨型 base64，
 * 以及 password 这类不该落库的字段。
 * @param body 请求体
 * @returns 序列化后的字符串（最多 2000 字）
 */
function safeStringify(body: any): string {
  try {
    const clone = mask(body);
    const s = JSON.stringify(clone);
    return s.length > 2000 ? `${s.slice(0, 1990)}…` : s;
  } catch {
    return '';
  }
}

/**
 * 递归脱敏：命中 SENSITIVE_KEYS 的值替换为 ***。
 * @param v 任意值
 * @param depth 当前深度（防循环引用爆栈）
 * @returns 脱敏后的副本
 */
function mask(v: any, depth = 0): any {
  if (v === null || v === undefined) return v;
  if (depth > 6) return '[deep]';
  if (Array.isArray(v)) return v.slice(0, 50).map((x) => mask(x, depth + 1));
  if (typeof v === 'object') {
    const out: Record<string, any> = {};
    for (const [k, val] of Object.entries(v)) {
      if (SENSITIVE_KEYS.includes(k.toLowerCase())) out[k] = '***';
      else out[k] = mask(val, depth + 1);
    }
    return out;
  }
  // 超长字符串（如 base64）只保留前 120 字
  if (typeof v === 'string' && v.length > 200) return `${v.slice(0, 120)}…(${v.length})`;
  return v;
}
