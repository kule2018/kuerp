import { BadRequestException, ForbiddenException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TableService } from '../table/table.service';
import { MessageService } from '../../common/message/message.service';

/** 当前登录用户（JwtStrategy 填充的最小信息） */
export interface ApprovalUser {
  id: number;
  username?: string;
  nickname?: string;
}

/** 一条审批流配置（对应 kuerp_approval_flow 一行） */
interface FlowRow {
  id: number;
  doc_table: string;
  level: number;
  role_id: number;
  min_amount: string | number;
  max_amount: string | number;
  status: string | number;
  note: string;
}

/** 一条审批流转记录（对应 kuerp_approval_log 一行） */
interface LogRow {
  id: number;
  doc_table: string;
  doc_id: number;
  doc_code: string;
  level: number;
  total_level: number;
  approver_id: number;
  approver_name: string;
  result: string;
  remark: string;
  createtime: number | string;
  updatetime: number | string;
}

/**
 * 多级审批流服务。
 *
 * 【整体思路】
 * 原系统的「审核」是单级：点一下 examine 就从「未审」变「已审」并过账。
 * 本服务在它与业务单据之间插入一层**可配置的多级审批**，但不改动原有审核链路：
 *
 *   提交审批 → 逐级通过 → 最后一级通过时**回调 TableService.examine(docTable, docId, 1)**
 *
 * 这样做的三个好处：
 * 1) 过账逻辑（库存/资金/批次/序列号）完全复用既有引擎，不重复实现，不会出现口径分叉；
 * 2) 未配置审批流的单据（kuerp_approval_flow 里查不到）走原路径，行为与升级前完全一致；
 * 3) 驳回只需把最后一条 pending 记录标 reject，单据本身不动，不会产生半过账的脏数据。
 *
 * 审批级数由「单据金额」动态决定：遍历启用的配置，取 min_amount <= 金额 <= max_amount
 * （max_amount = 0 视为不限上限）的那些行，按 level 升序即为本次需要的审批链。
 */
@Injectable()
export class ApprovalService {
  private readonly logger = new Logger(ApprovalService.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly tableService: TableService,
    private readonly messages: MessageService,
  ) {}

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /**
   * 归一化单据表名（允许传 goods-sales-order / goods_sales_order / kuerp_goods_sales_order）。
   * @param docTable 调用方传入的表名
   * @returns 不含 kuerp_ 前缀、下划线形式的标准表名
   */
  private normTable(docTable: string): string {
    const t = String(docTable || '')
      .trim()
      .replace(/-/g, '_')
      .replace(/^kuerp_/, '');
    if (!/^[a-z0-9_]+$/i.test(t)) throw new BadRequestException('非法单据表名');
    return t;
  }

  /**
   * 读取某单据类型下全部启用中的审批流配置。
   * @param docTable 标准表名（不含前缀）
   * @returns 按 level 升序的配置行
   */
  private async loadFlows(docTable: string): Promise<FlowRow[]> {
    try {
      const rows = await this.dataSource.query(
        `SELECT * FROM kuerp_approval_flow
          WHERE doc_table = ? AND status = 1 AND (deletetime IS NULL OR deletetime = 0)
          ORDER BY level ASC, id ASC`,
        [docTable],
      );
      return rows || [];
    } catch (e: any) {
      // 兼容尚未执行 extension-schema.sql 的旧库：表缺失时视为「无审批流」，走原单级审核
      if (String(e?.code || '') === 'ER_NO_SUCH_TABLE') return [];
      throw e;
    }
  }

  /**
   * 按金额筛选出本次实际生效的审批级次。
   *
   * 同一 level 若有多行命中（例如配了两条不同角色的一级审批），只保留第一条，
   * 避免出现「一级要过两次」这种无法解释的状态。
   *
   * @param flows 已按 level 升序的配置
   * @param amount 单据金额（取价税合计/优惠后金额，见 pickAmount）
   * @returns 去重后的生效配置
   */
  private matchLevels(flows: FlowRow[], amount: number): FlowRow[] {
    const hit = flows.filter((f) => {
      const min = Number(f.min_amount) || 0;
      const max = Number(f.max_amount) || 0;
      if (amount < min) return false;
      if (max > 0 && amount > max) return false;
      return true;
    });
    const seen = new Set<number>();
    const out: FlowRow[] = [];
    for (const f of hit) {
      const lv = Number(f.level) || 1;
      if (seen.has(lv)) continue;
      seen.add(lv);
      out.push(f);
    }
    // 级次必须从 1 开始连续，否则「通过第 1 级后就没有第 2 级」会卡住单据
    return out.map((f, i) => ({ ...f, level: i + 1 }));
  }

  /**
   * 从单据行里挑出用于判定金额的列。
   *
   * 优先级：价税合计 > 优惠后金额 > 单据金额 > 已收/付金额。
   * 之所以先取价税合计：含税业务的审批门槛通常按含税口径谈，
   * 原系统列表页展示的「单据金额」在有税时也是价税合计。
   *
   * @param row 单据主表行
   * @returns 金额（取不到返回 0）
   */
  private pickAmount(row: Record<string, any>): number {
    const keys = ['money_tax_price', 'real_money', 'all_money', 'total_money', 'money', 'pay_money'];
    for (const k of keys) {
      const v = row?.[k];
      if (v !== undefined && v !== null && v !== '') {
        const n = Number(v);
        if (!Number.isNaN(n)) return n;
      }
    }
    return 0;
  }

  /**
   * 读取单据主表的一行（表名已白名单校验，此处仅按主键取）。
   * @param docTable 标准表名（不含前缀）
   * @param docId 主键
   * @returns 单据行
   */
  private async loadDoc(docTable: string, docId: number): Promise<Record<string, any>> {
    const rows = await this.dataSource.query(
      `SELECT * FROM \`kuerp_${docTable}\` WHERE id = ? LIMIT 1`,
      [docId],
    );
    if (!rows?.length) throw new NotFoundException('单据不存在');
    return rows[0];
  }

  /**
   * 取用户所属的角色组 ID 列表。
   * @param adminId 管理员ID
   * @returns 角色组ID数组（无则空数组）
   */
  private async groupIdsOf(adminId: number): Promise<number[]> {
    try {
      const rows = await this.dataSource.query(
        'SELECT group_id FROM kuerp_auth_group_access WHERE admin_id = ?',
        [adminId],
      );
      return (rows || []).map((r: any) => Number(r.group_id)).filter(Boolean);
    } catch (e: any) {
      if (String(e?.code || '') === 'ER_NO_SUCH_TABLE') return [];
      throw e;
    }
  }

  /**
   * 判断用户能否审批指定级次。
   *
   * 规则：配置里 role_id = 0 表示「不限角色」（任何有登录权限的人都能审）；
   * 否则用户必须属于该角色组。超级管理员（id=1）恒通过，与原系统超管免检一致。
   *
   * @param flow 该级次配置
   * @param user 当前用户
   * @returns 是否可审
   */
  private async canApprove(flow: FlowRow, user: ApprovalUser): Promise<boolean> {
    if (Number(user.id) === 1) return true;
    const roleId = Number(flow.role_id) || 0;
    if (!roleId) return true;
    const groups = await this.groupIdsOf(Number(user.id));
    return groups.includes(roleId);
  }

  /**
   * 查询某单据当前的审批链（含每一级的处理状态），供前端画进度条。
   * @param docTable 单据表名
   * @param docId 单据ID
   * @returns { total, current, logs }
   */
  async status(docTable: string, docId: number) {
    const table = this.normTable(docTable);
    const logs = await this.logs(table, docId);
    const total = logs.length ? Number(logs[0].total_level) || logs.length : 0;
    const pending = logs.find((l) => l.result === 'pending');
    const rejected = logs.find((l) => l.result === 'reject');
    return {
      total,
      done: logs.filter((l) => l.result === 'pass').length,
      current: pending ? Number(pending.level) : 0,
      state: rejected ? 'reject' : pending ? 'pending' : total ? 'pass' : 'none',
      logs,
    };
  }

  /**
   * 读取某单据的全部流转记录（按级次升序）。
   * @param docTable 标准表名
   * @param docId 单据ID
   * @returns 记录数组
   */
  private async logs(docTable: string, docId: number): Promise<LogRow[]> {
    try {
      const rows = await this.dataSource.query(
        `SELECT * FROM kuerp_approval_log
          WHERE doc_table = ? AND doc_id = ?
          ORDER BY level ASC, id ASC`,
        [docTable, docId],
      );
      return rows || [];
    } catch (e: any) {
      if (String(e?.code || '') === 'ER_NO_SUCH_TABLE') return [];
      throw e;
    }
  }

  /**
   * 提交审批：按金额生成审批链，落第一条待审记录，并给审批人发消息。
   *
   * 若该单据类型未配置审批流，返回 { needApproval: false }，
   * 前端据此提示「可直接审核」，随后走原有 examine 接口。
   *
   * @param docTable 单据表名
   * @param docId 单据ID
   * @param user 提交人
   * @returns 审批状态
   */
  async submit(docTable: string, docId: number, user: ApprovalUser) {
    const table = this.normTable(docTable);
    const doc = await this.loadDoc(table, docId);
    if (String(doc.examine_status ?? '0') === '1') {
      throw new BadRequestException('单据已审核，无需再提交审批');
    }

    const flows = await this.loadFlows(table);
    if (!flows.length) return { needApproval: false, ...(await this.status(table, docId)) };

    const amount = this.pickAmount(doc);
    const levels = this.matchLevels(flows, amount);
    if (!levels.length) return { needApproval: false, ...(await this.status(table, docId)) };

    // 已有未完成的审批链：不重复提交，直接返回现状（幂等，避免用户连点生成多条 pending）
    const exist = await this.logs(table, docId);
    if (exist.some((l) => l.result === 'pending')) {
      return { needApproval: true, ...(await this.status(table, docId)) };
    }

    const code = String(doc.purchase_code || doc.code || doc.order_code || docId);
    const ts = this.now();
    await this.dataSource.query(
      `INSERT INTO kuerp_approval_log
         (doc_table, doc_id, doc_code, level, total_level, approver_id, approver_name, result, remark, createtime, updatetime)
       VALUES (?,?,?,?,?,0,'','pending','', ?, ?)`,
      [table, docId, code, 1, levels.length, ts, ts],
    );

    await this.notifyApprovers(table, docId, code, levels[0], levels.length, user);
    return { needApproval: true, ...(await this.status(table, docId)) };
  }

  /**
   * 给某一级的审批人发待办消息。
   *
   * role_id = 0（不限角色）时广播给全员，避免配置疏漏导致待办无人可见。
   *
   * @param docTable 表名
   * @param docId 单据ID
   * @param code 单据编号
   * @param flow 该级配置
   * @param totalLevel 总级数
   * @param from 提交人
   */
  private async notifyApprovers(
    docTable: string,
    docId: number,
    code: string,
    flow: FlowRow,
    totalLevel: number,
    from: ApprovalUser,
  ): Promise<void> {
    const roleId = Number(flow.role_id) || 0;
    let targets: number[] = [0];
    if (roleId) {
      try {
        const rows = await this.dataSource.query(
          'SELECT admin_id FROM kuerp_auth_group_access WHERE group_id = ?',
          [roleId],
        );
        const ids = (rows || []).map((r: any) => Number(r.admin_id)).filter(Boolean);
        if (ids.length) targets = ids;
      } catch {
        // 角色表缺失时退化为广播，不阻断审批流
      }
    }
    const who = from.username || from.nickname || `#${from.id}`;
    await this.messages.createMany(
      targets.map((id) => ({
        toAdminId: id,
        type: 'approval',
        level: 'warn' as const,
        title: `待审批：${code}（第 ${flow.level}/${totalLevel} 级）`,
        content: `${who} 提交了 ${docTable} 单据 ${code}，等待你审批。${flow.note ? '说明：' + flow.note : ''}`,
        link: '/system/approval-todo',
        refTable: docTable,
        refId: docId,
      })),
    );
  }

  /**
   * 审批通过。
   *
   * 关键点：**只有最后一级通过才触发过账**。中间级通过只推进指针，
   * 否则会出现「一级通过就动库存、后面被驳回」的资金/库存错账。
   *
   * @param docTable 单据表名
   * @param docId 单据ID
   * @param user 审批人
   * @param remark 审批意见
   * @returns 审批状态 + 是否已过账
   */
  async approve(docTable: string, docId: number, user: ApprovalUser, remark = '') {
    const table = this.normTable(docTable);
    const logs = await this.logs(table, docId);
    const pending = logs.find((l) => l.result === 'pending');
    if (!pending) throw new BadRequestException('没有待审批的记录');

    const level = Number(pending.level) || 1;
    const total = Number(pending.total_level) || 1;

    const flows = await this.loadFlows(table);
    const doc = await this.loadDoc(table, docId);
    const levels = this.matchLevels(flows, this.pickAmount(doc));
    const flow = levels.find((f) => f.level === level) || ({ role_id: 0, note: '', level } as FlowRow);

    if (!(await this.canApprove(flow, user))) {
      throw new ForbiddenException('你没有该级次的审批权限');
    }

    const ts = this.now();
    await this.dataSource.query(
      `UPDATE kuerp_approval_log
          SET result='pass', approver_id=?, approver_name=?, remark=?, updatetime=?
        WHERE id = ?`,
      [user.id, user.username || '', String(remark || '').slice(0, 500), ts, pending.id],
    );

    // 还有下一级：先立一条新的 pending，再发待办消息
    if (level < total) {
      await this.dataSource.query(
        `INSERT INTO kuerp_approval_log
           (doc_table, doc_id, doc_code, level, total_level, approver_id, approver_name, result, remark, createtime, updatetime)
         VALUES (?,?,?,?,?,0,'','pending','', ?, ?)`,
        [table, docId, pending.doc_code, level + 1, total, ts, ts],
      );
      const next = levels.find((f) => f.level === level + 1) || ({ role_id: 0, note: '' } as FlowRow);
      await this.notifyApprovers(table, docId, pending.doc_code, next as FlowRow, total, user);
      return { posted: false, ...(await this.status(table, docId)) };
    }

    // 最后一级通过：真正过账。过账失败（如库存不足）时把本条记录回退为 pending，
    // 保证「审批状态」与「是否已过账」永远一致，不会出现审过了但没入账。
    try {
      await this.tableService.examine(table, docId, 1);
    } catch (e: any) {
      await this.dataSource.query(
        `UPDATE kuerp_approval_log SET result='pending', approver_id=0, approver_name='', remark='', updatetime=? WHERE id = ?`,
        [this.now(), pending.id],
      );
      throw new BadRequestException(`审批通过但过账失败：${e?.message || '未知错误'}`);
    }

    return { posted: true, ...(await this.status(table, docId)) };
  }

  /**
   * 审批驳回：把当前 pending 记录标为 reject，并把结果通知提交人。
   *
   * 驳回不动单据本身（examine_status 仍为未审），用户可以改单后重新提交审批。
   *
   * @param docTable 单据表名
   * @param docId 单据ID
   * @param user 审批人
   * @param remark 驳回意见（建议必填，便于提交人知道改什么）
   * @returns 审批状态
   */
  async reject(docTable: string, docId: number, user: ApprovalUser, remark = '') {
    const table = this.normTable(docTable);
    const logs = await this.logs(table, docId);
    const pending = logs.find((l) => l.result === 'pending');
    if (!pending) throw new BadRequestException('没有待审批的记录');

    const flows = await this.loadFlows(table);
    const doc = await this.loadDoc(table, docId);
    const levels = this.matchLevels(flows, this.pickAmount(doc));
    const flow =
      levels.find((f) => Number(f.level) === Number(pending.level)) ||
      ({ role_id: 0, note: '', level: Number(pending.level) } as FlowRow);
    if (!(await this.canApprove(flow, user))) {
      throw new ForbiddenException('你没有该级次的审批权限');
    }

    await this.dataSource.query(
      `UPDATE kuerp_approval_log
          SET result='reject', approver_id=?, approver_name=?, remark=?, updatetime=?
        WHERE id = ?`,
      [user.id, user.username || '', String(remark || '').slice(0, 500), this.now(), pending.id],
    );

    // 通知提交人（取单据的 admin_id；老数据可能为 0，退化为广播）
    const submitter = Number(doc.admin_id || doc.creater_id || 0);
    await this.messages.create({
      toAdminId: submitter || 0,
      type: 'approval',
      level: 'danger',
      title: `审批驳回：${pending.doc_code}`,
      content: `${user.username || user.id} 驳回了单据 ${pending.doc_code}（第 ${pending.level}/${pending.total_level} 级）。意见：${remark || '未填写'}`,
      link: '/system/approval-todo',
      refTable: table,
      refId: docId,
    });

    return await this.status(table, docId);
  }

  /**
   * 我的待办：列出当前用户在其角色范围内、且处于待审状态的审批记录。
   *
   * 过滤在 SQL 外做（用 groupIds 判 role_id），因为审批记录量小（只存 pending 与历史），
   * 而把角色集合拼进 IN 子句会让 SQL 难以复用。
   *
   * @param user 当前用户
   * @param opts 分页与单据类型过滤
   * @returns { list, count }
   */
  async todo(user: ApprovalUser, opts: { page?: number; limit?: number; docTable?: string } = {}) {
    const page = Math.max(1, Number(opts.page) || 1);
    const limit = Math.min(200, Math.max(1, Number(opts.limit) || 20));
    const groups = await this.groupIdsOf(Number(user.id));
    const isSuper = Number(user.id) === 1;

    let rows: LogRow[];
    try {
      const sql =
        `SELECT * FROM kuerp_approval_log WHERE result = 'pending'` +
        (opts.docTable ? ' AND doc_table = ?' : '') +
        ' ORDER BY id DESC';
      rows = await this.dataSource.query(sql, opts.docTable ? [this.normTable(opts.docTable)] : []);
    } catch (e: any) {
      if (String(e?.code || '') === 'ER_NO_SUCH_TABLE') return { list: [], count: 0 };
      throw e;
    }

    // 按角色过滤：查每张表该级次配置的 role_id，判断是否命中当前用户角色
    const flowCache = new Map<string, FlowRow[]>();
    const visible: LogRow[] = [];
    for (const r of rows || []) {
      const key = r.doc_table;
      if (!flowCache.has(key)) flowCache.set(key, await this.loadFlows(key));
      const flows = flowCache.get(key) || [];
      const f = flows.find((x) => Number(x.level) === Number(r.level));
      const roleId = Number(f?.role_id || 0);
      if (isSuper || !roleId || groups.includes(roleId)) visible.push(r);
    }

    const count = visible.length;
    const list = visible.slice((page - 1) * limit, page * limit);
    return { list, count, page, limit };
  }

  /**
   * 某单据的审批历史。
   * @param docTable 单据表名
   * @param docId 单据ID
   * @returns 记录数组
   */
  async history(docTable: string, docId: number) {
    return await this.logs(this.normTable(docTable), docId);
  }
}
