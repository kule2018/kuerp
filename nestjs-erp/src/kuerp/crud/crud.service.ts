import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { paginate, ListQuery } from '../../common/pagination';
import { nowSec } from '../../common/bigint.transformer';
import { BaseEntity } from '../../common/base.entity';

/**
 * 通用 CRUD 服务：业务模块（资料/购货/销货/仓库/资金）统一复用。
 * 提供与原系统 controller 一致的 index/add/edit/del 能力（含分页、关键字、软删除）。
 */
@Injectable()
export class CrudService<T extends BaseEntity> {
  constructor(protected repo: Repository<T>) {}

  async index(query: ListQuery & { searchFields?: string[] }) {
    const r = await paginate<T>(this.repo, query, { searchFields: query.searchFields });
    return r;
  }

  async get(id: number) {
    return this.repo.findOne({ where: { id, deletetime: 0 } as any });
  }

  async add(dto: any) {
    const entity = this.repo.create({
      ...dto,
      createtime: nowSec(),
      updatetime: nowSec(),
      deletetime: 0,
    } as any);
    return this.repo.save(entity);
  }

  async edit(id: number, dto: any) {
    await this.repo.update(id, { ...dto, updatetime: nowSec() } as any);
    return this.repo.findOne({ where: { id } as any });
  }

  async del(id: number) {
    await this.repo.update(id, { deletetime: nowSec() } as any);
    return true;
  }
}
