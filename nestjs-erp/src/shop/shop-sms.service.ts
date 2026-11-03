import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';

/**
 * 短信验证码服务（1:1 还原 Order\Sms + FastAdmin `app\common\library\Sms`）。
 *
 * 原系统把验证码存 `fa_sms` 表并依赖后台安装的短信插件下发；
 * 本重建库用 `kuerp_sms`（见 db/shop-schema.sql）存储，下发通道改为
 * 「可配置的 HTTP 网关」：
 *   - 配置 SMS_GATEWAY_URL 时，POST {mobile, code, event} 到该地址完成下发；
 *   - 未配置时只落库并发告警日志，若 SMS_DEBUG=true 则把验证码回传给客户端，
 *     方便本地/联调环境走通注册、绑定、改密等流程（生产环境必须关闭）。
 *
 * 频率限制与原系统一致：同手机号同事件 60 秒一次；同 IP 每小时最多 5 条。
 */
@Injectable()
export class ShopSmsService {
  private readonly logger = new Logger('ShopSms');

  constructor(private readonly dataSource: DataSource) {}

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  /**
   * 发送验证码。
   *
   * @param mobile 手机号
   * @param event 事件：register / login / resetpwd / changemobile / mobilelogin / bind
   * @param ip 请求 IP
   * @returns { ok, msg, code? }，code 仅在 SMS_DEBUG=true 时回传
   */
  async send(mobile: string, event = 'register', ip = ''): Promise<{ ok: boolean; msg: string; code?: string }> {
    if (!/^1\d{10}$/.test(String(mobile || ''))) return { ok: false, msg: '手机号不正确' };

    // 1) 同手机号同事件 60 秒内不可重复发送
    const last = await this.dataSource
      .query('SELECT `createtime` FROM `kuerp_sms` WHERE `mobile` = ? AND `event` = ? ORDER BY `id` DESC LIMIT 1', [
        mobile,
        event,
      ])
      .then((r: any[]) => r?.[0] ?? null);
    if (last && this.now() - Number(last.createtime || 0) < 60) return { ok: false, msg: '发送频繁' };

    // 2) 同 IP 每小时最多 5 条
    if (ip) {
      const ipRows: any[] = await this.dataSource.query(
        'SELECT COUNT(*) AS `c` FROM `kuerp_sms` WHERE `ip` = ? AND `createtime` >= ?',
        [ip, this.now() - 3600],
      );
      if (Number(ipRows?.[0]?.c || 0) >= 5) return { ok: false, msg: '发送频繁' };
    }

    // 3) 业务前置校验：与原系统完全一致
    const user = await this.dataSource
      .query('SELECT `id` FROM `kuerp_user` WHERE `mobile` = ? AND (`deletetime` IS NULL OR `deletetime` = 0) LIMIT 1', [
        mobile,
      ])
      .then((r: any[]) => r?.[0] ?? null);

    if (event === 'register' && user) return { ok: false, msg: '已被注册' };
    if (event === 'changemobile' && user) return { ok: false, msg: '已被占用' };
    if ((event === 'changepwd' || event === 'resetpwd') && !user) return { ok: false, msg: '未注册' };
    if (event === 'bind' && !user) return { ok: false, msg: '未找到此账号信息' };

    // 4) 生成并落库（6 位数字，5 分钟有效由校验时的 createtime 判定）
    const code = String(Math.floor(100000 + Math.random() * 900000));
    await this.dataSource.query(
      'INSERT INTO `kuerp_sms` (`event`,`mobile`,`code`,`times`,`ip`,`createtime`) VALUES (?,?,?,?,?,?)',
      [event, mobile, code, 0, ip || '', this.now()],
    );

    // 5) 下发
    const gateway = String(process.env.SMS_GATEWAY_URL || '').trim();
    if (gateway) {
      try {
        const res = await fetch(gateway, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ mobile, code, event }),
        });
        if (!res.ok) {
          this.logger.error(`短信网关返回 ${res.status}：${await res.text().catch(() => '')}`);
          return { ok: false, msg: '发送失败，请检查短信配置是否正确' };
        }
      } catch (e: any) {
        this.logger.error('短信网关调用异常：' + (e?.message || e));
        return { ok: false, msg: '发送失败，请检查短信配置是否正确' };
      }
      return { ok: true, msg: '发送成功' };
    }

    this.logger.warn(`未配置 SMS_GATEWAY_URL，验证码仅落库：mobile=${mobile} event=${event}`);
    // 调试模式才回传验证码，生产禁止开启
    if (String(process.env.SMS_DEBUG || '').toLowerCase() === 'true') {
      return { ok: true, msg: '发送成功（调试模式，验证码随响应返回）', code };
    }
    return { ok: true, msg: '发送成功' };
  }

  /**
   * 校验验证码（等价 Sms::check）。校验成功不删除记录，由 flush 显式清理。
   *
   * @param mobile 手机号
   * @param captcha 用户输入的验证码
   * @param event 事件名
   * @param ttlSeconds 有效期，默认 300 秒（与原系统一致）
   * @returns 是否通过
   */
  async check(mobile: string, captcha: string, event = 'register', ttlSeconds = 300): Promise<boolean> {
    if (!/^1\d{10}$/.test(String(mobile || ''))) return false;
    const code = String(captcha || '').trim();
    if (!code) return false;

    const row: any = await this.dataSource
      .query(
        'SELECT `id`,`code`,`createtime`,`times` FROM `kuerp_sms` WHERE `mobile` = ? AND `event` = ? ORDER BY `id` DESC LIMIT 1',
        [mobile, event],
      )
      .then((r: any[]) => r?.[0] ?? null);
    if (!row) return false;
    if (this.now() - Number(row.createtime || 0) > ttlSeconds) return false;
    if (String(row.code) !== code) {
      // 记录错误次数，便于风控排查
      await this.dataSource.query('UPDATE `kuerp_sms` SET `times` = `times` + 1 WHERE `id` = ?', [row.id]);
      return false;
    }
    return true;
  }

  /**
   * 清除某手机号某事件的验证码（等价 Sms::flush）。
   * @param mobile 手机号
   * @param event 事件名，默认 default
   */
  async flush(mobile: string, event = 'default'): Promise<void> {
    await this.dataSource.query('DELETE FROM `kuerp_sms` WHERE `mobile` = ? AND `event` = ?', [mobile, event]);
  }
}
