import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

/**
 * 后台管理员（等效原系统 kuerp_admin 登录账户，FastAdmin 框架级表）
 */
@Entity('kuerp_admin')
export class Admin extends BaseEntity {
  @Column({ type: 'varchar', length: 50, default: '', comment: '用户名' })
  username: string;

  @Column({ type: 'varchar', length: 64, default: '', comment: '密码哈希' })
  password: string;

  @Column({ type: 'varchar', length: 64, default: '', comment: '密码盐' })
  salt: string;

  @Column({ type: 'varchar', length: 50, default: '', comment: '昵称' })
  nickname: string;

  @Column({ type: 'varchar', length: 100, default: '', comment: '头像' })
  avatar: string;

  @Column({ type: 'varchar', length: 100, default: '', comment: '邮箱' })
  email: string;

  @Column({ type: 'bigint', nullable: true, default: 0, comment: '最后登录时间' })
  logintime?: number;

  @Column({ type: 'varchar', length: 50, default: '', comment: '最后登录IP' })
  loginip: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态:1=正常,0=禁用' })
  status: number;
}
