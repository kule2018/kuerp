import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  HttpStatus,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

/**
 * 统一响应拦截器：把所有成功响应包成 { code: 1, msg: 'success', data, ... }
 * 与原 FastAdmin 返回的 { code, msg, data, count, ... } 风格保持一致，便于前端 1:1 对接。
 */
export interface ApiResult {
  code: number;
  msg: string;
  data?: any;
  [key: string]: any;
}

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, ApiResult> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<ApiResult> {
    return next.handle().pipe(
      map((data) => {
        // 若控制器已手动返回标准结构，则直接透传
        if (data && typeof data === 'object' && 'code' in data && 'msg' in data) {
          return data as ApiResult;
        }
        return { code: 1, msg: 'success', data: data ?? null };
      }),
    );
  }
}

export function ok(data?: any, msg = 'success'): ApiResult {
  return { code: 1, msg, data };
}

export function fail(msg = '操作失败', code = 0): ApiResult {
  return { code, msg, data: null };
}

export const HTTP_OK = HttpStatus.OK;
