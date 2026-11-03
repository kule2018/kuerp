import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ShopAuthService } from './shop-auth.service';

/**
 * 价格字段选取结果（等价 Order\Index::getPriceField 的返回值）。
 *
 * login：会员是否已绑定客户（未绑定则不下发价格）；
 * customerlevel：客户等级（1 零售 / 2 批发 / 3 VIP / 4、5 走折扣率）；
 * field：本次应取的价格列名。
 */
interface PriceField {
  login: boolean;
  customerlevel: number;
  field: string;
}

/**
 * 订货通小程序端业务服务。
 *
 * 覆盖原系统 `application/api/controller/kuerp/order/` 下的 Index / Address /
 * Config 三个控制器（User / Weixin / Sms / Common 分别在 shop-auth、shop-wechat、
 * shop-sms 中实现），逻辑与 SQL 语义 1:1 对齐，差异点均已就地注释。
 *
 * 通用约定（与原系统一致）：
 *   - 所有时间字段为秒级 bigint；
 *   - 金额展示走「整数部分 + 小数部分」两字段（price + decimal），小程序端自行拼接；
 *   - 图片地址统一经 cdnUrl() 转换（原系统 cdnurl()）。
 */
@Injectable()
export class ShopService {
  /** 无图时使用的占位图（等价 Index::$goods_image） */
  private readonly noImage = '/assets/addons/kuerp/img/noimage.png';

  constructor(
    private readonly dataSource: DataSource,
    private readonly auth: ShopAuthService,
  ) {}

  // ==================================================================
  // 一、基础工具
  // ==================================================================

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /** 本月 1 日 0 点 / 本月最后一天 23:59:59 的秒级时间戳（等价 strtotime(date('Y-m-01'))） */
  private monthRange(): [number, number] {
    const d = new Date();
    const first = new Date(d.getFullYear(), d.getMonth(), 1);
    const last = new Date(d.getFullYear(), d.getMonth() + 1, 0, 23, 59, 59);
    return [Math.floor(first.getTime() / 1000), Math.floor(last.getTime() / 1000)];
  }

  /**
   * 图片地址转换（等价 cdnurl($path, true)）。
   * 优先读取 env CDN_URL 作为前缀；未配置时原样返回（相对路径由小程序域名拼接）。
   *
   * @param path 数据库中的图片相对路径
   * @returns 可直接访问的 URL；空值返回空串
   */
  cdnUrl(path: any): string {
    const p = String(path ?? '').trim();
    if (!p) return '';
    if (/^https?:\/\//i.test(p)) return p;
    const base = String(process.env.CDN_URL || '').replace(/\/+$/, '');
    if (!base) return p;
    return base + (p.startsWith('/') ? p : '/' + p);
  }

  /**
   * 金额拆分（等价 PHP 端 explode('.', $price) 后拼 decimal 的逻辑）。
   *
   * 注意：原 PHP 在小数位超过 2 位时用了 substr($price[1], 1, 2)（从第 2 位截），
   * 属于明显笔误；由于库内金额列为 double(15,4)，实际可能命中该分支，
   * 故这里按业务本意取前两位（substr 0,2），并在下方注释标注差异。
   *
   * @param value 金额（数字或字符串）
   * @param prefix 整数部分写回的字段名，默认 price
   * @param decKey 小数部分写回的字段名，默认 decimal
   * @returns 形如 { price: '12', decimal: '50' } 的对象（含原对象其它字段由调用方合并）
   */
  splitPrice(value: any, prefix = 'price', decKey = 'decimal'): Record<string, any> {
    if (value === '' || value === null || value === undefined) return { [decKey]: '' };
    const s = String(value);
    const [intPart, rawDec] = s.split('.');
    let dec = rawDec ?? '';
    if (dec.length === 0) dec = '00';
    else if (dec.length === 1) dec = dec + '0';
    else dec = dec.slice(0, 2);
    return { [prefix]: intPart, [decKey]: dec };
  }

  /**
   * 计算本次应取的价格字段（等价 Index::getPriceField）。
   * 未绑定客户 → 不下发价格（login=false），field 回落到零售价。
   *
   * @param user 当前会员行（可为 null，代表游客）
   */
  private async priceField(user: any): Promise<PriceField> {
    const out: PriceField = { login: false, customerlevel: 0, field: 'market_sell_price' };
    if (!user || Number(user.binding) !== 1 || !user.customers_id) return out;

    const rows: any[] = await this.dataSource.query(
      'SELECT `customerlevel_id` FROM `kuerp_customers` WHERE `id` = ? LIMIT 1',
      [user.customers_id],
    );
    const level = Number(rows?.[0]?.customerlevel_id || 0);
    out.customerlevel = level;
    out.login = true;
    if (level === 2) out.field = 'wholesale_price';
    else if (level === 3) out.field = 'vip_price';
    return out;
  }

  /** 按折扣规则算最终单价（对应 PHP 中 customerlevel==4/5 的折扣分支） */
  private applyDiscount(
    price: any,
    discount: any,
    discount2: any,
    pf: PriceField,
    decimal: number,
  ): any {
    const p = Number(price || 0);
    if (pf.customerlevel === 4) return this.round(p * (Number(discount || 0) / 100), decimal);
    if (pf.customerlevel === 5) return this.round(p * (Number(discount2 || 0) / 100), decimal);
    return price;
  }

  /** 四舍五入到指定小数位（等价 PHP round） */
  private round(v: number, digits: number): number {
    const f = Math.pow(10, Math.max(0, digits));
    return Math.round(v * f) / f;
  }

  /** 读取系统参数 kuerp_sets 中的单个值（等价 Db::name('kuerp_sets')->where(['name'=>..])->value('value')） */
  private async setValue(name: string): Promise<string> {
    const rows: any[] = await this.dataSource.query(
      'SELECT `value` FROM `kuerp_sets` WHERE `name` = ? LIMIT 1',
      [name],
    );
    return rows?.[0]?.value ?? '';
  }

  /** 取单行 */
  private async one(sql: string, params: any[] = []): Promise<any> {
    const rows: any[] = await this.dataSource.query(sql, params);
    return rows?.[0] ?? null;
  }

  /** 取多行 */
  private async many(sql: string, params: any[] = []): Promise<any[]> {
    return (await this.dataSource.query(sql, params)) || [];
  }

  // ==================================================================
  // 二、商品域
  // ==================================================================

  /**
   * 读取商品的多单位与各单位价格、库存（等价 Index::getGoodsUnit）。
   *
   * @param goodsId 商品 ID
   * @param goodsUnit 指定单位 ID（原系统由调用方自行筛选，这里保留参数以对齐签名）
   * @param goodsAttr 指定属性组合 ID（用于按属性维度统计库存与取属性价）
   * @param user 当前会员（决定是否下发价格与取哪一档价格），可为 null 代表游客
   * @returns 单位数组，元素含 unit/price/stock/advance_rate/name/is_default
   */
  async getGoodsUnit(goodsId: number, goodsUnit: any = '', goodsAttr: any = '', user: any = null): Promise<any[]> {
    const pf = await this.priceField(user);
    const priceDecimal = Number((await this.setValue('price_decimal')) || 0);

    const row = await this.one(
      'SELECT `more_unit`,`unit_id`,`more_unit_id`, `' +
        pf.field +
        '` AS `price`, `discount`,`discount2`,`auxiliary` FROM `kuerp_goods` WHERE `id` = ? LIMIT 1',
      [goodsId],
    );
    if (!row) return [];

    // 库存：按商品（可选按属性）汇总所有仓库
    let stockSql = 'SELECT COALESCE(SUM(`stock`),0) AS `stock` FROM `kuerp_goods_stock` WHERE `goods_id` = ?';
    const stockParams: any[] = [goodsId];
    if (goodsAttr) {
      const attr = await this.one(
        'SELECT `attribute_id` FROM `kuerp_goods_attr` WHERE `goods_id` = ? AND `id` = ? LIMIT 1',
        [goodsId, goodsAttr],
      );
      if (attr?.attribute_id) {
        stockSql += ' AND `attribute_id` = ?';
        stockParams.push(attr.attribute_id);
      }
    }
    const stockRow = await this.one(stockSql, stockParams);
    const stock = Number(stockRow?.stock ?? 0);

    let list: any[] = [];

    if (Number(row.more_unit) !== 1) {
      // 单计量单位
      const unitName = (await this.one('SELECT `name` FROM `kuerp_unit` WHERE `id` = ? LIMIT 1', [row.unit_id]))
        ?.name;
      let price = row.price;
      let discount = row.discount;
      let discount2 = row.discount2;

      // 启用辅助属性时，价格取属性行的价格
      if (Number(row.auxiliary) === 1) {
        const attrWhere = goodsAttr ? ' AND `id` = ?' : '';
        const attrParams: any[] = goodsAttr ? [goodsId, goodsAttr] : [goodsId];
        const attr = await this.one(
          'SELECT `' + pf.field + '` AS `price`,`discount`,`discount2` FROM `kuerp_goods_attr` WHERE `goods_id` = ?' +
            attrWhere +
            ' LIMIT 1',
          attrParams,
        );
        price = attr?.price ?? 0;
        discount = attr?.discount ?? 0;
        discount2 = attr?.discount2 ?? 0;
      }

      list = [
        {
          unit: row.unit_id,
          price,
          discount,
          discount2,
          is_default: 1,
          name: unitName,
          stock,
          advance_rate: 1,
        },
      ];
    } else {
      // 多计量单位：主单位 + 换算单位
      const mainUnit = row.more_unit_id;
      const conversions: any[] = await this.many(
        'SELECT `vice_unit`,`advance_rate` FROM `kuerp_unit_conversion` WHERE `main_unit` = ? ORDER BY `advance_rate` ASC',
        [mainUnit],
      );
      const rateMap: Record<string, number> = {};
      for (const c of conversions) rateMap[String(c.vice_unit)] = Number(c.advance_rate || 0);

      list = await this.many(
        'SELECT g.`unit`, g.`' +
          pf.field +
          '` AS `price`, g.`discount`, g.`discount2`, g.`is_default`, u.`name` ' +
          'FROM `kuerp_goods_price` g LEFT JOIN `kuerp_unit` u ON u.`id` = g.`unit` ' +
          'WHERE g.`goods_id` = ? ORDER BY g.`is_default` DESC',
        [goodsId],
      );
      for (const item of list) item.advance_rate = rateMap[String(item.unit)] ?? 1;
    }

    // 统一处理：库存折算、折扣价、剔除中间字段
    for (const item of list) {
      if (Number(item.is_default) === 1) {
        item.stock = stock;
      } else {
        const rate = Number(rateMapOf(item, list));
        item.stock = rate && rate !== 0 ? this.round(stock / rate, 2) : stock;
      }
      if (!pf.login) item.price = '';
      else item.price = this.applyDiscount(item.price, item.discount, item.discount2, pf, priceDecimal);
      delete item.discount;
      delete item.discount2;
    }

    // 指定单位时只返回该单位（原 PHP 由调用方自行筛选，这里保持返回全量以兼容）
    void goodsUnit;
    return list;
  }

  /**
   * 读取商品辅助属性列表（等价 Index::getGoodsAuxiliary）。
   *
   * @param goodsId 商品 ID
   * @param user 当前会员（决定是否下发价格与取哪一档价格），可为 null 代表游客
   * @returns 属性数组，元素含 id/attr_code/barcode/unit/price/stock/attr_name/decimal
   */
  async getGoodsAuxiliary(goodsId: number, user: any = null): Promise<any[]> {
    const pf = await this.priceField(user);
    const priceDecimal = Number((await this.setValue('price_decimal')) || 0);

    // 辅助属性字典 id → 名称
    const auxRows: any[] = await this.many('SELECT `id`,`name` FROM `kuerp_auxiliary` WHERE `status` = 1');
    const auxMap: Record<string, string> = {};
    for (const a of auxRows) auxMap[String(a.id)] = a.name;

    const attrs: any[] = await this.many(
      'SELECT `id`,`attribute_id`,`attr_code`,`barcode`,`unit`, `' +
        pf.field +
        '` AS `price`,`discount`,`discount2` FROM `kuerp_goods_attr` WHERE `goods_id` = ?',
      [goodsId],
    );

    for (const a of attrs) {
      // 该属性组合的库存
      const s = await this.one(
        'SELECT COALESCE(SUM(`stock`),0) AS `stock` FROM `kuerp_goods_stock` WHERE `goods_id` = ? AND `attribute_id` = ?',
        [goodsId, a.attribute_id],
      );
      a.stock = Number(s?.stock ?? 0);

      // 属性组合名称：kuerp_aux_combination.attr_ids 形如 "1&3" → "红色/大号"
      const combo = await this.one('SELECT `attr_ids` FROM `kuerp_aux_combination` WHERE `id` = ? LIMIT 1', [
        a.attribute_id,
      ]);
      a.attr_name = '';
      if (combo?.attr_ids) {
        a.attr_name = String(combo.attr_ids)
          .split('&')
          .map((id) => auxMap[String(id)] ?? '')
          .join('/');
      }

      if (!pf.login) a.price = '';
      else a.price = this.applyDiscount(a.price, a.discount, a.discount2, pf, priceDecimal);
      delete a.discount;
      delete a.discount2;
      delete a.attribute_id;
    }

    // 金额拆分
    return attrs.map((a) => ({ ...a, ...this.splitPrice(a.price) }));
  }

  /**
   * 商品分类列表（等价 Index::goodsTypeList）。
   *
   * @param q 入参 { pid, type }；type=1 时返回整棵树
   * @param user 当前会员（用于统计各分类下购物车数量）
   */
  async goodsTypeList(q: any, user: any): Promise<any[]> {
    const pid = Number(q?.pid || 0);
    const type = Number(q?.type || 0);

    const where: string[] = ['`status` = ?', '`order_status` = ?'];
    const params: any[] = ['1', '1'];
    if (type !== 1) {
      where.push('`pid` = ?');
      params.push(pid);
    }

    const list: any[] = await this.many(
      'SELECT `id`,`pid`,`supplier_type_name` AS `name`,`supplier_type_image` AS `image`,`status`, ' +
        "FROM_UNIXTIME(`createtime`,'%Y-%m-%d') AS `createtime`, " +
        "FROM_UNIXTIME(`updatetime`,'%Y-%m-%d') AS `updatetime` " +
        'FROM `kuerp_goods_type` WHERE ' +
        where.join(' AND '),
      params,
    );

    const userId = Number(user?.id || 0);
    for (const item of list) {
      // 该分类及其子分类下的商品 ID 集合
      const children: any[] = await this.many('SELECT `id` FROM `kuerp_goods_type` WHERE `path` LIKE ?', [
        '%,' + item.id + ',%',
      ]);
      const typeIds = children.map((c) => c.id).concat([item.id]);
      const placeholders = typeIds.map(() => '?').join(',');

      const goodsRows: any[] = await this.many(
        'SELECT `id` FROM `kuerp_goods` WHERE `goods_type_id` IN (' + placeholders + ')',
        typeIds,
      );
      const goodsIds = goodsRows.map((g) => g.id);

      if (goodsIds.length) {
        const gph = goodsIds.map(() => '?').join(',');
        const cartGoods: any[] = await this.many(
          'SELECT `goods_id` FROM `kuerp_user_cart` WHERE `user_id` = ? AND `goods_id` IN (' + gph + ')',
          [userId, ...goodsIds],
        );
        item.goods_id = cartGoods.map((c) => c.goods_id);
        const sum = await this.one(
          'SELECT COALESCE(SUM(`number`),0) AS `n` FROM `kuerp_user_cart` WHERE `user_id` = ? AND `goods_id` IN (' +
            gph +
            ')',
          [userId, ...goodsIds],
        );
        item.cart_number = Number(sum?.n ?? 0);
      } else {
        item.goods_id = [];
        item.cart_number = 0;
      }

      item.image = this.cdnUrl(item.image);
    }

    return type === 1 ? this.buildTree(list, pid) : list;
  }

  /**
   * 把扁平分类数组按 pid 组装成树（等价 fast\Tree::getTreeArray，子节点键名 childlist）。
   *
   * @param rows 扁平数组，元素需含 id/pid
   * @param parentId 根节点父 ID
   */
  private buildTree(rows: any[], parentId: number): any[] {
    const out: any[] = [];
    for (const row of rows) {
      if (Number(row.pid) !== Number(parentId)) continue;
      const node = { ...row };
      const children = this.buildTree(rows, Number(row.id));
      if (children.length) node.childlist = children;
      out.push(node);
    }
    return out;
  }

  /**
   * 商品列表（等价 Index::goodsGoodsList）。
   *
   * @param q 入参 { page, limit, keyword, promotion, goods_type_id, tag }
   * @param user 当前会员
   * @returns { list, count }
   */
  async goodsGoodsList(q: any, user: any): Promise<{ list: any[]; count: number }> {
    const page = Number(q?.page || 1) || 1;
    const limit = Number(q?.limit || 10) || 10;
    const pf = await this.priceField(user);
    const priceDecimal = Number((await this.setValue('price_decimal')) || 0);
    const userId = Number(user?.id || 0);

    const where: string[] = ['g.`status` = ?', 'g.`order_status` = ?'];
    const params: any[] = ['1', '1'];

    const keyword = String(q?.keyword || '').trim();
    if (keyword) {
      where.push('(g.`goods_code` LIKE ? OR g.`goods_name` LIKE ? OR g.`goods_barcode` LIKE ?)');
      params.push('%' + keyword + '%', '%' + keyword + '%', '%' + keyword + '%');
    }
    if (String(q?.promotion || '') !== '') {
      where.push('g.`promotion` = ?');
      params.push('1');
    }
    if (q?.goods_type_id) {
      const tid = Number(q.goods_type_id);
      const children: any[] = await this.many('SELECT `id` FROM `kuerp_goods_type` WHERE `path` LIKE ?', [
        '%,' + tid + ',%',
      ]);
      const ids = children.map((c) => c.id).concat([tid]);
      where.push('g.`goods_type_id` IN (' + ids.map(() => '?').join(',') + ')');
      params.push(...ids);
    }
    if (q?.tag) {
      where.push('g.`tag` LIKE ?');
      params.push('%' + q.tag + '%');
    }

    const whereSql = where.join(' AND ');
    const baseFrom = 'FROM `kuerp_goods` g LEFT JOIN `kuerp_unit` u ON g.`unit_id` = u.`id` WHERE ' + whereSql;

    const list: any[] = await this.many(
      'SELECT g.`id`,g.`goods_code`,g.`goods_type_id`,g.`goods_name`,g.`goods_barcode`,g.`note`, ' +
        'g.`goods_specification_id` AS `goods_spec`,g.`unit_id`,u.`name` AS `unit_name`,g.`more_unit`, ' +
        'g.`' +
        pf.field +
        '` AS `price`,g.`discount`,g.`discount2`,g.`goods_image`,g.`inventory` AS `stock`,g.`status`, ' +
        "FROM_UNIXTIME(g.`updatetime`,'%Y-%m-%d %H:%i:%s') AS `updatetime` " +
        baseFrom +
        ' ORDER BY g.`sale_number` DESC, g.`id` DESC LIMIT ? OFFSET ?',
      [...params, limit, (page - 1) * limit],
    );

    const countRow = await this.one('SELECT COUNT(*) AS `c` ' + baseFrom, params);
    const count = Number(countRow?.c ?? 0);

    for (const item of list) {
      // 价格为空时回落到单位价格表中的默认单位价
      if (!item.price) {
        const unitData = await this.getGoodsUnit(item.id, item.unit_id, '', user);
        item.price = unitData?.[0]?.price ?? 0;
      }

      item.goods_image = this.cdnUrl(item.goods_image);

      if (!pf.login) item.price = '';
      else item.price = this.applyDiscount(item.price, item.discount, item.discount2, pf, priceDecimal);
      delete item.discount;
      delete item.discount2;

      // 多单位时单位名拼成 "个,箱,件(1:12:24)" 形式
      if (Number(item.more_unit) === 1) {
        const units: any[] = await this.many(
          'SELECT uc.`vice_unit`, u.`name`, uc.`advance_rate` FROM `kuerp_unit_conversion` uc ' +
            'LEFT JOIN `kuerp_unit` u ON u.`id` = uc.`vice_unit` WHERE uc.`main_unit` = ? ORDER BY uc.`advance_rate` ASC',
          [item.unit_id],
        );
        let unitName = item.unit_name || '';
        let rates = '1';
        for (const u of units) {
          unitName += ',' + (u.name ?? '');
          rates += ':' + u.advance_rate;
        }
        item.unit_name = unitName + '(' + rates + ')';
      }

      // 顶级分类（用于小程序分类高亮）
      if (item.goods_type_id) {
        const path = (await this.one('SELECT `path` FROM `kuerp_goods_type` WHERE `id` = ? LIMIT 1', [
          item.goods_type_id,
        ]))?.path;
        const ids = String(path || '')
          .split(',')
          .map((s) => Number(s))
          .filter((n) => n > 0);
        if (ids.length) {
          const top = await this.one(
            'SELECT `id` FROM `kuerp_goods_type` WHERE `id` IN (' + ids.map(() => '?').join(',') + ') AND `pid` = 0 LIMIT 1',
            ids,
          );
          item.parent_goods_type_id = top?.id ?? 0;
        } else {
          item.parent_goods_type_id = 0;
        }
      } else {
        item.parent_goods_type_id = 0;
      }

      // 购物车相关
      const cartRows: any[] = await this.many(
        'SELECT `id` FROM `kuerp_user_cart` WHERE `user_id` = ? AND `goods_id` = ?',
        [userId, item.id],
      );
      item.cart_status = cartRows.length ? 1 : 0;
      const cartSum = await this.one(
        'SELECT COALESCE(SUM(`number`),0) AS `n` FROM `kuerp_user_cart` WHERE `user_id` = ? AND `goods_id` = ?',
        [userId, item.id],
      );
      item.cart_number = Number(cartSum?.n ?? 0);

      item.unit_data = await this.getGoodsUnit(item.id, '', '', user);
      item.attr_data = await this.getGoodsAuxiliary(item.id, user);

      Object.assign(item, this.splitPrice(item.price));
    }

    return { list, count };
  }

  /**
   * 商品详情（等价 Index::goodsGoodsInfo），并写入浏览记录。
   *
   * @param q 入参 { id, goods_unit, goods_attr }
   * @param user 当前会员（可为空）
   */
  async goodsGoodsInfo(q: any, user: any): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const id = Number(q?.id || 0);
    if (!id) return { ok: false, msg: '请输入商品ID' };

    const row = await this.one(
      'SELECT `id`,`goods_code`,`goods_name`,`goods_barcode`,`goods_specification_id` AS `goods_spec`, ' +
        '`goods_type_id`,`unit_id`,`goods_image`,`goods_images`,`note`,`more_unit`,`content` ' +
        'FROM `kuerp_goods` WHERE `id` = ? AND `status` = ? LIMIT 1',
      [id, '1'],
    );
    if (!row) return { ok: false, msg: '未查询到商品数据' };

    // 顶级分类
    if (row.goods_type_id) {
      const path = (await this.one('SELECT `path` FROM `kuerp_goods_type` WHERE `id` = ? LIMIT 1', [row.goods_type_id]))
        ?.path;
      const ids = String(path || '')
        .split(',')
        .map((s) => Number(s))
        .filter((n) => n > 0);
      row.parent_goods_type_id = ids.length
        ? (await this.one(
            'SELECT `id` FROM `kuerp_goods_type` WHERE `id` IN (' + ids.map(() => '?').join(',') + ') AND `pid` = 0 LIMIT 1',
            ids,
          ))?.id ?? 0
        : 0;
    } else {
      row.parent_goods_type_id = 0;
    }

    row.goods_image = this.cdnUrl(row.goods_image || this.noImage);
    row.goods_images = String(row.goods_images || '')
      .split(',')
      .filter((s) => s !== '')
      .map((s) => this.cdnUrl(s));

    const goodsUnit = q?.goods_unit ?? '';
    const goodsAttr = q?.goods_attr ?? '';
    row.unit_data = (await this.getGoodsUnit(row.id, goodsUnit, goodsAttr, user)).map((u) => ({
      ...u,
      ...this.splitPrice(u.price),
    }));
    row.attr_data = await this.getGoodsAuxiliary(row.id, user);

    // 浏览记录：同一会员同一商品同一天只记一条
    if (user?.id) {
      const date = new Date();
      const ymd = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(
        date.getDate(),
      ).padStart(2, '0')}`;
      const exist = await this.one(
        'SELECT `id` FROM `kuerp_user_history` WHERE `user_id` = ? AND `goods_id` = ? AND `look_date` = ? LIMIT 1',
        [user.id, id, ymd],
      );
      if (!exist) {
        await this.dataSource.query(
          'INSERT INTO `kuerp_user_history` (`user_id`,`goods_id`,`goods_unit`,`goods_attr`,`look_date`,`createtime`,`updatetime`) VALUES (?,?,?,?,?,?,?)',
          [user.id, id, goodsUnit || 0, goodsAttr || 0, ymd, this.now(), this.now()],
        );
      }
      const cartSum = await this.one(
        'SELECT COALESCE(SUM(`number`),0) AS `n` FROM `kuerp_user_cart` WHERE `user_id` = ? AND `goods_id` = ?',
        [user.id, row.id],
      );
      row.cart_number = Number(cartSum?.n ?? 0);
    } else {
      row.cart_number = 0;
    }

    return { ok: true, data: row };
  }

  /**
   * 浏览历史（等价 Index::getHistory）。
   *
   * @param q 入参 { page, limit, list_type }：list_type=1 按日期分组，2 平铺
   * @param user 当前会员
   */
  async getHistory(q: any, user: any): Promise<{ list: any[]; count: number }> {
    const page = Number(q?.page || 1) || 1;
    const limit = Number(q?.limit || 10) || 10;
    const listType = Number(q?.list_type || 1) === 2 ? 2 : 1;
    if (!user?.id) return { list: [], count: 0 };

    const pf = await this.priceField(user);
    const priceDecimal = Number((await this.setValue('price_decimal')) || 0);

    /** 单条商品行的价格与图片处理（两分支共用） */
    const fill = async (rows: any[]): Promise<any[]> => {
      for (const r of rows) {
        if (!pf.login) r.price = '';
        else r.price = this.applyDiscount(r.price, r.discount, r.discount2, pf, priceDecimal);
        delete r.discount;
        delete r.discount2;
        r.goods_image = this.cdnUrl(r.goods_image || this.noImage);
        Object.assign(r, this.splitPrice(r.price));
      }
      return rows;
    };

    const goodsSql =
      'SELECT g.`id`,g.`goods_name`,g.`' +
      pf.field +
      '` AS `price`,g.`goods_image`,g.`discount`,g.`discount2`,h.`goods_unit`,h.`goods_attr` ' +
      'FROM `kuerp_user_history` h LEFT JOIN `kuerp_goods` g ON g.`id` = h.`goods_id` ';

    if (listType === 2) {
      const list = await fill(
        await this.many(goodsSql + 'WHERE h.`user_id` = ? LIMIT ? OFFSET ?', [
          user.id,
          limit,
          (page - 1) * limit,
        ]),
      );
      const c = await this.one('SELECT COUNT(*) AS `c` FROM `kuerp_user_history` WHERE `user_id` = ?', [user.id]);
      return { list, count: Number(c?.c ?? 0) };
    }

    // 按浏览日期分组
    const dates: any[] = await this.many(
      'SELECT `look_date` FROM `kuerp_user_history` WHERE `user_id` = ? GROUP BY `look_date` ORDER BY `look_date` DESC LIMIT ? OFFSET ?',
      [user.id, limit, (page - 1) * limit],
    );
    const c = await this.one(
      'SELECT COUNT(DISTINCT `look_date`) AS `c` FROM `kuerp_user_history` WHERE `user_id` = ?',
      [user.id],
    );
    for (const d of dates) {
      d.goods_list = await fill(
        await this.many(goodsSql + 'WHERE h.`look_date` = ? AND h.`user_id` = ?', [d.look_date, user.id]),
      );
    }
    return { list: dates, count: Number(c?.c ?? 0) };
  }

  // ==================================================================
  // 三、购物车域
  // ==================================================================

  /**
   * 购物车商品总数（等价 Index::getCartNumber）。
   * 顺带清理已删除商品对应的购物车脏数据（与原系统一致）。
   *
   * @param userId 会员 ID
   */
  async getCartNumber(userId: number): Promise<number> {
    const rows: any[] = await this.many('SELECT `id`,`goods_id` FROM `kuerp_user_cart` WHERE `user_id` = ?', [userId]);
    for (const r of rows) {
      const g = await this.one('SELECT `id` FROM `kuerp_goods` WHERE `id` = ? LIMIT 1', [r.goods_id]);
      if (!g) await this.dataSource.query('DELETE FROM `kuerp_user_cart` WHERE `id` = ?', [r.id]);
    }
    const sum = await this.one('SELECT COALESCE(SUM(`number`),0) AS `n` FROM `kuerp_user_cart` WHERE `user_id` = ?', [
      userId,
    ]);
    return Number(sum?.n ?? 0);
  }

  /**
   * 购物车列表（等价 Index::getCart）。
   * 返回每条购物车行 + 其商品快照（价格按当前会员等级换算）。
   *
   * @param user 会员行（决定价格档位）
   */
  async getCart(user: any): Promise<any[]> {
    const userId = Number(user?.id || 0);
    const carts: any[] = await this.many('SELECT c.* FROM `kuerp_user_cart` c WHERE c.`user_id` = ?', [userId]);
    for (const cart of carts) {
      let goods = await this.one(
        'SELECT `id`,`goods_code`,`goods_name`,`goods_barcode`,`goods_specification_id` AS `goods_spec`, ' +
          '`goods_type_id`,`unit_id`,`goods_image`,`goods_images`,`note`,`more_unit` ' +
          'FROM `kuerp_goods` WHERE `id` = ? AND `status` = ? LIMIT 1',
        [cart.goods_id, '1'],
      );

      if (goods) {
        goods.goods_image = this.cdnUrl(goods.goods_image || this.noImage);
        goods.goods_images = String(goods.goods_images || '')
          .split(',')
          .filter((s) => s !== '')
          .map((s) => this.cdnUrl(s));

        const unitData = await this.getGoodsUnit(goods.id, cart.goods_unit, cart.goods_attr, user);
        goods.price = '';
        goods.unit_name = '';
        for (const u of unitData) {
          if (String(u.unit) === String(cart.goods_unit)) {
            goods.price = u.price;
            goods.unit_name = u.name;
          }
        }

        goods.attr_name = '';
        const attrData = await this.getGoodsAuxiliary(goods.id, user);
        for (const a of attrData) {
          if (String(a.id) === String(cart.goods_attr)) goods.attr_name = a.attr_name;
        }

        Object.assign(goods, this.splitPrice(goods.price));
      } else {
        goods = { price: '', decimal: '', goods_images: [], unit_data: [], attr_data: [] } as any;
      }

      cart.goods = goods;
    }
    return carts;
  }

  /**
   * 加入购物车（等价 Index::addCart）：同商品同单位同属性累加数量。
   *
   * @param body 入参 { goods_id, goods_unit, number, goods_attr, more_number }
   * @param userId 会员 ID
   */
  async addCart(body: any, userId: number): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const goodsId = Number(body?.goods_id || 0);
    const goodsUnit = Number(body?.goods_unit || 0);
    const number = Number(body?.number || 0);
    if (!goodsId || !goodsUnit) return { ok: false, msg: '参数错误：商品与单位必填' };

    const g = await this.one('SELECT `id` FROM `kuerp_goods` WHERE `id` = ? AND `status` = ? LIMIT 1', [goodsId, '1']);
    if (!g) return { ok: false, msg: '未查询到商品数据' };

    const goodsAttr = Number(body?.goods_attr || 0);
    const exist = await this.one(
      'SELECT * FROM `kuerp_user_cart` WHERE `user_id` = ? AND `goods_id` = ? AND `goods_unit` = ? AND `goods_attr` = ? LIMIT 1',
      [userId, goodsId, goodsUnit, goodsAttr],
    );

    if (exist) {
      const next = number + Number(exist.number || 0);
      await this.dataSource.query('UPDATE `kuerp_user_cart` SET `number` = ?, `updatetime` = ? WHERE `id` = ?', [
        next,
        this.now(),
        exist.id,
      ]);
      return { ok: true, data: next };
    }

    if (number <= 0) return { ok: false, msg: '数量不能等于0' };
    await this.dataSource.query(
      'INSERT INTO `kuerp_user_cart` (`user_id`,`goods_id`,`goods_unit`,`goods_attr`,`number`,`createtime`,`updatetime`) VALUES (?,?,?,?,?,?,?)',
      [userId, goodsId, goodsUnit, goodsAttr, number, this.now(), this.now()],
    );
    return { ok: true, data: number };
  }

  /**
   * 修改购物车数量（等价 Index::editCart）。
   * cart_id 与 goods_id 二者传其一即可。
   *
   * @param body 入参 { cart_id, goods_id, number }
   * @param userId 会员 ID
   */
  async editCart(body: any, userId: number): Promise<{ ok: boolean; msg?: string }> {
    const cartId = Number(body?.cart_id || 0);
    const goodsId = Number(body?.goods_id || 0);
    const number = Number(body?.number || 0);
    if (cartId <= 0 && goodsId <= 0) return { ok: false, msg: '参数错误' };
    if (number <= 0) return { ok: false, msg: '数量不能等于0' };

    const where = cartId > 0 ? '`id` = ?' : '`goods_id` = ?';
    const key = cartId > 0 ? cartId : goodsId;
    const exist = await this.one(`SELECT * FROM \`kuerp_user_cart\` WHERE \`user_id\` = ? AND ${where} LIMIT 1`, [
      userId,
      key,
    ]);
    if (!exist) return { ok: false, msg: '未找到相关信息' };

    await this.dataSource.query('UPDATE `kuerp_user_cart` SET `number` = ?, `updatetime` = ? WHERE `id` = ?', [
      number,
      this.now(),
      exist.id,
    ]);
    return { ok: true };
  }

  /**
   * 删除购物车（等价 Index::delCart），支持批量（cart_id 传数组或逗号分隔）。
   *
   * @param body 入参 { cart_id }
   * @param userId 会员 ID
   */
  async delCart(body: any, userId: number): Promise<{ ok: boolean; msg?: string }> {
    const ids = this.toIdArray(body?.cart_id);
    if (!ids.length) return { ok: false, msg: '参数错误' };
    const ph = ids.map(() => '?').join(',');
    const exist = await this.one(
      `SELECT \`id\` FROM \`kuerp_user_cart\` WHERE \`user_id\` = ? AND \`id\` IN (${ph}) LIMIT 1`,
      [userId, ...ids],
    );
    if (!exist) return { ok: false, msg: '未找到相关信息' };
    await this.dataSource.query(`DELETE FROM \`kuerp_user_cart\` WHERE \`user_id\` = ? AND \`id\` IN (${ph})`, [
      userId,
      ...ids,
    ]);
    return { ok: true };
  }

  /**
   * 清空购物车（等价 Index::cancelCart）。
   * @param userId 会员 ID
   */
  async cancelCart(userId: number): Promise<{ ok: boolean; msg?: string }> {
    const exist = await this.one('SELECT `id` FROM `kuerp_user_cart` WHERE `user_id` = ? LIMIT 1', [userId]);
    if (!exist) return { ok: false, msg: '未找到相关信息' };
    await this.dataSource.query('DELETE FROM `kuerp_user_cart` WHERE `user_id` = ?', [userId]);
    return { ok: true };
  }

  /** 把 1 / [1,2] / '1,2' 统一成数字数组 */
  private toIdArray(v: any): number[] {
    if (v === null || v === undefined || v === '') return [];
    const arr = Array.isArray(v) ? v : String(v).split(',');
    return arr.map((x) => Number(x)).filter((n) => !Number.isNaN(n) && n > 0);
  }

  // ==================================================================
  // 四、订单域
  // ==================================================================

  /**
   * 生成订货单号（等价 Index::getOrderNum）。
   * 规则：DH + YmdHis + 毫秒后 5 位 + 6 位随机数，重复则递归重取。
   *
   * @param prefix 前缀，默认 DH
   */
  async genOrderNum(prefix = 'DH'): Promise<string> {
    for (let i = 0; i < 10; i++) {
      const d = new Date();
      const ymd =
        d.getFullYear() +
        String(d.getMonth() + 1).padStart(2, '0') +
        String(d.getDate()).padStart(2, '0') +
        String(d.getHours()).padStart(2, '0') +
        String(d.getMinutes()).padStart(2, '0') +
        String(d.getSeconds()).padStart(2, '0');
      const ms = String(d.getTime());
      const tail = ms.slice(-5);
      const rand = String(Math.floor(100000 + Math.random() * 900000));
      const num = prefix + ymd + tail + rand;
      const dup = await this.one('SELECT `id` FROM `kuerp_user_order` WHERE `order_num` = ? LIMIT 1', [num]);
      if (!dup) return num;
    }
    // 极端冲突时退化为时间戳 + 随机，保证不阻塞下单
    return prefix + Date.now() + String(Math.floor(100000 + Math.random() * 900000));
  }

  /**
   * 创建订货单（等价 Index::createOrder）。
   *
   * 流程：校验购物车 → 校验配送方式/自提门店/收货地址 → 逐行取价 → 事务写
   * kuerp_user_order + kuerp_user_orderinfo → 清空对应购物车行。
   *
   * @param body 入参 { cart_id, diver_type, store_id, address_id }
   * @param user 会员行
   */
  async createOrder(body: any, user: any): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const cartIds = this.toIdArray(body?.cart_id);
    if (!cartIds.length) return { ok: false, msg: '请选择要下单的购物车商品' };

    const diverType = Number(body?.diver_type || 1) === 1 ? 1 : 2;
    const storeId = Number(body?.store_id || 0);

    // 到店自取：必须选择有效自提门店（kuerp_address 发货地址）
    let store: any = null;
    if (diverType === 2) {
      if (!storeId) return { ok: false, msg: '请选择自提门店' };
      store = await this.one('SELECT * FROM `kuerp_address` WHERE `id` = ? LIMIT 1', [storeId]);
      if (!store) return { ok: false, msg: '选择的自提门店不可用' };
    }

    const ph = cartIds.map(() => '?').join(',');
    const carts: any[] = await this.many(
      `SELECT * FROM \`kuerp_user_cart\` WHERE \`user_id\` = ? AND \`id\` IN (${ph})`,
      [user.id, ...cartIds],
    );
    if (!carts.length) return { ok: false, msg: '未找到相关信息' };

    // 收货地址：专业配送时必填（未传则取默认地址）
    let address: any = null;
    if (diverType !== 2) {
      const addressId = Number(body?.address_id || 0);
      if (!addressId) {
        address = await this.one(
          'SELECT * FROM `kuerp_user_address` WHERE `user_id` = ? AND `is_default` = ? LIMIT 1',
          [user.id, '1'],
        );
        if (!address) return { ok: false, msg: '未设置默认收货地址，订货单创建失败' };
      } else {
        address = await this.one('SELECT * FROM `kuerp_user_address` WHERE `user_id` = ? AND `id` = ? LIMIT 1', [
          user.id,
          addressId,
        ]);
        if (!address) return { ok: false, msg: '未找到收货地址，订货单创建失败' };
      }
    }

    // 逐行取价并组装明细
    const info: any[] = [];
    let orderPrice = 0;
    for (const cart of carts) {
      const goods = await this.one(
        'SELECT `id`,`unit_id`,`goods_name`,`goods_image`,`status`,`order_status` FROM `kuerp_goods` WHERE `id` = ? LIMIT 1',
        [cart.goods_id],
      );
      if (!goods) continue;
      if (String(goods.status) !== '1' || String(goods.order_status) !== '1') {
        return { ok: false, msg: goods.goods_name + '已下架，不可订货' };
      }

      const unitData = await this.getGoodsUnit(goods.id, cart.goods_unit, cart.goods_attr, user);
      let price: any = '';
      let unitName = '';
      for (const u of unitData) {
        if (String(u.unit) === String(cart.goods_unit)) {
          price = u.price;
          unitName = u.name;
        }
      }

      let attrName = '';
      for (const a of await this.getGoodsAuxiliary(goods.id, user)) {
        if (String(a.id) === String(cart.goods_attr)) attrName = a.attr_name;
      }

      if (price !== '' && Number(price) >= 0 && price !== null) {
        const money = this.round(Number(price) * Number(cart.number || 0), 2);
        info.push({
          user_id: user.id,
          goods_id: cart.goods_id,
          goods_unit: cart.goods_unit,
          goods_attr: cart.goods_attr,
          goods_name: goods.goods_name,
          goods_image: goods.goods_image,
          unit_name: unitName,
          attr_name: attrName,
          number: cart.number,
          price,
          money,
          createtime: this.now(),
          updatetime: this.now(),
        });
        orderPrice += money;
      }
    }

    if (!info.length || orderPrice <= 0) return { ok: false, msg: '数据异常，订货单创建失败' };

    const orderNum = await this.genOrderNum();
    // 当月序号（原系统用于月度统计展示）
    const [firstDay, lastDay] = this.monthRange();
    const lastNumb = await this.one(
      'SELECT `numb` FROM `kuerp_user_order` WHERE `createtime` BETWEEN ? AND ? ORDER BY `numb` DESC LIMIT 1',
      [firstDay, lastDay],
    );
    const numb = lastNumb?.numb ? Number(lastNumb.numb) + 1 : 1;

    // 事务写入
    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();
    try {
      const orderRes: any = await qr.manager.query(
        'INSERT INTO `kuerp_user_order` (`user_id`,`name`,`phone`,`address`,`order_num`,`order_price`,`diver_type`,`store_id`,`numb`,`createtime`,`updatetime`) ' +
          'VALUES (?,?,?,?,?,?,?,?,?,?,?)',
        [
          user.id,
          address?.connect_name ?? '',
          address?.connect_mobile ?? '',
          address?.detail_address ?? '',
          orderNum,
          orderPrice,
          diverType,
          storeId,
          numb,
          this.now(),
          this.now(),
        ],
      );
      const orderId = Number(orderRes?.insertId || 0);
      if (!orderId) throw new Error('order insert failed');

      for (const row of info) {
        await qr.manager.query(
          'INSERT INTO `kuerp_user_orderinfo` (`user_id`,`order_id`,`goods_id`,`goods_unit`,`goods_attr`,`goods_name`,`goods_image`,`unit_name`,`attr_name`,`number`,`price`,`money`,`createtime`,`updatetime`) ' +
            'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
          [
            row.user_id,
            orderId,
            row.goods_id,
            row.goods_unit,
            row.goods_attr,
            row.goods_name,
            row.goods_image,
            row.unit_name,
            row.attr_name,
            row.number,
            row.price,
            row.money,
            row.createtime,
            row.updatetime,
          ],
        );
      }

      await qr.manager.query(
        `DELETE FROM \`kuerp_user_cart\` WHERE \`user_id\` = ? AND \`id\` IN (${ph})`,
        [user.id, ...cartIds],
      );
      await qr.commitTransaction();
      return { ok: true, data: orderNum };
    } catch (e: any) {
      await qr.rollbackTransaction();
      return { ok: false, msg: '订单创建失败：' + (e?.message || '未知错误') };
    } finally {
      await qr.release();
    }
  }

  /**
   * 订单列表（等价 Index::getOrderList）。
   *
   * @param q 入参 { page, limit, status }
   * @param user 会员行
   */
  async getOrderList(q: any, user: any): Promise<{ list: any[]; count: number }> {
    if (!user?.id) return { list: [], count: 0 };
    const page = Number(q?.page || 1) || 1;
    const limit = Number(q?.limit || 10) || 10;

    const where: string[] = ['`user_id` = ?'];
    const params: any[] = [user.id];
    if (q?.status !== undefined && q?.status !== '') {
      where.push('`status` = ?');
      params.push(Number(q.status));
    }
    const whereSql = where.join(' AND ');

    const list: any[] = await this.many(
      'SELECT * FROM `kuerp_user_order` WHERE ' + whereSql + ' ORDER BY `id` DESC LIMIT ? OFFSET ?',
      [...params, limit, (page - 1) * limit],
    );
    const c = await this.one('SELECT COUNT(*) AS `c` FROM `kuerp_user_order` WHERE ' + whereSql, params);

    for (const order of list) {
      const goodsList: any[] = await this.many('SELECT * FROM `kuerp_user_orderinfo` WHERE `order_id` = ?', [order.id]);
      for (const g of goodsList) {
        g.goods_image = this.cdnUrl(g.goods_image);
        Object.assign(g, this.splitPrice(g.price));
        Object.assign(g, this.splitPrice(g.money, 'money', 'money_decimal'));
      }
      order.goods_list = goodsList;
      Object.assign(order, this.splitPrice(order.order_price));
    }

    return { list, count: Number(c?.c ?? 0) };
  }

  /**
   * 订单详情（等价 Index::orderInfo），按订单号 + 会员定位。
   *
   * @param q 入参 { order_num }
   * @param user 会员行
   */
  async orderInfo(q: any, user: any): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const orderNum = String(q?.order_num || '').trim();
    if (!orderNum) return { ok: false, msg: '请输入订单号' };

    const order = await this.one('SELECT * FROM `kuerp_user_order` WHERE `user_id` = ? AND `order_num` = ? LIMIT 1', [
      user.id,
      orderNum,
    ]);
    if (!order) return { ok: false, msg: '未找到相关信息' };

    Object.assign(order, this.splitPrice(order.order_price));

    const goodsList: any[] = await this.many('SELECT * FROM `kuerp_user_orderinfo` WHERE `order_id` = ?', [order.id]);
    for (const g of goodsList) {
      g.goods_image = this.cdnUrl(g.goods_image);
      Object.assign(g, this.splitPrice(g.price));
      Object.assign(g, this.splitPrice(g.money, 'money', 'money_decimal'));
    }
    order.goods_list = goodsList;

    return { ok: true, data: order };
  }

  /**
   * 确认收货（等价 Index::receiving）：仅 status=3（待收货）可操作，改 4（已收货）。
   *
   * @param q 入参 { order_num }
   * @param user 会员行
   */
  async receiving(q: any, user: any): Promise<{ ok: boolean; msg?: string }> {
    const orderNum = String(q?.order_num || '').trim();
    if (!orderNum) return { ok: false, msg: '请输入订单号' };

    const order = await this.one('SELECT * FROM `kuerp_user_order` WHERE `user_id` = ? AND `order_num` = ? LIMIT 1', [
      user.id,
      orderNum,
    ]);
    if (!order) return { ok: false, msg: '未找到相关信息' };

    const statusMap: Record<number, string> = {
      0: '此订单未审核，不可确认收货',
      1: '此订单未发货，不可确认收货',
      2: '此订单待发货，不可确认收货',
      4: '此订单已收货，不可重复收货',
      5: '此订单已申请退款，不可确认收货',
      6: '此订单已退款，不可确认收货',
      7: '此订单已取消，不可确认收货',
      8: '此订单已完成，不可确认收货',
    };
    const status = Number(order.status);
    if (status !== 3) return { ok: false, msg: statusMap[status] || '状态异常，不可确认收货' };

    await this.dataSource.query('UPDATE `kuerp_user_order` SET `status` = ?, `updatetime` = ? WHERE `id` = ?', [
      4,
      this.now(),
      order.id,
    ]);
    return { ok: true };
  }

  /**
   * 取消订单（等价 Index::cancelOrder）。
   * 仅 status=0（待审核）可取消，取消即物理删除订单（与原系统一致）。
   *
   * @param q 入参 { order_num }
   * @param user 会员行
   */
  async cancelOrder(q: any, user: any): Promise<{ ok: boolean; msg?: string }> {
    const orderNum = String(q?.order_num || '').trim();
    if (!orderNum) return { ok: false, msg: '请输入订单号' };

    const order = await this.one('SELECT * FROM `kuerp_user_order` WHERE `user_id` = ? AND `order_num` = ? LIMIT 1', [
      user.id,
      orderNum,
    ]);
    if (!order) return { ok: false, msg: '未找到相关信息' };

    const statusMap: Record<number, string> = {
      1: '此订单未发货，不可取消',
      2: '此订单待发货，不可取消',
      3: '此订单已发货，不可取消',
      4: '此订单已收货，不可取消',
      5: '此订单已申请退款，不可取消',
      6: '此订单已退款，不可取消',
      7: '此订单已取消，不可取消',
      8: '此订单已完成，不可取消',
    };
    const status = Number(order.status);
    if (status !== 0) return { ok: false, msg: statusMap[status] || '状态异常，不可取消' };

    await this.dataSource.query('DELETE FROM `kuerp_user_orderinfo` WHERE `order_id` = ?', [order.id]);
    await this.dataSource.query('DELETE FROM `kuerp_user_order` WHERE `id` = ?', [order.id]);
    return { ok: true };
  }

  // ==================================================================
  // 五、发货地址 / 自提门店、地区
  // ==================================================================

  /** 按 ID 取地区（等价 Index::getArea） */
  async getArea(id: number): Promise<any | null> {
    return this.one('SELECT * FROM `kuerp_area` WHERE `id` = ? LIMIT 1', [id]);
  }

  /**
   * 发货地址 / 自提门店列表（等价 Index::address_list）。
   * 会补充 province_name / city_name / area_name 三级地区名。
   *
   * @param q 入参 { page, limit }
   */
  async addressList(q: any): Promise<{ list: any[]; count: number }> {
    const page = Number(q?.page || 1) || 1;
    const limit = Number(q?.limit || 10) || 10;

    const list: any[] = await this.many(
      'SELECT `id`,`nickname`,`connect_name`,`connect_phone`,`connect_mobile`,`province`,`city`,`area`,`detail_address`,`post_code`,`is_default`, ' +
        "FROM_UNIXTIME(`createtime`,'%Y-%m-%d %H:%i:%s') AS `createtime` " +
        'FROM `kuerp_address` LIMIT ? OFFSET ?',
      [limit, (page - 1) * limit],
    );
    const c = await this.one('SELECT COUNT(*) AS `c` FROM `kuerp_address`');

    const cache: Record<string, string> = {};
    const nameOf = async (id: any): Promise<string> => {
      const key = String(id || 0);
      if (!key || key === '0') return '';
      if (cache[key] !== undefined) return cache[key];
      const row = await this.getArea(Number(key));
      cache[key] = row?.name ?? '';
      return cache[key];
    };

    for (const item of list) {
      item.province_name = await nameOf(item.province);
      item.city_name = await nameOf(item.city);
      item.area_name = await nameOf(item.area);
    }

    return { list, count: Number(c?.c ?? 0) };
  }

  /**
   * 会员收货地址分页列表（等价 Order\Address::getlist + UserAddress::getList）。
   *
   * @param q 入参 { page, limit, name, phone }
   * @param userId 会员 ID
   */
  async addrList(q: any, userId: number): Promise<{ list: any[]; count: number }> {
    const page = Number(q?.page || 1) || 1;
    const limit = Number(q?.limit || 10) || 10;

    const where: string[] = ['`user_id` = ?'];
    const params: any[] = [userId];
    if (q?.name) {
      where.push('`connect_name` LIKE ?');
      params.push('%' + q.name + '%');
    }
    if (q?.phone) {
      where.push('`connect_mobile` LIKE ?');
      params.push('%' + q.phone + '%');
    }
    const whereSql = where.join(' AND ');

    const list: any[] = await this.many(
      'SELECT * FROM `kuerp_user_address` WHERE ' + whereSql + ' ORDER BY `is_default` DESC, `id` DESC LIMIT ? OFFSET ?',
      [...params, limit, (page - 1) * limit],
    );
    const c = await this.one('SELECT COUNT(*) AS `c` FROM `kuerp_user_address` WHERE ' + whereSql, params);
    return { list, count: Number(c?.c ?? 0) };
  }

  /** 会员收货地址详情（等价 Order\Address::getdetail） */
  async addrDetail(id: number, userId: number): Promise<any | null> {
    return this.one('SELECT * FROM `kuerp_user_address` WHERE `id` = ? AND `user_id` = ? LIMIT 1', [id, userId]);
  }

  /**
   * 新增会员收货地址（等价 Order\Address::adddetail）。
   * is_default=1 时自动把该会员其它地址置为非默认。
   *
   * @param body 地址字段
   * @param userId 会员 ID
   */
  async addrAdd(body: any, userId: number): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const data = {
      user_id: userId,
      connect_name: String(body?.connect_name ?? ''),
      connect_mobile: String(body?.connect_mobile ?? ''),
      province: Number(body?.province || 0),
      city: Number(body?.city || 0),
      area: Number(body?.area || 0),
      detail_address: String(body?.detail_address ?? ''),
      is_default: Number(body?.is_default || 0) === 1 ? '1' : '0',
      createtime: this.now(),
      updatetime: this.now(),
    };
    if (!data.connect_name) return { ok: false, msg: '联系人不能为空' };
    if (!/^1\d{10}$/.test(data.connect_mobile)) return { ok: false, msg: '手机号格式错误' };

    if (data.is_default === '1') {
      await this.dataSource.query('UPDATE `kuerp_user_address` SET `is_default` = ? WHERE `user_id` = ?', [
        '0',
        userId,
      ]);
    }

    const cols = Object.keys(data);
    const res: any = await this.dataSource.query(
      `INSERT INTO \`kuerp_user_address\` (${cols.map((c) => '`' + c + '`').join(',')}) VALUES (${cols
        .map(() => '?')
        .join(',')})`,
      cols.map((c) => (data as any)[c]),
    );
    return { ok: true, data: Number(res?.insertId || 0) };
  }

  /**
   * 编辑会员收货地址（等价 Order\Address::editdetail）。
   *
   * @param body 地址字段（必须含 id）
   * @param userId 会员 ID
   */
  async addrEdit(body: any, userId: number): Promise<{ ok: boolean; msg?: string }> {
    const id = Number(body?.id || 0);
    if (!id) return { ok: false, msg: '请输入地址ID' };
    const exist = await this.one('SELECT `id` FROM `kuerp_user_address` WHERE `id` = ? AND `user_id` = ? LIMIT 1', [
      id,
      userId,
    ]);
    if (!exist) return { ok: false, msg: '未找到相关地址' };

    const isDefault = Number(body?.is_default || 0) === 1 ? '1' : '0';
    if (isDefault === '1') {
      await this.dataSource.query('UPDATE `kuerp_user_address` SET `is_default` = ? WHERE `user_id` = ?', [
        '0',
        userId,
      ]);
    }

    await this.dataSource.query(
      'UPDATE `kuerp_user_address` SET `connect_name` = ?, `connect_mobile` = ?, `province` = ?, `city` = ?, ' +
        '`area` = ?, `detail_address` = ?, `is_default` = ?, `updatetime` = ? WHERE `id` = ? AND `user_id` = ?',
      [
        String(body?.connect_name ?? ''),
        String(body?.connect_mobile ?? ''),
        Number(body?.province || 0),
        Number(body?.city || 0),
        Number(body?.area || 0),
        String(body?.detail_address ?? ''),
        isDefault,
        this.now(),
        id,
        userId,
      ],
    );
    return { ok: true };
  }

  /** 删除会员收货地址（等价 Order\Address::deldetail） */
  async addrDel(id: number, userId: number): Promise<{ ok: boolean; msg?: string }> {
    const exist = await this.one('SELECT `id` FROM `kuerp_user_address` WHERE `id` = ? AND `user_id` = ? LIMIT 1', [
      id,
      userId,
    ]);
    if (!exist) return { ok: false, msg: '未找到相关地址' };
    await this.dataSource.query('DELETE FROM `kuerp_user_address` WHERE `id` = ? AND `user_id` = ?', [id, userId]);
    return { ok: true };
  }

  /**
   * 省市区三级联动（等价 Order\Address::area）。
   *
   * @param body 入参 { province, city, adcode }
   * @returns [{ value, name, adcode }]
   */
  async areaList(body: any): Promise<any[]> {
    let province = body?.province === undefined ? '' : body.province;
    let city = body?.city === undefined ? '' : body.city;
    const adcode = String(body?.adcode || '');

    // 通过行政区划编码反查，定位到对应层级
    if (adcode) {
      const area = await this.one('SELECT * FROM `kuerp_area` WHERE `adcode` = ? LIMIT 1', [adcode]);
      if (area) {
        if (Number(area.level) === 1) province = area.id;
        else if (Number(area.level) === 2) city = area.id;
      }
    }

    let pid = 0;
    let level = 1;
    if (province !== '' && province !== null) {
      pid = Number(province);
      level = 2;
      if (city !== '' && city !== null) {
        pid = Number(city);
        level = 3;
      }
    }

    return this.many('SELECT `id` AS `value`,`name`,`adcode` FROM `kuerp_area` WHERE `pid` = ? AND `level` = ?', [
      pid,
      level,
    ]);
  }

  // ==================================================================
  // 六、系统配置 / 轮播 / 留言
  // ==================================================================

  /** 读系统配置详情（等价 Order\Config::getdetail → Systems::getDetail） */
  async configGetDetail(name: string): Promise<any> {
    return this.one('SELECT * FROM `kuerp_user_config` WHERE `name` = ? LIMIT 1', [name]);
  }

  /** 新增系统配置（等价 Order\Config::adddetail） */
  async configAddDetail(body: any): Promise<{ ok: boolean; msg?: string }> {
    const name = String(body?.name || '').trim();
    if (!name) return { ok: false, msg: '变量名不能为空' };
    const dup = await this.one('SELECT `id` FROM `kuerp_user_config` WHERE `name` = ? LIMIT 1', [name]);
    if (dup) return { ok: false, msg: '变量名已存在' };
    await this.dataSource.query(
      'INSERT INTO `kuerp_user_config` (`name`,`group`,`title`,`tip`,`type`,`value`,`content`,`rule`,`extend`,`setting`) VALUES (?,?,?,?,?,?,?,?,?,?)',
      [
        name,
        String(body?.group || ''),
        String(body?.title || ''),
        String(body?.tip || ''),
        String(body?.type || 'string'),
        String(body?.value ?? ''),
        String(body?.content || ''),
        String(body?.rule || ''),
        String(body?.extend || ''),
        String(body?.setting || ''),
      ],
    );
    return { ok: true };
  }

  /** 编辑系统配置（等价 Order\Config::editdetail） */
  async configEditDetail(body: any): Promise<{ ok: boolean; msg?: string }> {
    const name = String(body?.name || '').trim();
    if (!name) return { ok: false, msg: '变量名不能为空' };
    const exist = await this.one('SELECT `id` FROM `kuerp_user_config` WHERE `name` = ? LIMIT 1', [name]);
    if (!exist) return { ok: false, msg: '配置不存在' };
    await this.dataSource.query('UPDATE `kuerp_user_config` SET `value` = ? WHERE `name` = ?', [
      String(body?.value ?? ''),
      name,
    ]);
    return { ok: true };
  }

  /**
   * 取单个配置值（等价 Order\Config::getSet）：先查 kuerp_user_config，再查 kuerp_user_sets。
   * @param name 变量名
   */
  async getSet(name: string): Promise<{ ok: boolean; msg?: string; data?: any }> {
    if (!name) return { ok: false, msg: '参数错误', data: null };
    const cfg = await this.one('SELECT `value` FROM `kuerp_user_config` WHERE `name` = ? LIMIT 1', [name]);
    if (cfg) return { ok: true, data: cfg.value };
    const set = await this.one('SELECT `value` FROM `kuerp_user_sets` WHERE `name` = ? LIMIT 1', [name]);
    if (set) return { ok: true, data: set.value };
    return { ok: false, msg: '查询失败', data: null };
  }

  /**
   * 批量取 kuerp_user_sets 配置（等价 Order\Config::getConfig）。
   * wxcode 字段会转成完整图片 URL。
   *
   * @param names 变量名数组或逗号分隔字符串
   */
  async setsConfig(names: any): Promise<Record<string, any>> {
    const arr = Array.isArray(names)
      ? names
      : String(names || '')
          .split(',')
          .map((s) => s.trim())
          .filter(Boolean);
    if (!arr.length) return {};
    const rows: any[] = await this.many(
      'SELECT `name`,`value` FROM `kuerp_user_sets` WHERE `name` IN (' + arr.map(() => '?').join(',') + ')',
      arr,
    );
    const out: Record<string, any> = {};
    for (const r of rows) out[r.name] = r.name === 'wxcode' ? this.cdnUrl(r.value) : r.value;
    return out;
  }

  /**
   * 支付参数配置（等价 Index::getConfig）：微信商户信息 + 服务商直连参数。
   * 注意：密钥类字段按要求只回传，不下发到日志。
   */
  async payConfig(): Promise<Record<string, any>> {
    const sets: any[] = await this.many('SELECT `name`,`value` FROM `kuerp_user_sets`');
    const map: Record<string, any> = {};
    for (const s of sets) map[s.name] = s.value;

    const cfg: Record<string, any> = {
      app_id: map['appid'] ?? '',
      mch_id: map['mch_id'] ?? '',
      key: map['pay_key'] ?? '',
      notify_url: (process.env.PUBLIC_BASE_URL || '') + '/shop/index/notify',
    };
    if (map['order_send'] !== undefined) {
      cfg.order_send = map['order_send'] ?? '';
      cfg.order_send_name = map['order_send_name'] ?? '';
      cfg.order_send_phone = map['order_send_phone'] ?? '';
      cfg.serial_no = map['serial_no'] ?? '';
      cfg.serial = map['serial'] ?? '';
    }
    return cfg;
  }

  /**
   * 轮播图（等价 Index::banner）。
   * @param typeId 广告位 ID
   */
  async banner(typeId: any): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const id = Number(typeId || 0);
    if (!id) return { ok: false, msg: '广告位参数错误' };
    const list: any[] = await this.many(
      'SELECT `id`,`name`,`image`,`link`,`status`, ' +
        "FROM_UNIXTIME(`createtime`,'%Y-%m-%d') AS `createtime` " +
        'FROM `kuerp_banner` WHERE `type_id` = ? AND `status` = ?',
      [id, '1'],
    );
    if (!list.length) return { ok: false, msg: '查询失败' };
    for (const b of list) b.image = this.cdnUrl(b.image);
    return { ok: true, data: list };
  }

  /**
   * 商品留言（等价 Index::leaving）。
   * 注：原系统该接口做的是「一小时内只可留一次言」但判断写成 `$log>=0`（恒真），
   * 导致实际永远报错。这里按业务本意改为 `$log>0`，使留言功能可用。
   *
   * @param body 留言字段
   * @param userId 会员 ID
   */
  async leaving(body: any, userId: number): Promise<{ ok: boolean; msg?: string }> {
    const recent = await this.one(
      'SELECT COUNT(*) AS `c` FROM `kuerp_user_leaving` WHERE `user_id` = ? AND `createtime` >= ?',
      [userId, this.now() - 3600],
    );
    if (Number(recent?.c ?? 0) > 0) return { ok: false, msg: '一小时内只可留一次言' };

    const fields = ['color', 'attr', 'length', 'number', 'unit', 'user', 'phone', 'remark'];
    const data: Record<string, any> = { user_id: userId, createtime: this.now() };
    for (const f of fields) if (body?.[f] !== undefined) data[f] = body[f];

    const cols = Object.keys(data);
    await this.dataSource.query(
      `INSERT INTO \`kuerp_user_leaving\` (${cols.map((c) => '`' + c + '`').join(',')}) VALUES (${cols
        .map(() => '?')
        .join(',')})`,
      cols.map((c) => data[c]),
    );
    return { ok: true };
  }

  // ==================================================================
  // 七、会员资料维护（供 User 控制器使用）
  // ==================================================================

  /** 更新会员资料（等价 Order\User::profile） */
  async updateProfile(userId: number, body: any): Promise<{ ok: boolean; msg?: string }> {
    const sets: string[] = [];
    const params: any[] = [];
    const nickname = String(body?.nickname ?? '');
    const avatar = String(body?.avatar ?? '');
    if (nickname) {
      sets.push('`nickname` = ?');
      params.push(nickname);
    }
    if (avatar) {
      sets.push('`avatar` = ?');
      params.push(avatar);
    }
    if (!sets.length) return { ok: false, msg: '没有需要更新的内容' };
    sets.push('`updatetime` = ?');
    params.push(this.now(), userId);
    await this.dataSource.query(`UPDATE \`kuerp_user\` SET ${sets.join(',')} WHERE \`id\` = ?`, params);
    return { ok: true };
  }

  /**
   * 绑定手机号（等价 Order\User::changemobile / Weixin::bind）。
   * 手机号必须已存在于 kuerp_customers（客户档案），绑定后 binding=1 才可看价格。
   *
   * @param userId 会员 ID
   * @param mobile 手机号
   */
  async bindMobile(userId: number, mobile: string): Promise<{ ok: boolean; msg?: string; user?: any }> {
    if (!/^1\d{10}$/.test(mobile)) return { ok: false, msg: '手机号格式错误' };

    const dup = await this.one(
      'SELECT `id` FROM `kuerp_user` WHERE `mobile` = ? AND `id` <> ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
      [mobile, userId],
    );
    if (dup) return { ok: false, msg: '手机号已绑定' };

    const customer = await this.one('SELECT `id` FROM `kuerp_customers` WHERE `customer_mobile` = ? LIMIT 1', [mobile]);
    if (!customer) return { ok: false, msg: '此手机号尚未成为客户，不可绑定' };

    const verification = JSON.stringify({ mobile: 1 });
    await this.dataSource.query(
      'UPDATE `kuerp_user` SET `binding` = 1, `customers_id` = ?, `username` = ?, `mobile` = ?, ' +
        '`verification` = ?, `updatetime` = ? WHERE `id` = ?',
      [customer.id, mobile, mobile, verification, this.now(), userId],
    );
    return { ok: true };
  }

  /** 重置密码（等价 Order\User::resetpwd}） */
  async resetPassword(userId: number, newPassword: string): Promise<{ ok: boolean; msg?: string }> {
    if (!newPassword) return { ok: false, msg: '新密码不能为空' };
    const salt = this.auth.randomSalt(6);
    await this.dataSource.query('UPDATE `kuerp_user` SET `password` = ?, `salt` = ?, `updatetime` = ? WHERE `id` = ?', [
      this.auth.encryptPassword(newPassword, salt),
      salt,
      this.now(),
      userId,
    ]);
    return { ok: true };
  }

  /**
   * 按手机号查会员（等价 KuerpUser::getByMobile）。
   * @param mobile 手机号
   */
  async findUserByMobile(mobile: string): Promise<any | null> {
    return this.one(
      'SELECT * FROM `kuerp_user` WHERE `mobile` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
      [mobile],
    );
  }

  /**
   * 按主键查会员。
   * @param id 会员 ID
   */
  async findUserById(id: number): Promise<any | null> {
    return this.one('SELECT * FROM `kuerp_user` WHERE `id` = ? LIMIT 1', [id]);
  }

  /**
   * 判断邮箱是否已被其他会员占用。
   * @param email 邮箱
   * @param excludeId 排除的会员 ID
   */
  async emailTaken(email: string, excludeId = 0): Promise<boolean> {
    const rows: any[] = await this.many('SELECT `id` FROM `kuerp_user` WHERE `email` = ? AND `id` <> ? LIMIT 1', [
      email,
      excludeId,
    ]);
    return rows.length > 0;
  }

  /**
   * 更新会员邮箱。
   * @param userId 会员 ID
   * @param email 新邮箱
   */
  async updateEmail(userId: number, email: string): Promise<void> {
    await this.dataSource.query('UPDATE `kuerp_user` SET `email` = ?, `updatetime` = ? WHERE `id` = ?', [
      email,
      this.now(),
      userId,
    ]);
  }
}

/**
 * 多单位库存折算：取该单位相对主单位的换算率（advance_rate）。
 * 主单位（is_default=1）返回 1。
 *
 * @param item 单位行
 * @param _list 单位数组（保留参数以便后续扩展按主单位查找）
 */
function rateMapOf(item: any, _list: any[]): number | string {
  if (Number(item.is_default) === 1) return 1;
  return item.advance_rate ?? 1;
}
