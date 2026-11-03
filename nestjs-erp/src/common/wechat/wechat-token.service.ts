import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';

/** 取到的 access_token 结果 */
export interface WechatTokenResult {
  /** 是否成功 */
  ok: boolean;
  /** 令牌（失败时为空串） */
  token: string;
  /** 过期时间（秒级时间戳） */
  expireAt: number;
  /** 失败原因 */
  msg?: string;
}

/**
 * 微信小程序 access_token 统一管理。
 *
 * 为什么要单独做一层缓存：
 * 1) access_token 有效期 7200 秒，且**每日调用次数有限**（stable_token 接口按次计费更严格）；
 * 2) 微信在旧 token 未过期时重复获取可能返回同一个，但若每次都现取，接口耗时会多一次外网往返；
 * 3) 进程重启后缓存丢失，首个相关请求会变慢，所以由定时作业每 30 分钟预热一次，
 *    正常路径上永远命中缓存，不阻塞业务。
 *
 * 凭证来源优先级：环境变量 WX_APPID/WX_SECRET > kuerp_sets 的 appid/appsecret
 * （后者是原系统在小程序设置页维护的字段，便于不重启进程就换号）。
 */
@Injectable()
export class WechatTokenService {
  private readonly logger = new Logger(WechatTokenService.name);

  /** 缓存：token + 过期时间 */
  private cache: { token: string; expireAt: number } = { token: '', expireAt: 0 };

  /** 最近一次失败原因（供定时作业日志展示） */
  private lastError = '';

  /** 提前刷新窗口（秒）：留 5 分钟余量，避免临界过期 */
  private readonly EARLY = 300;

  constructor(private readonly dataSource: DataSource) {}

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /**
   * 读取微信凭证（环境变量优先，其次系统参数）。
   * @returns { appid, secret }；缺失时返回空串
   */
  private async credentials(): Promise<{ appid: string; secret: string }> {
    let appid = String(process.env.WX_APPID || '').trim();
    let secret = String(process.env.WX_SECRET || '').trim();
    if (appid && secret) return { appid, secret };

    try {
      const rows = await this.dataSource.query(
        `SELECT name, value FROM kuerp_sets WHERE name IN ('appid','appsecret')`,
      );
      for (const r of rows || []) {
        if (r.name === 'appid' && !appid) appid = String(r.value || '').trim();
        if (r.name === 'appsecret' && !secret) secret = String(r.value || '').trim();
      }
    } catch {
      // 表不存在或数据库暂不可用时静默降级，最终会以「未配置」返回
    }
    return { appid, secret };
  }

  /**
   * 获取 access_token（命中缓存直接返回）。
   * @param force 是否强制刷新（定时作业用 true，业务调用用默认 false）
   * @returns 令牌结果
   */
  async getToken(force = false): Promise<WechatTokenResult> {
    const n = this.now();
    if (!force && this.cache.token && this.cache.expireAt - this.EARLY > n) {
      return { ok: true, token: this.cache.token, expireAt: this.cache.expireAt };
    }

    const { appid, secret } = await this.credentials();
    if (!appid || !secret) {
      this.lastError = '未配置小程序 AppID / AppSecret（WX_APPID、WX_SECRET 或系统参数 appid/appsecret）';
      return { ok: false, token: '', expireAt: 0, msg: this.lastError };
    }

    // stable_token 是微信推荐的稳定版接口：普通模式强制刷新会拿到新 token，
    // 但强制刷新会让其它实例的旧 token 失效，所以这里只在缓存失效时才带 force_refresh。
    const needForce = force && !this.cache.token;
    const url = 'https://api.weixin.qq.com/cgi-bin/stable_token';
    try {
      const res = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ grant_type: 'client_credential', appid, secret, force_refresh: needForce }),
      });
      const data: any = await res.json();
      if (!data?.access_token) {
        this.lastError = data?.errmsg || `获取 access_token 失败（errcode=${data?.errcode ?? '未知'}）`;
        this.logger.warn(this.lastError);
        return { ok: false, token: '', expireAt: 0, msg: this.lastError };
      }
      const expireAt = n + Number(data.expires_in || 7200);
      this.cache = { token: String(data.access_token), expireAt };
      this.lastError = '';
      return { ok: true, token: this.cache.token, expireAt };
    } catch (e: any) {
      this.lastError = `请求微信接口失败：${e?.message || e}`;
      this.logger.warn(this.lastError);
      return { ok: false, token: '', expireAt: 0, msg: this.lastError };
    }
  }

  /**
   * 当前缓存状态（供管理页展示，不触发网络请求）。
   * @returns { token 掩码, expireAt, 剩余秒数, lastError }
   */
  status() {
    const n = this.now();
    const t = this.cache.token;
    return {
      hasToken: !!t,
      // 只回显前 6 位，避免令牌被日志或页面泄露
      tokenMask: t ? `${t.slice(0, 6)}****${t.slice(-4)}` : '',
      expireAt: this.cache.expireAt,
      remain: Math.max(0, this.cache.expireAt - n),
      lastError: this.lastError,
    };
  }
}
