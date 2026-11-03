import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/**
 * 提取当前登录用户：@CurrentUser() 等价于 Spring Security 的 SecurityContext。
 */
export const CurrentUser = createParamDecorator(
  (data: string | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user;
    return data ? user?.[data] : user;
  },
);
