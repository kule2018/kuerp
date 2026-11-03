import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Admin } from './entities/admin.entity';
import { makeSalt, encryptPassword } from '../common/utils/password';
import { nowSec } from '../common/bigint.transformer';

/**
 * 系统服务：管理员账号管理 + 首次启动写入默认账号(admin/123456)。
 */
@Injectable()
export class SystemService implements OnModuleInit {
  constructor(
    @InjectRepository(Admin) private readonly adminRepo: Repository<Admin>,
    private readonly dataSource: DataSource,
  ) {}

  async onModuleInit() {
    await this.seedDefaultAdmin();
  }

  /** 首次启动若无管理员则创建 admin / 123456（与原系统 demo 账号一致） */
  private async seedDefaultAdmin() {
    const count = await this.adminRepo.count();
    if (count > 0) return;
    const salt = makeSalt();
    const admin = this.adminRepo.create({
      username: 'admin',
      nickname: '超级管理员',
      salt,
      password: encryptPassword('123456', salt),
      status: 1,
      createtime: nowSec(),
      updatetime: nowSec(),
      deletetime: 0,
    } as any);
    await this.adminRepo.save(admin);
  }

  async list(query: { page?: number; limit?: number; search?: string }) {
    const qb = this.adminRepo.createQueryBuilder('a').where('a.deletetime = 0 OR a.deletetime IS NULL');
    if (query.search) qb.andWhere('a.username LIKE :kw OR a.nickname LIKE :kw', { kw: `%${query.search}%` });
    qb.orderBy('a.id', 'DESC');
    const page = query.page || 1;
    const limit = query.limit || 10;
    const [items, count] = await qb.skip((page - 1) * limit).take(limit).getManyAndCount();
    // 连带查询每个管理员的角色组（auth_group_access），便于前端渲染角色多选
    const links = await this.dataSource.query(
      'SELECT admin_id, GROUP_CONCAT(group_id) AS gids FROM kuerp_auth_group_access GROUP BY admin_id',
    );
    const gidMap: Record<number, number[]> = {};
    links.forEach((l: any) => {
      gidMap[l.admin_id] = String(l.gids || '')
        .split(',')
        .filter(Boolean)
        .map(Number);
    });
    const list = items.map((a: any) => ({ ...a, group_ids: gidMap[a.id] || [] }));
    return { list, count, page, limit };
  }

  async create(dto: Partial<Admin>) {
    const salt = makeSalt();
    const entity = this.adminRepo.create({
      ...dto,
      salt,
      password: encryptPassword(dto.password || '123456', salt),
      createtime: nowSec(),
      updatetime: nowSec(),
      deletetime: 0,
    } as any);
    const saved: any = await this.adminRepo.save(entity);
    if (Array.isArray((dto as any).group_ids)) {
      await this.syncGroups(saved.id, (dto as any).group_ids);
    }
    return saved;
  }

  async update(id: number, dto: Partial<Admin>) {
    const data: any = { ...dto, updatetime: nowSec() };
    if (dto.password) {
      const salt = makeSalt();
      data.salt = salt;
      data.password = encryptPassword(dto.password, salt);
    }
    await this.adminRepo.update(id, data);
    // 角色组变更：前端传 group_ids 时重绑（不传则保持原关联）
    if (Array.isArray((dto as any).group_ids)) {
      await this.syncGroups(id, (dto as any).group_ids);
    }
    return this.adminRepo.findOne({ where: { id } as any });
  }

  /** 重绑管理员 → 角色组（先删后插，简单可靠） */
  private async syncGroups(adminId: number, groupIds: any[]) {
    const ids = groupIds.map(Number).filter((n) => !Number.isNaN(n));
    await this.dataSource.query('DELETE FROM kuerp_auth_group_access WHERE admin_id = ?', [adminId]);
    if (ids.length) {
      const vals = ids.map((gid) => `(${adminId}, ${gid})`).join(', ');
      await this.dataSource.query(
        `INSERT INTO kuerp_auth_group_access (admin_id, group_id) VALUES ${vals}`,
      );
    }
  }

  async remove(id: number) {
    await this.adminRepo.update(id, { deletetime: nowSec() } as any);
    await this.dataSource.query('DELETE FROM kuerp_auth_group_access WHERE admin_id = ?', [id]);
    return true;
  }
}
