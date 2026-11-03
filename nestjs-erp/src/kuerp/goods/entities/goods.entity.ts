import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../../common/base.entity';
import { BigIntTransformer } from '../../../common/bigint.transformer';

/**
 * 商品表（1:1 还原 kuerp_goods 结构）
 */
@Entity('kuerp_goods')
export class Goods extends BaseEntity {
  @Column({ type: 'int', default: 0, comment: '管理员ID' })
  admin_id: number;

  @Column({ type: 'varchar', length: 30, default: '', comment: '商品编号' })
  goods_code: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: '商品名称' })
  goods_name: string;

  @Column({ type: 'varchar', length: 50, default: '', comment: '商品条码' })
  goods_barcode: string;

  @Column({ type: 'varchar', length: 50, default: '', comment: '规格型号' })
  goods_specification_id: string;

  @Column({ type: 'int', default: 0, comment: '商品类别' })
  goods_type_id: number;

  @Column({ type: 'int', default: 0, comment: '首选仓库' })
  manager_warehouse_id: number;

  @Column({ type: 'int', default: 0, comment: '计量单位' })
  unit_id: number;

  @Column({ type: 'varchar', length: 8, default: '2', comment: '多计量单位:1=是,2=否' })
  more_unit: string;

  @Column({ type: 'int', nullable: true, comment: '多单位ID' })
  more_unit_id: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '零售价' })
  market_sell_price: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '批发价' })
  wholesale_price: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: 'vip会员价' })
  vip_price: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '折扣率1' })
  discount: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '折扣率2' })
  discount2: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '预计采购价' })
  purchase: number;

  @Column({ type: 'varchar', length: 255, default: '', comment: '商品主图' })
  goods_image: string;

  @Column({ type: 'text', nullable: true, comment: '商品图集' })
  goods_images: string;

  @Column({ type: 'text', nullable: true, comment: '商品详情' })
  content: string;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '总库存' })
  inventory: number;

  @Column({ type: 'varchar', length: 8, default: '0', comment: '多属性:0=否,1=是' })
  more_attribute: string;

  @Column({ type: 'varchar', length: 30, default: '', comment: '商品属性条码' })
  attribute_id: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: '备注' })
  note: string;

  @Column({ type: 'varchar', length: 8, default: '0', comment: '是否常用:0=否,1=是' })
  is_offten: string;

  @Column({ type: 'varchar', length: 8, default: '0', comment: '库存预警:0=否,1=是' })
  stock_warning: string;

  @Column({ type: 'int', default: 0, comment: '最低库存' })
  min_stock: number;

  @Column({ type: 'int', default: 0, comment: '最高库存' })
  max_stock: number;

  @Column({ type: 'varchar', length: 8, default: '0', comment: '分仓预警:0=否,1=是' })
  branch: string;

  @Column({ type: 'int', nullable: true, comment: '首选入库单位' })
  warehousing: number;

  @Column({ type: 'int', nullable: true, comment: '首选出库单位' })
  warehouse: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '期初数量' })
  period: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '单位成本' })
  unit_cost: number;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '期初总价' })
  price: number;

  @Column({ type: 'varchar', length: 8, default: '0', comment: '期初设置' })
  period_status: string;

  @Column({ type: 'varchar', length: 8, default: '1', comment: '状态:0=下架,1=上架' })
  status: string;

  @Column({ type: 'varchar', length: 8, default: '1', comment: '允许修改:0=否,1=是' })
  is_edit: string;

  @Column({ type: 'varchar', length: 16, nullable: true, comment: '辅助属性' })
  auxiliary: number;

  @Column({ type: 'varchar', length: 255, nullable: true, comment: '辅助属性' })
  auxiliary_type: string;

  @Column({ type: 'varchar', length: 255, nullable: true, comment: '辅助属性2' })
  auxiliary_type_c: string;

  @Column({ type: 'tinyint', nullable: true, comment: '批次保质期' })
  batch: number;

  @Column({ type: 'int', nullable: true, comment: '保质期天数' })
  shelf_life: number;

  @Column({ type: 'int', nullable: true, comment: '预警天数' })
  early_warning: number;

  @Column({ type: 'tinyint', nullable: true, comment: '序列号' })
  serial: number;

  @Column({ type: 'varchar', length: 16, default: 'sale', comment: '标签' })
  tag: string;

  @Column({ type: 'double', precision: 15, scale: 4, default: 0, comment: '销量' })
  sale_number: number;

  @Column({ type: 'varchar', length: 8, default: '1', comment: '订货通显示:0=否,1=是' })
  order_status: string;

  @Column({ type: 'varchar', length: 8, default: '0', comment: '促销:0=否,1=是' })
  promotion: string;
}
