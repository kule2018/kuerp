/**
 * 通用字段元信息工具：中文标签兜底、枚举注释解析、时间戳格式化。
 *
 * 背景：动态表格页（crud-page 等）的列/表单字段来自后端 /columns 元信息，
 * 大量技术字段（admin_id / path / weigh / createtime…）没有中文注释，
 * 枚举列注释形如「状态:0=禁用,1=正常」也没被利用起来，导致界面出现
 * 英文字段名与 0/1 裸值。本模块统一解决：
 *   1. fieldLabel()  —— 字段展示名（注释优先，无注释走通用中文字典兜底）
 *   2. parseComment()—— 把「状态:0=禁用,1=启用」「状态 枚举:0,1」解析成下拉选项
 *   3. fmtDateTime() —— 秒级时间戳 → YYYY-MM-DD HH:mm:ss
 */

/** 常见技术字段的中文标签字典：列无注释（或注释就是字段名本身）时兜底 */
export const FIELD_LABELS = {
  id: 'ID',
  admin_id: '管理员ID',
  user_id: '用户ID',
  shop_id: '店铺ID',
  goods_id: '商品ID',
  order_id: '订单ID',
  type_id: '类型ID',
  cate_id: '分类ID',
  category_id: '分类ID',
  supplier_id: '供应商ID',
  suppliers_id: '供应商ID',
  customer_id: '客户ID',
  warehouse_id: '仓库ID',
  unit_id: '单位ID',
  pid: '上级ID',
  path: '路径',
  weigh: '排序',
  weight: '排序',
  sort: '排序',
  status: '状态',
  state: '状态',
  name: '名称',
  title: '标题',
  code: '编码',
  image: '图片',
  images: '图片集',
  logo: '图标',
  remark: '备注',
  memo: '备注',
  note: '备注',
  content: '内容',
  description: '描述',
  address: '地址',
  mobile: '手机号',
  phone: '电话',
  email: '邮箱',
  price: '价格',
  num: '数量',
  money: '金额',
  total: '合计',
  unit: '单位',
  spec: '规格',
  level: '级别',
  createtime: '创建时间',
  updatetime: '更新时间',
  deletetime: '删除时间',
  // 计量 / 单位换算
  unit_name: '单位名称',
  main_unit: '主计量单位',
  vice_unit: '副计量单位',
  advance_rate: '换算进率',
  base_unit: '基本单位',
  // 时间类业务字段
  account_time: '到账时间',
  pay_time: '付款时间',
  send_time: '发货时间',
  logintime: '登录时间',
  purchase_time: '采购时间',
  sales_time: '销售时间',
  purchase_code: '采购单号',
  bill_code: '单据编号',
  bill_count: '单据笔数',
  checkdate: '盘点日期',
  // 单据 / 库存业务字段（数据库注释为空，扫描 information_schema 汇总）
  bill_time: '单据时间',
  checktime: '对单时间',
  delivery_time: '交货时间',
  library_time: '入库时间',
  examine_time: '审核时间',
  order_time: '下单时间',
  preparation_time: '制单时间',
  all_money: '单据金额',
  old_money: '原金额',
  tax_money: '税额',
  money_tax_price: '价税合计',
  number: '数量',
  basic_nmber: '基本数量',
  cost: '费用',
  cost_price: '成本价',
  inventory: '库存',
  max_stock: '库存上限',
  min_stock: '库存下限',
  batch_id: '批次ID',
  batch_name: '批次名称',
  attr_name: '属性名称',
  attribute_id: '属性ID',
  manufacture: '生产厂家',
  validity: '有效期',
  guarantee: '保修期',
  old_store: '原仓库',
  old_status: '原状态',
  exchange_id: '换货ID',
  purchase_id: '采购ID',
  order_info_id: '订单明细ID',
  invoicing_id: '开票ID',
  times: '次数',
  prevtime: '上次登录时间',
  jointime: '加入时间',
  expiretime: '过期时间',
  // 地区
  province: '省',
  city: '市',
  area: '区',
  district: '区',
  region: '地区',
  detail_address: '详细地址',
  connect_address: '联系地址',
  // 联系人 / 往来单位常见字段
  supplyer_code: '供应商编码',
  supplyer_name: '供应商名称',
  supplyertype_id: '供应商类型',
  first_connect_name: '联系人',
  first_connect_mobile: '联系手机',
  first_connect_phone: '联系电话',
  qq_wx_email: 'QQ/微信/邮箱',
  need_give_account: '应付账款',
  receive_account: '收款账户',
  opening_payable: '期初应付',
  opening_prepayment: '期初预付',
  vat_rate: '增值税率',
  identification: '纳税人识别号',
  deposit_bank: '开户银行',
  bank_number: '银行账号',
};

/**
 * 解析列注释为 { label, options }。
 * 支持两种枚举写法（全项目统一）：
 *  ① 「结算方式状态:0=禁用,1=启用」—— 带中文选项，表格/表单/筛选均显示中文
 *  ② 「状态 枚举:0,1」—— 仅有取值列表，选项显示原值
 * 普通注释原样作为 label 返回，options 为 null。
 *
 * @param {string} comment 列注释
 * @returns {{label: string, options: Array<{value: string, label: string}>|null}}
 */
export function parseComment(comment) {
  const raw = String(comment || '').trim();
  if (!raw) return { label: '', options: null };
  // ② 「xx 枚举:0,1」（兼容旧写法）
  const mEnum = /(?:^|\s)枚举[:：]\s*([0-9A-Za-z_\u4e00-\u9fa5,，、]+)/.exec(raw);
  if (mEnum) {
    const label = raw.replace(mEnum[0], '').trim();
    const values = mEnum[1].split(/[,，、]/).map((s) => s.trim()).filter(Boolean);
    return { label, options: values.map((v) => ({ value: v, label: v })) };
  }
  // ① 「label:0=禁用,1=启用」：右侧整体是 v=l 的逗号列表（≥2 项），
    // 避免把「节点标识(如 kuerp/goods)」这类普通冒号注释误判成枚举。
    // 容错：个别库注释存在「13组装单」这类漏写 = 的坏对，
    // 跳过坏对继续解析（而不是整体判失败回退成超长原始注释撑爆表头）。
  const m = /^([^::]{1,20})[::]\s*(.+)$/.exec(raw);
  if (m) {
    const pairs = m[2].split(/[,，]/).map((s) => s.trim()).filter(Boolean);
    const opts = [];
    let good = 0;
    let bad = 0;
    for (const p of pairs) {
      const i = p.indexOf('=');
      // 坏对：无「=」或键为空 → 记为坏对，跳过
      if (i <= 0 || !p.slice(i + 1).trim()) { bad++; continue; }
      opts.push({ value: String(p.slice(0, i).trim()), label: p.slice(i + 1).trim() });
      good++;
    }
    if (good >= 2 && good > bad) return { label: m[1].trim(), options: opts };
  }
  return { label: raw, options: null };
}

/**
 * 字段展示名：优先取注释（自动去掉枚举尾巴），无注释或注释就是字段名时走中文字典兜底。
 * 保证界面不出现 admin_id / path / weigh 这类裸英文字段名。
 *
 * @param {string} name 列名
 * @param {string} comment 列注释
 * @returns {string} 中文展示名
 */
export function fieldLabel(name, comment) {
  const { label } = parseComment(comment);
  const key = String(name || '').toLowerCase();
  if (label && label.toLowerCase() !== key) return label;
  return FIELD_LABELS[key] || name;
}

/** 是否为时间戳字段（createtime / updatetime / deletetime / pay_time 这类，以 time/date 结尾） */
export function isTimeField(name) {
  return /(time|date)$/i.test(String(name || ''));
}

/**
 * 秒级时间戳 → YYYY-MM-DD HH:mm:ss。
 * 非时间戳格式的值原样返回（10 位按秒、13 位按毫秒处理）。
 * @param {any} v 原始值
 * @returns {string|any}
 */
export function fmtDateTime(v) {
  const s = String(v ?? '').trim();
  if (!/^\d{9,13}$/.test(s)) return v;
  const n = Number(s);
  const d = new Date(s.length > 10 ? n : n * 1000);
  if (Number.isNaN(d.getTime())) return v;
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}
