import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { createHash, randomUUID, randomBytes } from 'crypto';

/**
 * 订货通（小程序端）统一响应结构。
 *
 * 与原系统 `app\common\controller\Api` 的 success/error 完全一致：
 *   success($msg, $data, 200) → { code: 200, msg, time, data }
 *   error($msg, '', 500)      → { code: 500, msg, time, data: '' }
 *
 * 注意与原后台的 { code: 1 } 不同：订货通小程序端用 200 表示成功、
 * 250 表示未登录、400/500 表示业务失败，前端 Uniapp 按此码判断，故必须保留。
 */
export interface ShopResult {
  code: number;
  msg: string;
  time: number;
  data: any;
}

/** 会员信息（等价 Auth::getUserinfo 的 allowFields 交集结果 + token 附加字段） */
export interface ShopUserInfo {
  id: number;
  username: string;
  nickname: string;
  mobile: string;
  avatar: string;
  score: number;
  binding: number;
  customers_id: number | null;
  token?: string;
  expires_in?: number;
}

/** 登录 / 注册 / 直登的结果 */
export interface ShopAuthResult {
  ok: boolean;
  msg?: string;
  token?: string;
  user?: any;
}

/**
 * 订货通会员鉴权服务（1:1 还原 application/api/library/kuerp/Auth.php）。
 *
 * 与原系统的差异（唯一一处，已在 db/shop-schema.sql 中说明）：
 *   原系统 Token 走 FastAdmin `user_token` 表并做 ripemd160 哈希；
 *   本重建库没有该表，但 `kuerp_user` 自带 `token` 列，故直接把明文
 *   UUID 令牌写入 `kuerp_user.token`，校验时按 token 反查用户。
 *   对外行为（token 字符串、鉴权语义、失效时机）不变，小程序端无需改动。
 *
 * 密码算法与原系统一致：password = md5(md5(明文) + salt)，salt 存 `kuerp_user.salt`。
 */
@Injectable()
export class ShopAuthService {
  /** 默认对外暴露的会员字段（等价 Auth::$allowFields） */
  private readonly allowFields = [
    'id',
    'username',
    'nickname',
    'mobile',
    'avatar',
    'score',
    'binding',
    'customers_id',
  ];

  constructor(private readonly dataSource: DataSource) {}

  // ==================================================================
  // 响应组装
  // ==================================================================

  /**
   * 组装成功响应。
   * @param msg 提示语
   * @param data 数据体
   * @param code 业务码，订货通默认 200
   * @returns ShopResult
   */
  succ(msg: string, data: any = '', code = 200): ShopResult {
    return { code, msg, time: Math.floor(Date.now() / 1000), data };
  }

  /**
   * 组装失败响应。
   * @param msg 提示语
   * @param code 业务码：250=未登录，400=参数/业务校验失败，500=服务端失败
   * @returns ShopResult
   */
  err(msg: string, code = 500): ShopResult {
    return { code, msg, time: Math.floor(Date.now() / 1000), data: '' };
  }

  /** 当前秒级时间戳（库内 createtime/updatetime 均为秒级 bigint） */
  now(): number {
    return Math.floor(Date.now() / 1000);
  }

  // ==================================================================
  // 密码与令牌
  // ==================================================================

  /**
   * 生成密码摘要（等价 Auth::getEncryptPassword）。
   * @param password 明文密码
   * @param salt 密码盐（存 kuerp_user.salt）
   * @returns md5(md5(password) + salt)
   */
  encryptPassword(password: string, salt = ''): string {
    const inner = createHash('md5').update(String(password)).digest('hex');
    return createHash('md5').update(inner + String(salt ?? '')).digest('hex');
  }

  /** 生成 32 位随机密码盐（等价 fast\Random::alnum） */
  randomSalt(len = 6): string {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const buf = randomBytes(len);
    let out = '';
    for (let i = 0; i < len; i++) out += chars[buf[i] % chars.length];
    return out;
  }

  /** 生成 UUID 形式的令牌（等价 fast\Random::uuid） */
  private uuid(): string {
    return randomUUID();
  }

  // ==================================================================
  // 鉴权核心
  // ==================================================================

  /**
   * 根据令牌取会员（等价 Auth::init）。
   *
   * @param token 客户端传入的令牌（HTTP token 头或 body.token）
   * @returns 会员行；无效令牌返回 null
   */
  async init(token: string): Promise<any | null> {
    const t = String(token || '').trim();
    if (!t) return null;
    const rows: any[] = await this.dataSource.query(
      'SELECT * FROM `kuerp_user` WHERE `token` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
      [t],
    );
    if (!rows.length) return null;
    const user = rows[0];
    // 状态：normal=正常，hidden=禁用（等价原系统 status 判断）
    if (user.status && user.status !== 'normal') return null;
    return user;
  }

  /**
   * 直登（等价 Auth::direct）：刷新登录统计并换发新令牌。
   *
   * @param userId 会员 ID
   * @returns 登录结果，ok=false 时带 msg
   */
  async direct(userId: number): Promise<ShopAuthResult> {
    const rows: any[] = await this.dataSource.query('SELECT * FROM `kuerp_user` WHERE `id` = ? LIMIT 1', [userId]);
    if (!rows.length) return { ok: false, msg: '账户不存在' };
    const user = rows[0];

    const now = this.now();
    // 今天 0 点与昨天 0 点（用于连续登录天数计算，等价 fast\Date::unixtime('day')）
    const day0 = new Date();
    day0.setHours(0, 0, 0, 0);
    const today = Math.floor(day0.getTime() / 1000);
    const yesterday = today - 86400;

    let successions = Number(user.successions || 1);
    let maxsuccessions = Number(user.maxsuccessions || 1);
    if (Number(user.logintime || 0) < today) {
      successions = Number(user.logintime || 0) < yesterday ? 1 : successions + 1;
      maxsuccessions = Math.max(successions, maxsuccessions);
    }

    const token = this.uuid();
    await this.dataSource.query(
      'UPDATE `kuerp_user` SET `token` = ?, `prevtime` = ?, `logintime` = ?, `loginfailure` = 0, ' +
        '`successions` = ?, `maxsuccessions` = ?, `updatetime` = ? WHERE `id` = ?',
      [token, user.logintime, now, successions, maxsuccessions, now, userId],
    );

    return { ok: true, token, user: { ...user, token, logintime: now } };
  }

  /**
   * 账号密码登录（等价 Auth::login）。
   * 账号可以是用户名 / 邮箱 / 手机号，按格式自动识别。
   *
   * @param account 账号
   * @param password 明文密码
   */
  async login(account: string, password: string): Promise<ShopAuthResult> {
    const acc = String(account || '').trim();
    if (!acc || !password) return { ok: false, msg: '请输入账户和密码' };

    // 与 PHP 一致：先判邮箱，再判手机号，最后按用户名
    let field = 'username';
    if (/^[\w.+-]+@[\w-]+\.[\w.-]+$/.test(acc)) field = 'email';
    else if (/^1\d{10}$/.test(acc)) field = 'mobile';

    const rows: any[] = await this.dataSource.query(
      `SELECT * FROM \`kuerp_user\` WHERE \`${field}\` = ? AND (\`deletetime\` IS NULL OR \`deletetime\` = 0) LIMIT 1`,
      [acc],
    );
    if (!rows.length) return { ok: false, msg: '账户不正确' };
    const user = rows[0];
    if (user.status && user.status !== 'normal') return { ok: false, msg: '账户已禁用' };
    if (user.password !== this.encryptPassword(password, user.salt)) {
      return { ok: false, msg: '密码错误' };
    }
    return this.direct(user.id);
  }

  /**
   * 注册会员（等价 Auth::register）。
   *
   * @param username 用户名
   * @param nickname 昵称
   * @param avatar 头像
   * @param password 明文密码
   * @param email 邮箱
   * @param mobile 手机号
   * @param extra 额外写入字段（如 binding / customers_id）
   */
  async register(
    username: string,
    nickname = '',
    avatar = '',
    password = '',
    email = '',
    mobile = '',
    extra: Record<string, any> = {},
  ): Promise<ShopAuthResult> {
    const uname = String(username || '').trim();
    if (!uname) return { ok: false, msg: '用户名不能为空' };

    const dup: any[] = await this.dataSource.query(
      'SELECT `id` FROM `kuerp_user` WHERE `username` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1',
      [uname],
    );
    if (dup.length) return { ok: false, msg: '用户名已被占用' };

    const now = this.now();
    const salt = this.randomSalt(6);
    const pwd = this.encryptPassword(password || this.randomSalt(10), salt);
    const row: Record<string, any> = {
      username: uname,
      nickname: nickname || uname,
      avatar: avatar || '',
      password: pwd,
      salt,
      email: email || '',
      mobile: mobile || '',
      status: 'normal',
      // verification 在原系统是 JSON 字段（记录手机/邮箱/三方授权是否已验证）
      verification: JSON.stringify({ mobile: mobile ? 1 : 0, email: email ? 1 : 0 }),
      group_id: 1,
      jointime: now,
      createtime: now,
      updatetime: now,
      ...extra,
    };

    const cols = Object.keys(row);
    const res: any = await this.dataSource.query(
      `INSERT INTO \`kuerp_user\` (${cols.map((c) => '`' + c + '`').join(',')}) VALUES (${cols
        .map(() => '?')
        .join(',')})`,
      cols.map((c) => row[c]),
    );
    const userId = Number(res?.insertId || 0);
    if (!userId) return { ok: false, msg: '注册失败' };

    const directRes = await this.direct(userId);
    if (!directRes.ok) return directRes;
    return { ...directRes, user: { ...directRes.user, ...row } };
  }

  /**
   * 退出登录（等价 Auth::logout）：清除令牌。
   * @param userId 会员 ID
   */
  async logout(userId: number): Promise<void> {
    await this.dataSource.query('UPDATE `kuerp_user` SET `token` = \'\', `updatetime` = ? WHERE `id` = ?', [
      this.now(),
      userId,
    ]);
  }

  /**
   * 把会员行裁剪成对外字段（等价 Auth::getUserinfo 的 allowFields 交集）。
   *
   * @param user kuerp_user 行
   * @returns 仅含 allowFields 的对象；user 为空时返回 null
   */
  toUserInfo(user: any): ShopUserInfo | null {
    if (!user) return null;
    const out: any = {};
    for (const f of this.allowFields) out[f] = user[f] ?? null;
    if (user.token) out.token = user.token;
    return out as ShopUserInfo;
  }

  /**
   * 读取请求令牌（等价 `$this->request->server('HTTP_TOKEN', $this->request->request('token'))`）。
   * 优先级：Header `token` > Header `Authorization: Bearer xxx` > body.token > query.token。
   *
   * @param req Express 请求对象
   * @param body 请求体
   * @returns 令牌字符串，未取到返回空串
   */
  pickToken(req: any, body: any): string {
    const h = req?.headers || {};
    if (h['token']) return String(h['token']);
    const auth = String(h['authorization'] || '');
    if (auth.toLowerCase().startsWith('bearer ')) return auth.slice(7);
    if (body?.token) return String(body.token);
    if (req?.query?.token) return String(req.query.token);
    return '';
  }
}
