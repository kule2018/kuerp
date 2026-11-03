import { PrimaryGeneratedColumn, Column } from 'typeorm';
import { BigIntTransformer, nowSec } from './bigint.transformer';

/**
 * 业务基础实体：与原系统表结构对齐
 * - id 自增主键
 * - createtime / updatetime / deletetime 均为秒级 bigint 时间戳
 * - deletetime 非空即代表软删除（与原系统一致，不使用 TypeORM 物理删除）
 */
export abstract class BaseEntity {
  @PrimaryGeneratedColumn({ type: 'int', unsigned: true })
  id: number;

  @Column({ type: 'bigint', nullable: true, default: 0, transformer: BigIntTransformer, comment: '创建时间' })
  createtime?: number;

  @Column({ type: 'bigint', nullable: true, default: 0, transformer: BigIntTransformer, comment: '更新时间' })
  updatetime?: number;

  @Column({ type: 'bigint', nullable: true, default: 0, transformer: BigIntTransformer, comment: '删除时间(软删除)' })
  deletetime?: number;

  /** 赋值时自动写入创建/更新时间，子类可在 save 前调用 */
  touch(isCreate = false) {
    const t = nowSec();
    if (isCreate) this.createtime = t;
    this.updatetime = t;
  }
}
