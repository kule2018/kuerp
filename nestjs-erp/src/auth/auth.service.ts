import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Admin } from '../system/entities/admin.entity';
import { verifyPassword, encryptPassword } from '../common/utils/password';
import { nowSec } from '../common/bigint.transformer';
import * as crypto from 'crypto';

/**
 * 认证服务：登录签发 JWT、修改密码、当前用户信息、权限集合。
 */
@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Admin) private readonly adminRepo: Repository<Admin>,
    private readonly jwt: JwtService,
    private readonly dataSource: DataSource,
  ) {}

  async login(username: string, password: string) {
    const user = await this.adminRepo.findOne({ where: { username } as any });
    if (!user) throw new UnauthorizedException('账号或密码错误');
    if (user.status !== 1) throw new UnauthorizedException('账号已被禁用');
    if (!verifyPassword(password, user.salt, user.password)) {
      throw new UnauthorizedException('账号或密码错误');
    }
    user.logintime = nowSec();
    await this.adminRepo.update(user.id, { logintime: nowSec() } as any);
    const token = this.jwt.sign({ sub: user.id, username: user.username });
    return {
      token: 'Bearer ' + token,
      expires_in: Number(process.env.JWT_EXPIRES_IN || 7200),
      user: { id: user.id, username: user.username, nickname: user.nickname, avatar: user.avatar },
    };
  }

  async profile(userId: number) {
    const user = await this.adminRepo.findOne({ where: { id: userId } as any });
    if (!user) throw new UnauthorizedException('用户不存在');
    return { id: user.id, username: user.username, nickname: user.nickname, avatar: user.avatar, email: user.email };
  }

  async changePassword(userId: number, oldPwd: string, newPwd: string) {
    const user = await this.adminRepo.findOne({ where: { id: userId } as any });
    if (!user) throw new UnauthorizedException('用户不存在');
    if (!verifyPassword(oldPwd, user.salt, user.password)) {
      throw new UnauthorizedException('原密码错误');
    }
    const salt = crypto.randomBytes(16).toString('hex');
    const hash = encryptPassword(newPwd, salt);
    await this.adminRepo.update(user.id, { password: hash, salt } as any);
    return true;
  }

  /**
   * 查询当前用户的权限集合（供前端做按钮级显隐）。
   *
   * 返回结构设计：
   * - isSuper：超管为 true，前端可直接全部放行，不必逐项判断；
   * - nodes：原始节点数组（'kuerp/goods'、'kuerp/goods:add'、'*' 等），便于调试；
   * - tables：把节点归并成「表 → 可用动作」，'*' 表示该表全部动作，
   *   数组表示仅这些动作。归并后前端只需 hasPerm(table, action) 一次判断，
   *   不必在渲染时反复解析字符串；
   * - menus：非 kuerp 前缀的节点（dashboard/screen 等菜单级节点）。
   *
   * 判定口径与 RbacGuard 严格一致：表级节点（无冒号）视为该表全部动作。
   *
   * @param userId 当前登录用户ID
   * @returns 权限集合
   */
  async perms(userId: number) {
    const isSuper = Number(userId) === 1;
    if (isSuper) {
      return { isSuper: true, nodes: ['*'], tables: {} as Record<string, '*' | string[]>, menus: ['*'] };
    }

    let nodes: string[] = [];
    try {
      const rows = await this.dataSource.query(
        `SELECT g.rules AS rules
           FROM kuerp_auth_group_access a
           JOIN kuerp_auth_group g ON g.id = a.group_id
          WHERE a.admin_id = ? AND g.status = 1`,
        [userId],
      );
      nodes = (rows || [])
        .map((r: any) => String(r.rules || ''))
        .join(',')
        .split(',')
        .map((s: string) => s.trim())
        .filter(Boolean);
    } catch (e: any) {
      // 未执行 rbac-schema.sql 的旧库：返回空集，前端会退化为「只显示菜单、不隐藏按钮」
      if (String(e?.code || '') !== 'ER_NO_SUCH_TABLE') throw e;
      nodes = [];
    }

    const tables: Record<string, '*' | string[]> = {};
    const menus: string[] = [];
    for (const n of nodes) {
      if (!n.startsWith('kuerp/')) {
        menus.push(n);
        continue;
      }
      const rest = n.slice('kuerp/'.length);
      const [rawTable, rawAction] = rest.split(':');
      const key = String(rawTable || '').replace(/-/g, '_');
      if (!key) continue;
      if (!rawAction || rawAction === '*') {
        tables[key] = '*';
        continue;
      }
      // 已标记为「全部动作」的表不再降级为动作数组
      if (tables[key] === '*') continue;
      const list = Array.isArray(tables[key]) ? (tables[key] as string[]) : [];
      if (!list.includes(rawAction)) list.push(rawAction);
      tables[key] = list;
    }

    return { isSuper: nodes.includes('*'), nodes, tables, menus };
  }
}
