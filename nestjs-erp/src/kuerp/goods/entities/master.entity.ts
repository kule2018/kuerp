import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../../common/base.entity';

/**
 * 商品类别（kuerp_goods_type）
 */
@Entity('kuerp_goods_type')
export class GoodsType extends BaseEntity {
  @Column({ type: 'varchar', length: 50, default: '', comment: '类别名称' })
  name: string;

  @Column({ type: 'int', default: 0, comment: '上级类别' })
  pid: number;

  @Column({ type: 'int', default: 0, comment: '排序' })
  sort: number;

  @Column({ type: 'varchar', length: 255, default: '', comment: '图片' })
  image: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态' })
  status: number;
}

/**
 * 计量单位（kuerp_unit / kuerp_auxiliary）
 */
@Entity('kuerp_unit')
export class Unit extends BaseEntity {
  @Column({ type: 'varchar', length: 50, default: '', comment: '单位名称' })
  name: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态' })
  status: number;
}

/**
 * 仓库（kuerp_warehouse）
 */
@Entity('kuerp_warehouse')
export class Warehouse extends BaseEntity {
  @Column({ type: 'varchar', length: 100, default: '', comment: '仓库名称' })
  name: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: '地址' })
  address: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态:1=启用,0=禁用' })
  status: number;

  @Column({ type: 'varchar', length: 255, default: '', comment: '备注' })
  remark: string;
}

/**
 * 供应商（kuerp_suppliers）
 */
@Entity('kuerp_suppliers')
export class Suppliers extends BaseEntity {
  @Column({ type: 'varchar', length: 50, default: '', comment: '供应商编号' })
  supplier_code: string;

  @Column({ type: 'varchar', length: 100, default: '', comment: '供应商名称' })
  supplier_name: string;

  @Column({ type: 'int', default: 0, comment: '供应商类别' })
  supplier_type_id: number;

  @Column({ type: 'varchar', length: 50, default: '', comment: '联系人' })
  contacts: string;

  @Column({ type: 'varchar', length: 50, default: '', comment: '电话' })
  phone: string;

  @Column({ type: 'varchar', length: 50, default: '', comment: '传真' })
  fax: string;

  @Column({ type: 'varchar', length: 100, default: '', comment: '邮箱' })
  email: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: '地址' })
  address: string;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '预付款' })
  amount_payable: number;

  @Column({ type: 'varchar', length: 255, default: '', comment: '备注' })
  remark: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态' })
  status: number;
}

/**
 * 客户（kuerp_customers）
 */
@Entity('kuerp_customers')
export class Customers extends BaseEntity {
  @Column({ type: 'varchar', length: 50, default: '', comment: '客户编号' })
  customer_code: string;

  @Column({ type: 'varchar', length: 100, default: '', comment: '客户名称' })
  customer_name: string;

  @Column({ type: 'int', default: 0, comment: '客户类别' })
  customer_type_id: number;

  @Column({ type: 'varchar', length: 50, default: '', comment: '联系人' })
  contacts: string;

  @Column({ type: 'varchar', length: 50, default: '', comment: '电话' })
  phone: string;

  @Column({ type: 'varchar', length: 100, default: '', comment: '邮箱' })
  email: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: '地址' })
  address: string;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '应收款' })
  amount_receivable: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '应付款' })
  amount_payable: number;

  @Column({ type: 'varchar', length: 255, default: '', comment: '备注' })
  remark: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态' })
  status: number;
}
