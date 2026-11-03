import { BaseEntity } from './base.entity';

/**
 * 列表查询通用入参（与原 FastAdmin 的 filter/sort/order/offset/limit 对齐）
 */
export interface ListQuery {
  page?: number;
  limit?: number;
  offset?: number;
  sort?: string;
  order?: 'ASC' | 'DESC';
  filter?: Record<string, any>;
  search?: string;
  [key: string]: any;
}

export interface PageResult<T> {
  list: T[];
  count: number;
  page: number;
  limit: number;
}

/**
 * 通用分页/检索工具：基于 TypeORM Repository 实现关键字搜索 + 精确过滤 + 排序 + 分页。
 * 等效还原原系统的 index 接口（filter 为 JSON 字符串或对象均可）。
 */
export async function paginate<T extends BaseEntity>(
  repo: any,
  query: ListQuery,
  options: {
    searchFields?: string[];
    alias?: string;
    relations?: string[];
  } = {},
): Promise<PageResult<T>> {
  const alias = options.alias || 't';
  const qb = repo.createQueryBuilder(alias);
  if (options.relations) {
    options.relations.forEach((r) => qb.leftJoinAndSelect(`${alias}.${r}`, r));
  }
  // 软删除过滤
  qb.andWhere(`${alias}.deletetime IS NULL OR ${alias}.deletetime = 0`);

  // 关键字搜索
  if (query.search && options.searchFields?.length) {
    const likes = options.searchFields.map((f) => `${alias}.${f} LIKE :kw`);
    qb.andWhere(`(${likes.join(' OR ')})`, { kw: `%${query.search}%` });
  }
  // 精确过滤
  if (query.filter && typeof query.filter === 'object') {
    Object.entries(query.filter).forEach(([k, v]) => {
      if (v !== undefined && v !== null && v !== '') {
        qb.andWhere(`${alias}.${k} = :f_${k}`, { [`f_${k}`]: v });
      }
    });
  }
  const sortField = query.sort && query.sort !== 'id' ? `${alias}.${query.sort}` : `${alias}.id`;
  qb.orderBy(sortField, query.order || 'DESC');

  const page = query.page && query.page > 0 ? query.page : 1;
  const limit = query.limit && query.limit > 0 ? query.limit : 10;
  const offset =
    query.offset !== undefined ? query.offset : (page - 1) * limit;
  qb.skip(offset).take(limit);

  const [list, count] = await qb.getManyAndCount();
  return { list, count, page, limit };
}
