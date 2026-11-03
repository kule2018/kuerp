import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { createHash } from 'crypto';
import { TableService } from '../kuerp/table/table.service';

/** 开放 API 响应结构（与原系统 FastAdmin Api 控制器一致） */
export interface OpenApiResult {
  code: number;
  msg: string;
  time: number;
  data: any;
}

/**
 * 鉴权结果：fail 存在表示鉴权失败（fail 即可直接返回的错误响应），
 * 否则 account 为 kuerp_third_account 账户行。
 * 注：项目 tsconfig 关闭了 strictNullChecks，字面量判别联合不收窄，故采用可选字段结构。
 */
interface VerifyResult {
  account?: any;
  fail?: OpenApiResult;
}

/**
 * 开放对接 API 服务（等价原系统 application/api/controller/kuerp/third/*）。
 *
 * 鉴权（1:1 还原 Thirds.php::_initialize）：
 *   1. request_time 距当前超过 300 秒 → 无效请求(23)；
 *   2. account / sign 必填；
 *   3. account 必须存在于 kuerp_third_account 且 status=1；
 *   4. 每个接口有固定的「参与签名参数表」；取这些参数（trim、键小写、ksort），
 *      按 k=v 用 & 拼接后追加 key=<salt>，取 MD5 与请求 sign 比对，不一致 → 签名错误(24)。
 *
 * 写入类接口（下单 / 退货）复用通用单号规则引擎与审核过账引擎：
 *   - 单号：TableService.genCodeByRule（等价原系统 getCodes，按 kuerp_prefix 规则）；
 *   - 自动审核：系统未开启「审核」开关时，新单自动走 TableService.examine 过账，
 *     与后台手工开单共用同一套库存 / 资金过账链路。
 */
@Injectable()
export class OpenApiService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tableService: TableService,
  ) {}

  // ==================================================================
  // 基础工具
  // ==================================================================

  /** 组装成功响应。code 默认 1（与原系统 success 第三参一致） */
  private succ(msg: string, data: any = '', code = 1): OpenApiResult {
    return { code, msg, time: Math.floor(Date.now() / 1000), data };
  }

  /** 组装失败响应 */
  private err(msg: string, code = 27): OpenApiResult {
    return { code, msg, time: Math.floor(Date.now() / 1000), data: '' };
  }

  /** 当前秒级时间戳（与库内 createtime/updatetime 秒级 bigint 约定一致） */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /** 今天 0 点的秒级时间戳（原系统 strtotime(date('Y-m-d'))） */
  private today0(): number {
    const d = new Date();
    d.setHours(0, 0, 0, 0);
    return Math.floor(d.getTime() / 1000);
  }

  /**
   * 三方账户签名校验（1:1 还原 Thirds.php）。
   * @param body 请求参数集合
   * @param ruleName 接口签名规则名（如 goods_getGoodsList）
   * @returns VerifyOk 携带三方账户行；VerifyFail 携带可直接返回的错误响应
   */
  private async verify(body: any, ruleName: string): Promise<VerifyResult> {
    const requestTime = Number(body?.request_time || 0);
    const account = body?.account || '';
    const requestSign = body?.sign || '';

    // —— 时效：request_time 早于 300 秒前视为重放/过期请求 ——
    if (requestTime < Math.floor(Date.now() / 1000) - 300) {
      return { fail: this.err('无效请求', 23) };
    }
    if (!account) {
      return { fail: this.err('account参数错误', 25) };
    }
    if (!requestSign) {
      return { fail: this.err('签名错误', 24) };
    }
    const rows: any[] = await this.dataSource.query(
      'SELECT * FROM `kuerp_third_account` WHERE account = ? LIMIT 1',
      [account],
    );
    const acc = rows[0];
    if (!acc) {
      return { fail: this.err('账户不存在', 21) };
    }
    if (Number(acc.status) !== 1) {
      return { fail: this.err('账户状态异常', 22) };
    }

    // —— 每个接口固定的参与签名参数表（与原系统 $rule 一致）——
    const RULES: Record<string, string> = {
      goods_goodstypelist: 'account',
      goods_getgoodslist: 'account',
      goods_getgoodsinfo: 'account,id',
      customers_getsaleslist: 'account',
      customers_getcustomerslist: 'account',
      customers_joincustomers: 'account,name,mobile',
      customers_customersinfo: 'account,mobile',
      customers_editcustomers: 'account,code,name,mobile',
      customers_delcustomers: 'account,mobile',
      sales_getsaleslist: 'account',
      sales_sales: 'account,order_num,mobile,goods',
      sales_salesinfo: 'account,purchase_code',
      sales_returnsales: 'account,order_num,mobile,goods',
      sales_returnsalesinfo: 'account,purchase_code',
    };
    const rule = RULES[ruleName];
    if (!rule) {
      return { fail: this.err('接口地址错误', 20) };
    }
    const signArr: Record<string, string> = {};
    for (const key of rule.split(',')) {
      if (!(key in (body || {}))) {
        return { fail: this.err(`${key}参数错误`, 25) };
      }
      signArr[key.toLowerCase()] = String(body[key] ?? '').trim();
    }
    // 签名串：ksort 后 k=v 用 & 连接，末尾拼 key=<salt>（与原系统逐字符一致）
    const signStr =
      Object.keys(signArr)
        .sort()
        .map((k) => `${k}=${signArr[k]}`)
        .join('&') + `key=${acc.salt}`;
    const sign = createHash('md5').update(signStr, 'utf8').digest('hex');
    if (sign !== requestSign) {
      return { fail: this.err('签名错误', 24) };
    }
    return { account: acc };
  }

  /**
   * 简单必填校验（等价 checkParameter 的 require 部分）。
   * @param data 参数集合
   * @param map { 字段: 中文名 }
   * @returns 错误响应或 null（通过）
   */
  private require(data: any, map: Record<string, string>): OpenApiResult | null {
    for (const [k, name] of Object.entries(map)) {
      if (!(k in (data || {})) || data[k] === '' || data[k] === undefined) {
        return this.err(`${name}参数不正确`, 25);
      }
    }
    return null;
  }

  /** 通用单条 INSERT：列名来自代码内构造的白名单行对象，值全部参数化 */
  private async insert(table: string, row: Record<string, any>): Promise<number> {
    const keys = Object.keys(row);
    const cols = keys.map((k) => `\`${k}\``).join(',');
    const holders = keys.map(() => '?').join(',');
    const ret: any = await this.dataSource.query(
      `INSERT INTO \`${table}\` (${cols}) VALUES (${holders})`,
      keys.map((k) => row[k] ?? null),
    );
    return Number(ret?.insertId || 0);
  }

  /** 结账守卫：单据日期不得早于最近一次结账日期（等价原系统 kuerp_checkout 检查） */
  private async guardCheckout(purchaseTime: number): Promise<OpenApiResult | null> {
    const rows: any[] = await this.dataSource.query(
      'SELECT checktime, checkdate FROM `kuerp_checkout` ORDER BY checktime DESC LIMIT 1',
    );
    const last = rows[0];
    if (last && purchaseTime <= Number(last.checktime || 0)) {
      return this.err(`不可添加小于结账日期${last.checkdate ?? ''}的数据`, 0);
    }
    return null;
  }

  /**
   * 读取系统设置（等价原系统 _initialize 中的 sets 探测）。
   * @returns 各开关与税率/小数位配置
   */
  private async loadSettings() {
    const rows: any[] = await this.dataSource.query(
      'SELECT name, is_checked, value FROM `kuerp_sets`',
    );
    const map: Record<string, any> = {};
    for (const r of rows) map[r.name] = { checked: Number(r.is_checked), value: r.value };
    return {
      serial: map['serial']?.checked ?? 0,
      batch: map['batch']?.checked ?? 0,
      auxiliary: map['auxiliary']?.checked ?? 0,
      taxes: map['taxes']?.checked ?? 0,
      taxesRate: Number(map['taxes']?.value ?? 0),
      numberDecimal: Number(map['number_decimal']?.value ?? 4),
      examine: map['examine']?.checked ?? 0,
    };
  }

  /**
   * 多单位换算率：goods 提交的单位ID 相对商品主单位的 advance_rate（主单位为 1）。
   * @param goods 商品行（含 more_unit / more_unit_id / unit_id）
   * @param unitId 提交的单位ID
   */
  private async advanceRate(goods: any, unitId: number): Promise<number> {
    if (Number(goods.more_unit) !== 1) return 1;
    const rows: any[] = await this.dataSource.query(
      'SELECT vice_unit, advance_rate FROM `kuerp_unit_conversion` WHERE main_unit = ?',
      [goods.more_unit_id],
    );
    const map: Record<string, number> = { [String(goods.unit_id)]: 1 };
    for (const r of rows) map[String(r.vice_unit)] = Number(r.advance_rate) || 1;
    return map[String(unitId)] ?? 1;
  }

  // ==================================================================
  // 商品（等价 Goods.php）
  // ==================================================================

  /**
   * 商品分类列表。
   * @param body { pid? } 父级ID，默认取一级分类
   */
  async goodsTypeList(body: any) {
    const v = await this.verify(body, 'goods_goodstypelist');
    if (v.fail) return v.fail;
    const pid = Number(body.pid || 0);
    const list: any[] = await this.dataSource.query(
      `SELECT id, pid, supplier_type_name AS name, supplier_type_image AS image,
              DATE_FORMAT(FROM_UNIXTIME(updatetime), '%Y-%m-%d') AS updatetime
         FROM \`kuerp_goods_type\` WHERE pid = ? AND status = '1'`,
      [pid],
    );
    for (const row of list) {
      if (!row.image) row.image = '/assets/addons/kuerp/img/noimage.png';
    }
    return this.succ('查询成功', list, 200);
  }

  /**
   * 商品分页列表（含多单位价格摘要）。
   * @param body { page?, limit?, keyword?, goods_type_id?, tag? }
   */
  async getGoodsList(body: any) {
    const v = await this.verify(body, 'goods_getgoodslist');
    if (v.fail) return v.fail;
    const page = Math.max(1, Number(body.page || 1));
    const limit = Math.max(1, Number(body.limit || 10));

    // —— 动态条件（全部参数化）：关键字 / 分类（含子级 path）/ 标签 / 上架状态 ——
    const where: string[] = [`g.status = '1'`];
    const params: any[] = [];
    if (body.keyword) {
      where.push('(g.goods_code LIKE ? OR g.goods_name LIKE ? OR g.goods_barcode LIKE ?)');
      const kw = `%${body.keyword}%`;
      params.push(kw, kw, kw);
    }
    if (body.goods_type_id) {
      const children: any[] = await this.dataSource.query(
        'SELECT id FROM `kuerp_goods_type` WHERE path LIKE ?',
        [`%,${body.goods_type_id},%`],
      );
      const ids = children.map((r) => Number(r.id)).concat(Number(body.goods_type_id));
      where.push(`g.goods_type_id IN (${ids.map(() => '?').join(',')})`);
      params.push(...ids);
    }
    if (body.tag) {
      where.push('g.tag LIKE ?');
      params.push(`%${body.tag}%`);
    }
    const whereSql = where.join(' AND ');

    const list: any[] = await this.dataSource.query(
      `SELECT g.id, g.goods_code, g.goods_type_id, g.goods_name, g.goods_barcode, g.note,
              g.goods_specification_id AS goods_spec, g.unit_id, u.name AS unit_name, g.more_unit,
              g.purchase, g.market_sell_price, g.wholesale_price, g.vip_price, g.discount, g.discount2,
              g.goods_image, g.inventory AS stock,
              DATE_FORMAT(FROM_UNIXTIME(g.updatetime), '%Y-%m-%d %H:%i:%s') AS updatetime
         FROM \`kuerp_goods\` g JOIN \`kuerp_unit\` u ON g.unit_id = u.id
        WHERE ${whereSql}
        ORDER BY g.sale_number DESC, g.id DESC
        LIMIT ? OFFSET ?`,
      [...params, limit, (page - 1) * limit],
    );

    // —— 价格修正：以主单位（默认单位）价格行为准；多单位商品拼接单位与换算率 ——
    for (const row of list) {
      const unitData = await this.getGoodsUnit(row.id, '');
      const p = unitData[0] || {};
      row.purchase = p.purchase ?? 0;
      row.market_sell_price = p.market_sell_price ?? 0;
      row.wholesale_price = p.wholesale_price ?? 0;
      row.vip_price = p.vip_price ?? 0;
      row.discount = p.discount ?? 0;
      row.discount2 = p.discount2 ?? 0;
      if (!row.goods_image) row.goods_image = '/assets/addons/kuerp/img/noimage.png';
      if (Number(row.more_unit) === 1) {
        const conv: any[] = await this.dataSource.query(
          `SELECT uc.advance_rate, u.name FROM \`kuerp_unit_conversion\` uc
             JOIN \`kuerp_unit\` u ON u.id = uc.vice_unit
            WHERE uc.main_unit = ? ORDER BY uc.advance_rate ASC`,
          [row.unit_id],
        );
        const rates = conv.map((c) => c.advance_rate).join(':');
        const names = conv.map((c) => c.name).join(',');
        row.unit_name = `${row.unit_name},${names}(1:${rates})`;
      }
    }
    const cnt: any[] = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM \`kuerp_goods\` g JOIN \`kuerp_unit\` u ON g.unit_id = u.id WHERE ${whereSql}`,
      params,
    );
    return this.succ('查询成功', { list, count: Number(cnt[0]?.c || 0) }, 200);
  }

  /**
   * 商品详情（含单位价格表 unit_data 与辅助属性表 attr_data）。
   * @param body { id, goods_attr? }
   */
  async getGoodsInfo(body: any) {
    const v = await this.verify(body, 'goods_getgoodsinfo');
    if (v.fail) return v.fail;
    const id = Number(body.id || 0);
    if (!id) return this.err('商品参数不正确', 25);
    const rows: any[] = await this.dataSource.query(
      `SELECT id, goods_code, goods_name, goods_barcode, goods_specification_id AS goods_spec,
              goods_type_id, unit_id, goods_image, goods_images, note, more_unit, content
         FROM \`kuerp_goods\` WHERE id = ? AND status = '1' LIMIT 1`,
      [id],
    );
    const row = rows[0];
    if (!row) return this.err('未查询到商品数据', 500);
    if (!row.goods_image) row.goods_image = '/assets/addons/kuerp/img/noimage.png';
    row.goods_images = row.goods_images ? String(row.goods_images).split(',') : [];
    row.unit_data = await this.getGoodsUnit(id, body.goods_attr || '');
    row.attr_data = await this.getGoodsAuxiliary(id);
    return this.succ('查询成功', row, 200);
  }

  /**
   * 商品多单位价格表（等价 Goods::getGoodsUnit）。
   * 单计量商品返回主单位一行（辅助属性商品按属性取价）；
   * 多计量商品返回 kuerp_goods_price 中全部单位行，并按换算率折算各单位的可用库存。
   * @param id 商品ID
   * @param goodsAttr 属性明细ID（可为空）
   */
  private async getGoodsUnit(id: number, goodsAttr: string | number): Promise<any[]> {
    const goodsRows: any[] = await this.dataSource.query(
      `SELECT more_unit, unit_id, more_unit_id, purchase, market_sell_price, wholesale_price,
              vip_price, discount, discount2, auxiliary
         FROM \`kuerp_goods\` WHERE id = ? LIMIT 1`,
      [id],
    );
    const goods = goodsRows[0];
    if (!goods) return [];

    // —— 可用库存：同商品（同属性时仅统计该属性）全部仓库合计 ——
    const stockWhere: string[] = ['goods_id = ?'];
    const stockParams: any[] = [id];
    if (goodsAttr) {
      const attrRows: any[] = await this.dataSource.query(
        'SELECT attribute_id FROM `kuerp_goods_attr` WHERE goods_id = ? AND id = ? LIMIT 1',
        [id, goodsAttr],
      );
      if (attrRows[0]) {
        stockWhere.push('attribute_id = ?');
        stockParams.push(attrRows[0].attribute_id);
      }
    }
    const stockRows: any[] = await this.dataSource.query(
      `SELECT SUM(stock) AS s FROM \`kuerp_goods_stock\` WHERE ${stockWhere.join(' AND ')}`,
      stockParams,
    );
    const stock = Number(stockRows[0]?.s || 0);

    let priceRows: any[];
    if (Number(goods.more_unit) !== 1) {
      // 单计量：主单位一行；启用辅助属性时价格改取属性明细价
      let purchase = goods.purchase;
      let market = goods.market_sell_price;
      let wholesale = goods.wholesale_price;
      let vip = goods.vip_price;
      let discount = goods.discount;
      let discount2 = goods.discount2;
      if (Number(goods.auxiliary) === 1) {
        const attrWhere: string[] = ['goods_id = ?'];
        const attrParams: any[] = [id];
        if (goodsAttr) {
          attrWhere.push('attribute_id = ?');
          attrParams.push(goodsAttr);
        }
        const attrPrice: any[] = await this.dataSource.query(
          `SELECT purchase, market_sell_price, wholesale_price, vip_price, discount, discount2
             FROM \`kuerp_goods_attr\` WHERE ${attrWhere.join(' AND ')} LIMIT 1`,
          attrParams,
        );
        if (attrPrice[0]) {
          purchase = attrPrice[0].purchase;
          market = attrPrice[0].market_sell_price;
          wholesale = attrPrice[0].wholesale_price;
          vip = attrPrice[0].vip_price;
          discount = attrPrice[0].discount;
          discount2 = attrPrice[0].discount2;
        }
      }
      const unitNameRows: any[] = await this.dataSource.query(
        'SELECT name FROM `kuerp_unit` WHERE id = ? LIMIT 1',
        [goods.unit_id],
      );
      priceRows = [
        {
          unit: goods.unit_id,
          purchase,
          market_sell_price: market,
          wholesale_price: wholesale,
          vip_price: vip,
          discount,
          discount2,
          is_default: 1,
          name: unitNameRows[0]?.name || '',
        },
      ];
    } else {
      // 多计量：取商品价格表中全部单位行（默认单位排前）
      priceRows = await this.dataSource.query(
        `SELECT g.unit, g.purchase, g.market_sell_price, g.wholesale_price, g.vip_price,
                g.discount, g.discount2, g.is_default, u.name
           FROM \`kuerp_goods_price\` g JOIN \`kuerp_unit\` u ON u.id = g.unit
          WHERE g.goods_id = ? ORDER BY g.is_default DESC`,
        [id],
      );
    }

    // —— 各单位库存折算：非默认单位按换算率换算为主单位口径的反向数量 ——
    const conv: any[] = await this.dataSource.query(
      'SELECT vice_unit, advance_rate FROM `kuerp_unit_conversion` WHERE main_unit = ?',
      [goods.more_unit_id],
    );
    const rateMap: Record<string, number> = {};
    for (const c of conv) rateMap[String(c.vice_unit)] = Number(c.advance_rate) || 0;
    for (const p of priceRows) {
      if (Number(p.is_default) === 1) {
        p.stock = stock;
      } else {
        const rate = rateMap[String(p.unit)];
        p.stock = rate ? Math.round((stock / rate) * 100) / 100 : stock;
      }
    }
    return priceRows;
  }

  /**
   * 商品辅助属性明细（等价 Goods::getGoodsAuxiliary）。
   * @param id 商品ID
   */
  private async getGoodsAuxiliary(id: number): Promise<any[]> {
    const aux: any[] = await this.dataSource.query(
      'SELECT id, name FROM `kuerp_auxiliary` WHERE status = 1',
    );
    const auxMap: Record<string, string> = {};
    for (const a of aux) auxMap[String(a.id)] = a.name;
    const attrs: any[] = await this.dataSource.query(
      `SELECT id, attribute_id, attr_code, barcode, unit, purchase, market_sell_price,
              wholesale_price, vip_price, discount, discount2
         FROM \`kuerp_goods_attr\` WHERE goods_id = ?`,
      [id],
    );
    for (const row of attrs) {
      row.attr_name = '';
      const comb: any[] = await this.dataSource.query(
        'SELECT attr_ids FROM `kuerp_aux_combination` WHERE id = ? LIMIT 1',
        [row.attribute_id],
      );
      if (comb[0]?.attr_ids) {
        row.attr_name = String(comb[0].attr_ids)
          .split('&')
          .map((x) => auxMap[x] ?? '')
          .join('/');
      }
      delete row.attribute_id;
    }
    return attrs;
  }

  // ==================================================================
  // 客户（等价 Customers.php）
  // ==================================================================

  /**
   * 职员列表（业务员选择用，手机号脱敏）。
   * @param body { page?, limit?, keyword? }
   */
  async staffList(body: any) {
    const v = await this.verify(body, 'customers_getsaleslist');
    if (v.fail) return v.fail;
    const page = Math.max(1, Number(body.page || 1));
    const limit = Math.max(1, Number(body.limit || 10));
    const where: string[] = ["status = '1'"];
    const params: any[] = [];
    if (body.keyword) {
      where.push('(men_code LIKE ? OR name LIKE ? OR phone LIKE ?)');
      const kw = `%${body.keyword}%`;
      params.push(kw, kw, kw);
    }
    const whereSql = where.join(' AND ');
    const list: any[] = await this.dataSource.query(
      `SELECT id, men_code, name, phone,
              DATE_FORMAT(FROM_UNIXTIME(updatetime), '%Y-%m-%d %H:%i:%s') AS updatetime
         FROM \`kuerp_staff_member\` WHERE ${whereSql} LIMIT ? OFFSET ?`,
      [...params, limit, (page - 1) * limit],
    );
    // 手机号脱敏：11 位手机号中间四位替换为 ****（与原系统一致）
    for (const row of list) {
      if (/^1[3-9]\d{9}$/.test(String(row.phone))) {
        row.phone = String(row.phone).replace(/^(.{3})\d{4}(.{4})$/, '$1****$2');
      }
    }
    const cnt: any[] = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM \`kuerp_staff_member\` WHERE ${whereSql}`,
      params,
    );
    return this.succ('查询成功', { list, count: Number(cnt[0]?.c || 0) }, 200);
  }

  /**
   * 客户列表（仅返回该三方账户名下 third_id 匹配的客户）。
   * @param body { page?, limit?, keyword? }
   */
  async getCustomersList(body: any) {
    const v = await this.verify(body, 'customers_getcustomerslist');
    if (v.fail) return v.fail;
    const page = Math.max(1, Number(body.page || 1));
    const limit = Math.max(1, Number(body.limit || 10));
    const where: string[] = ['third_id = ?'];
    const params: any[] = [v.account.id];
    if (body.keyword) {
      where.push('(customer_code LIKE ? OR customer_name LIKE ? OR customer_mobile LIKE ?)');
      const kw = `%${body.keyword}%`;
      params.push(kw, kw, kw);
    }
    const whereSql = where.join(' AND ');
    const list: any[] = await this.dataSource.query(
      `SELECT customer_code, customer_name AS name, customer_mobile AS mobile,
              staff_member_id AS saler, createtime, status
         FROM \`kuerp_customers\` WHERE ${whereSql} LIMIT ? OFFSET ?`,
      [...params, limit, (page - 1) * limit],
    );
    for (const row of list) {
      const saler: any[] = await this.dataSource.query(
        'SELECT men_code FROM `kuerp_staff_member` WHERE id = ? LIMIT 1',
        [row.saler],
      );
      row.saler = saler[0]?.men_code ?? '';
      row.createtime_text = row.createtime
        ? new Date(Number(row.createtime) * 1000).toISOString().slice(0, 19).replace('T', ' ')
        : '';
    }
    const cnt: any[] = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM \`kuerp_customers\` WHERE ${whereSql}`,
      params,
    );
    return this.succ('查询成功', { list, count: Number(cnt[0]?.c || 0) }, 200);
  }

  /**
   * 添加客户：三方商城新客注册。
   * 生成客户编号（单号规则引擎）→ 手机号查重 → 校验业务员 →
   * 事务写入客户主表 + 往来期初日志(business_type=5, give_money=0) + 首联系人。
   * @param body { name, mobile, saler?, address?, note? }
   */
  async joinCustomers(body: any) {
    const v = await this.verify(body, 'customers_joincustomers');
    if (v.fail) return v.fail;
    const bad = this.require(body, { name: '客户名称', mobile: '客户联系方式' });
    if (bad) return bad;

    const codeRet = await this.tableService.genCodeByRule('kuerp_customers', 'customer_code');
    const customerCode = codeRet.code;

    const dup: any[] = await this.dataSource.query(
      'SELECT id FROM `kuerp_customers` WHERE customer_mobile = ? LIMIT 1',
      [body.mobile],
    );
    if (dup.length) return this.err('此手机号已注册', 27);

    // —— 业务员（可选）：须存在且启用 ——
    let salerId = 0;
    if (body.saler) {
      const saler: any[] = await this.dataSource.query(
        "SELECT id FROM `kuerp_staff_member` WHERE men_code = ? AND status = '1' LIMIT 1",
        [body.saler],
      );
      if (!saler.length) return this.err('职员不可用', 27);
      salerId = Number(saler[0].id);
    }
    const latestType: any[] = await this.dataSource.query(
      "SELECT id FROM `kuerp_customertype` WHERE status = '1' ORDER BY id DESC LIMIT 1",
    );
    const now = this.now();
    const customer = {
      customer_code: customerCode,
      customertype_id: latestType[0]?.id ?? 0,
      customerlevel_id: 1,
      customer_name: body.name,
      connet_name: body.name,
      customer_mobile: body.mobile,
      getgoods_address: body.address || '',
      note: body.note || '',
      staff_member_id: salerId,
      account_time: now,
      third_id: v.account.id,
      createtime: now,
      updatetime: now,
    };
    try {
      const id = await this.insert('kuerp_customers', customer);
      await this.insert('kuerp_sales_payment_log', {
        customers_id: id,
        business_type: 5,
        bill_time: customer.account_time,
        bill_code: customerCode,
        give_money: 0,
      });
      await this.insert('kuerp_customers_user', {
        customers_code: customerCode,
        sid: id,
        first_connect_name: body.name,
        first_connect_mobile: body.mobile,
        first_connect_phone: '',
        qq_wx_email: '',
        connect_address: body.address || '',
        is_first: 1,
        createtime: now,
        updatetime: now,
      });
      return this.succ('添加成功', { id, customer_code: customerCode }, 1);
    } catch (e: any) {
      return this.err(e?.message || '添加失败', 27);
    }
  }

  /**
   * 客户详情（按手机号 + 三方账户定位）。
   * @param body { mobile }
   */
  async customersInfo(body: any) {
    const v = await this.verify(body, 'customers_customersinfo');
    if (v.fail) return v.fail;
    const bad = this.require(body, { mobile: '电话' });
    if (bad) return bad;
    const rows: any[] = await this.dataSource.query(
      `SELECT customer_code, customer_name AS name, customer_mobile AS mobile,
              getgoods_address AS address, note, staff_member_id AS saler, createtime, status
         FROM \`kuerp_customers\` WHERE customer_mobile = ? AND third_id = ? LIMIT 1`,
      [body.mobile, v.account.id],
    );
    const customer = rows[0];
    if (!customer) return this.err('未找到相关客户', 27);
    if (Number(customer.status) !== 1) return this.err('此客户状态异常', 27);
    const saler: any[] = await this.dataSource.query(
      'SELECT men_code FROM `kuerp_staff_member` WHERE id = ? LIMIT 1',
      [customer.saler],
    );
    customer.saler = saler[0]?.men_code ?? '';
    customer.createtime_text = customer.createtime
      ? new Date(Number(customer.createtime) * 1000).toISOString().slice(0, 19).replace('T', ' ')
      : '';
    return this.succ('查询成功', customer, 1);
  }

  /**
   * 编辑客户：更新主表 + 首联系人（联系人信息变化时重建首联系人行）。
   * @param body { code, name, mobile, saler?, address?, note? }
   */
  async editCustomers(body: any) {
    const v = await this.verify(body, 'customers_editcustomers');
    if (v.fail) return v.fail;
    const bad = this.require(body, { code: '客户编号', name: '客户名称', mobile: '客户联系方式' });
    if (bad) return bad;
    const rows: any[] = await this.dataSource.query(
      'SELECT * FROM `kuerp_customers` WHERE customer_code = ? AND third_id = ? LIMIT 1',
      [body.code, v.account.id],
    );
    const customer = rows[0];
    if (!customer) return this.err('未找到相关客户', 27);
    if (Number(customer.status) !== 1) return this.err('此客户状态异常', 27);

    let salerId = 0;
    if (body.saler) {
      const saler: any[] = await this.dataSource.query(
        "SELECT id FROM `kuerp_staff_member` WHERE men_code = ? AND status = '1' LIMIT 1",
        [body.saler],
      );
      if (!saler.length) return this.err('职员不可用', 27);
      salerId = Number(saler[0].id);
    }
    const address = body.address || '';
    // —— 首联系人是否变化：未变化则不动；变化则删除旧联系人并写入新首联系人 ——
    const contact: any[] = await this.dataSource.query(
      `SELECT id FROM \`kuerp_customers_user\`
        WHERE customers_code = ? AND sid = ? AND first_connect_name = ? AND first_connect_mobile = ?
          AND connect_address = ? AND is_first = 1 LIMIT 1`,
      [customer.customer_code, customer.id, body.name, body.mobile, address],
    );
    const now = this.now();
    try {
      await this.dataSource.query(
        `UPDATE \`kuerp_customers\` SET customer_name = ?, connet_name = ?, customer_mobile = ?,
                getgoods_address = ?, note = ?, staff_member_id = ?, updatetime = ? WHERE id = ?`,
        [body.name, body.name, body.mobile, address, body.note || '', salerId, now, customer.id],
      );
      if (!contact.length) {
        await this.dataSource.query('DELETE FROM `kuerp_customers_user` WHERE sid = ?', [
          customer.id,
        ]);
        await this.insert('kuerp_customers_user', {
          customers_code: customer.customer_code,
          sid: customer.id,
          first_connect_name: body.name,
          first_connect_mobile: body.mobile,
          first_connect_phone: '',
          qq_wx_email: '',
          connect_address: address,
          is_first: 1,
          createtime: now,
          updatetime: now,
        });
      }
      return this.succ('编辑成功', '', 1);
    } catch (e: any) {
      return this.err(e?.message || '编辑失败', 27);
    }
  }

  /**
   * 注销客户：无业务数据（销货/退货/其他出库/核销）方可删除，
   * 事务清理客户主表 + 联系人 + 核销来源(type=3) + 往来期初日志(business_type in 5,6)。
   * @param body { mobile }
   */
  async delCustomers(body: any) {
    const v = await this.verify(body, 'customers_delcustomers');
    if (v.fail) return v.fail;
    const bad = this.require(body, { mobile: '电话' });
    if (bad) return bad;
    const rows: any[] = await this.dataSource.query(
      'SELECT * FROM `kuerp_customers` WHERE customer_mobile = ? AND third_id = ? LIMIT 1',
      [body.mobile, v.account.id],
    );
    const customer = rows[0];
    if (!customer) return this.err('未找到相关客户', 27);

    // —— 业务数据保护：任一业务表出现该客户即拒绝注销 ——
    const checks: Array<[string, string]> = [
      ['kuerp_goods_sales_info', 'customers_id'],
      ['kuerp_goods_sales_exchange_info', 'customers_id'],
      ['kuerp_warehouse', 'customers_id'],
    ];
    for (const [table, col] of checks) {
      const hit: any[] = await this.dataSource.query(
        `SELECT id FROM \`${table}\` WHERE \`${col}\` = ? LIMIT 1`,
        [customer.id],
      );
      if (hit.length) return this.err(`${customer.customer_name || '客户'}已有业务数据，不可注销`, 27);
    }
    const woHit: any[] = await this.dataSource.query(
      'SELECT id FROM `kuerp_writeoff` WHERE customers_id = ? OR customers_out_id = ? OR customers_enter_id = ? LIMIT 1',
      [customer.id, customer.id, customer.id],
    );
    if (woHit.length) return this.err(`${customer.customer_name || '客户'}已有业务数据，不可注销`, 27);

    try {
      await this.dataSource.query('DELETE FROM `kuerp_customers` WHERE id = ?', [customer.id]);
      await this.dataSource.query('DELETE FROM `kuerp_customers_user` WHERE sid = ?', [customer.id]);
      await this.dataSource.query(
        'DELETE FROM `kuerp_writeoff_source` WHERE customers_id = ? AND type = 3',
        [customer.id],
      );
      await this.dataSource.query(
        'DELETE FROM `kuerp_sales_payment_log` WHERE bill_code = ? AND business_type IN (5, 6)',
        [customer.customer_code],
      );
      return this.succ('注销成功', '', 1);
    } catch (e: any) {
      return this.err(e?.message || '注销失败', 27);
    }
  }

  // ==================================================================
  // 销货（等价 Sales.php）
  // ==================================================================

  /**
   * 销货单列表（仅本三方账户的单据）。
   * @param body { page?, limit?, keyword?, order_num? }
   */
  async getSalesList(body: any) {
    const v = await this.verify(body, 'sales_getsaleslist');
    if (v.fail) return v.fail;
    const page = Math.max(1, Number(body.page || 1));
    const limit = Math.max(1, Number(body.limit || 10));
    const where: string[] = ['g.third_id = ?'];
    const params: any[] = [v.account.id];
    if (body.keyword) {
      where.push('s.purchase_code LIKE ?');
      params.push(`%${body.keyword}%`);
    }
    if (body.order_num) {
      where.push('g.order_num LIKE ?');
      params.push(`%${body.order_num}%`);
    }
    const whereSql = where.join(' AND ');
    const list: any[] = await this.dataSource.query(
      `SELECT s.purchase_code, s.purchase_time, s.customers_id, c.customer_code, c.customer_name,
              s.receiving_address AS address, s.number, s.all_money, s.preferential_money,
              s.real_money, s.tax_money, s.money_tax_price, s.note, s.createtime
         FROM \`kuerp_goods_sales\` s
         JOIN \`kuerp_goods_salethird\` g ON s.id = g.purchase_id
         JOIN \`kuerp_customers\` c ON s.customers_id = c.id
        WHERE ${whereSql} LIMIT ? OFFSET ?`,
      [...params, limit, (page - 1) * limit],
    );
    for (const row of list) {
      row.purchase_time_text = row.purchase_time
        ? new Date(Number(row.purchase_time) * 1000).toISOString().slice(0, 10)
        : '';
      row.createtime_text = row.createtime
        ? new Date(Number(row.createtime) * 1000).toISOString().slice(0, 19).replace('T', ' ')
        : '';
    }
    const cnt: any[] = await this.dataSource.query(
      `SELECT COUNT(*) AS c
         FROM \`kuerp_goods_sales\` s
         JOIN \`kuerp_goods_salethird\` g ON s.id = g.purchase_id
         JOIN \`kuerp_customers\` c ON s.customers_id = c.id
        WHERE ${whereSql}`,
      params,
    );
    return this.succ('查询成功', { list, count: Number(cnt[0]?.c || 0) }, 200);
  }

  /**
   * 商品行入参校验（等价 sales/returnSales 中对 goods 数组的逐行检查）。
   * 校验：必填字段、同单内「商品+单位+属性」不可重复、商品存在、辅助属性必选。
   * @param goodsData 解析后的商品行数组
   * @param auxiliarySetting 辅助属性开关
   * @returns 错误响应或 null
   */
  private async validateGoodsItems(goodsData: any[], auxiliarySetting: number): Promise<OpenApiResult | null> {
    for (const item of goodsData) {
      const bad = this.require(item, {
        goods_code: '商品编号',
        goods_unit: '商品单位',
        number: '数量',
        price: '商品价格',
      });
      if (bad) return bad;
      if (!('goods_attr' in item)) return this.err('商品属性参数错误', 25);
    }
    for (const item of goodsData) {
      const dup = goodsData.filter(
        (x) =>
          x.goods_code === item.goods_code &&
          String(x.goods_unit) === String(item.goods_unit) &&
          String(x.goods_attr ?? '') === String(item.goods_attr ?? ''),
      );
      if (dup.length > 1) {
        return this.err('同一笔销货单不可存在相同单位,属性的商品', 27);
      }
      const gRows: any[] = await this.dataSource.query(
        'SELECT * FROM `kuerp_goods` WHERE goods_code = ? LIMIT 1',
        [item.goods_code],
      );
      const goods = gRows[0];
      if (!goods) return this.err('商品数据错误', 27);
      if (Number(goods.auxiliary) === 1 && auxiliarySetting === 1 && !item.goods_attr) {
        return this.err(`${goods.goods_name}必须选择商品属性`, 27);
      }
    }
    return null;
  }

  /**
   * 解析 goods 入参（JSON 字符串或已解析数组）。
   * @param raw goods 参数
   * @returns 数组或 null（解析失败）
   */
  private parseGoods(raw: any): any[] | null {
    if (Array.isArray(raw)) return raw;
    if (typeof raw !== 'string') return null;
    try {
      const arr = JSON.parse(raw);
      return Array.isArray(arr) ? arr : null;
    } catch {
      return null;
    }
  }

  /**
   * 构造销货明细行（等价 Sales::setGoodsData）。
   *
   * 整体思路（与原系统逐段对应）：
   *   1. 税金：接口提交单价按「价税合计」口径处理，不含税单价 = 价税合计*100/(100+税率)；
   *   2. 库存分仓：按 kuerp_goods_stock 各仓余量 FIFO 分配（goods_code + 属性）；
   *   3. 批次：批次商品在每仓内按 kuerp_goods_batch_stock 余量继续 FIFO 分配；
   *   4. 序列号：序列号商品按仓取 store_status='1' 的可用序列号，数量不足即失败；
   *   5. 多单位：按单位换算率折算基本数量 basic_nmber（number × advance_rate）。
   * 每条分仓/分批/分序列结果各生成一行明细（与原系统一致，一张单可能拆多行）。
   *
   * @param goodsData 入参商品行数组
   * @param set 系统设置（taxes/taxesRate/batch/serial）
   * @returns { status, msg?, rows? } rows 为明细行（含临时字段 serial_code/goods_batch_info）
   */
  private async buildSalesRows(goodsData: any[], set: ReturnType<OpenApiService['loadSettings']> extends Promise<infer T> ? T : never) {
    const accountRows: any[] = await this.dataSource.query(
      "SELECT id FROM `kuerp_accounts` WHERE is_default = '1' LIMIT 1",
    );
    let accountId = accountRows[0]?.id;
    if (!accountId) {
      const anyAcc: any[] = await this.dataSource.query('SELECT id FROM `kuerp_accounts` LIMIT 1');
      accountId = anyAcc[0]?.id;
      if (!accountId) return { status: 0, msg: '未查询到可用账户' };
    }

    const out: any[] = [];
    const now = this.now();
    for (const item of goodsData) {
      const gRows: any[] = await this.dataSource.query(
        'SELECT * FROM `kuerp_goods` WHERE goods_code = ? LIMIT 1',
        [item.goods_code],
      );
      const goods = gRows[0];
      if (!goods) return { status: 0, msg: `商品不存在: ${item.goods_code}` };
      const number = Number(item.number);
      const attr = item.goods_attr || 0;

      // —— 1. 税金口径：提交价格为价税合计，反推不含税单价 ——
      let unitPrice: number;
      let taxIncluded: number;
      if (set.taxes === 1) {
        taxIncluded = Number(item.price);
        const denom = 100 + set.taxesRate;
        unitPrice = denom === 0 ? taxIncluded : (taxIncluded * 100) / denom;
      } else {
        unitPrice = Number(item.price);
        taxIncluded = Number(item.price);
      }
      const allMoney = unitPrice * number;
      const moneyTaxPrice = taxIncluded * number;
      const taxMoney = moneyTaxPrice - allMoney;

      // —— 2. 分仓 FIFO：同商品（同属性）全部仓余量分配 ——
      const stockWhere: string[] = ['goods_code = ?'];
      const stockParams: any[] = [goods.goods_code];
      if (Number(attr) > 0) {
        stockWhere.push('attribute_id = ?');
        stockParams.push(attr);
      }
      const stockRows: any[] = await this.dataSource.query(
        `SELECT stores_id, stock FROM \`kuerp_goods_stock\` WHERE ${stockWhere.join(' AND ')}`,
        stockParams,
      );
      if (!stockRows.length) return { status: 0, msg: `${goods.goods_name}商品库存不足` };
      const allowStock = stockRows.reduce((s, r) => s + Number(r.stock || 0), 0);
      let need = number;
      const alloc: Array<{ stores_id: number; number: number; batch_id?: number; batch_name?: string; manufacture?: any; guarantee?: any; validity?: any; serial_code?: string[]; period?: string }> = [];
      for (const r of stockRows) {
        if (need <= 0) break;
        const take = need < Number(r.stock) ? need : Number(r.stock);
        alloc.push({ stores_id: Number(r.stores_id), number: take });
        need -= take;
      }

      // —— 3. 批次分批：批次商品在各仓内按批次余量二次分配 ——
      if (Number(goods.batch) === 1 && set.batch === 1) {
        const batchAlloc: any[] = [];
        for (const a of alloc) {
          const bw: string[] = ['goods_id = ?', 'stores_id = ?'];
          const bp: any[] = [goods.id, a.stores_id];
          if (Number(attr) > 0) {
            bw.push('attribute_id = ?');
            bp.push(attr);
          }
          const batchStock: any[] = await this.dataSource.query(
            `SELECT * FROM \`kuerp_goods_batch_stock\` WHERE ${bw.join(' AND ')}`,
            bp,
          );
          if (!batchStock.length) return { status: 0, msg: '批次信息查询失败' };
          let bNeed = a.number;
          for (const bs of batchStock) {
            if (bNeed <= 0) break;
            const batchRows: any[] = await this.dataSource.query(
              'SELECT * FROM `kuerp_goods_batch` WHERE id = ? LIMIT 1',
              [bs.batch_id],
            );
            const batch = batchRows[0];
            if (!batch) return { status: 0, msg: '批次信息查询失败' };
            const take = bNeed < Number(bs.stock) ? bNeed : Number(bs.stock);
            batchAlloc.push({
              stores_id: a.stores_id,
              batch_id: Number(bs.batch_id),
              number: take,
              batch_name: batch.batch_name,
              manufacture: batch.manufacture,
              guarantee: batch.guarantee,
              validity: batch.validity,
            });
            bNeed -= take;
          }
        }
        alloc.length = 0;
        alloc.push(...batchAlloc);
      }

      // —— 4. 序列号分配：每仓按可用序列号取号，不足即失败 ——
      for (const a of alloc) {
        if (Number(goods.serial) === 1 && set.serial === 1) {
          const sw: string[] = ['goods_id = ?', 'stores_id = ?', "store_status = '1'"];
          const sp: any[] = [goods.id, a.stores_id];
          if (Number(attr) > 0) {
            sw.push('attribute_id = ?');
            sp.push(attr);
          }
          const serials: any[] = await this.dataSource.query(
            `SELECT serial, remark FROM \`kuerp_goods_serial\` WHERE ${sw.join(' AND ')} LIMIT ${Math.ceil(a.number)}`,
            sp,
          );
          if (serials.length < Math.ceil(a.number)) {
            return { status: 0, msg: '商品可用序列号不足' };
          }
          a.period = JSON.stringify(serials.map((s) => ({ serial: s.serial, remark: s.remark })));
          a.serial_code = serials.map((s) => s.serial);
        }

        // —— 5. 明细行组装（含批次字段与临时字段，落库前剥离临时字段）——
        const rate = await this.advanceRate(goods, item.goods_unit);
        const hasBatch = 'batch_id' in a;
        out.push({
          goods_code: item.goods_code,
          goods_note: goods.note,
          goods_unit: item.goods_unit,
          stores_id: a.stores_id,
          allow_stock: allowStock,
          number: a.number,
          default_unit: goods.unit_id,
          basic_nmber: a.number * rate,
          unit_price: unitPrice,
          cost_price: 0,
          discount: 0,
          dis_money: 0,
          all_money: allMoney,
          remark: '',
          goods_attr: attr,
          tax_included: taxIncluded,
          tax_rate: set.taxesRate,
          tax_money: taxMoney,
          money_tax_price: moneyTaxPrice,
          batch_id: hasBatch ? a.batch_id : 0,
          batch_name: a.batch_name ?? '',
          manufacture: a.manufacture ?? null,
          guarantee: a.guarantee ?? null,
          validity: a.validity ?? null,
          preferential_rate: 0,
          preferential_money: 0,
          real_money: moneyTaxPrice,
          purchase_money: 0,
          pay_status: 1,
          pay_money: moneyTaxPrice,
          account: accountId,
          createtime: now,
          updatetime: now,
          goods_batch_info: hasBatch
            ? {
                batch_id: a.batch_id,
                goods_id: goods.id,
                goods_code: goods.goods_code,
                attribute_id: attr,
                goods_unit: item.goods_unit,
                stores_id: a.stores_id,
                stock: a.number,
                number: a.number,
                batch_name: a.batch_name ?? '',
                manufacture: a.manufacture ?? null,
                guarantee: a.guarantee ?? null,
                validity: a.validity ?? null,
                status: '0',
                type: 2,
                createtime: now,
                updatetime: now,
              }
            : null,
          period: a.period ?? '',
          serial_code: a.serial_code ?? [],
        });
      }
    }
    return { status: 1, rows: out };
  }

  /**
   * 添加销货单（三方下单入口）。
   *
   * 流程（与原系统 sales() 一致）：
   *   生成单号 → 结账守卫 → 客户校验（手机号 + third_id）→ 外部订单号查重 →
   *   商品行校验/组装（税金/分仓/批次/序列号/多单位）→ 写主表 + salethird 映射 +
   *   明细 + 批次 + 序列号占用 → 系统未开「审核」时自动过账。
   *
   * @param body { order_num, mobile, goods, address?, note?, preferential_money? }
   */
  async sales(body: any) {
    const v = await this.verify(body, 'sales_sales');
    if (v.fail) return v.fail;
    const bad = this.require(body, { order_num: '外部订单号', mobile: '客户', goods: '商品' });
    if (bad) return bad;

    const set = await this.loadSettings();
    const codeRet = await this.tableService.genCodeByRule('kuerp_goods_sales', 'purchase_code');
    const purchaseCode = codeRet.code;
    const purchaseTime = this.today0();

    const guard = await this.guardCheckout(purchaseTime);
    if (guard) return guard;

    // —— 客户校验：手机号必须已注册到本三方账户且状态正常 ——
    const cRows: any[] = await this.dataSource.query(
      'SELECT * FROM `kuerp_customers` WHERE customer_mobile = ? AND third_id = ? LIMIT 1',
      [body.mobile, v.account.id],
    );
    const customer = cRows[0];
    if (!customer) return this.err('此手机号未注册', 27);
    if (Number(customer.status) !== 1) return this.err('客户状态异常', 27);

    // —— 外部订单号防重：同一三方账户下 order_num 只能建一张销货单 ——
    const dup: any[] = await this.dataSource.query(
      'SELECT id FROM `kuerp_goods_salethird` WHERE order_num = ? AND third_id = ? LIMIT 1',
      [body.order_num, v.account.id],
    );
    if (dup.length) return this.err('此订单号已创建销货单', 27);

    const goodsData = this.parseGoods(body.goods);
    if (!goodsData || !goodsData.length) return this.err('商品数据解析失败', 27);
    const badItems = await this.validateGoodsItems(goodsData, set.auxiliary);
    if (badItems) return badItems;

    const built = await this.buildSalesRows(goodsData, set);
    if (built.status !== 1) return this.err(built.msg, 27);
    const rows = built.rows as any[];

    // —— 汇总表头金额（数量/金额/税额/价税合计）——
    let number = 0, allMoney = 0, taxMoney = 0, moneyTaxPrice = 0;
    for (const r of rows) {
      number += Number(r.number);
      allMoney += Number(r.all_money);
      taxMoney += Number(r.tax_money);
      moneyTaxPrice += Number(r.money_tax_price);
    }
    const preferential = Number(body.preferential_money || 0);
    const preferentialRate = moneyTaxPrice > 0 ? preferential / moneyTaxPrice : 0;
    const now = this.now();
    const head = {
      purchase_code: purchaseCode,
      purchase_type: 1,
      purchase_time: purchaseTime,
      customers_id: customer.id,
      sale_user: 0,
      receiving_address: body.address || customer.getgoods_address || '',
      customers_money: 0,
      number,
      all_money: allMoney,
      tax_money: taxMoney,
      money_tax_price: moneyTaxPrice,
      preferential_rate: preferentialRate,
      preferential_money: preferential,
      real_money: moneyTaxPrice - preferential,
      purchase_money: 0,
      note: body.note || '',
      arrears: 0,
      all_arrears: 0,
      pay_status: 1,
      pay_money: moneyTaxPrice - preferential,
      account: rows[0].account,
      cost_data: null,
      third_id: v.account.id,
      createtime: now,
      updatetime: now,
    };

    try {
      const id = await this.insert('kuerp_goods_sales', head);
      await this.insert('kuerp_goods_salethird', {
        order_num: body.order_num,
        purchase_id: id,
        third_id: v.account.id,
        createtime: now,
        updatetime: now,
      });
      for (const r of rows) {
        const { serial_code, goods_batch_info, ...infoRow } = r;
        const infoId = await this.insert('kuerp_goods_sales_info', {
          ...infoRow,
          purchase_code: purchaseCode,
          purchase_type: 1,
          purchase_time: purchaseTime,
          customers_id: customer.id,
          sale_user: 0,
          receiving_address: head.receiving_address,
        });
        if (goods_batch_info) {
          await this.insert('kuerp_goods_batch_sale_info', {
            ...goods_batch_info,
            purchase_info_id: infoId,
          });
        }
        if (serial_code && serial_code.length) {
          const holders = serial_code.map(() => '?').join(',');
          await this.dataSource.query(
            `UPDATE \`kuerp_goods_serial\` SET status = '3', sale_id = ?, sale_code = ? WHERE serial IN (${holders})`,
            [infoId, purchaseCode, ...serial_code],
          );
        }
      }
      // —— 自动审核：系统未开「审核」开关时立即过账（失败不阻断开单，与原系统一致）——
      if (set.examine !== 1) {
        try {
          await this.tableService.examine('goods-sales', id, 1);
        } catch {
          /* 过账失败交由后台人工审核处理 */
        }
      }
      return this.succ('添加成功', { id, purchase_code: purchaseCode }, 1);
    } catch (e: any) {
      return this.err(e?.message || '添加失败', 27);
    }
  }

  /**
   * 销货单详情（主表 + 明细，明细附单位名与辅助属性名）。
   * @param body { purchase_code }
   */
  async salesInfo(body: any) {
    const v = await this.verify(body, 'sales_salesinfo');
    if (v.fail) return v.fail;
    const bad = this.require(body, { purchase_code: '销货单编号' });
    if (bad) return bad;
    return this.docInfo('kuerp_goods_sales', 'kuerp_goods_salethird', 'kuerp_goods_sales_info', body.purchase_code, v.account.id);
  }

  /**
   * 添加销货退货单（三方退货入口）。
   *
   * 流程（与原系统 returnSales() 一致）：
   *   定位原销货单（order_num + third_id，须已审核）→ 生成退货单号 → 结账守卫 →
   *   客户校验 → exchangethird 查重 → 逐行与原单明细匹配（商品+单位+属性）→
   *   批次/序列号沿用原单批次并校验可用量 → 写退货主表 + saleexc 关联 +
   *   exchangethird 映射 + 明细 + 批次 + 序列号 + 明细级退货关联 → 自动过账。
   *
   * @param body { order_num, mobile, goods, address?, note?, preferential_money? }
   */
  async returnSales(body: any) {
    const v = await this.verify(body, 'sales_returnsales');
    if (v.fail) return v.fail;
    const bad = this.require(body, { order_num: '外部订单号', mobile: '客户', goods: '商品' });
    if (bad) return bad;

    const set = await this.loadSettings();

    // —— 原销货单定位：仅本三方账户，且必须已审核 ——
    const origRows: any[] = await this.dataSource.query(
      `SELECT s.*, c.customer_code, c.customer_name
         FROM \`kuerp_goods_sales\` s
         JOIN \`kuerp_goods_salethird\` g ON s.id = g.purchase_id
         JOIN \`kuerp_customers\` c ON s.customers_id = c.id
        WHERE g.order_num = ? AND g.third_id = ? LIMIT 1`,
      [body.order_num, v.account.id],
    );
    const orig = origRows[0];
    if (!orig) return this.err('未查询到相关数据', 27);
    if (Number(orig.examine_status) !== 1) return this.err('此销货单未审核，不可退货', 27);
    const origInfo: any[] = await this.dataSource.query(
      'SELECT * FROM `kuerp_goods_sales_info` WHERE purchase_code = ?',
      [orig.purchase_code],
    );

    const codeRet = await this.tableService.genCodeByRule('kuerp_goods_sales_exchange', 'purchase_code');
    const purchaseCode = codeRet.code;
    const purchaseTime = this.today0();
    const guard = await this.guardCheckout(purchaseTime);
    if (guard) return guard;

    const cRows: any[] = await this.dataSource.query(
      'SELECT * FROM `kuerp_customers` WHERE customer_mobile = ? AND third_id = ? LIMIT 1',
      [body.mobile, v.account.id],
    );
    const customer = cRows[0];
    if (!customer) return this.err('此手机号未注册', 27);
    if (Number(customer.status) !== 1) return this.err('客户状态异常', 27);

    const dup: any[] = await this.dataSource.query(
      'SELECT id FROM `kuerp_goods_exchangethird` WHERE order_num = ? AND third_id = ? LIMIT 1',
      [body.order_num, v.account.id],
    );
    if (dup.length) return this.err('此订单号已创建销货退货单', 27);

    const goodsData = this.parseGoods(body.goods);
    if (!goodsData || !goodsData.length) return this.err('商品数据解析失败', 27);
    const badItems = await this.validateGoodsItems(goodsData, set.auxiliary);
    if (badItems) return badItems;

    const accountRows: any[] = await this.dataSource.query(
      "SELECT id FROM `kuerp_accounts` WHERE is_default = '1' LIMIT 1",
    );
    let accountId = accountRows[0]?.id;
    if (!accountId) {
      const anyAcc: any[] = await this.dataSource.query('SELECT id FROM `kuerp_accounts` LIMIT 1');
      accountId = anyAcc[0]?.id;
      if (!accountId) return this.err('未查询到可用账户', 27);
    }
    const now = this.now();

    // —— 逐行与原单明细匹配，构造退货明细行（批次沿用原单、序列号校验可用量）——
    const data: any[] = [];
    for (const item of goodsData) {
      let matched = false;
      for (const o of origInfo) {
        const attrSame = o.goods_attr ? String(o.goods_attr) === String(item.goods_attr || '') : !item.goods_attr;
        if (String(o.goods_code) === String(item.goods_code) && String(o.goods_unit) === String(item.goods_unit) && attrSame) {
          matched = true;
          const gRows: any[] = await this.dataSource.query(
            'SELECT * FROM `kuerp_goods` WHERE goods_code = ? LIMIT 1',
            [item.goods_code],
          );
          const goods = gRows[0];
          if (!goods) return this.err(`商品不存在: ${item.goods_code}`, 27);

          // 批次：原单行必须带批次，退货沿用原批次信息
          let goodsBatchInfo: any = null;
          if (Number(goods.batch) === 1 && set.batch === 1) {
            if (!o.batch_id) return this.err('销货单批次信息错误，不可退货', 27);
            const batchRows: any[] = await this.dataSource.query(
              'SELECT * FROM `kuerp_goods_batch` WHERE id = ? LIMIT 1',
              [o.batch_id],
            );
            if (!batchRows.length) return this.err('批次信息查询失败', 27);
            goodsBatchInfo = {
              batch_id: o.batch_id,
              goods_id: goods.id,
              goods_code: goods.goods_code,
              attribute_id: item.goods_attr || 0,
              goods_unit: Number(item.goods_unit),
              stores_id: o.stores_id,
              stock: Number(item.number),
              number: Number(item.number),
              batch_name: o.batch_name || '',
              manufacture: o.manufacture,
              guarantee: o.guarantee,
              validity: o.validity,
              status: '0',
              type: 2,
              createtime: now,
              updatetime: now,
            };
          }

          // 序列号：原单行 period 反查序列号，可用量须覆盖退货数量
          let period = '';
          let serialCode: string[] = [];
          if (Number(goods.serial) === 1 && set.serial === 1) {
            const origSerials = this.parsePeriodJson(o.period);
            const codes = origSerials.map((s) => s.serial);
            if (codes.length) {
              const holders = codes.map(() => '?').join(',');
              const avail: any[] = await this.dataSource.query(
                `SELECT serial, remark FROM \`kuerp_goods_serial\` WHERE store_status = '1' AND serial IN (${holders}) LIMIT ${Math.ceil(Number(item.number))}`,
                codes,
              );
              if (avail.length < Math.ceil(Number(item.number))) {
                return this.err('商品可用序列号不足，退货失败', 27);
              }
              period = JSON.stringify(avail.map((s) => ({ serial: s.serial, remark: s.remark })));
              serialCode = avail.map((s) => s.serial);
            }
          }

          // 税金与金额（接口提交价格按价税合计口径）
          const number = Number(item.number);
          let unitPrice: number, taxIncluded: number;
          if (set.taxes === 1) {
            taxIncluded = Number(item.price);
            const denom = 100 + set.taxesRate;
            unitPrice = denom === 0 ? taxIncluded : (taxIncluded * 100) / denom;
          } else {
            unitPrice = Number(item.price);
            taxIncluded = Number(item.price);
          }
          const allMoney = unitPrice * number;
          const moneyTaxPrice = taxIncluded * number;
          const taxMoney = moneyTaxPrice - allMoney;
          const rate = await this.advanceRate(goods, item.goods_unit);

          data.push({
            purchase_code: purchaseCode,
            purchase_type: 2,
            purchase_time: purchaseTime,
            customers_id: customer.id,
            sale_user: 0,
            receiving_address: body.address || customer.getgoods_address || '',
            goods_code: o.goods_code,
            goods_note: o.remark,
            goods_unit: o.goods_unit,
            stores_id: o.stores_id,
            allow_stock: o.number,
            number,
            default_unit: o.default_unit,
            basic_nmber: number * rate,
            unit_price: unitPrice,
            cost_price: 0,
            discount: 0,
            dis_money: 0,
            all_money: allMoney,
            remark: '',
            goods_attr: item.goods_attr || 0,
            tax_included: taxIncluded,
            tax_rate: set.taxesRate,
            tax_money: taxMoney,
            money_tax_price: moneyTaxPrice,
            batch_id: o.batch_id,
            batch_name: o.batch_name || '',
            manufacture: o.manufacture,
            guarantee: o.guarantee,
            validity: o.validity,
            preferential_rate: 0,
            preferential_money: 0,
            real_money: moneyTaxPrice,
            purchase_money: 0,
            purchase_info_id: o.id,
            purchase_id: orig.purchase_code,
            retreat_number: number,
            retreat_status: 1,
            retreat_money: moneyTaxPrice,
            account: accountId,
            createtime: now,
            updatetime: now,
            goods_batch_info: goodsBatchInfo,
            period,
            serial_code: serialCode,
          });
        }
      }
      if (!matched) return this.err('退货单商品数据与购货单商品数据不符，退货单创建失败', 1);
    }

    // —— 汇总表头（number 沿用原单数量，与原系统 quirk 一致）——
    let allMoney = 0, taxMoney = 0, moneyTaxPrice = 0, retreatNumber = 0;
    for (const r of data) {
      retreatNumber += Number(r.number);
      allMoney += Number(r.all_money);
      taxMoney += Number(r.tax_money);
      moneyTaxPrice += Number(r.money_tax_price);
    }
    const preferential = Number(body.preferential_money || 0);
    const preferentialRate = moneyTaxPrice > 0 ? preferential / moneyTaxPrice : 0;
    const head = {
      purchase_code: purchaseCode,
      purchase_type: 2,
      purchase_time: purchaseTime,
      customers_id: customer.id,
      sale_user: 0,
      receiving_address: body.address || customer.getgoods_address || '',
      customers_money: 0,
      number: Number(orig.number),
      all_money: allMoney,
      tax_money: taxMoney,
      money_tax_price: moneyTaxPrice,
      preferential_rate: preferentialRate,
      preferential_money: preferential,
      real_money: moneyTaxPrice - preferential,
      purchase_money: 0,
      note: body.note || '',
      arrears: 0,
      all_arrears: 0,
      pay_status: 1,
      pay_money: moneyTaxPrice - preferential,
      purchase_id: orig.purchase_code,
      retreat_number: retreatNumber,
      retreat_status: 1,
      retreat_money: moneyTaxPrice - preferential,
      account: accountId,
      cost_data: null,
      third_id: v.account.id,
      createtime: now,
      updatetime: now,
    };

    try {
      const id = await this.insert('kuerp_goods_sales_exchange', head);
      await this.insert('kuerp_goods_saleexc', { purchase_id: orig.id, exchange_id: id });
      await this.insert('kuerp_goods_exchangethird', {
        order_num: body.order_num,
        purchase_id: id,
        third_id: v.account.id,
        createtime: now,
        updatetime: now,
      });
      for (const r of data) {
        const { serial_code, goods_batch_info, ...infoRow } = r;
        const infoId = await this.insert('kuerp_goods_sales_exchange_info', infoRow);
        if (goods_batch_info) {
          await this.insert('kuerp_goods_batch_salee_info', {
            ...goods_batch_info,
            purchase_info_id: infoId,
          });
        }
        if (serial_code && serial_code.length) {
          const holders = serial_code.map(() => '?').join(',');
          await this.dataSource.query(
            `UPDATE \`kuerp_goods_serial\` SET status = '4', purchase_exchange_id = ?, purchase_exchange_code = ? WHERE serial IN (${holders})`,
            [infoId, purchaseCode, ...serial_code],
          );
        }
        // 明细级退货关联（原单明细 ← 退货明细，金额/税额快照）
        if (infoRow.purchase_info_id) {
          await this.insert('kuerp_goods_saleexc_info', {
            purchase_id: infoRow.purchase_info_id,
            exchange_id: infoId,
            type: infoRow.purchase_type,
            number: infoRow.retreat_number,
            money: infoRow.retreat_money,
            all_money: infoRow.all_money,
            tax_rate: infoRow.tax_rate,
            tax_money: infoRow.tax_money,
            money_tax_price: infoRow.money_tax_price,
          });
        }
      }
      if (set.examine !== 1) {
        try {
          await this.tableService.examine('goods-sales-exchange', id, 1);
        } catch {
          /* 过账失败交由后台人工审核处理 */
        }
      }
      return this.succ('添加成功', { id, purchase_code: purchaseCode }, 1);
    } catch (e: any) {
      return this.err(e?.message || '添加失败', 27);
    }
  }

  /**
   * 销货退货单详情（主表 + 明细，明细附单位名与辅助属性名）。
   * @param body { purchase_code }
   */
  async returnSalesInfo(body: any) {
    const v = await this.verify(body, 'sales_returnsalesinfo');
    if (v.fail) return v.fail;
    const bad = this.require(body, { purchase_code: '销货退货单编号' });
    if (bad) return bad;
    return this.docInfo(
      'kuerp_goods_sales_exchange',
      'kuerp_goods_exchangethird',
      'kuerp_goods_sales_exchange_info',
      body.purchase_code,
      v.account.id,
    );
  }

  /**
   * 销货/退货单详情公共实现（等价 salesInfo / returnSalesInfo）。
   * @param headTable 单据主表
   * @param thirdTable 三方映射表
   * @param infoTable 明细表
   * @param purchaseCode 单号
   * @param thirdId 三方账户ID（数据隔离）
   */
  private async docInfo(
    headTable: string,
    thirdTable: string,
    infoTable: string,
    purchaseCode: string,
    thirdId: number,
  ) {
    const rows: any[] = await this.dataSource.query(
      `SELECT s.purchase_code, s.purchase_time, s.customers_id, c.customer_code, c.customer_name,
              s.receiving_address AS address, s.number, s.all_money, s.preferential_money,
              s.real_money, s.tax_money, s.money_tax_price, s.note, s.createtime
         FROM \`${headTable}\` s
         JOIN \`${thirdTable}\` g ON s.id = g.purchase_id
         JOIN \`kuerp_customers\` c ON s.customers_id = c.id
        WHERE g.third_id = ? AND s.purchase_code = ? LIMIT 1`,
      [thirdId, purchaseCode],
    );
    const head = rows[0];
    if (!head) return this.err('未查询到相关数据', 27);
    head.purchase_time_text = head.purchase_time
      ? new Date(Number(head.purchase_time) * 1000).toISOString().slice(0, 10)
      : '';
    head.createtime_text = head.createtime
      ? new Date(Number(head.createtime) * 1000).toISOString().slice(0, 19).replace('T', ' ')
      : '';
    const info: any[] = await this.dataSource.query(
      `SELECT gs.goods_code, gs.goods_note, gs.goods_attr, gs.goods_unit, u.name AS unit_name,
              gs.number, gs.unit_price, gs.tax_included, gs.all_money, gs.tax_money, gs.money_tax_price
         FROM \`${infoTable}\` gs
         JOIN \`kuerp_goods\` g ON gs.goods_code = g.goods_code
         JOIN \`kuerp_unit\` u ON u.id = gs.goods_unit
        WHERE gs.purchase_code = ?`,
      [purchaseCode],
    );
    // 辅助属性名：attr 明细 → 属性组合 → 各属性值名用 / 拼接
    for (const row of info) {
      const attrRows: any[] = await this.dataSource.query(
        'SELECT attribute_id FROM `kuerp_goods_attr` WHERE id = ? LIMIT 1',
        [row.goods_attr],
      );
      let attrName = '';
      if (attrRows[0]) {
        const comb: any[] = await this.dataSource.query(
          'SELECT attr_ids FROM `kuerp_aux_combination` WHERE id = ? LIMIT 1',
          [attrRows[0].attribute_id],
        );
        if (comb[0]?.attr_ids) {
          const ids = String(comb[0].attr_ids).split('&');
          const holders = ids.map(() => '?').join(',');
          const names: any[] = await this.dataSource.query(
            `SELECT name FROM \`kuerp_auxiliary\` WHERE id IN (${holders})`,
            ids,
          );
          attrName = names.map((n) => n.name).join('/');
        }
      }
      row.attr_name = attrName;
    }
    head.info_list = info;
    return this.succ('查询成功', head, 1);
  }

  /**
   * 解析 period 字段为序列号数组（本模块写入统一为 JSON 数组格式）。
   * @param raw period 原文
   */
  private parsePeriodJson(raw: any): Array<{ serial: string; remark: string }> {
    if (!raw) return [];
    try {
      const arr = JSON.parse(String(raw));
      return Array.isArray(arr)
        ? arr.map((x: any) => ({ serial: String(x?.serial ?? ''), remark: String(x?.remark ?? '') }))
        : [];
    } catch {
      return [];
    }
  }
}
