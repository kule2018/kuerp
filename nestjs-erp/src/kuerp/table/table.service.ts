import { Injectable, BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { nowSec } from '../../common/bigint.transformer';
import { CacheService } from '../../common/cache/cache.service';
import { PostingService } from '../posting/posting.service';
import { FundsService } from '../funds/funds.service';
import { AGG_REPORTS, runAggReport } from './agg-reports';

/**
 * 虚拟报表列元信息（非单表，无法从 INFORMATION_SCHEMA 读取，需显式声明）。
 * key 为前端路由传入的 table 段（连字符）；report-page.vue 会请求 /columns 与 /index。
 */
export const VIRTUAL_REPORT_COLUMNS: Record<string, { table: string; pk: string; columns: any[] }> = {
  'goods-sales-ranking': {
    table: 'kuerp_goods_sales_ranking',
    pk: 'goods_code',
    columns: [
      { name: 'goods_code', type: 'varchar', comment: '商品编号', nullable: true, isPk: false },
      { name: 'goods_name', type: 'varchar', comment: '商品名称', nullable: true, isPk: false },
      { name: 'number', type: 'double', comment: '销售数量', nullable: true, isPk: false },
      { name: 'all_money', type: 'double', comment: '销售金额', nullable: true, isPk: false },
      { name: 'tax_money', type: 'double', comment: '税额', nullable: true, isPk: false },
      { name: 'money_tax_price', type: 'double', comment: '价税合计', nullable: true, isPk: false },
    ],
  },
};


/**
 * 表字段元信息缓存项。
 */
interface TableMeta {
  columns: string[];          // 全部列名
  pk: string;                 // 主键列名
  hasDeletetime: boolean;     // 是否软删除
  textColumns: string[];      // 可做关键字搜索的字符列（varchar/char/text）
  columnTypes: Record<string, string>; // 列名 -> DATA_TYPE（小写），用于写入前类型矫正
}

/**
 * 列表查询通用入参（与 FastAdmin filter/sort/order/offset/limit 对齐）。
 */
export interface TableQuery {
  page?: number;
  limit?: number;
  offset?: number;
  sort?: string;
  order?: 'ASC' | 'DESC';
  search?: string;
  filter?: Record<string, any> | string; // 支持对象或 JSON 字符串
  /** 逐字段模糊筛选（列名 -> 关键字），用于列表页「多字段筛选栏」的文本字段 */
  like?: Record<string, any> | string;   // 支持对象或 JSON 字符串
  dateField?: string;   // 日期范围筛选作用的列（默认 createtime）
  starttime?: number;   // 起始时间戳（含），用于报表按日期筛选
  endtime?: number;     // 截止时间戳（含）
  rank_type?: string;   // 排行类别：number(按数量) / amount(按金额)，仅虚拟报表使用
  /** 数据权限：2=仅本人创建数据（表需含 admin_id 列），其余值=全部数据。超管不走此分支 */
  dataScope?: number;
  /** 当前登录用户 ID（数据权限=仅本人时用作 admin_id 过滤值） */
  userId?: number;
}

/**
 * 通用动态表服务：不依赖具体 TypeORM 实体，直接对任意 kuerp_* 表做 CRUD。
 *
 * 设计动机：原系统为 FastAdmin 通用模型驱动，159 张表共用同一套 index/add/edit/del/examine 逻辑。
 * 这里用「运行期读取 INFORMATION_SCHEMA 元数据 + 参数化 SQL」在 NestJS 侧等效还原，
 * 使所有表接口（/kuerp/:table/index 等）与原系统保持 1:1，而无需为每张表手写实体。
 *
 * SQL 安全：表名走白名单正则校验，列名只允许来自元数据，所有值均用参数化绑定，杜绝注入。
 */
@Injectable()
export class TableService {
  /** 表名 -> 元信息缓存（运行期首次访问时填充） */
  private metaCache = new Map<string, TableMeta>();

  constructor(
    private readonly dataSource: DataSource,
    private readonly posting: PostingService,
    private readonly funds: FundsService,
    private readonly cache: CacheService,
  ) {}

  /**
   * 校验并规范化表名。
   * @param table 路由传入的表名（不含 kuerp_ 前缀或含均可）
   * @returns 完整物理表名（kuerp_xxx）
   */
  private resolveTable(table: string): string {
    if (!table || !/^[a-z0-9_-]+$/i.test(table)) {
      throw new BadRequestException('非法表名');
    }
    // URL 段常用连字符（goods-type），物理表用下划线（kuerp_goods_type），统一转换
    const normalized = table.replace(/-/g, '_');
    const full = normalized.startsWith('kuerp_') ? normalized : `kuerp_${normalized}`;
    if (!/^kuerp_[a-z0-9_]+$/.test(full)) {
      throw new BadRequestException('非法表名');
    }
    return full;
  }

  /**
   * 读取（并缓存）一张表的列元信息。
   * @param table 物理表名
   */
  private async meta(table: string): Promise<TableMeta> {
    if (this.metaCache.has(table)) return this.metaCache.get(table)!;
    // 从 INFORMATION_SCHEMA 读取列名/主键/数据类型，用于动态构造安全 SQL
    const cols: any[] = await this.dataSource.query(
      `SELECT COLUMN_NAME AS name, DATA_TYPE AS type, COLUMN_KEY AS ckey
         FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?`,
      [table],
    );
    if (!cols.length) throw new BadRequestException(`表 ${table} 不存在`);
    const meta: TableMeta = {
      columns: cols.map((c) => c.name),
      pk: (cols.find((c) => c.ckey === 'PRI') || cols[0]).name,
      hasDeletetime: cols.some((c) => c.name === 'deletetime'),
      columnTypes: Object.fromEntries(cols.map((c) => [c.name, String(c.type).toLowerCase()])),
      textColumns: cols
        .filter((c) =>
          ['varchar', 'char', 'text', 'tinytext', 'mediumtext', 'longtext'].includes(
            String(c.type).toLowerCase(),
          ),
        )
        .map((c) => c.name),
    };
    this.metaCache.set(table, meta);
    return meta;
  }

  /**
   * 列出当前库内所有 kuerp_* 业务表（含中文注释），供前端导航/菜单使用。
   * @returns [{ table, name, comment }]
   */
  async listTables() {
    const rows: any[] = await this.dataSource.query(
      `SELECT TABLE_NAME AS \`table\`, TABLE_COMMENT AS comment
         FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME LIKE 'kuerp\\_%'
        ORDER BY TABLE_NAME`,
    );
    // comment 形如「商品 / 商品资料」时取「/」前主体作为业务名
    return rows.map((r) => {
      const raw = String(r.comment || '').split('/')[0].trim();
      return { table: r.table, name: raw || r.table, comment: r.comment };
    });
  }

  /**
   * 保存单号组合规则（kuerp_prefix，见 3.设置/1.系统参数.md「单号设置」）。
   *
   * 规则字段：prefix 前缀 + 年/月/日/时/分/秒 是否参与编号（'1'=参与，'2'=不参与）
   * + start 起始数 + strlen 自定义数字长度。
   * 保护（与原系统 Sets.php 一致）：该单据已产生数据后，不允许再修改其组合规则，
   * 否则历史单据编号与新规则会冲突。
   * @param rows 规则数组（每项含 id 与上述字段）
   * @returns 更新的规则条数
   */
  async savePrefixRules(rows: Array<Record<string, any>>) {
    if (!Array.isArray(rows) || !rows.length) {
      throw new BadRequestException('缺少规则数据');
    }
    // 物理表白名单（用于校验 dbname，杜绝拼接注入）
    const rawTables = await this.listRawTables();
    const tableSet = new Set(rawTables.map((r: any) => String(r.table)));
    let updated = 0;
    for (const r of rows) {
      const id = Number(r.id);
      if (!id) continue;
      const cur: any[] = await this.dataSource.query(
        `SELECT * FROM \`kuerp_prefix\` WHERE id = ?`,
        [id],
      );
      const row = cur[0];
      if (!row) continue;

      const next = {
        prefix: String(r.prefix ?? row.prefix),
        year: String(r.year ?? row.year),
        month: String(r.month ?? row.month),
        day: String(r.day ?? row.day),
        hour: String(r.hour ?? row.hour),
        minute: String(r.minute ?? row.minute),
        second: String(r.second ?? row.second),
        start: Number(r.start ?? row.start),
        strlen: Number(r.strlen ?? row.strlen),
      };
      // 组合规则是否发生变化
      const changed =
        next.prefix !== String(row.prefix) ||
        next.year !== String(row.year) ||
        next.month !== String(row.month) ||
        next.day !== String(row.day) ||
        next.hour !== String(row.hour) ||
        next.minute !== String(row.minute) ||
        next.second !== String(row.second) ||
        next.start !== Number(row.start) ||
        next.strlen !== Number(row.strlen);
      if (!changed) continue;

      // 已产生数据的单据不可再修改组合规则
      const dbname = String(row.dbname || '');
      if (dbname && /^kuerp_[a-z_]+$/.test(dbname) && tableSet.has(dbname)) {
        const cnt: any[] = await this.dataSource.query(
          `SELECT COUNT(*) AS c FROM \`${dbname}\``,
        );
        if (Number(cnt[0]?.c || 0) > 0) {
          throw new BadRequestException(
            `已产生${row.name || dbname}数据，不可再修改${row.name || dbname}单号组合规则`,
          );
        }
      }
      await this.dataSource.query(
        `UPDATE \`kuerp_prefix\`
            SET prefix = ?, year = ?, month = ?, day = ?, hour = ?, minute = ?, second = ?,
                start = ?, strlen = ?
          WHERE id = ?`,
        [
          next.prefix, next.year, next.month, next.day, next.hour, next.minute, next.second,
          next.start, next.strlen, id,
        ],
      );
      updated++;
    }
    return { updated };
  }

  /**
   * 按「单号设置」规则生成下一个单据编号（等价原系统 Goods::getCodes 管理端口径）。
   *
   * 整体思路（与原系统逐行对齐）：
   *  1. 以 (dbname, field) 定位 kuerp_prefix 规则——同表多编号字段时精确匹配
   *     （如 kuerp_goods_sales 同时有销货单 purchase_code 与零售单 order_code 两条规则）；
   *  2. 序号从规则的 start 起步，按 strlen 左侧补零；
   *  3. 拼接「前缀 + 年/月/日/时/分/秒（规则中 '1' 表示参与）」；
   *  4. 与目标表现有编码查重，已占用则序号 +1 继续尝试（原系统为递归，此处等价改为循环，
   *     因此号段中的空洞会被优先回填，与原系统行为一致）。
   *
   * @param dbname 目标表名（白名单校验，杜绝注入）
   * @param field  编码字段名（须存在于目标表）
   * @returns { code, rule: { id, name, prefix } } 生成的编号与命中的规则摘要
   */
  async genCodeByRule(dbname: string, field: string) {
    // —— 入参白名单：表名与字段名均只允许小写字母/数字/下划线，且表必须真实存在 ——
    if (!/^kuerp_[a-z_]+$/.test(dbname)) {
      throw new BadRequestException('非法表名');
    }
    if (!/^[a-z_][a-z0-9_]*$/.test(field)) {
      throw new BadRequestException('非法字段名');
    }
    const rawTables = await this.listRawTables();
    const tableSet = new Set(rawTables.map((r: any) => String(r.table)));
    if (!tableSet.has(dbname)) {
      throw new BadRequestException(`表 ${dbname} 不存在`);
    }
    const meta = await this.meta(dbname);
    if (!meta.columns.includes(field)) {
      throw new BadRequestException(`表 ${dbname} 无字段 ${field}`);
    }

    // 定位单号规则：优先 field 精确匹配，同 dbname 多规则时取 id 最小者
    const rules: any[] = await this.dataSource.query(
      `SELECT * FROM \`kuerp_prefix\`
        WHERE dbname = ?
        ORDER BY (field = ?) DESC, id ASC
        LIMIT 1`,
      [dbname, field],
    );
    const rule = rules[0];
    if (!rule) {
      throw new BadRequestException(`未配置 ${dbname}.${field} 的单号规则，请先到「单号设置」中维护`);
    }

    const start = Number(rule.start) || 1;
    const strlen = Number(rule.strlen) || 0;

    // 日期段：规则中 '1' 表示该单位参与编号，'2' 表示不参与
    const now = new Date();
    const p2 = (v: number) => String(v).padStart(2, '0');
    const dateParts = [
      String(rule.year) === '1' ? String(now.getFullYear()) : '',
      String(rule.month) === '1' ? p2(now.getMonth() + 1) : '',
      String(rule.day) === '1' ? p2(now.getDate()) : '',
      String(rule.hour) === '1' ? p2(now.getHours()) : '',
      String(rule.minute) === '1' ? p2(now.getMinutes()) : '',
      String(rule.second) === '1' ? p2(now.getSeconds()) : '',
    ].join('');

    // 从 start 起逐序号查重（原系统为递归递增，此处等价改为循环；上限防死循环）
    for (let seq = start; seq < start + 10000; seq++) {
      const code = `${String(rule.prefix || '')}${dateParts}${String(seq).padStart(strlen, '0')}`;
      const dup: any[] = await this.dataSource.query(
        `SELECT \`${meta.pk}\` FROM \`${dbname}\` WHERE \`${field}\` = ? LIMIT 1`,
        [code],
      );
      if (!dup.length) {
        return { code, rule: { id: rule.id, name: rule.name, prefix: rule.prefix } };
      }
    }
    throw new BadRequestException('单号生成失败：序号空间不足，请调整「单号设置」');
  }

  /**
   * 列出全部 kuerp_* 物理表名（不做中文名解析，供初始化等运维操作用）。
   * @returns [{ table }]
   */
  async listRawTables() {
    const rows: any[] = await this.dataSource.query(
      `SELECT TABLE_NAME AS \`table\`
         FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME LIKE 'kuerp\\_%'
        ORDER BY TABLE_NAME`,
    );
    return rows;
  }

  /**
   * 清空一张业务表（TRUNCATE，自增列重置）。
   * 表名经 resolveTable 白名单校验，杜绝注入。
   * @param table 表名
   */
  async truncateTable(table: string) {
    table = this.resolveTable(table);
    await this.dataSource.query(`TRUNCATE TABLE \`${table}\``);
    // 清空表后旧下拉选项必然失效
    this.invalidateOptions();
    return true;
  }

  /**
   * 统计各业务表数据量（数据管理页用）。
   * 逐表 COUNT(*) 精确计数；表数量近百，本地库耗时仍在百毫秒级。
   * @returns [{ table, name, count }]
   */
  async tableStats() {
    const tables = await this.listRawTables();
    const out: Array<{ table: string; name: string; count: number }> = [];
    for (const t of tables) {
      try {
        const rows: any[] = await this.dataSource.query(
          `SELECT COUNT(*) AS c FROM \`${t.table}\``,
        );
        out.push({ table: t.table, name: t.table, count: Number(rows[0]?.c || 0) });
      } catch {
        out.push({ table: t.table, name: t.table, count: -1 }); // -1 表示统计失败
      }
    }
    return out;
  }

  /**
   * 返回一张表的字段元信息（供前端动态渲染列表列与表单）。
   * @param table 表名
   * @returns { pk, columns, dateable }；dateable=false 表示该报表无日期维度，
   *          前端应隐藏日期范围筛选（避免时间戳与非日期列比较导致查空）
   */
  async columns(table: string) {
    // 聚合报表：列元信息来自 agg-reports.ts 的显式声明（JOIN + GROUP BY 虚拟视图）
    if (AGG_REPORTS[table]) {
      const v = AGG_REPORTS[table];
      return {
        table: v.table,
        pk: v.pk,
        columns: v.columns.map((c) => ({ ...c })),
        dateable: v.dateable !== false,
      };
    }
    // 虚拟报表：返回显式声明的列元信息（不走 INFORMATION_SCHEMA）
    if (VIRTUAL_REPORT_COLUMNS[table]) {
      const v = VIRTUAL_REPORT_COLUMNS[table];
      return {
        table: v.table,
        pk: v.pk,
        columns: v.columns,
        dateable: v.columns.some((c: any) => /_time$/.test(String(c.name)) || c.type === 'datetime'),
      };
    }
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    const rows: any[] = await this.dataSource.query(
      `SELECT COLUMN_NAME AS name, DATA_TYPE AS type, IS_NULLABLE AS nullable,
              COLUMN_DEFAULT AS \`default\`, COLUMN_COMMENT AS comment, COLUMN_KEY AS ckey,
              CHARACTER_MAXIMUM_LENGTH AS maxLength
         FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?
        ORDER BY ORDINAL_POSITION`,
      [table],
    );
    return {
      table,
      pk: meta.pk,
      columns: rows.map((c) => ({
        name: c.name,
        type: c.type,
        nullable: c.nullable === 'YES',
        default: c.default,
        comment: String(c.comment || '').split('/')[0].trim(),
        isPk: c.ckey === 'PRI',
        maxLength: c.maxLength,
      })),
      // 有 _time 结尾或 datetime 类型的列即认为可按日期筛选（默认按 createtime）
      dateable: rows.some((c) => /_time$/.test(String(c.name)) || c.type === 'datetime'),
    };
  }

  /**
   * 外键字段 -> 关联表 的实体推断字典。
   * key 为去掉 _id / _code 后缀后的实体词；value 为物理表名（不含 kuerp_ 前缀时自动补）。
   * 仅覆盖原系统高频往来单位 / 主数据，未命中则走下方通用猜测。
   */
  private readonly FK_TABLE: Record<string, string> = {
    supplier: 'kuerp_suppliers',
    suppiler: 'kuerp_suppliers',
    supplyer: 'kuerp_suppliers',
    customer: 'kuerp_customers',
    goods: 'kuerp_goods',
    store: 'kuerp_stores',
    staff: 'kuerp_staff_member',
    goods_type: 'kuerp_goods_type',
    unit: 'kuerp_unit',
    auxiliary: 'kuerp_auxiliary',
    settlement: 'kuerp_settlementtype',
    account: 'kuerp_accounts',
    warehouse: 'kuerp_warehouse',
    driver: 'kuerp_driver',
    expenditure: 'kuerp_expenditure',
    income: 'kuerp_income',
    user: 'kuerp_user',
    enclosure: 'kuerp_enclosure',
    customerlevel: 'kuerp_customerlevel',
    customertype: 'kuerp_customertype',
    supplyertype: 'kuerp_supplyertype',
    expend_type: 'kuerp_expend_type',
    income_type: 'kuerp_income_type',
    payment_account: 'kuerp_payment_account',
    third_account: 'kuerp_third_account',
    customers_user: 'kuerp_customers_user',
    settlementtype: 'kuerp_settlementtype',
  };

  /** 关联表首选标签列（按存在性优选其一），用于下拉显示。 */
  private readonly FK_LABEL_PRIORITY = [
    'name',
    'customer_name',
    'supplyer_name',
    'supplier_name',
    'goods_name',
    'customers_name',
    'title',
    'nickname',
    'username',
  ];

  /**
   * 解析指定表某字段的外键选项（等价原系统 selectpage / getSuppliers 等下拉数据源）。
   * 仅当字段名符合 <实体>_id / <实体>_code 约定且能推断到真实存在的关联表时返回选项，
   * 否则返回空数组（前端据此保留普通输入框，不影响其它功能）。
   *
   * 【缓存】下拉选项是典型的「读多写极少」数据：通用页每次打开筛选面板都会请求，
   * 但档案表一天改不了几次。因此按 `opt:<当前表>:<字段>` 缓存 120 秒；
   * 任意档案表的增删改（add/edit/del/import/truncate）都会调用 invalidateOptions()
   * 清掉全部 `opt:` 前缀，保证「改完商品立刻能在下拉里看到」。
   *
   * @param table 当前表（用于上下文，未来可支持「当前表关联字段」精确映射）
   * @param field 字段名，如 suppliers_id / goods_code / customers_id
   * @returns [{ value, label }]，最多 200 条
   */
  async fieldOptions(table: string, field: string): Promise<any[]> {
    if (!field || !/^[a-z0-9_]+$/i.test(field)) return [];
    // 缓存键带上当前表：同一字段（如 goods_id）在不同表的过滤条件可能不同
    return this.cache.wrap(`opt:${table}:${field}`, 120, () =>
      this.fieldOptionsUncached(table, field),
    );
  }

  /**
   * 下拉选项的真实计算逻辑（未走缓存）。
   *
   * 拆成独立方法而不是在 fieldOptions 里包一层 try：
   * 缓存只应包住「纯读取」，把计算逻辑隔离后，缓存层与业务层各自职责清晰，
   * 将来换 Redis 只需改 fieldOptions，本方法完全不动。
   *
   * @param table 当前表
   * @param field 字段名（已通过合法性校验）
   * @returns [{ value, label }]，最多 200 条
   */
  private async fieldOptionsUncached(table: string, field: string): Promise<any[]> {
    const isCode = /_code$/.test(field);
    const entity = field.replace(/_(id|code)$/i, '').toLowerCase();

    // 1) 字典命中优先
    let refTable = this.FK_TABLE[entity];
    // 2) 字典未命中：将实体词补全为 kuerp_<entity> 并校验真实存在
    if (!refTable) {
      const guess = `kuerp_${entity}`;
      const exists = await this.dataSource
        .query('SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', [
          guess,
        ])
        .then((r: any[]) => r?.length > 0);
      refTable = exists ? guess : '';
    }
    if (!refTable) return [];

    // 校验关联表存在且能取到列元信息
    let refMeta: TableMeta;
    try {
      refMeta = await this.meta(refTable);
    } catch {
      return [];
    }

    // 值列：_id 用主键 id；_code 用同名字段（如 supplyer_code），缺则回退主键
    let valueCol = refMeta.pk;
    if (isCode && refMeta.columns.includes(field)) valueCol = field;
    else if (isCode) {
      const codeCol = refMeta.columns.find((c) => /_code$/.test(c));
      if (codeCol) valueCol = codeCol;
    }
    if (!refMeta.columns.includes(valueCol)) valueCol = refMeta.pk;

    // 标签列：按优先级取第一个存在列
    const labelCol =
      this.FK_LABEL_PRIORITY.find((c) => refMeta.columns.includes(c)) ||
      refMeta.columns.find((c) => !['id', 'createtime', 'updatetime', 'deletetime'].includes(c)) ||
      refMeta.pk;

    const whereSql = refMeta.columns.includes('deletetime')
      ? 'WHERE `deletetime` = 0 OR `deletetime` IS NULL'
      : '';
    const rows: any[] = await this.dataSource.query(
      `SELECT \`${valueCol}\` AS \`value\`, \`${labelCol}\` AS \`label\`
         FROM \`${refTable}\`
         ${whereSql}
        ORDER BY \`${refMeta.pk}\` DESC
        LIMIT 200`,
    );
    // 标签为空时回退为「值」本身，避免空选项
    return rows.map((r) => ({ value: r.value, label: r.label === null || r.label === '' ? r.value : r.label }));
  }

  /**
   * 失效全部下拉选项缓存。
   *
   * 为什么不精确到「哪张表变了」：
   * 一张档案表的变更会影响「其它表引用它」的下拉（改商品名后，销货单的商品下拉也要变），
   * 关联关系需要反查 FK_TABLE 反推，实现复杂且容易漏。
   * 下拉选项本身只有几百条、重建成本是一次轻量 SELECT，
   * 全量失效是最省心且不会出错的策略。
   *
   * @returns 无
   */
  private invalidateOptions(): void {
    this.cache.delByPrefix('opt:');
  }

  /**
   * 写入后失效与本次变更相关的派生缓存。
   *
   * 统一入口而不是在各个 add/edit/del 里各写一遍：
   * 缓存失效点一旦分散就必然漏掉某条写路径，症状是「改了不生效」或更糟的
   * 「撤权后仍能操作」。集中在一处，新增缓存时只需在这里补一行。
   *
   * @param table 刚被写入的物理表名
   * @returns 无
   */
  private touchCaches(table: string): void {
    // 系统参数：税率/批次开关/负库存策略等，业务侧高频读取
    if (table === 'kuerp_sets') this.cache.delByPrefix('set:');
    // 角色与授权关系：权限守卫缓存
    if (
      table === 'kuerp_auth_group' ||
      table === 'kuerp_auth_group_access' ||
      table === 'kuerp_admin'
    ) {
      this.cache.delByPrefix('rbac:');
    }
  }

  /**
   * 校验字段名是否在表元数据内（防止注入）。
   */
  private guardColumn(table: string, meta: TableMeta, col: string): string {
    if (!meta.columns.includes(col)) {
      throw new BadRequestException(`非法字段: ${col}`);
    }
    return col;
  }

  /**
   * 列表 / 检索（等价原系统 index 接口）。
   * @param table 表名
   * @param query 分页 / 搜索 / 过滤 / 排序参数
   * @returns { list, count, page, limit }
   */
  /**
   * 读取某账号的数据权限范围（带 30s 缓存，与 RbacGuard 规则缓存同生命周期）。
   * 取所属全部启用角色中「最严格」的 data_scope：1=全部数据，2=仅本人创建数据；
   * 无任何角色时默认全部(1)。超管(id=1)由调用方跳过，不进入此查询。
   * @param adminId 管理员 ID
   * @returns 数据权限范围（1/2）
   */
  async dataScopeOf(adminId: number): Promise<number> {
    const key = `rbac:ds:${adminId}`;
    const cached = this.cache.get<number>(key);
    if (cached !== undefined && cached !== null) return cached;
    let scope = 1;
    try {
      const rows = await this.dataSource.query(
        `SELECT MIN(g.data_scope) AS scope
           FROM kuerp_auth_group_access a
           JOIN kuerp_auth_group g ON g.id = a.group_id
          WHERE a.admin_id = ? AND g.status = 1`,
        [adminId],
      );
      const v = rows && rows[0] && rows[0].scope;
      if (v !== undefined && v !== null) scope = Number(v);
    } catch {
      scope = 1;
    }
    this.cache.set(key, scope, 30);
    return scope;
  }

  async index(table: string, query: TableQuery) {
    // 聚合报表：走 agg-reports.ts 的 GROUP BY 查询（汇总表/对账单/利润表/收发汇总等）
    if (AGG_REPORTS[table]) return runAggReport(this.dataSource, table, query);
    table = this.resolveTable(table);
    const meta = await this.meta(table);

    // —— 组装 WHERE（软删除 + 关键字 + 精确过滤），全部参数化 ——
    const where: string[] = [];
    const params: any[] = [];
    if (meta.hasDeletetime) {
      // 软删除判定须兼容 NULL：种子数据/部分表的 deletetime 为 NULL，
      // 严格 `= 0` 会把未删除的记录也过滤掉（如权限规则表查出 0 条）。
      where.push('(deletetime = 0 OR deletetime IS NULL)');
    }
    // 数据权限：仅本人数据（dataScope=2 且表含 admin_id 列）。超管与全量权限用户不进入此分支。
    if (query.dataScope === 2 && meta.columns.includes('admin_id')) {
      where.push('`admin_id` = ?');
      params.push(query.userId);
    }
    // 关键字搜索：对所有字符列做 LIKE OR 连接
    const search = query.search ? String(query.search).trim() : '';
    if (search && meta.textColumns.length) {
      const likes = meta.textColumns.map((c) => `\`${c}\` LIKE ?`);
      where.push(`(${likes.join(' OR ')})`);
      meta.textColumns.forEach(() => params.push(`%${search}%`));
    }
    // 精确过滤：filter 支持对象或 JSON 字符串
    let filter: Record<string, any> = {};
    if (query.filter && typeof query.filter === 'string') {
      try {
        filter = JSON.parse(query.filter);
      } catch {
        filter = {};
      }
    } else if (query.filter && typeof query.filter === 'object') {
      filter = query.filter as Record<string, any>;
    }
    Object.entries(filter).forEach(([k, v]) => {
      if (v === undefined || v === null || v === '') return;
      this.guardColumn(table, meta, k);
      where.push(`\`${k}\` = ?`);
      params.push(v);
    });

    // 逐字段模糊筛选：等价原系统列表页筛选栏中「文本输入框」的 LIKE 查询
    // （如客户名称 / 客户手机 各自模糊匹配，而非全局 keyword 搜全部字符列）
    let likeFilter: Record<string, any> = {};
    if (query.like && typeof query.like === 'string') {
      try {
        likeFilter = JSON.parse(query.like);
      } catch {
        likeFilter = {};
      }
    } else if (query.like && typeof query.like === 'object') {
      likeFilter = query.like as Record<string, any>;
    }
    Object.entries(likeFilter).forEach(([k, v]) => {
      if (v === undefined || v === null || v === '') return;
      this.guardColumn(table, meta, k);
      where.push(`\`${k}\` LIKE ?`);
      params.push(`%${v}%`);
    });

    // 日期范围筛选：作用于 dateField（默认 createtime），仅当该列存在于表元数据，
    // 用于报表页按时间区间过滤（原系统报表的起止日期条件等价还原）。
    const dateField =
      query.dateField && meta.columns.includes(query.dateField)
        ? query.dateField
        : 'createtime';
    if (meta.columns.includes(dateField)) {
      if (query.starttime !== undefined && query.starttime !== null) {
        where.push(`\`${dateField}\` >= ?`);
        params.push(Number(query.starttime));
      }
      if (query.endtime !== undefined && query.endtime !== null) {
        where.push(`\`${dateField}\` <= ?`);
        params.push(Number(query.endtime));
      }
    }

    const whereSql = where.length ? ` WHERE ${where.join(' AND ')}` : '';

    // —— 排序：列名必须合法，否则回退主键 ——
    const sortCol =
      query.sort && meta.columns.includes(query.sort) ? query.sort : meta.pk;
    const order = String(query.order).toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

    // —— 分页 ——
    const page = query.page && query.page > 0 ? Number(query.page) : 1;
    const limit = query.limit && query.limit > 0 ? Number(query.limit) : 10;
    const offset =
      query.offset !== undefined && query.offset !== null
        ? Number(query.offset)
        : (page - 1) * limit;

    // 查总数（列名用 * 规避字段白名单，count 不含值参数）
    const countSql = `SELECT COUNT(*) AS c FROM \`${table}\`${whereSql}`;
    const total = await this.dataSource.query(countSql, params);
    const count = Number(total[0]?.c || 0);

    // 查当前页（ORDER BY 列名不可参数化，但已白名单校验）
    const listSql =
      `SELECT * FROM \`${table}\`${whereSql}` +
      ` ORDER BY \`${sortCol}\` ${order} LIMIT ? OFFSET ?`;
    const list = await this.dataSource.query(listSql, [...params, limit, offset]);

    return { list, count, page, limit };
  }

  /**
   * 单条详情（等价原系统按 id 取数据）。
   * @param table 表名
   * @param id 主键值
   */
  async get(table: string, id: number) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    const soft = meta.hasDeletetime ? ' AND (deletetime = 0 OR deletetime IS NULL)' : '';
    const rows = await this.dataSource.query(
      `SELECT * FROM \`${table}\` WHERE \`${meta.pk}\` = ?${soft}`,
      [id],
    );
    return rows[0] || null;
  }

  /**
   * 写入前类型矫正：非字符串列的空串统一「剔除字段」（返回 undefined）。
   * 背景：动态表单里 tinyint/int/decimal/date/enum 等列留空时前端提交 ''，
   * 直接入库会报「Data truncated for column 'status' at row 1」；
   * 而转 NULL 又会撞上 NOT NULL 约束，故直接省略该列，让库默认值生效。
   * @param meta 表元信息（含列类型）
   * @param col 列名
   * @param v 原始值
   * @returns 矫正后的值；undefined 表示该字段应从 SQL 中剔除
   */
  private coerceValue(meta: TableMeta, col: string, v: any): any {
    if (v !== '') return v;
    const t = meta.columnTypes?.[col] || '';
    const isStringType = [
      'varchar', 'char', 'text', 'tinytext', 'mediumtext', 'longtext', 'json', 'set',
    ].includes(t);
    return isStringType ? '' : undefined;
  }

  /**
   * 新增（等价原系统 add）。仅写入表内真实存在的列。
   * @param table 表名
   * @param dto 前端提交的数据
   */
  async add(table: string, dto: Record<string, any>) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);

    // 结账日期全局拦截：单据日期不得 <= 系统结账日期（见 3.设置/3.结账&反结账.md）
    await this.guardCheckoutDate(table, meta, dto);

    // 过滤出合法列，并自动补齐 createtime/updatetime/deletetime
    const data: Record<string, any> = {};
    Object.entries(dto || {}).forEach(([k, v]) => {
      if (!meta.columns.includes(k)) return;
      const c = this.coerceValue(meta, k, v);
      if (c !== undefined) data[k] = c; // 非字符列空串直接剔除，让库默认值生效
    });
    if (meta.columns.includes('createtime')) data.createtime = nowSec();
    if (meta.columns.includes('updatetime')) data.updatetime = nowSec();
    if (meta.hasDeletetime) data.deletetime = 0;

    const cols = Object.keys(data);
    if (!cols.length) throw new BadRequestException('无可写入字段');
    const placeholders = cols.map(() => '?').join(', ');
    const sql =
      `INSERT INTO \`${table}\` (${cols.map((c) => `\`${c}\``).join(', ')})` +
      ` VALUES (${placeholders})`;
    const res: any = await this.dataSource.query(sql, cols.map((c) => data[c]));
    // 新增档案后，其它表引用它的下拉必须重新取数
    this.invalidateOptions();
    this.touchCaches(table);
    return { insertId: res.insertId };
  }

  /**
   * 编辑（等价原系统 edit）。
   * @param table 表名
   * @param id 主键值
   * @param dto 前端提交的数据
   */
  async edit(table: string, id: number, dto: Record<string, any>) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);

    // 结账日期全局拦截：被修改单据的日期若 <= 结账日期则拒绝（已结账单据不可编辑）
    await this.guardCheckoutDate(table, meta, dto, id);
    // 期初余额保护：结账后不允许设置/修改商品、供应商、客户、账户的期初余额
    // （见 3.设置/3.结账&反结账.md 注意事项第 5 条）
    await this.guardOpeningBalance(table, meta, dto);

    // 仅收集合法列；主键不允许被改
    const cols = Object.keys(dto || {}).filter(
      (k) => meta.columns.includes(k) && k !== meta.pk,
    );
    if (meta.columns.includes('updatetime')) {
      if (!cols.includes('updatetime')) cols.push('updatetime');
    }
    // 非字符列的空串直接从 SET 中剔除（updatetime 除外，下面强制补）
    const setCols = cols.filter(
      (c) => c === 'updatetime' || this.coerceValue(meta, c, dto[c]) !== undefined,
    );
    if (!setCols.length) throw new BadRequestException('无可更新字段');

    const setSql = setCols.map((c) => `\`${c}\` = ?`).join(', ');
    const params = setCols.map((c) => (c === 'updatetime' ? nowSec() : this.coerceValue(meta, c, dto[c])));
    params.push(id);
    await this.dataSource.query(
      `UPDATE \`${table}\` SET ${setSql} WHERE \`${meta.pk}\` = ?`,
      params,
    );
    // 改名/改编码后下拉标签会变，必须失效
    this.invalidateOptions();
    this.touchCaches(table);
    return this.get(table, id);
  }

  /**
   * 删除（等价原系统 del）。有 deletetime 列走软删除，否则物理删除。
   * 支持单条（id）与批量（ids 数组）两种形态，与原系统多选删除对齐。
   *
   * 结账守卫（见 3.设置/3.结账&反结账.md「已结账的单据不能再编辑」）：
   * 与原系统一致，仅对「已审核」单据校验结账日期——未审核单据不纳入核算，
   * 允许直接删除（文档明确：结帐前的未审核单据只能做删除操作）。
   * @param table 表名
   * @param id 主键值或主键值数组
   */
  async del(table: string, id: number | number[]) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    const ids = (Array.isArray(id) ? id : [id]).map((v) => Number(v)).filter((v) => !isNaN(v));
    if (!ids.length) throw new BadRequestException('缺少 id');

    // —— 结账守卫：已审核且单据日期 <= 结账日期的记录禁止删除 ——
    await this.guardCheckoutDateForRows(table, meta, ids);
    // —— 已对单（check_status=1）的单据禁止删除（原系统 del 内的约束）——
    if (meta.columns.includes('check_status')) {
      const marks = ids.map(() => '?').join(', ');
      const rows: any[] = await this.dataSource.query(
        `SELECT COUNT(*) AS c FROM \`${table}\` WHERE \`check_status\` = 1 AND \`${meta.pk}\` IN (${marks})`,
        ids,
      );
      if (Number(rows[0]?.c || 0) > 0) {
        throw new BadRequestException('不能删除已对单的数据');
      }
    }

    const marks = ids.map(() => '?').join(', ');
    if (meta.hasDeletetime) {
      // 软删除：deletetime 置为当前时间戳（原系统语义）
      await this.dataSource.query(
        `UPDATE \`${table}\` SET deletetime = ? WHERE \`${meta.pk}\` IN (${marks})`,
        [nowSec(), ...ids],
      );
    } else {
      await this.dataSource.query(
        `DELETE FROM \`${table}\` WHERE \`${meta.pk}\` IN (${marks})`,
        ids,
      );
    }
    // 删除档案后其下拉选项不应再出现
    this.invalidateOptions();
    this.touchCaches(table);
    return true;
  }

  /**
   * 对单 / 反对单（等价原系统 counter）。
   *
   * 用途：单据与实物/银行流水核对后打标，避免重复核对；已对单数据不可删除。
   * 守卫：与删除一致——已审核且单据日期 <= 结账日期的单据不允许（反）对单。
   * @param table 表名
   * @param id 主键值或主键值数组
   * @param counter 1=对单 / 0=反对单
   * @returns 受影响的行数
   */
  /**
   * 对单 / 反对单（等价原系统 GoodsPurchase::counter 等 4 个购销单据控制器）。
   * 语义与原系统完全一致：
   *  - counter=1 对单：仅作用于未对单（check_status=0）的行，置为 1；
   *  - counter=2（或 0）反对单：仅作用于已对单（check_status=1）的行，置为 0；
   *  - 选中单据中任一单据日期 <= 系统结账日期即整体拒绝（原系统逐行 checkOutTime）；
   *  - 同步更新最后操作人 operation_id（原系统写 Session 中的 admin id）。
   * @param table 表名
   * @param id 主键值或主键值数组
   * @param counter 1=对单，0=反对单
   * @param operatorId 操作人 ID（写入 operation_id）
   */
  async counter(table: string, id: number | number[], counter: 0 | 1 = 1, operatorId = 0) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    if (!meta.columns.includes('check_status')) {
      throw new BadRequestException(`表 ${table} 无对单状态字段`);
    }
    const ids = (Array.isArray(id) ? id : [id]).map((v) => Number(v)).filter((v) => !isNaN(v));
    if (!ids.length) throw new BadRequestException('缺少 id');

    // 结账守卫：选中单据中任一单据日期 <= 结账日期即整体拒绝（不要求已审核）
    await this.guardCheckoutDateForRows(table, meta, ids, false);

    const marks = ids.map(() => '?').join(', ');
    // 原系统语义：对单只挑未对单行，反对单只挑已对单行
    const fromStatus = counter === 1 ? '0' : '1';
    const cnt: any[] = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM \`${table}\`
        WHERE \`check_status\` = ? AND \`${meta.pk}\` IN (${marks})`,
      [fromStatus, ...ids],
    );
    if (Number(cnt[0]?.c || 0) === 0) {
      throw new BadRequestException(
        counter === 1 ? '请选择需要对单的数据' : '请选择需要反对单的数据',
      );
    }

    // 更新对单状态 + 最后操作人（表有 operation_id 列时才写）
    const sets = ['`check_status` = ?', '`updatetime` = ?'];
    const params: any[] = [counter === 1 ? '1' : '0', nowSec()];
    if (meta.columns.includes('operation_id')) {
      sets.push('`operation_id` = ?');
      params.push(operatorId || 0);
    }
    await this.dataSource.query(
      `UPDATE \`${table}\` SET ${sets.join(', ')}
        WHERE \`check_status\` = ? AND \`${meta.pk}\` IN (${marks})`,
      [...params, fromStatus, ...ids],
    );
    return { counter: counter === 1 ? 1 : 0 };
  }

  /**
   * 批量校验记录的结账日期守卫（供 del / counter 等批量操作复用）。
   * 规则：单据日期 <= 结账日期的记录被拒绝；requireExamined=true 时仅「已审核」
   * （examine_status=1）记录纳入拦截，未审核单据不纳入核算故放行
   * （与 3.设置/3.结账&反结账.md 一致）；counter 等操作传 false 表示全量拦截。
   * @param table 物理表名
   * @param meta 表元信息
   * @param ids 主键数组
   * @param requireExamined 是否只拦截已审核记录
   */
  private async guardCheckoutDateForRows(
    table: string,
    meta: TableMeta,
    ids: number[],
    requireExamined = true,
  ) {
    const cd = await this.getCheckoutDate();
    if (!cd) return; // 未结账不拦截
    const dateCol = meta.columns.includes('purchase_time')
      ? 'purchase_time'
      : meta.columns.includes('order_time')
        ? 'order_time'
        : null;
    if (!dateCol) return; // 非业务单据表，放行
    const marks = ids.map(() => '?').join(', ');
    const examinedCond = requireExamined ? '`examine_status` = 1 AND ' : '';
    const rows: any[] = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM \`${table}\`
        WHERE ${examinedCond}\`${dateCol}\` <= ? AND \`${meta.pk}\` IN (${marks})`,
      [cd, ...ids],
    );
    if (Number(rows[0]?.c || 0) > 0) {
      throw new BadRequestException(
        '已结账的单据不能再操作（修改/审核/反审核/删除/对单），请先反结账',
      );
    }
  }

  /**
   * 回收站列表（等价原系统 recyclebin）：仅列软删除记录。
   * @param table 表名
   * @param query 分页 / 搜索参数
   */
  async recyclebin(table: string, query: TableQuery) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    if (!meta.hasDeletetime) {
      // 无软删除列的表不存在回收站，直接返回空列表
      return { list: [], count: 0, page: 1, limit: query.limit || 10 };
    }

    const where: string[] = ['deletetime != 0'];
    const params: any[] = [];
    const search = query.search ? String(query.search).trim() : '';
    if (search && meta.textColumns.length) {
      const likes = meta.textColumns.map((c) => `\`${c}\` LIKE ?`);
      where.push(`(${likes.join(' OR ')})`);
      meta.textColumns.forEach(() => params.push(`%${search}%`));
    }

    const page = query.page && query.page > 0 ? Number(query.page) : 1;
    const limit = query.limit && query.limit > 0 ? Number(query.limit) : 10;
    const offset =
      query.offset !== undefined && query.offset !== null
        ? Number(query.offset)
        : (page - 1) * limit;

    const total = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM \`${table}\` WHERE ${where.join(' AND ')}`,
      params,
    );
    const list = await this.dataSource.query(
      `SELECT * FROM \`${table}\` WHERE ${where.join(' AND ')}` +
        ` ORDER BY \`${meta.pk}\` DESC LIMIT ? OFFSET ?`,
      [...params, limit, offset],
    );
    return { list, count: Number(total[0]?.c || 0), page, limit };
  }

  /**
   * 还原（等价原系统 reduction）：deletetime 置 0，记录回到正常列表。
   * @param table 表名
   * @param id 主键值或主键值数组
   */
  async reduction(table: string, id: number | number[]) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    if (!meta.hasDeletetime) throw new BadRequestException('该表无回收站');
    const ids = (Array.isArray(id) ? id : [id]).map((v) => Number(v)).filter((v) => !isNaN(v));
    if (!ids.length) throw new BadRequestException('缺少 id');
    const marks = ids.map(() => '?').join(', ');
    await this.dataSource.query(
      `UPDATE \`${table}\` SET deletetime = 0 WHERE \`${meta.pk}\` IN (${marks})`,
      ids,
    );
    // 还原后该档案应重新出现在下拉选项中
    this.invalidateOptions();
    return true;
  }

  /**
   * 真实删除（等价原系统 realdel）：物理删除，不可恢复。
   * @param table 表名
   * @param id 主键值或主键值数组
   */
  async realdel(table: string, id: number | number[]) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    const ids = (Array.isArray(id) ? id : [id]).map((v) => Number(v)).filter((v) => !isNaN(v));
    if (!ids.length) throw new BadRequestException('缺少 id');
    const marks = ids.map(() => '?').join(', ');
    await this.dataSource.query(
      `DELETE FROM \`${table}\` WHERE \`${meta.pk}\` IN (${marks})`,
      ids,
    );
    this.invalidateOptions();
    return true;
  }

  /**
   * 批量导入（等价原系统 import）：一次性插入多行。
   * 仅写入表内真实存在的列，非法字段自动忽略；自动补齐时间戳字段。
   * @param table 表名
   * @param rows 数据行数组（JSON）
   * @returns { inserted: 成功行数 }
   */
  async import(table: string, rows: Record<string, any>[]) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    if (!Array.isArray(rows) || !rows.length) {
      throw new BadRequestException('无可导入数据');
    }
    let inserted = 0;
    // 逐行插入：与单条 add 保持同一套字段过滤/时间戳逻辑，行为可预期
    for (const row of rows) {
      await this.add(table, row);
      inserted++;
    }
    return { inserted };
  }

  /**
   * 审核（等价原系统 examine）。更新单据审核状态字段，
   * 字段名按 examine_status / examine / status 优先探测，未命中则跳过。
   *
   * 业务过账联动（见 PostingService）：对购货/销货/退货/其他入出库/调拨/成本调整/盘点
   * 等库存类单据，审核(status=1)时过账到库存+收发明细+移动平均成本，反审(status=0)时冲转。
   * 过账在翻转状态之前执行：审核时单据尚未标记已审，反审时仍标记已审，正好满足过账/冲转前置条件。
   * @param table 表名
   * @param id 主键值
   * @param status 审核状态（0=反审, 1=已审）
   */
  async examine(table: string, id: number, status = 1) {
    table = this.resolveTable(table);
    const meta = await this.meta(table);
    const statusCol =
      ['examine_status', 'examine', 'status'].find((c) =>
        meta.columns.includes(c),
      ) || null;
    if (!statusCol) {
      throw new BadRequestException(`表 ${table} 无审核状态字段`);
    }
    // —— 结账守卫：单据日期 <= 结账日期的单据不允许审核/反审 ——
    // （见 3.设置/3.结账&反结账.md「已结账的单据不能再编辑，如修改、审核、反审核」）
    await this.guardCheckoutDateForRows(table, meta, [id]);
    // —— 业务过账：库存类单据审核/反审时联动库存与资金（失败则阻断审核，如库存不足）——
    // 顺序：审核先过库存再过资金；反审先冲转资金再冲转库存。
    if (status === 1) {
      if (this.posting.isDocTable(table)) {
        await this.posting.post(table, id);
      }
      if (this.funds.isFundTable(table) || this.funds.isStockFundTable(table)) {
        await this.funds.post(table, id);
      }
    } else {
      if (this.funds.isFundTable(table) || this.funds.isStockFundTable(table)) {
        await this.funds.unpost(table, id);
      }
      if (this.posting.isDocTable(table)) {
        await this.posting.unpost(table, id);
      }
    }
    // —— 翻转审核状态，同时记录审核时间（若表有该列）——
    const sets: string[] = [`\`${statusCol}\` = ?`];
    const params: any[] = [status];
    if (meta.columns.includes('examine_time')) {
      sets.push('`examine_time` = ?');
      params.push(status === 1 ? nowSec() : null);
    }
    params.push(id);
    await this.dataSource.query(
      `UPDATE \`${table}\` SET ${sets.join(', ')} WHERE \`${meta.pk}\` = ?`,
      params,
    );
    return this.get(table, id);
  }

  /**
   * 结账日期全局拦截（见 开发文档/3.设置/3.结账&反结账.md）。
   * 规则：任何带单据日期列（purchase_time / order_time）的业务单据，
   * 新增或编辑时其单据日期不得 <= 系统结账日期（checkout.checktime）。
   * @param table 物理表名
   * @param meta 表元信息
   * @param dto 提交数据（取其中的单据日期）
   * @param id 编辑时的主键值（用于加载原单据日期做比较）
   */
  private async guardCheckoutDate(
    table: string,
    meta: TableMeta,
    dto: Record<string, any>,
    id?: number,
  ) {
    const cd = await this.getCheckoutDate();
    if (!cd) return; // 未结账则不拦截
    const dateCol = meta.columns.includes('purchase_time')
      ? 'purchase_time'
      : meta.columns.includes('order_time')
        ? 'order_time'
        : null;
    if (!dateCol) return; // 非业务单据表，放行
    // 编辑时以原记录日期为准（避免仅靠未提交的日期字段绕过）
    let docDate = dto && dto[dateCol] !== undefined ? Number(dto[dateCol]) : NaN;
    if (id && (isNaN(docDate) || docDate === 0)) {
      const ex = await this.get(table, Number(id));
      if (ex && ex[dateCol] !== undefined) docDate = Number(ex[dateCol]);
    }
    if (!isNaN(docDate) && docDate > 0 && docDate <= cd) {
      throw new BadRequestException('单据日期不能小于或等于系统结账日期，请先反结账');
    }
  }

  /**
   * 期初余额保护（见 3.设置/3.结账&反结账.md 注意事项第 5 条）：
   * 「进销存账套结账后，不支持设置、修改商品、供应商、客户、账户的期初余额」。
   * 已结账时，若提交数据里包含这些表的期初类字段则直接拒绝。
   * @param table 物理表名
   * @param meta 表元信息
   * @param dto 提交数据
   */
  private async guardOpeningBalance(table: string, meta: TableMeta, dto: Record<string, any>) {
    // 各表的期初类字段（与原系统字段一一对应）
    const OPENING_COLS: Record<string, string[]> = {
      kuerp_goods: ['period', 'price', 'unit_cost', 'period_status'],
      kuerp_suppliers: ['receive_account', 'opening_payable', 'opening_prepayment'],
      kuerp_customers: ['receive_account', 'opening_prepayment'],
      kuerp_accounts: ['start_account_balance', 'start_account_time'],
    };
    const cols = OPENING_COLS[table];
    if (!cols || !cols.length) return;
    const hit = cols.find((c) => meta.columns.includes(c) && dto && dto[c] !== undefined);
    if (!hit) return;
    const cd = await this.getCheckoutDate();
    if (cd > 0) {
      throw new BadRequestException('已结账，不支持设置/修改期初余额，请先反结账');
    }
  }

  /**
   * 读取当前系统结账日期（秒级时间戳），未结账返回 0。
   * @returns 结账日期时间戳（秒）或 0
   */
  async getCheckoutDate(): Promise<number> {
    try {
      const rows: any[] = await this.dataSource.query(
        `SELECT checktime FROM \`kuerp_checkout\` ORDER BY id DESC LIMIT 1`,
      );
      const t = Number(rows[0]?.checktime || 0);
      return t > 0 ? t : 0;
    } catch {
      return 0; // 表不存在等异常时视为未结账
    }
  }

  /**
   * 读取系统启用日期（kuerp_sets.enable_time，'YYYY-MM-DD'）的秒级时间戳，未取到返回 0。
   * @returns 启用日期时间戳（秒）或 0
   */
  private async getEnableTime(): Promise<number> {
    try {
      const rows: any[] = await this.dataSource.query(
        `SELECT value FROM \`kuerp_sets\` WHERE name = 'enable_time' LIMIT 1`,
      );
      const v = String(rows[0]?.value || '').trim();
      if (!/^\d{4}-\d{2}-\d{2}/.test(v)) return 0;
      // 启用日当天 00:00:00（原系统 strtotime('Y-m-d') 语义）
      return Math.floor(new Date(`${v.slice(0, 10)}T00:00:00`).getTime() / 1000);
    } catch {
      return 0;
    }
  }

  /**
   * 查询是否存在负库存商品（用于结账前拦截）。
   * 口径：kuerp_goods_stock.stock < 0（分仓核算下的任一仓负库存即拦截）。
   * @returns 负库存商品概要列表（最多 5 条，供错误信息展示）
   */
  private async findNegativeStock(): Promise<{ goods_code: string; stock: number }[]> {
    try {
      const rows: any[] = await this.dataSource.query(
        `SELECT g.goods_code AS goods_code, s.stock AS stock
           FROM \`kuerp_goods_stock\` s
           LEFT JOIN \`kuerp_goods\` g ON g.id = s.goods_id
          WHERE s.stock < 0
          ORDER BY s.stock ASC
          LIMIT 5`,
      );
      return rows.map((r) => ({ goods_code: String(r.goods_code || ''), stock: Number(r.stock) || 0 }));
    } catch {
      return []; // 表缺失等异常时不阻断结账
    }
  }

  /**
   * 结账：归档当前账期，固定结账日期（见 3.设置/3.结账&反结账.md）。
   *
   * 前置校验（均来自原系统 Checkout::checkout 与文档注意事项）：
   *   1. 结账日期不能小于系统启用日期（kuerp_sets.enable_time）；
   *   2. 结账日期不能小于等于上次结账日期；
   *   3. 商品为负库存时不允许结账；
   *   4. 结账日期不得早于当前已过账单据覆盖到的时间（由调用方保证，未审核单据不纳入核算）。
   *
   * 归档动作：
   *   - kuerp_checkout 写入当前账期（先清空再插入，保证只有一条当前结账记录）；
   *   - kuerp_checkout_info 写入商品成本快照（结账截止时刻各商品的剩余数量/成本），
   *     供下次结账延续成本计算（原系统 checkOutGoodss 口径）。
   * @param endDate 结账截止日期（'YYYY-MM-DD'）
   * @returns 写入的结账记录
   */
  async settleCheckout(endDate: string, operatorId = 0) {
    if (!endDate || !/^\d{4}-\d{2}-\d{2}$/.test(endDate)) {
      throw new BadRequestException('结账日期格式应为 YYYY-MM-DD');
    }
    // 截止日 23:59:59（秒级）
    const endSec = Math.floor(new Date(`${endDate}T23:59:59`).getTime() / 1000);

    // —— 校验 1：结账日期不得早于系统启用日期 ——
    const enableTime = await this.getEnableTime();
    if (enableTime > 0 && endSec < enableTime) {
      throw new BadRequestException(
        `结账日期不能小于系统启用日期：${new Date(enableTime * 1000).toISOString().slice(0, 10)}`,
      );
    }

    // —— 校验 2：结账日期必须大于上次结账日期 ——
    const lastTime = await this.getCheckoutDate();
    if (lastTime > 0 && endSec <= lastTime) {
      const rows: any[] = await this.dataSource.query(
        `SELECT checkdate FROM \`kuerp_checkout\` ORDER BY id DESC LIMIT 1`,
      );
      throw new BadRequestException(
        `结账日期不能小于等于上次结账日期：${String(rows[0]?.checkdate || '')}`,
      );
    }

    // —— 校验 3：负库存不允许结账 ——
    const negative = await this.findNegativeStock();
    if (negative.length) {
      const detail = negative.map((r) => `${r.goods_code}(${r.stock})`).join('、');
      throw new BadRequestException(`存在负库存商品，不允许结账：${detail}`);
    }

    // —— 写入结账主记录（单行）——
    await this.dataSource.query(`DELETE FROM \`kuerp_checkout\``);
    const res: any = await this.dataSource.query(
      `INSERT INTO \`kuerp_checkout\`
        (checkdate, checktime, preparation_id, preparation_time, createtime, updatetime)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [endDate, endSec, operatorId, nowSec(), nowSec(), nowSec()],
    );
    const checkoutId = Number(res?.insertId || 0);

    // —— 归档商品成本快照到 kuerp_checkout_info ——
    // 口径：以结账截止时间为界，取每个商品「最后一条购货明细」及其剩余数量/成本；
    // 移动平均列（av_*）与明细列同值（本系统 PostingService 统一按移动平均维护成本）。
    const snapshot = await this.buildCheckoutSnapshot(endSec);
    if (checkoutId > 0 && snapshot.length) {
      for (const s of snapshot) {
        await this.dataSource.query(
          `INSERT INTO \`kuerp_checkout_info\`
            (checkout_id, goods_id, goods_code, basic_nmber, all_money,
             purchase_id, purchase_time, av_basic_nmber, av_all_money)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [
            checkoutId, s.goods_id, s.goods_code, s.basic_nmber, s.all_money,
            s.purchase_id, s.purchase_time, s.basic_nmber, s.all_money,
          ],
        );
      }
    }
    return { checkdate: endDate, checktime: endSec, archived: snapshot.length };
  }

  /**
   * 构建结账商品成本快照（写入 kuerp_checkout_info 的数据源）。
   *
   * 思路：对每个商品，取其 purchase_time <= 结账截止时间的「最后一条购货明细」，
   * 以该明细的数量/金额作为结账时点的剩余数量与成本锚点。
   * 与原系统 checkOutGoodss 的差异：原系统会重算 FIFO/移动平均的完整批次链，
   * 本系统由 PostingService 在过账时已维护好 goods_stock 的移动平均成本，
   * 故此处直接锚定最后一条购货明细，避免二次重算造成口径分叉。
   * @param endSec 结账截止时间（秒）
   */
  private async buildCheckoutSnapshot(endSec: number) {
    const rows: any[] = await this.dataSource.query(
      `SELECT pi.id AS purchase_id, pi.purchase_time AS purchase_time,
              pi.goods_id AS goods_id, pi.goods_code AS goods_code,
              pi.basic_nmber AS basic_nmber, pi.all_money AS all_money
         FROM \`kuerp_goods_purchase_info\` pi
         JOIN (SELECT goods_code, MAX(purchase_time) AS max_time
                 FROM \`kuerp_goods_purchase_info\`
                WHERE purchase_time <= ?
                GROUP BY goods_code) t
           ON t.goods_code = pi.goods_code AND t.max_time = pi.purchase_time
        WHERE pi.purchase_time <= ?
        ORDER BY pi.goods_code ASC, pi.id DESC`,
      [endSec, endSec],
    );
    // 同一商品同一时间可能有多条明细，仅保留 id 最大的一条作为锚点
    const seen = new Set<string>();
    const out: any[] = [];
    for (const r of rows) {
      const key = String(r.goods_code);
      if (seen.has(key)) continue;
      seen.add(key);
      out.push({
        purchase_id: Number(r.purchase_id) || 0,
        purchase_time: Number(r.purchase_time) || 0,
        goods_id: Number(r.goods_id) || 0,
        goods_code: key,
        basic_nmber: Number(r.basic_nmber) || 0,
        all_money: Number(r.all_money) || 0,
      });
    }
    return out;
  }

  /**
   * 反结账：清除结账记录及其归档明细，允许修改结账日期前的单据。
   * 与原系统 Checkout::checkoutf 一致：同时删除 kuerp_checkout 与 kuerp_checkout_info。
   */
  async unsettleCheckout() {
    await this.dataSource.query(`DELETE FROM \`kuerp_checkout\``);
    await this.dataSource.query(`DELETE FROM \`kuerp_checkout_info\``);
    return { unsettled: true };
  }

  /**
   * 数据面板（工作台）核心指标聚合：购货 / 销货 / 仓库 / 资金 四大模块。
   * 各指标独立 try/catch，单指标失败不影响整体返回（返回 0）。
   * @returns 四模块核心统计
   */
  async dashboardStats() {
    const safe = async (sql: string, params: any[] = []): Promise<number> => {
      try {
        const r: any[] = await this.dataSource.query(sql, params);
        return Number(r[0]?.v || r[0]?.c || 0);
      } catch {
        return 0;
      }
    };
    const [goodsCount, customerCount, supplierCount, warningCount, purchaseCount, purchaseAmount, salesCount, salesAmount, stockKinds, stockValue, receivable, payable, accountBalance] = await Promise.all([
      safe(`SELECT COUNT(*) AS c FROM \`kuerp_goods\` WHERE deletetime = 0`),
      safe(`SELECT COUNT(*) AS c FROM \`kuerp_customers\``),
      safe(`SELECT COUNT(*) AS c FROM \`kuerp_suppliers\``),
      // 库存预警数：实时计算（开启预警 且 当前库存越界），与虚拟报表 goods-stock-warning 口径一致
      safe(`SELECT COUNT(*) AS c FROM \`kuerp_goods_stock\` WHERE stock_warning = '1' AND deletetime IS NULL AND (stock < min_stock OR (max_stock > 0 AND stock > max_stock))`),
      safe(`SELECT COUNT(*) AS c FROM \`kuerp_goods_purchase\` WHERE deletetime = 0`),
      safe(`SELECT SUM(all_money) AS v FROM \`kuerp_goods_purchase\` WHERE deletetime = 0 AND examine_status = '1'`),
      safe(`SELECT COUNT(*) AS c FROM \`kuerp_goods_sales\` WHERE deletetime = 0`),
      safe(`SELECT SUM(all_money) AS v FROM \`kuerp_goods_sales\` WHERE deletetime = 0 AND examine_status = '1'`),
      safe(`SELECT COUNT(*) AS c FROM \`kuerp_goods\` WHERE deletetime = 0 AND inventory > 0`),
      safe(`SELECT SUM(inventory * unit_cost) AS v FROM \`kuerp_goods\` WHERE deletetime = 0`),
      safe(`SELECT SUM(arrears) AS v FROM \`kuerp_accounts_receivable\``),
      safe(`SELECT SUM(arrears) AS v FROM \`kuerp_accounts_copewith\``),
      safe(`SELECT SUM(balance) AS v FROM \`kuerp_accounts\``),
    ]);
    return {
      goods: { count: goodsCount, warning: warningCount },
      customers: { count: customerCount },
      suppliers: { count: supplierCount },
      purchase: { count: purchaseCount, amount: purchaseAmount },
      sales: { count: salesCount, amount: salesAmount },
      warehouse: { kinds: stockKinds, totalValue: stockValue },
      capital: { receivable, payable, accountBalance },
    };
  }
}
