import { Injectable, BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CacheService } from '../../common/cache/cache.service';

/**
 * 进销存业务扩展服务（1:1 还原 kuerp-1.6.13-extended 各控制器非 CRUD 的 Action）。
 *
 * 背景：
 * 原系统 100 个后台控制器里除标准 index/add/edit/del/examine 之外，还存在大量
 * 「取数辅助 / 弹窗选择 / 业务动作」接口（getUnit、getSaleUnit、getSerial、getGoods、
 * getMenu、getReceivingAddress、choselist、chosereceivable、chosecopewith、
 * choseadvancelist、deliver、savetemp、gettemp、checkPurchase、getBranch、period）。
 * 这些接口决定了页面能否「一模一样」地操作，因此统一收敛到本服务，供 BizController 暴露。
 *
 * 设计约定（与原系统一致）：
 * - 金额/数量统一 double，计算时四舍五入到 4 位；价格展示保留 price_decimal 位；
 * - 价格字段随「客户等级」切换：1=零售价 2=批发价 3=VIP价 4=折扣率1 5=折扣率2；
 * - 税率取自 kuerp_sets（taxes.value / taxes.is_checked / price_taxes.is_checked）；
 * - 库存统一读 kuerp_goods_stock（goods_id + attribute_id + stores_id）；
 * - 时间戳统一秒级 bigint。
 */
@Injectable()
export class BizService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly cache: CacheService,
  ) {}

  // ==================================================================
  // 通用工具
  // ==================================================================

  /** 执行查询并返回行数组 */
  private async many(sql: string, params: any[] = []): Promise<any[]> {
    const r = await this.dataSource.query(sql, params);
    return Array.isArray(r) ? r : [];
  }

  /** 执行查询并返回首行（无结果返回 null） */
  private async one(sql: string, params: any[] = []): Promise<any | null> {
    const rows = await this.many(sql, params);
    return rows.length ? rows[0] : null;
  }

  /** 数值安全转换（null/''/undefined → 0） */
  private n(v: any): number {
    const x = Number(v);
    return Number.isFinite(x) ? x : 0;
  }

  /** 四舍五入到指定小数位（默认 4 位，与原系统 round($x,4) 一致） */
  private r4(v: any, d = 4): number {
    const p = Math.pow(10, d);
    return Math.round((this.n(v) + Number.EPSILON) * p) / p;
  }

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /**
   * 读取系统参数表 kuerp_sets，返回以 name 为键的字典。
   *
   * 【缓存】本方法在取价、取税、取单据编号等几乎所有扩展接口里都会被调用，
   * 而参数表只有几十行、几乎不变。缓存 60 秒，键前缀固定为 `set:all`；
   * 设置页保存（/kuerp/sets/edit）会由 TableService.touchSets() 清掉 `set:` 前缀，
   * 因此「改完参数立刻生效」不受影响。
   *
   * @returns Record<name, { value, is_checked, set }>
   */
  private async sets(): Promise<Record<string, any>> {
    return this.cache.wrap('set:all', 60, async () => {
      const rows = await this.many(
        'SELECT `type`,`name`,`value`,`is_checked`,`set` FROM `kuerp_sets`',
      );
      const map: Record<string, any> = {};
      for (const r of rows) {
        map[String(r.name)] = {
          type: r.type,
          name: r.name,
          value: r.value,
          is_checked: this.n(r.is_checked),
          set: r.set,
        };
      }
      return map;
    });
  }

  /**
   * 按客户等级解析价格字段名（等价原系统 getSaleUnit 内 switch 分支）。
   * @param customerlevelId 客户等级 ID（1~5）
   * @returns 价格字段名，未知等级回落零售价
   */
  private priceFieldOf(customerlevelId: any): string {
    switch (this.n(customerlevelId)) {
      case 2:
        return 'wholesale_price';
      case 3:
        return 'vip_price';
      case 4:
        return 'discount';
      case 5:
        return 'discount2';
      default:
        return 'market_sell_price';
    }
  }

  /**
   * 由「价格字段 + 商品行」计算某单位的单价。
   * 折扣率字段（discount/discount2）存的是百分比，需用零售价折算。
   *
   * @param src 含市场价与各等级价格的对象（商品行或属性行）
   * @param field 价格字段名
   * @param priceDecimal 价格小数位
   */
  private pickPrice(src: any, field: string, priceDecimal: number): number {
    if (!src) return 0;
    if (field === 'discount' || field === 'discount2') {
      return this.r4((this.n(src.market_sell_price) * this.n(src[field])) / 100, priceDecimal);
    }
    return this.n(src[field]);
  }

  // ==================================================================
  // 一、商品单位 / 价格 / 属性
  // ==================================================================

  /**
   * 批量取商品的「可用单位 + 各单位价格 + 库存 + 辅助属性」。
   * 1:1 还原 Goods::getUnit（价格字段固定取零售价 market_sell_price，对齐 PHP getUnit）
   * 与 Goods::getSaleUnit（priceField=auto 时按客户等级切换）。
   *
   * 入参 rows 每项形如 { goods_id, goods_attr?, stores_id? }。
   * 返回每项额外挂载：
   *   unit[]  { id, name, is_default, basic_nmber, purchase, tax, tax_rate, tax_included, tax_money, stock }
   *   attr[]  { id, attr_code, attr_name, attr_ids[], ... }
   *   goods   { id, goods_code, goods_name, ... }
   *
   * @param rows 商品行数组
   * @param opts priceField=purchase|auto；customersId 用于 auto 时解析客户等级；
   *             storesId 指定仓库（getSaleUnit 用首选仓库，getUnit 不过滤仓库）
   */
  async goodsUnits(
    rows: Array<{ goods_id: any; goods_attr?: any; stores_id?: any }>,
    opts: { priceField?: 'purchase' | 'auto' | 'market_sell_price'; customersId?: any; storesId?: any } = {},
  ): Promise<any[]> {
    const list = Array.isArray(rows) ? rows : [];
    if (!list.length) return [];

    const setMap = await this.sets();
    const priceDecimal = this.n(setMap['price_decimal']?.value ?? 2);
    const taxOn = this.n(setMap['taxes']?.is_checked) === 1;
    const taxRate = this.n(setMap['taxes']?.value);
    const taxIncludedPrice = this.n(setMap['price_taxes']?.is_checked) === 1;

    // 价格字段：auto 模式按客户等级解析；getUnit 默认取零售价 market_sell_price（对齐 PHP）
    let priceField: string = opts.priceField ?? 'purchase';
    if (opts.priceField === 'auto') {
      let level = 1;
      if (opts.customersId) {
        const cu = await this.one(
          'SELECT `customerlevel_id` FROM `kuerp_customers` WHERE `id` = ? LIMIT 1',
          [this.n(opts.customersId)],
        );
        level = this.n(cu?.customerlevel_id) || 1;
      }
      priceField = this.priceFieldOf(level);
    }

    // 辅助属性字典（一次读全，避免逐商品查询）
    const auxRows = await this.many(
      'SELECT `id`,`name` FROM `kuerp_auxiliary` WHERE `status` = ?',
      ['1'],
    );
    const auxName = new Map<string, string>();
    auxRows.forEach((a: any) => auxName.set(String(a.id), String(a.name || '')));

    const out: any[] = [];
    for (const item of list) {
      const goodsId = this.n(item.goods_id);
      const row: any = await this.one(
        'SELECT `id`,`goods_code`,`goods_name`,`goods_barcode`,`goods_specification_id`,`manager_warehouse_id`,' +
          '`market_sell_price`,`wholesale_price`,`vip_price`,`discount`,`discount2`,`purchase`,' +
          '`unit_id`,`more_unit`,`more_unit_id`,`auxiliary`,`batch`,`serial`,`shelf_life`' +
          ' FROM `kuerp_goods` WHERE `id` = ? LIMIT 1',
        [goodsId],
      );

      // 商品不存在：返回空壳，保持与原系统（$row 为空 → id=0）一致，不抛错
      if (!row) {
        out.push({ ...item, unit: [], attr: [], goods: null });
        continue;
      }
      // 规格型号拼接（原系统把规格并入 goods_name，前端直接展示）
      if (row.goods_specification_id) {
        row.goods_name = `${row.goods_name}_${row.goods_specification_id}`;
      }

      // ---- 单位集合 ----
      const unitIds: number[] = [this.n(row.unit_id)];
      const rateMap = new Map<string, number>(); // 单位ID → 换算进率
      let priceRows: any[] = [];

      if (this.n(row.more_unit) === 1) {
        const conv = await this.many(
          'SELECT uc.`vice_unit`, u.`name`, u.`id`, uc.`advance_rate`' +
            ' FROM `kuerp_unit_conversion` uc' +
            ' JOIN `kuerp_unit` u ON u.`id` = uc.`vice_unit`' +
            ' WHERE uc.`main_unit` = ? ORDER BY uc.`advance_rate` ASC',
          [this.n(row.unit_id)],
        );
        conv.forEach((c: any) => {
          unitIds.push(this.n(c.id));
          rateMap.set(String(c.id), this.n(c.advance_rate) || 1);
        });
        rateMap.set(String(row.unit_id), 1);

        priceRows = await this.many(
          'SELECT * FROM `kuerp_goods_price` WHERE `goods_id` = ? AND `unit` IN (' +
            unitIds.map(() => '?').join(',') +
            ')',
          [goodsId, ...unitIds],
        );
        // 主单位进率固定 1
        priceRows.forEach((p: any) => {
          if (this.n(p.unit) === this.n(row.unit_id)) p.advance_rate = 1;
          else if (rateMap.has(String(p.unit))) p.advance_rate = rateMap.get(String(p.unit));
        });
      } else {
        rateMap.set(String(row.unit_id), 1);
      }

      const unitRows = await this.many(
        'SELECT `id`,`name` FROM `kuerp_unit` WHERE `id` IN (' +
          unitIds.map(() => '?').join(',') +
          ')',
        unitIds,
      );

      // ---- 库存（getUnit 不按仓库过滤，getSaleUnit 按首选仓库）----
      const stockWhere: string[] = ['`goods_id` = ?'];
      const stockParams: any[] = [goodsId];
      if (opts.priceField === 'auto') {
        stockWhere.push('`stores_id` = ?');
        stockParams.push(this.n(item.stores_id ?? opts.storesId ?? row.manager_warehouse_id));
      }
      if (item.goods_attr) {
        stockWhere.push('`attribute_id` = ?');
        stockParams.push(this.n(item.goods_attr));
      }
      const stockRow = await this.one(
        'SELECT `stock` FROM `kuerp_goods_stock` WHERE ' + stockWhere.join(' AND ') + ' LIMIT 1',
        stockParams,
      );
      const stock = this.n(stockRow?.stock);

      // ---- 属性行（辅助属性组合）----
      const attrRows = await this.many(
        'SELECT * FROM `kuerp_goods_attr` WHERE `goods_id` = ?',
        [goodsId],
      );
      for (const a of attrRows) {
        a.attr_ids = [];
        a.attr_name = '';
        const comb = await this.one(
          'SELECT `attr_ids` FROM `kuerp_aux_combination` WHERE `id` = ? LIMIT 1',
          [this.n(a.attribute_id)],
        );
        const ids = String(comb?.attr_ids || '');
        if (ids) {
          a.attr_id = ids;
          const parts = ids.split('&').filter(Boolean);
          a.attr_ids = parts;
          a.attr_name = parts.map((p) => auxName.get(String(p)) || '').filter(Boolean).join('/');
        }
      }

      // ---- 逐单位计算价格 / 库存 / 税额 ----
      const units: any[] = [];
      for (const uid of unitIds) {
        const u = unitRows.find((x: any) => this.n(x.id) === this.n(uid));
        if (!u) continue;

        let isDefault = 0;
        let basicNumber = 1;
        let basePrice = 0;

        const priceRow = priceRows.find((p: any) => this.n(p.unit) === this.n(uid));
        if (priceRow) {
          isDefault = this.n(priceRow.is_default);
          basePrice = this.pickPrice(priceRow, priceField, priceDecimal);
          basicNumber = isDefault === 1 ? 1 : this.n(priceRow.advance_rate) || 1;
        } else {
          // 无单位价：按商品行（或多属性行）直接取值，仅主单位有价
          const src =
            this.n(row.auxiliary) === 1 && item.goods_attr
              ? await this.one(
                  'SELECT * FROM `kuerp_goods_attr` WHERE `goods_id` = ? AND `id` = ? LIMIT 1',
                  [goodsId, this.n(item.goods_attr)],
                )
              : row;
          const price = this.pickPrice(src, priceField, priceDecimal);
          if (this.n(uid) === this.n(row.unit_id)) {
            isDefault = 1;
            basicNumber = 1;
            basePrice = price;
          }
        }

        // ---- 含税 / 不含税折算（1:1 复刻原系统三分支）----
        let purchase: number;
        let taxIncluded: number;
        if (taxOn && taxIncludedPrice) {
          purchase = this.r4((basePrice * basicNumber) / (100 + taxRate) * 100, 4);
          taxIncluded = this.r4(basePrice * basicNumber, 4);
        } else if (taxOn && !taxIncludedPrice) {
          purchase = this.r4(basePrice * basicNumber, 4);
          taxIncluded = this.r4((basePrice * basicNumber * (100 + taxRate)) / 100, 4);
        } else {
          purchase = this.r4(basePrice * basicNumber, 4);
          taxIncluded = this.r4(basePrice * basicNumber, 4);
        }

        units.push({
          id: u.id,
          name: u.name,
          is_default: isDefault,
          basic_nmber: basicNumber,
          purchase,
          tax: taxOn ? 1 : 0,
          tax_rate: taxOn ? taxRate : 0,
          tax_included: taxIncluded,
          tax_money: this.r4(taxIncluded - purchase, 4),
          // 非主单位库存按进率折算（原系统口径）
          stock: isDefault === 1 ? stock : this.r4(stock / (basicNumber || 1), 2),
        });
      }

      out.push({ ...item, unit: units, attr: attrRows, goods: row });
    }
    return out;
  }

  /**
   * 取某商品在指定仓库的可用序列号（等价 Goods::getSerial）。
   *
   * @param p goods_code 商品编号；stores_id 仓库；attribute_id 属性组合（可选）
   * @returns { list: [{ serial, remark, status }] }
   */
  async goodsSerial(p: { goods_code?: string; stores_id?: any; attribute_id?: any }): Promise<any> {
    const where: string[] = ['`store_status` = ?', '`goods_code` = ?'];
    const params: any[] = ['1', String(p.goods_code || '')];
    if (p.stores_id !== undefined && p.stores_id !== '') {
      where.push('`stores_id` = ?');
      params.push(this.n(p.stores_id));
    }
    if (p.attribute_id) {
      where.push('`attribute_id` = ?');
      params.push(String(p.attribute_id));
    }
    const list = await this.many(
      'SELECT `serial`,`remark`,`status` FROM `kuerp_goods_serial` WHERE ' +
        where.join(' AND ') +
        ' ORDER BY `id` ASC',
      params,
    );
    return { list };
  }

  /**
   * 序列号录入辅助（等价 Goods::period）。
   * 把前端提交的序列号数组归一化为「数量 + 序列化串」，供单据明细 period 字段存储。
   *
   * @param body period_period 已存在的序列化串；chose_serial 已选序列号数组；
   *             serial[] + remark[] 手工录入
   * @returns { num, ser }
   */
  async buildSerial(body: any): Promise<any> {
    // 场景一：已存在序列化串，直接回读
    if (body?.period_period) {
      return { num: undefined, ser: body.period_period };
    }
    // 场景二：已选序列号数组
    if (Array.isArray(body?.chose_serial)) {
      const data = body.chose_serial
        .filter((s: any) => String(s || '').trim() !== '')
        .map((s: any) => ({ serial: String(s), remark: '' }));
      return { num: data.length, ser: JSON.stringify(data) };
    }
    // 场景三：手工录入（serial + remark 两列）
    const serial = Array.isArray(body?.serial) ? body.serial : [];
    const remark = Array.isArray(body?.remark) ? body.remark : [];
    const data: any[] = [];
    serial.forEach((s: any, i: number) => {
      if (String(s || '').trim() !== '') {
        data.push({ serial: String(s), remark: remark[i] ?? '' });
      }
    });
    return { num: data.length, ser: JSON.stringify(data) };
  }

  /**
   * 扫码 / 按编号定位商品（等价 Goods::getGoods）。
   * 依次匹配：商品编号 → 商品条码 → 辅助属性条码 → 属性编号。
   *
   * @param code 扫码内容
   * @returns 命中商品（含命中的属性组合 ID），未命中返回 null
   */
  async goodsByCode(code: string): Promise<any> {
    const key = String(code || '').trim();
    if (!key) return null;

    // 对齐 PHP Goods::getGoods：先按辅助属性条码命中（仅 barcode，不含 attr_code），
    // 命中则按属性所属商品编号取商品；否则再按商品编号 / 商品条码命中。
    const attr = await this.one(
      'SELECT * FROM `kuerp_goods_attr` WHERE `barcode` = ? LIMIT 1',
      [key],
    );
    let goods: any = null;
    if (attr) {
      goods = await this.one(
        'SELECT * FROM `kuerp_goods` WHERE `goods_code` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
        [String(attr.goods_code)],
      );
    } else {
      goods = await this.one(
        'SELECT * FROM `kuerp_goods` WHERE `goods_code` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
        [key],
      );
      if (!goods) {
        goods = await this.one(
          'SELECT * FROM `kuerp_goods` WHERE `goods_barcode` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
          [key],
        );
      }
    }
    if (!goods) return null;

    if (goods.goods_specification_id) {
      goods.goods_name = `${goods.goods_name}_${goods.goods_specification_id}`;
    }
    // goods_attr 仅在经由属性条码命中时返回，避免直接命中商品时被无关属性覆盖
    return { goods, goods_attr: attr ? this.n(attr.id) : null };
  }

  /**
   * 商品类别树（等价 Goods::getMenu）。
   * @returns 顶级类别数组，children 递归
   */
  async goodsMenu(): Promise<any[]> {
    const rows = await this.many(
      'SELECT `id`,`type_name`,`pid`,`path`,`weigh`,`status` FROM `kuerp_goods_type` ORDER BY `weigh` DESC, `id` ASC',
    );
    const map = new Map<number, any>();
    rows.forEach((r: any) => map.set(this.n(r.id), { ...r, children: [] }));
    const roots: any[] = [];
    for (const r of rows) {
      const node = map.get(this.n(r.id));
      const pid = this.n(r.pid);
      if (pid && map.has(pid)) map.get(pid).children.push(node);
      else roots.push(node);
    }
    return roots;
  }

  // ==================================================================
  // 二、往来单位辅助
  // ==================================================================

  /**
   * 客户收货地址（等价 GoodsSales::getReceivingAddress）。
   * 原系统取客户档案上的默认收货地址；这里同时兼容 kuerp_address 明细表。
   *
   * @param customersId 客户 ID
   * @returns { address, connet_name, mobile, list }
   */
  async receivingAddress(customersId: any): Promise<any> {
    const cid = this.n(customersId);
    const cu = await this.one(
      'SELECT `customer_name`,`connet_name`,`customer_mobile`,`customer_phone`,`getgoods_address`' +
        ' FROM `kuerp_customers` WHERE `id` = ? LIMIT 1',
      [cid],
    );
    // 收货地址明细表（若存在该客户的地址记录则一并返回）
    let list: any[] = [];
    try {
      list = await this.many(
        'SELECT `id`,`name`,`phone`,`address`,`is_default` FROM `kuerp_address`' +
          ' WHERE `customers_id` = ? ORDER BY `is_default` DESC, `id` DESC',
        [cid],
      );
    } catch {
      list = [];
    }
    return {
      address: cu?.getgoods_address || '',
      connet_name: cu?.connet_name || '',
      mobile: cu?.customer_mobile || cu?.customer_phone || '',
      list,
    };
  }

  /**
   * 门店 / 仓库分支列表（等价 GoodsPurchase::getBranch）。
   * 供单据选择「门店配送」或按仓库过滤商品。
   *
   * @param keyword 名称模糊检索（可选）
   */
  async branchList(keyword?: string): Promise<any[]> {
    const where: string[] = ['(`deletetime` IS NULL OR `deletetime` = 0)'];
    const params: any[] = [];
    if (keyword) {
      where.push('`name` LIKE ?');
      params.push(`%${keyword}%`);
    }
    return this.many(
      'SELECT `id`,`name`,`type`,`address`,`status` FROM `kuerp_stores` WHERE ' +
        where.join(' AND ') +
        ' ORDER BY `id` ASC LIMIT 500',
      params,
    );
  }

  // ==================================================================
  // 三、核销源单（四种口径）
  // ==================================================================

  /**
   * 核销源单列表，1:1 复刻 Writeoff 控制器的四个选择弹窗：
   *   receive    应收（chosereceivable）：purchase_type ∈ [3,5]，按 customers_id 过滤
   *   cope       应付（chosecopewith）：  purchase_type ∈ [4,5]，按供应商编号过滤
   *   advance    预收（choselist）：     purchase_type ∈ [1,6]，按 customers_id 过滤
   *   advanceOut 预付（choseadvancelist）：purchase_type ∈ [2,6]，按供应商编号过滤
   *
   * 说明：收款单/付款单的源单弹窗会混选「预收 + 应收 + 期初」，因此额外支持
   * types 显式覆盖默认集合（如 types=1,3,5），避免为每种组合硬编码口径。
   *
   * 共同过滤：排除已被完整核销的源单（writeoff_log.write_off<>0 视为仍有余额）。
   *
   * @param p kind 口径；types 覆盖用的 purchase_type 列表（逗号分隔）；
   *          customers_id 客户；suppliers_id 供应商；keyword 单号模糊；
   *          start 起（秒）；end 止（秒）
   * @returns { total, rows }
   */
  async writeoffSources(p: {
    kind?: string;
    types?: string;
    customers_id?: any;
    suppliers_id?: any;
    keyword?: string;
    start?: any;
    end?: any;
  }): Promise<any> {
    const kind = String(p.kind || 'receive');

    const where: string[] = [];
    const params: any[] = [];

    // 1) 口径 → 可选 purchase_type 集合（可被 types 覆盖）
    const defaults: Record<string, number[]> = {
      receive: [3, 5],
      cope: [4, 5],
      advance: [1, 6],
      advanceOut: [2, 6],
    };
    let types = defaults[kind] || defaults.receive;
    if (p.types) {
      const parsed = String(p.types)
        .split(',')
        .map((x) => Number(x.trim()))
        .filter((x) => x >= 1 && x <= 6);
      if (parsed.length) types = parsed;
    }

    // 2) 往来单位维度：应付/预付按供应商编号，应收/预收按客户 ID
    const bySupplier = kind === 'cope' || kind === 'advanceOut';
    if (bySupplier) {
      const sp = await this.one(
        'SELECT `supplyer_code` FROM `kuerp_suppliers` WHERE `id` = ? LIMIT 1',
        [this.n(p.suppliers_id)],
      );
      // 供应商未选定：不加条件（返回全部，前端可按需再筛）
      if (sp?.supplyer_code) {
        where.push('`suppliers_code` = ?');
        params.push(String(sp.supplyer_code));
      }
    } else if (p.customers_id) {
      where.push('`customers_id` = ?');
      params.push(this.n(p.customers_id));
    }

    where.push('`purchase_type` IN (' + types.map(() => '?').join(',') + ')');
    params.push(...types);

    if (p.keyword) {
      where.push('`purchase_code` LIKE ?');
      params.push(`%${String(p.keyword)}%`);
    }
    if (p.start) {
      where.push('`purchase_time` >= ?');
      params.push(this.n(p.start));
    }
    if (p.end) {
      where.push('`purchase_time` <= ?');
      params.push(this.n(p.end));
    }

    // 未核销完过滤：无日志，或日志里仍有未核销余额
    const raw = await this.many(
      'SELECT * FROM `kuerp_writeoff_source` WHERE ' +
        where.join(' AND ') +
        ' AND (`id` NOT IN (SELECT `source_id` FROM `kuerp_writeoff_log`)' +
        '      OR `id` IN (SELECT `source_id` FROM `kuerp_writeoff_log` WHERE `write_off` <> 0))' +
        ' ORDER BY `purchase_type` DESC, `purchase_time` ASC',
      params,
    );

    const rows: any[] = [];
    for (const v of raw) {
      const log = await this.one(
        'SELECT `money`,`write_off` FROM `kuerp_writeoff_log` WHERE `source_id` = ? LIMIT 1',
        [this.n(v.id)],
      );
      const isOpening = this.n(v.purchase_type) > 4;
      rows.push({
        ...v,
        money_tax_price: this.n(v.price),
        pay_money: log ? this.n(log.money) : 0,
        money: log ? this.n(log.write_off) : this.n(v.write_off),
        purchase_type_id: this.n(v.id),
        purchase_codes: v.purchase_code,
        purchase_type_name: this.sourceTypeName(v),
        purchase_code_display: isOpening ? '期初余额' : v.purchase_code,
        purchase_time_str: v.purchase_time
          ? new Date(this.n(v.purchase_time) * 1000).toISOString().slice(0, 10)
          : '',
      });
    }
    return { total: rows.length, rows };
  }

  /**
   * 核销源单类型文案（与前端 fund-doc 的 sourceTypeName 口径一致）。
   * purchase_type：1=预收单 2=预付单 3=应收 4=应付 5=期初应收 6=期初预付；
   * type=2 表示退货单。
   *
   * @param row 源单行
   */
  private sourceTypeName(row: any): string {
    const names: Record<number, string> = {
      1: '预收单',
      2: '预付单',
      3: '应收单',
      4: '应付单',
      5: '期初应收',
      6: '期初预付',
    };
    const base = names[this.n(row.purchase_type)] || '源单';
    return this.n(row.type) === 2 ? `${base}(退货)` : base;
  }

  // ==================================================================
  // 四、订货通订单：审核 / 发货
  // ==================================================================

  /**
   * 订货单审核（等价 UserOrder::examine）：批量把 status 置为 2（待发货）。
   * 仅「待审核(0)/已审核(1)」可审核；其余状态给出明确提示。
   *
   * @param ids 订单 ID 数组
   * @param adminId 操作人
   */
  async userOrderExamine(ids: number[], adminId = 0): Promise<{ count: number; msg: string }> {
    const list = Array.isArray(ids) ? ids.filter((i) => this.n(i) > 0) : [];
    if (!list.length) throw new BadRequestException('请选择要审核的数据');

    const rows = await this.many(
      'SELECT `id`,`order_num`,`status` FROM `kuerp_user_order` WHERE `id` IN (' +
        list.map(() => '?').join(',') +
        ') AND (`deletetime` IS NULL OR `deletetime` = 0)',
      list,
    );
    if (!rows.length) throw new BadRequestException('未找到订单');

    for (const r of rows) {
      const st = this.n(r.status);
      if (st > 4) throw new BadRequestException(`${r.order_num} 状态异常，不可审核`);
    }

    await this.dataSource.query(
      'UPDATE `kuerp_user_order` SET `status` = ?, `updatetime` = ? WHERE `id` IN (' +
        list.map(() => '?').join(',') +
        ')',
      ['2', this.now(), ...list],
    );
    void adminId;
    return { count: rows.length, msg: '审核成功' };
  }

  /**
   * 订货单发货（等价 UserOrder::deliver）。
   *
   * 校验链路与原系统一致：
   *   1. status=0 未审核不可发货；2 待发货才可发货；3/4 已发货/已收货不可重复发货；
   *   2. 待发货订单必须已生成销货单（kuerp_user_ordersale.sales_id > 0）；
   *   3. 若系统配置 pay_status=1（要求支付后发货），订单必须已支付；
   *   4. 配送方式：send_type=1 司机配送（写司机姓名/电话）；否则快递（写快递公司/单号）。
   *
   * @param ids 订单 ID 数组
   * @param body send_type / diver_id / express_code / express_num
   * @param adminId 操作人
   */
  async userOrderDeliver(
    ids: number[],
    body: { send_type?: any; diver_id?: any; express_code?: string; express_num?: string },
    adminId = 0,
  ): Promise<{ count: number; msg: string }> {
    const list = Array.isArray(ids) ? ids.filter((i) => this.n(i) > 0) : [];
    if (!list.length) throw new BadRequestException('请选择要发货的数据');

    const rows = await this.many(
      'SELECT * FROM `kuerp_user_order` WHERE `id` IN (' +
        list.map(() => '?').join(',') +
        ') AND (`deletetime` IS NULL OR `deletetime` = 0)',
      list,
    );
    if (!rows.length) throw new BadRequestException('未找到订单');

    // 是否要求「支付后发货」
    const payCfg = await this.one(
      'SELECT `value` FROM `kuerp_user_config` WHERE `name` = ? LIMIT 1',
      ['pay_status'],
    );
    const requirePay = this.n(payCfg?.value) === 1;

    // 逐单校验
    for (const v of rows) {
      const st = this.n(v.status);
      if (st === 0) throw new BadRequestException(`${v.order_num} 未审核，不可发货`);
      if (st === 2) {
        const sale = await this.one(
          'SELECT `sales_id` FROM `kuerp_user_ordersale` WHERE `order_id` = ? LIMIT 1',
          [this.n(v.id)],
        );
        if (!sale || this.n(sale.sales_id) <= 0) {
          throw new BadRequestException(`${v.order_num} 未生成销货单，不可发货`);
        }
        if (requirePay && this.n(v.pay_status) !== 1) {
          throw new BadRequestException(`${v.order_num} 未支付，不可发货`);
        }
      } else if (st === 3) {
        throw new BadRequestException(`${v.order_num} 已发货，不可重复发货`);
      } else if (st === 4) {
        throw new BadRequestException(`${v.order_num} 已收货，不可重复发货`);
      } else {
        // status=1 等任何非 0/2/3/4 的状态均视为异常，不可发货（对齐 PHP 的 default 分支）
        throw new BadRequestException(`${v.order_num} 状态异常，不可发货`);
      }
    }

    const sendType = this.n(body?.send_type) === 2 ? 2 : 1;
    let diverName = '';
    let diverPhone = '';
    if (sendType === 1) {
      const driver = await this.one(
        'SELECT `name`,`phone` FROM `kuerp_driver` WHERE `id` = ? LIMIT 1',
        [this.n(body?.diver_id)],
      );
      diverName = String(driver?.name || '');
      diverPhone = String(driver?.phone || '');
    }

    // 快递公司字典（原系统 $this->express 配置，这里取 kuerp_sets 中的 express 配置）
    const setMap = await this.sets();
    let expressName = '';
    if (sendType === 2 && body?.express_code) {
      const conf = this.parseExpressConfig(setMap['express']?.value);
      expressName = conf[String(body.express_code)] || '';
    }

    let count = 0;
    for (const v of rows) {
      const data: any = { status: '3', updatetime: this.now(), operation_id: adminId || null };
      if (sendType === 1) {
        data.diver_type = '1';
        data.diver_id = this.n(body?.diver_id) || null;
        data.diver_name = diverName;
        data.diver_phone = diverPhone;
      } else {
        data.diver_type = '1';
        data.express_code = body?.express_code || '';
        data.express_name = expressName;
        data.express_num = body?.express_num || '';
      }
      const fields = Object.keys(data);
      await this.dataSource.query(
        'UPDATE `kuerp_user_order` SET ' + fields.map((f) => `\`${f}\` = ?`).join(', ') + ' WHERE `id` = ?',
        [...fields.map((f) => data[f]), this.n(v.id)],
      );
      count++;
    }

    return { count, msg: '发货成功' };
  }

  /**
   * 解析快递公司配置（兼容 JSON 与 `code:name` 换行两种格式）。
   * @param raw kuerp_sets.express.value
   */
  private parseExpressConfig(raw: any): Record<string, string> {
    const out: Record<string, string> = {};
    const s = String(raw || '').trim();
    if (!s) return out;
    try {
      const obj = JSON.parse(s);
      if (obj && typeof obj === 'object') {
        Object.keys(obj).forEach((k) => (out[k] = String(obj[k])));
        return out;
      }
    } catch {
      /* 非 JSON，按行解析 */
    }
    s.split(/[\r\n,;]+/)
      .map((x) => x.trim())
      .filter(Boolean)
      .forEach((line) => {
        const m = line.split(/[:：=]/);
        if (m.length >= 2) out[m[0].trim()] = m.slice(1).join(':').trim();
      });
    return out;
  }

  /**
   * 快递公司字典（等价 deliver.html 的 express_list）。
   * @returns [{ code, name }]
   */
  async expressList(): Promise<Array<{ code: string; name: string }>> {
    const setMap = await this.sets();
    const conf = this.parseExpressConfig(setMap['express']?.value);
    return Object.keys(conf).map((code) => ({ code, name: conf[code] }));
  }

  /**
   * 订货单生成销货单（等价 UserOrder 列表「生成销货单」→ goods_sales/add?order_id=x）。
   *
   * 行为说明：
   * 原系统打开的是「新增销货单」表单并预填订单商品，由用户确认后保存；
   * 这里等价落一张**未审核**销货单（表头 + 明细），审核后由过账引擎扣库存，
   * 同时写 kuerp_user_ordersale 关联、把订单状态推进到 2（待发货）。
   *
   * @param orderId 订货单 ID
   * @param adminId 操作人
   * @returns { sales_id, purchase_code }
   */
  async userOrderToSales(orderId: any, adminId = 0): Promise<any> {
    const oid = this.n(orderId);
    if (!oid) throw new BadRequestException('缺少订单 ID');

    const order = await this.one(
      'SELECT * FROM `kuerp_user_order` WHERE `id` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
      [oid],
    );
    if (!order) throw new BadRequestException('未找到订单');

    // 已生成过销货单：直接返回（幂等）
    const exist = await this.one(
      'SELECT `sales_id` FROM `kuerp_user_ordersale` WHERE `order_id` = ? LIMIT 1',
      [oid],
    );
    if (exist && this.n(exist.sales_id) > 0) {
      return { sales_id: this.n(exist.sales_id), purchase_code: '', existed: true };
    }

    const items = await this.many(
      'SELECT * FROM `kuerp_user_orderinfo` WHERE `order_id` = ? ORDER BY `id` ASC',
      [oid],
    );
    if (!items.length) throw new BadRequestException('订单无商品明细，不可生成销货单');

    // 客户：订货通会员可能绑定业务客户
    const user = await this.one('SELECT `customers_id` FROM `kuerp_user` WHERE `id` = ? LIMIT 1', [
      this.n(order.user_id),
    ]);
    const customersId = this.n(user?.customers_id) || null;

    const w = this.now();
    const code = await this.genCodeSafe('kuerp_goods_sales', 'purchase_code', 'XHD');

    const headId = await this.insertAndGetId('kuerp_goods_sales', {
      admin_id: adminId || null,
      purchase_code: code,
      order_code: order.order_num || '',
      order_time: this.n(order.createtime) || w,
      order_type: '1',
      purchase_type: '1',
      purchase_time: w,
      customers_id: customersId,
      receiving_address: order.address || '',
      number: 0,
      all_money: this.n(order.order_price),
      real_money: this.n(order.order_price),
      money_tax_price: this.n(order.order_price),
      preparation_id: adminId || null,
      operation_id: adminId || null,
      examine_status: '0',
      note: `由订货单 ${order.order_num || ''} 生成`,
      createtime: w,
      updatetime: w,
    });

    let totalNumber = 0;
    for (const it of items) {
      const goods = await this.one(
        'SELECT `id`,`goods_code`,`unit_id`,`more_unit`,`manager_warehouse_id` FROM `kuerp_goods` WHERE `id` = ? LIMIT 1',
        [this.n(it.goods_id)],
      );
      // 多单位换算基本数量
      let rate = 1;
      if (goods && this.n(goods.more_unit) === 1 && this.n(it.goods_unit) !== this.n(goods.unit_id)) {
        const conv = await this.one(
          'SELECT `advance_rate` FROM `kuerp_unit_conversion` WHERE `main_unit` = ? AND `vice_unit` = ? LIMIT 1',
          [this.n(goods.unit_id), this.n(it.goods_unit)],
        );
        rate = this.n(conv?.advance_rate) || 1;
      }
      totalNumber += this.n(it.number);

      await this.insertAndGetId('kuerp_goods_sales_info', {
        admin_id: adminId || null,
        purchase_code: code,
        purchase_type: '1',
        purchase_time: w,
        customers_id: customersId,
        receiving_address: order.address || '',
        goods_code: String(goods?.goods_code || ''),
        goods_attr: this.n(it.goods_attr) || null,
        goods_unit: this.n(it.goods_unit) || null,
        stores_id: this.n(goods?.manager_warehouse_id) || null,
        number: this.n(it.number),
        default_unit: this.n(goods?.unit_id) || null,
        basic_nmber: this.r4(this.n(it.number) * rate),
        unit_price: this.n(it.price),
        all_money: this.n(it.money),
        money_tax_price: this.n(it.money),
        remark: it.attr_name ? String(it.attr_name) : null,
        preparation_id: adminId || null,
        operation_id: adminId || null,
        createtime: w,
        updatetime: w,
      });
    }

    // 回写表头数量
    await this.dataSource.query(
      'UPDATE `kuerp_goods_sales` SET `number` = ? WHERE `id` = ?',
      [this.r4(totalNumber), headId],
    );
    // 关联 + 状态推进
    await this.insertAndGetId('kuerp_user_ordersale', { order_id: oid, sales_id: headId });
    await this.dataSource.query(
      'UPDATE `kuerp_user_order` SET `status` = ?, `updatetime` = ? WHERE `id` = ?',
      ['2', w, oid],
    );

    return { sales_id: headId, purchase_code: code };
  }

  /**
   * 按「单号设置」生成编号；规则缺失时回落到「前缀 + 年月日时分秒」。
   *
   * @param table 目标表名（kuerp_goods_sales 等）
   * @param field 编号字段名
   * @param fallbackPrefix 缺规则时的前缀
   */
  private async genCodeSafe(table: string, field: string, fallbackPrefix: string): Promise<string> {
    try {
      const rule = await this.one(
        'SELECT * FROM `kuerp_prefix` WHERE `dbname` = ? ORDER BY (`field` = ?) DESC, `id` ASC LIMIT 1',
        [table, field],
      );
      if (rule) {
        const d = new Date();
        const p2 = (v: number) => String(v).padStart(2, '0');
        const dateSeg =
          (String(rule.year) === '1' ? String(d.getFullYear()) : '') +
          (String(rule.month) === '1' ? p2(d.getMonth() + 1) : '') +
          (String(rule.day) === '1' ? p2(d.getDate()) : '') +
          (String(rule.hour) === '1' ? p2(d.getHours()) : '') +
          (String(rule.minute) === '1' ? p2(d.getMinutes()) : '') +
          (String(rule.second) === '1' ? p2(d.getSeconds()) : '');
        const prefix = `${rule.prefix || fallbackPrefix}${dateSeg}`;
        const strlen = this.n(rule.strlen) || 4;
        const start = this.n(rule.start) || 1;
        // 查当前最大流水号，递增到不冲突
        const last = await this.one(
          `SELECT \`${field}\` AS code FROM \`${table}\` WHERE \`${field}\` LIKE ? ORDER BY \`${field}\` DESC LIMIT 1`,
          [`${prefix}%`],
        );
        let seq = start;
        if (last?.code) {
          const tail = String(last.code).slice(prefix.length);
          const num = Number(tail);
          if (Number.isFinite(num) && num >= start) seq = num + 1;
        }
        // 冲突重试（并发/历史脏数据）
        for (let i = 0; i < 50; i++) {
          const code = `${prefix}${String(seq + i).padStart(strlen, '0')}`;
          const dup = await this.one(
            `SELECT 1 AS x FROM \`${table}\` WHERE \`${field}\` = ? LIMIT 1`,
            [code],
          );
          if (!dup) return code;
        }
      }
    } catch {
      /* 规则异常走兜底 */
    }
    const d = new Date();
    const p2 = (v: number) => String(v).padStart(2, '0');
    return (
      fallbackPrefix +
      String(d.getFullYear()) +
      p2(d.getMonth() + 1) +
      p2(d.getDate()) +
      p2(d.getHours()) +
      p2(d.getMinutes()) +
      p2(d.getSeconds())
    );
  }

  // ==================================================================
  // 五、组装 / 拆卸模板
  // ==================================================================
  /** 模板表名映射：assemble → kuerp_assemble_temp / split → kuerp_split_temp */
  private tempTables(kind: string) {
    if (kind === 'split') {
      return { head: 'kuerp_split_temp', info: 'kuerp_split_info_temp', label: '拆卸单' };
    }
    return { head: 'kuerp_assemble_temp', info: 'kuerp_assemble_info_temp', label: '组装单' };
  }

  /**
   * 存为模板（等价 Assemble::savetemp / Split::savetemp）。
   *
   * 与「新增单据」的差别：只落模板表（head + info_temp），不生成库存流水。
   * 校验点：模板名非空且不重复、单据编号非空、明细行需选单位与仓库。
   *
   * @param kind assemble / split
   * @param body { temp_name, head: {...}, rows: [...] }
   * @param adminId 操作人
   * @returns 新模板 ID
   */
  async saveTemp(kind: string, body: any, adminId = 0): Promise<any> {
    const t = this.tempTables(kind);
    const tempName = String(body?.temp_name || '').trim();
    if (!tempName) throw new BadRequestException('请输入模板名称');

    const dup = await this.one(`SELECT \`id\` FROM \`${t.head}\` WHERE \`temp_name\` = ? LIMIT 1`, [
      tempName,
    ]);
    if (dup) throw new BadRequestException('模板名称不能重复');

    const head = body?.head || {};
    const rows: any[] = Array.isArray(body?.rows) ? body.rows : [];
    if (!String(head.purchase_code || '').trim()) throw new BadRequestException('请填写单据编号');
    if (!rows.length) throw new BadRequestException('组件信息不能为空');

    const w = this.now();
    const headId = await this.insertAndGetId(t.head, {
      admin_id: adminId || null,
      temp_name: tempName,
      purchase_code: String(head.purchase_code || ''),
      purchase_time: this.n(head.purchase_time) || w,
      business_type: '1',
      money: this.n(head.money ?? head.costs),
      remark: head.remark ?? head.note ?? '',
      preparation_id: adminId || null,
      operation_id: adminId || null,
      createtime: w,
      updatetime: w,
    });

    // 明细：type=1 组合件（第一行），其余 type=2 子件，与原系统一致
    for (let i = 0; i < rows.length; i++) {
      const r = rows[i];
      if (!String(r.goods_code || '').trim()) continue;
      if (!r.goods_unit) throw new BadRequestException('请选择单位');
      if (!r.stores_id) throw new BadRequestException('请选择仓库');

      const goods = await this.one(
        'SELECT `id`,`goods_code`,`unit_id`,`more_unit` FROM `kuerp_goods` WHERE `goods_code` = ? LIMIT 1',
        [String(r.goods_code)],
      );
      if (!goods) throw new BadRequestException(`商品 ${r.goods_code} 不存在`);

      // 多单位：换算基本数量
      let rate = 1;
      if (this.n(goods.more_unit) === 1 && this.n(r.goods_unit) !== this.n(goods.unit_id)) {
        const conv = await this.one(
          'SELECT `advance_rate` FROM `kuerp_unit_conversion` WHERE `main_unit` = ? AND `vice_unit` = ? LIMIT 1',
          [this.n(goods.unit_id), this.n(r.goods_unit)],
        );
        if (!conv) throw new BadRequestException('商品单位信息查询失败');
        rate = this.n(conv.advance_rate) || 1;
      }

      await this.insertAndGetId(t.info, {
        admin_id: adminId || null,
        purchase_id: headId,
        purchase_code: String(head.purchase_code || ''),
        purchase_time: this.n(head.purchase_time) || w,
        business_type: '1',
        type: i === 0 ? '1' : '2',
        goods_id: this.n(goods.id),
        goods_code: String(r.goods_code),
        goods_attr: this.n(r.goods_attr) || null,
        goods_unit: this.n(r.goods_unit) || null,
        stores_id: this.n(r.stores_id) || null,
        allow_stock: this.n(r.allow_stock),
        number: this.n(r.number),
        period: r.period ?? null,
        basic_number: this.r4(rate * this.n(r.number)),
        unit_cost: this.n(r.unit_cost),
        cost_money: this.n(r.cost_money),
        remark: r.remark ?? null,
        batch_id: this.n(r.batch_id) || null,
        batch: r.batch ?? null,
        manufacture: this.n(r.manufacture) || null,
        guarantee: this.n(r.guarantee) || null,
        validity: this.n(r.validity) || null,
        preparation_id: adminId || null,
        operation_id: adminId || null,
        createtime: w,
        updatetime: w,
      });
    }
    return { id: headId };
  }

  /**
   * 模板列表（等价 AssembleTemp/SplitTemp::index）。
   * @param kind assemble / split
   */
  async listTemps(kind: string): Promise<any[]> {
    const t = this.tempTables(kind);
    const sql =
      'SELECT `id`,`temp_name`,`purchase_code`,`purchase_time`,`money`,`remark`,`createtime`' +
      ` FROM \`${t.head}\` ORDER BY \`id\` DESC LIMIT 500`;
    return this.many(sql);
  }

  /**
   * 模板详情（等价 AssembleTemp::gettemp）：表头 + 明细（含商品名称）。
   *
   * @param kind assemble / split
   * @param id 模板 ID
   * @returns { temp, info }
   */
  async getTemp(kind: string, id: any): Promise<any> {
    const t = this.tempTables(kind);
    const temp = await this.one(`SELECT * FROM \`${t.head}\` WHERE \`id\` = ? LIMIT 1`, [this.n(id)]);
    if (!temp) throw new BadRequestException('未查询到模板信息');
    const info = await this.many(
      `SELECT a.*, g.\`goods_name\`, g.\`goods_barcode\` FROM \`${t.info}\` a` +
        ' LEFT JOIN `kuerp_goods` g ON g.`id` = a.`goods_id`' +
        ' WHERE a.`purchase_id` = ? ORDER BY a.`id` ASC',
      [this.n(id)],
    );
    if (!info.length) throw new BadRequestException('未查询到模板信息');
    return { temp, info };
  }

  /** 通用插入并返回自增 ID（字段名做白名单式转义） */
  private async insertAndGetId(table: string, data: Record<string, any>): Promise<number> {
    if (!/^kuerp_[a-z0-9_]+$/.test(table)) throw new BadRequestException('非法表名');
    const fields = Object.keys(data);
    const sql =
      `INSERT INTO \`${table}\` (` +
      fields.map((f) => `\`${f}\``).join(',') +
      ') VALUES (' +
      fields.map(() => '?').join(',') +
      ')';
    const r = await this.dataSource.query(sql, fields.map((f) => data[f]));
    return this.n(r?.insertId ?? r?.[0]?.insertId ?? 0);
  }

  // ==================================================================
  // 六、库存校验（checkPurchase / checkExchange / checkInventory）
  // ==================================================================

  /**
   * 单据出库库存校验（等价 GoodsSales::checkPurchase 等）。
   * 按「商品 + 属性 + 仓库」聚合出库基本数量，与当前库存比较；
   * 系统参数 allow_negative=1（允许负库存）时直接放行。
   *
   * @param lines [{ goods_code, goods_unit?, goods_attr?, stores_id, number }]
   * @returns { ok, list } list 为不足明细
   */
  async checkStock(
    lines: Array<{
      goods_code?: string;
      goods_unit?: any;
      goods_attr?: any;
      stores_id?: any;
      number?: any;
    }>,
  ): Promise<any> {
    const setMap = await this.sets();
    if (this.n(setMap['allow_negative']?.is_checked) === 1) return { ok: true, list: [] };

    // 同商品同仓同属性累加（一张单据可能多行同商品）
    const acc = new Map<string, { goods_code: string; stores_id: number; attr: number; qty: number }>();
    for (const l of lines || []) {
      const code = String(l.goods_code || '').trim();
      if (!code) continue;
      const storesId = this.n(l.stores_id);
      const attr = this.n(l.goods_attr);
      const goods = await this.one(
        'SELECT `id`,`goods_code`,`unit_id`,`more_unit` FROM `kuerp_goods` WHERE `goods_code` = ? LIMIT 1',
        [code],
      );
      if (!goods) continue;
      let rate = 1;
      if (this.n(goods.more_unit) === 1 && l.goods_unit && this.n(l.goods_unit) !== this.n(goods.unit_id)) {
        const conv = await this.one(
          'SELECT `advance_rate` FROM `kuerp_unit_conversion` WHERE `main_unit` = ? AND `vice_unit` = ? LIMIT 1',
          [this.n(goods.unit_id), this.n(l.goods_unit)],
        );
        rate = this.n(conv?.advance_rate) || 1;
      }
      const qty = this.n(l.number) * rate;
      const key = `${this.n(goods.id)}|${storesId}|${attr}`;
      const cur = acc.get(key) || { goods_code: code, stores_id: storesId, attr, qty: 0 };
      cur.qty = this.r4(cur.qty + qty);
      acc.set(key, cur);
    }

    const list: any[] = [];
    for (const v of acc.values()) {
      const where = ['`goods_code` = ?', '`stores_id` = ?'];
      const params: any[] = [v.goods_code, v.stores_id];
      if (v.attr) {
        where.push('`attribute_id` = ?');
        params.push(v.attr);
      }
      const st = await this.one(
        'SELECT `stock` FROM `kuerp_goods_stock` WHERE ' + where.join(' AND ') + ' LIMIT 1',
        params,
      );
      const stock = this.n(st?.stock);
      if (v.qty > stock + 1e-6) {
        list.push({ goods_code: v.goods_code, stores_id: v.stores_id, need: v.qty, stock });
      }
    }
    return { ok: list.length === 0, list };
  }
}
