import { CanActivate, ExecutionContext, Injectable, ForbiddenException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CacheService } from '../cache/cache.service';

/**
 * RBAC 权限守卫：等效原系统 $auth->check($nowmenu) 节点鉴权。
 *
 * 工作方式：
 * 1. 只拦截 /kuerp/ 下的业务接口（/auth /system /ai 等框架接口不拦截）；
 * 2. 超级管理员（admin 表 id=1）直接放行，与原系统超管免检一致；
 * 3. 其余账号经 kuerp_auth_group_access 找到所属角色组，
 *    用 kuerp_auth_group.rules（逗号分隔节点名，'*' 表示全部）匹配节点。
 *
 * 节点支持三级粒度（由粗到细，任一命中即放行）：
 *   *                     全部放行
 *   kuerp/goods           表级：放行该表全部动作（兼容既有配置）
 *   kuerp/goods:*         表内全部动作（写法更显式，等价上一行）
 *   kuerp/goods:add       操作级：仅放行该动作（index/get/columns/add/edit/del/
 *                         examine/import/recyclebin/reduction/realdel…）
 *
 * 为什么保留表级节点：既有角色配置里大量是 `kuerp/<table>` 这种粗放写法，
 * 若只认操作级节点会导致升级后非超管全线 403。因此操作级是「可选的更细粒度」，
 * 不配置时回落到表级判定。
 *
 * 注意：本守卫须置于 JwtAuthGuard 之后执行（req.user 由 JWT 守卫填充）。
 */
@Injectable()
export class RbacGuard implements CanActivate {
  constructor(
    private readonly dataSource: DataSource,
    private readonly cache: CacheService,
  ) {}

  async canActivate(ctx: ExecutionContext): Promise<boolean> {
    const req = ctx.switchToHttp().getRequest();
    const user = req.user;
    // 未登录：由前置 JwtAuthGuard 拦截，这里双保险直接拒绝
    if (!user) return false;
    // 超级管理员免检
    if (Number(user.id) === 1) return true;

    const path = String(req.path || '');
    // 仅业务表接口做权限校验
    if (!path.startsWith('/kuerp/')) return true;

    // 从 /kuerp/<table>/<action> 提取表名与动作（URL 连字符转下划线，与前端路由一致）
    const segs = path.split('/').filter(Boolean);
    const table = (segs[1] || '').replace(/-/g, '_');
    if (!table) return true;
    const action = String(segs[2] || 'index').replace(/-/g, '_');

    const rules = await this.rulesOf(user.id);
    if (rules.includes('*')) return true;
    // 表级 / 表内通配 / 操作级，任一层级命中即放行；
    // 未命中时主动抛 403（带中文文案）：直接 return false 会让 Nest 用默认
    // 英文 "Forbidden resource" 提示，不符合「界面全中文」的要求。
    const allowed =
      rules.includes(`kuerp/${table}`) ||
      rules.includes(`kuerp/${table}:*`) ||
      rules.includes(`kuerp/${table}:${action}`);
    if (!allowed) throw new ForbiddenException('无权限访问该资源，请联系管理员');
    return true;
  }

  /**
   * 读取某账号的角色规则集合（带缓存）。
   *
   * 【为什么要缓存】本守卫挂在所有 /kuerp/ 接口前，一次列表刷新会连带触发
   * 多次（前端并行请求 index/columns/options），默认每请求一次两表 JOIN；
   * 权限是典型的低频变更数据，30 秒缓存即可把这类重复查询压到接近零。
   *
   * 【为什么 TTL 短到 30 秒】不能只靠显式失效：
   * 角色/授权关系的写入路径不止一处（角色编辑、用户授权、批量导入），
   * 只要有一条漏掉失效，用户就会「被撤权后仍能操作」，这在 ERP 里是不可接受的。
   * 30 秒是「体验上无感、风险上有界」的折中，同时角色表变更时也会主动清 `rbac:` 前缀。
   *
   * @param adminId 账号 ID
   * @returns 规整后的节点名数组（已去掉空白项）
   */
  private async rulesOf(adminId: any): Promise<string[]> {
    const key = `rbac:rules:${adminId}`;
    const cached = this.cache.get<string[]>(key);
    if (cached) return cached;

    let rows: any[];
    try {
      rows = await this.dataSource.query(
        `SELECT g.rules AS rules
           FROM kuerp_auth_group_access a
           JOIN kuerp_auth_group g ON g.id = a.group_id
          WHERE a.admin_id = ? AND g.status = 1`,
        [adminId],
      );
    } catch (e: any) {
      // 兼容尚未执行 rbac-schema.sql 的旧库：表缺失时视为「全部放行」，
      // 避免升级窗口期全线 500。此结果**不写缓存**，建表后下一次请求立即恢复真实校验。
      if (String(e?.code || '') === 'ER_NO_SUCH_TABLE') return ['*'];
      throw e;
    }

    const rules = rows
      .map((r) => String(r.rules || ''))
      .join(',')
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);
    this.cache.set(key, rules, 30);
    return rules;
  }
}
