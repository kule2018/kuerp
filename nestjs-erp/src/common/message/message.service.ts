import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';

/** 一条待写入的消息 */
export interface MessageInput {
  /** 接收人ID；0 表示全员广播 */
  toAdminId?: number;
  /** 类型：stock_warning / batch_expiry / ar_due / approval / system */
  type: string;
  /** 级别：info / warn / danger */
  level?: 'info' | 'warn' | 'danger';
  /** 标题 */
  title: string;
  /** 内容 */
  content?: string;
  /** 点击跳转的前端路由 */
  link?: string;
  /** 关联表（不含 kuerp_ 前缀） */
  refTable?: string;
  /** 关联记录ID */
  refId?: string | number;
}

/** 消息查询条件 */
export interface MessageQuery {
  page?: number;
  limit?: number;
  /** 仅未读 */
  unread?: boolean;
  /** 类型过滤 */
  type?: string;
  /** 接收人（0 时同时返回广播消息） */
  toAdminId?: number;
}

/**
 * 消息中心服务。
 *
 * 设计取舍：
 * 1) 只写不常改，与操作日志一样直接用 DataSource 跑原生 SQL，不建 Entity；
 * 2) 「全员广播」用 to_admin_id = 0 表示，查询时以 (to_admin_id = ? OR to_admin_id = 0) 命中，
 *    避免为每条广播消息给每个管理员各插一行（N 倍写放大）；
 * 3) 已读状态是「每人一份」的，所以广播消息的已读记录落在 kuerp_message_read 表，
 *    而不是在 kuerp_message 上改 is_read（否则一个人读了所有人都变已读）。
 */
@Injectable()
export class MessageService {
  private readonly logger = new Logger(MessageService.name);

  constructor(private readonly dataSource: DataSource) {}

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /**
   * 写入一条消息。
   * @param input 消息内容
   * @returns 新消息 ID（写入失败返回 0，不抛错——消息推送不应阻断主业务）
   */
  async create(input: MessageInput): Promise<number> {
    try {
      const r = await this.dataSource.query(
        `INSERT INTO kuerp_message
           (to_admin_id, type, level, title, content, link, ref_table, ref_id, is_read, createtime)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, ?)`,
        [
          input.toAdminId ?? 0,
          input.type || 'system',
          input.level || 'info',
          (input.title || '').slice(0, 200),
          (input.content || '').slice(0, 1000),
          (input.link || '').slice(0, 255),
          input.refTable || '',
          String(input.refId ?? ''),
          this.now(),
        ],
      );
      return Number(r?.insertId || 0);
    } catch (e: any) {
      this.logger.warn(`写消息失败：${e?.message || e}`);
      return 0;
    }
  }

  /**
   * 批量写入消息（逐条插入，任一条失败不影响其余）。
   * @param list 消息数组
   * @returns 成功写入条数
   */
  async createMany(list: MessageInput[]): Promise<number> {
    let n = 0;
    for (const m of list) {
      const id = await this.create(m);
      if (id) n++;
    }
    return n;
  }

  /**
   * 分页查询消息。
   * @param q 查询条件
   * @returns { list, count }
   */
  async list(q: MessageQuery) {
    const page = Math.max(1, Number(q.page) || 1);
    const limit = Math.min(200, Math.max(1, Number(q.limit) || 20));
    const adminId = Number(q.toAdminId || 0);

    // 可见范围：自己的 + 全员广播
    const where: string[] = ['m.deletetime IS NULL', '(m.to_admin_id = ? OR m.to_admin_id = 0)'];
    const params: any[] = [adminId];
    if (q.unread) {
      // 广播消息的已读状态在 kuerp_message_read；这里用 NOT EXISTS 统一表达
      where.push('NOT EXISTS (SELECT 1 FROM kuerp_message_read rd WHERE rd.message_id = m.id AND rd.admin_id = ?)');
      params.push(adminId);
    }
    if (q.type) {
      where.push('m.type = ?');
      params.push(q.type);
    }
    const whereSql = where.join(' AND ');

    const rows = await this.dataSource.query(
      `SELECT m.*,
              EXISTS (SELECT 1 FROM kuerp_message_read rd WHERE rd.message_id = m.id AND rd.admin_id = ?) AS is_read_by_me
         FROM kuerp_message m
        WHERE ${whereSql}
        ORDER BY m.id DESC
        LIMIT ? OFFSET ?`,
      [adminId, ...params, limit, (page - 1) * limit],
    );
    const cnt = await this.dataSource.query(
      `SELECT COUNT(*) AS c FROM kuerp_message m WHERE ${whereSql}`,
      params,
    );

    return {
      list: (rows || []).map((r: any) => ({
        ...r,
        is_read: Number(r.is_read_by_me) === 1 || Number(r.is_read) === 1 ? 1 : 0,
      })),
      count: Number(cnt?.[0]?.c || 0),
    };
  }

  /**
   * 未读条数（侧栏徽标用）。
   * @param adminId 当前管理员ID
   * @param type 可选类型过滤
   * @returns 未读条数
   */
  async unreadCount(adminId: number, type?: string): Promise<number> {
    const params: any[] = [adminId, adminId];
    let extra = '';
    if (type) {
      extra = ' AND m.type = ?';
      params.push(type);
    }
    const r = await this.dataSource.query(
      `SELECT COUNT(*) AS c
         FROM kuerp_message m
        WHERE m.deletetime IS NULL
          AND (m.to_admin_id = ? OR m.to_admin_id = 0)
          AND m.is_read = 0
          AND NOT EXISTS (SELECT 1 FROM kuerp_message_read rd WHERE rd.message_id = m.id AND rd.admin_id = ?)
          ${extra}`,
      params,
    );
    return Number(r?.[0]?.c || 0);
  }

  /**
   * 标记单条已读。
   * @param id 消息ID
   * @param adminId 当前管理员ID
   * @returns 是否成功
   */
  async markRead(id: number, adminId: number): Promise<boolean> {
    const rows = await this.dataSource.query('SELECT to_admin_id FROM kuerp_message WHERE id = ? LIMIT 1', [id]);
    if (!rows?.length) return false;
    const toId = Number(rows[0].to_admin_id || 0);
    // 私有消息：直接改标志位；广播消息：写已读明细表
    if (toId === 0) {
      await this.dataSource.query(
        `INSERT IGNORE INTO kuerp_message_read (message_id, admin_id, readtime) VALUES (?, ?, ?)`,
        [id, adminId, this.now()],
      );
    } else {
      await this.dataSource.query(
        'UPDATE kuerp_message SET is_read = 1, readtime = ? WHERE id = ? AND to_admin_id = ?',
        [this.now(), id, adminId],
      );
    }
    return true;
  }

  /**
   * 全部标记已读（当前用户可见范围内）。
   * @param adminId 当前管理员ID
   * @returns 影响条数
   */
  async markAllRead(adminId: number): Promise<number> {
    // 私有消息批量置位
    const r1 = await this.dataSource.query(
      'UPDATE kuerp_message SET is_read = 1, readtime = ? WHERE to_admin_id = ? AND is_read = 0',
      [this.now(), adminId],
    );
    // 广播消息逐条补已读明细（数量有限，逐条 INSERT IGNORE 可接受）
    const broadcasts = await this.dataSource.query(
      `SELECT m.id FROM kuerp_message m
        WHERE m.to_admin_id = 0 AND m.deletetime IS NULL AND m.is_read = 0
          AND NOT EXISTS (SELECT 1 FROM kuerp_message_read rd WHERE rd.message_id = m.id AND rd.admin_id = ?)`,
      [adminId],
    );
    for (const b of broadcasts || []) {
      await this.dataSource.query(
        'INSERT IGNORE INTO kuerp_message_read (message_id, admin_id, readtime) VALUES (?, ?, ?)',
        [b.id, adminId, this.now()],
      );
    }
    return Number(r1?.affectedRows || 0) + (broadcasts?.length || 0);
  }

  /**
   * 软删除一条消息（仅限自己的消息；广播消息不可删）。
   * @param id 消息ID
   * @param adminId 当前管理员ID
   * @returns 是否成功
   */
  async remove(id: number, adminId: number): Promise<boolean> {
    const r = await this.dataSource.query(
      'UPDATE kuerp_message SET deletetime = ? WHERE id = ? AND to_admin_id = ?',
      [this.now(), id, adminId],
    );
    return Number(r?.affectedRows || 0) > 0;
  }

  /**
   * 清理 N 天前的已读消息（供定时任务调用，避免消息表无限膨胀）。
   * @param days 保留天数
   * @returns 删除条数
   */
  async purgeRead(days = 90): Promise<number> {
    const before = this.now() - days * 86400;
    const r = await this.dataSource.query(
      'DELETE FROM kuerp_message WHERE is_read = 1 AND createtime < ? LIMIT 2000',
      [before],
    );
    return Number(r?.affectedRows || 0);
  }
}
