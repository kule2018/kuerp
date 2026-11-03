import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { createCipheriv, createDecipheriv, createHash, createSign, randomBytes, randomUUID } from 'crypto';
import { ShopService } from './shop.service';
import { ShopSmsService } from './shop-sms.service';
import { ShopAuthService } from './shop-auth.service';

/**
 * 微信小程序登录 / 支付服务。
 *
 * 对应原系统两个文件：
 *   - `application/api/controller/kuerp/order/Weixin.php`（登录、绑定、解绑、三方授权信息）
 *   - `application/api/controller/kuerp/order/Index.php` 的
 *     wxpay / wxpays / notify / sendOrder / generateSign（支付下单与回调）
 *
 * 支付同时支持微信支付两代接口，按 kuerp_user_sets 的 `order_send` 开关切换：
 *   order_send=1 → APIv3（RSA-SHA256 签名，商户私钥 serial）
 *   其它         → APIv2（MD5 签名，商户 API 密钥 pay_key）
 * 回调 notify 同时兼容 v2（XML）与 v3（JSON + AES-256-GCM 解密）。
 */
@Injectable()
export class ShopWechatService {
  private readonly logger = new Logger('ShopWechat');

  /** 小程序 session_key 本地缓存（等价原系统 Cache::set(session_key, data, 31 天)） */
  private readonly sessionCache = new Map<string, { data: any; expire: number }>();

  constructor(
    private readonly dataSource: DataSource,
    private readonly shop: ShopService,
    private readonly sms: ShopSmsService,
    private readonly auth: ShopAuthService,
  ) {}

  /** 当前秒级时间戳 */
  private now(): number {
    return Math.floor(Date.now() / 1000);
  }

  // ==================================================================
  // 一、小程序登录
  // ==================================================================

  /**
   * code 换 session_key（等价 Weixin::getWxMiniProgramSessionKey）。
   *
   * @param code wx.login 得到的临时 code
   * @returns { ok, msg?, data? }，data 含 openid/session_key
   */
  async code2Session(code: string): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const appid = String(process.env.WX_APPID || '').trim();
    const secret = String(process.env.WX_SECRET || '').trim();
    if (!appid || !secret) {
      return { ok: false, msg: '未配置小程序 AppID / AppSecret（WX_APPID、WX_SECRET）' };
    }
    if (!code) return { ok: false, msg: '缺少 code' };

    const url =
      'https://api.weixin.qq.com/sns/jscode2session?appid=' +
      encodeURIComponent(appid) +
      '&secret=' +
      encodeURIComponent(secret) +
      '&js_code=' +
      encodeURIComponent(code) +
      '&grant_type=authorization_code';

    try {
      const res = await fetch(url);
      const data: any = await res.json();
      if (!data?.session_key || !data?.openid) {
        return { ok: false, msg: data?.errmsg || 'code 换取 session_key 失败' };
      }
      // 缓存 31 天
      this.sessionCache.set(data.session_key, { data, expire: this.now() + 31 * 86400 });
      return { ok: true, data };
    } catch (e: any) {
      return { ok: false, msg: '请求微信接口失败：' + (e?.message || e) };
    }
  }

  /**
   * 读取 session_key 对应的会话数据（等价 Cache::get）。
   * @param sessionKey 会话密钥
   */
  private getSession(sessionKey: string): any | null {
    const hit = this.sessionCache.get(sessionKey);
    if (!hit) return null;
    if (hit.expire < this.now()) {
      this.sessionCache.delete(sessionKey);
      return null;
    }
    return hit.data;
  }

  /**
   * 解密小程序加密数据（等价 Wechat::decryptData，AES-128-CBC）。
   *
   * @param sessionKey 会话密钥
   * @param iv 初始向量
   * @param encryptedData 密文
   * @returns 解密后的对象；失败返回 null
   */
  decryptData(sessionKey: string, iv: string, encryptedData: string): any | null {
    try {
      const key = Buffer.from(sessionKey, 'base64');
      const ivBuf = Buffer.from(iv, 'base64');
      const cipher = Buffer.from(encryptedData, 'base64');
      const decipher = createDecipheriv('aes-128-cbc', key, ivBuf);
      decipher.setAutoPadding(true);
      const decoded = Buffer.concat([decipher.update(cipher), decipher.final()]).toString('utf8');
      return JSON.parse(decoded);
    } catch (e: any) {
      this.logger.error('解密小程序数据失败：' + (e?.message || e));
      return null;
    }
  }

  /**
   * 小程序授权登录（等价 Weixin::wxMiniProgramOauth）。
   * 首次登录自动注册会员并写 kuerp_user_oauth；已存在则直接登录。
   *
   * @param body { code?, session_key, iv, encryptedData, event }
   */
  async miniProgramOauth(body: any): Promise<{ ok: boolean; msg?: string; code?: number; data?: any }> {
    const sessionKey = String(body?.session_key || '').trim();
    if (!sessionKey) return { ok: false, msg: '未获取到登录依据,请重试', code: 205 };

    const session = this.getSession(sessionKey);
    if (!session?.openid) return { ok: false, msg: '未获取到登录依据,请重试', code: 205 };

    // 解出用户信息（昵称/头像/性别），失败时仅依赖 session
    const decrypted = this.decryptData(sessionKey, String(body?.iv || ''), String(body?.encryptedData || '')) || {};
    const lower: any = {};
    for (const k of Object.keys(decrypted)) lower[k.toLowerCase()] = decrypted[k];
    const openid = String(lower.openid || session.openid);
    if (!openid) return { ok: false, msg: 'code错误,请重试', code: 206 };

    const platform = 'wxMiniPrograms';
    const provider = 'Wechat';

    // 1) 查三方授权记录
    const oauth: any = await this.dataSource
      .query('SELECT * FROM `kuerp_user_oauth` WHERE `openid` = ? AND `platform` = ? AND `provider` = ? LIMIT 1', [
        openid,
        platform,
        provider,
      ])
      .then((r: any[]) => r?.[0] ?? null);

    const now = this.now();
    const oauthData = {
      provider,
      platform,
      openid,
      unionid: lower.unionid || null,
      nickname: lower.nickname || '',
      sex: Number(lower.gender || lower.sex || 0),
      country: lower.country || '',
      province: lower.province || '',
      city: lower.city || '',
      headimgurl: lower.avatarurl || lower.headimgurl || '',
      session_key: sessionKey,
      expire_in: 7200,
      expiretime: now + 7200,
      logintime: now,
    };

    let userId = 0;

    if (oauth?.user_id && Number(oauth.user_id) > 0) {
      // 2) 已授权：校验会员是否仍然有效
      const user = await this.dataSource
        .query('SELECT `id`,`status` FROM `kuerp_user` WHERE `id` = ? LIMIT 1', [oauth.user_id])
        .then((r: any[]) => r?.[0] ?? null);
      if (user && (!user.status || user.status === 'normal')) {
        userId = Number(user.id);
        await this.dataSource.query(
          'UPDATE `kuerp_user_oauth` SET `nickname` = ?, `headimgurl` = ?, `session_key` = ?, `logintime` = ?, ' +
            '`logincount` = `logincount` + 1, `expiretime` = ?, `updatetime` = ? WHERE `id` = ?',
          [oauthData.nickname, oauthData.headimgurl, sessionKey, now, oauthData.expiretime, now, oauth.id],
        );
        // 同步最新头像/昵称到会员表
        await this.dataSource.query('UPDATE `kuerp_user` SET `nickname` = ?, `avatar` = ?, `updatetime` = ? WHERE `id` = ?', [
          oauthData.nickname || oauth.nickname || '',
          oauthData.headimgurl || oauth.headimgurl || '',
          now,
          userId,
        ]);
      } else {
        // 会员已被删除：清掉失效授权，走新注册
        await this.dataSource.query('DELETE FROM `kuerp_user_oauth` WHERE `id` = ?', [oauth.id]);
      }
    }

    if (!userId) {
      // 3) 新用户：以 openid 作为用户名注册（与原系统一致）
      const reg = await this.auth.register(
        openid,
        oauthData.nickname || openid,
        oauthData.headimgurl,
        this.auth.randomSalt(12),
        '',
        '',
        { binding: 2 },
      );
      if (!reg.ok) return { ok: false, msg: reg.msg || '登录失败', code: 500 };
      userId = Number(reg.user?.id || 0);

      // 4) 写/更新三方授权记录
      if (oauth) {
        await this.dataSource.query(
          'UPDATE `kuerp_user_oauth` SET `user_id` = ?, `session_key` = ?, `logintime` = ?, `updatetime` = ? WHERE `id` = ?',
          [userId, sessionKey, now, now, oauth.id],
        );
      } else {
        await this.dataSource.query(
          'INSERT INTO `kuerp_user_oauth` (`user_id`,`provider`,`platform`,`openid`,`unionid`,`nickname`,`sex`,`country`,`province`,`city`,`headimgurl`,`session_key`,`expire_in`,`expiretime`,`logintime`,`logincount`,`createtime`,`updatetime`) ' +
            'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
          [
            userId,
            provider,
            platform,
            openid,
            oauthData.unionid,
            oauthData.nickname,
            oauthData.sex,
            oauthData.country,
            oauthData.province,
            oauthData.city,
            oauthData.headimgurl,
            sessionKey,
            7200,
            oauthData.expiretime,
            now,
            1,
            now,
            now,
          ],
        );
      }
    }

    // 5) 换发令牌并回传会员信息
    const directRes = await this.auth.direct(userId);
    if (!directRes.ok) return { ok: false, msg: directRes.msg || '登录失败', code: 500 };

    const user = await this.dataSource
      .query('SELECT * FROM `kuerp_user` WHERE `id` = ? LIMIT 1', [userId])
      .then((r: any[]) => r?.[0] ?? null);
    const info: any = this.auth.toUserInfo(user);
    if (info) info.avatar = this.shop.cdnUrl(info.avatar);

    return { ok: true, data: { userinfo: info, token: directRes.token, openid } };
  }

  /**
   * 绑定手机号（等价 Weixin::bind）：验证码通过且手机号是客户档案才可绑定。
   *
   * @param userId 会员 ID
   * @param mobile 手机号
   * @param captcha 验证码
   */
  async bind(userId: number, mobile: string, captcha: string): Promise<{ ok: boolean; msg?: string; token?: string }> {
    const pass = await this.sms.check(mobile, captcha, 'changemobile');
    if (!pass) return { ok: false, msg: '验证码错误' };

    const cur: any = await this.dataSource
      .query('SELECT `binding` FROM `kuerp_user` WHERE `id` = ? LIMIT 1', [userId])
      .then((r: any[]) => r?.[0] ?? null);
    if (!cur) return { ok: false, msg: '未找到相关用户' };
    if (Number(cur.binding) !== 2) return { ok: false, msg: '此用户已绑定' };

    const res = await this.shop.bindMobile(userId, mobile);
    if (!res.ok) return { ok: false, msg: res.msg };

    await this.sms.flush(mobile, 'changemobile');
    const directRes = await this.auth.direct(userId);
    return { ok: true, token: directRes.token };
  }

  /**
   * 三方授权信息（等价 Weixin::thirdOauthInfo）。
   * @param userId 会员 ID
   * @param platform 平台名，如 wxMiniPrograms
   */
  async thirdOauthInfo(userId: number, platform: string): Promise<any> {
    return this.dataSource
      .query('SELECT `headimgurl`,`nickname` FROM `kuerp_user_oauth` WHERE `platform` = ? AND `user_id` = ? LIMIT 1', [
        platform,
        userId,
      ])
      .then((r: any[]) => r?.[0] ?? null);
  }

  /**
   * 按 openid 查已绑定的会员 ID（供「code 换 session_key 后自动登录」使用）。
   *
   * @param openid 微信 openid
   * @param provider 厂商，默认 Wechat
   * @param platform 平台，默认 wxMiniPrograms
   * @returns 会员 ID；未绑定返回 0
   */
  async findUserIdByOpenid(openid: string, provider = 'Wechat', platform = 'wxMiniPrograms'): Promise<number> {
    const row: any = await this.dataSource
      .query(
        'SELECT `user_id` FROM `kuerp_user_oauth` WHERE `provider` = ? AND `platform` = ? AND `openid` = ? AND `user_id` > 0 LIMIT 1',
        [provider, platform, openid],
      )
      .then((r: any[]) => r?.[0] ?? null);
    return Number(row?.user_id || 0);
  }

  /**
   * 解除三方绑定（等价 Weixin::unbindThirdOauth）。
   * 需先绑定手机号，避免解绑后无法登录。
   *
   * @param userId 会员 ID
   * @param platform 平台名
   * @param provider 厂商名
   */
  async unbindThirdOauth(userId: number, platform: string, provider: string): Promise<{ ok: boolean; msg?: string }> {
    const user: any = await this.dataSource
      .query('SELECT `mobile` FROM `kuerp_user` WHERE `id` = ? LIMIT 1', [userId])
      .then((r: any[]) => r?.[0] ?? null);
    if (!user) return { ok: false, msg: '未找到相关用户' };
    if (!user.mobile) return { ok: false, msg: '请先绑定手机号再进行解绑操作' };

    await this.dataSource.query('DELETE FROM `kuerp_user_oauth` WHERE `platform` = ? AND `provider` = ? AND `user_id` = ?', [
      platform,
      provider,
      userId,
    ]);
    return { ok: true };
  }

  // ==================================================================
  // 二、微信支付
  // ==================================================================

  /** 读取支付所需配置（appid / mch_id / key / serial 等） */
  private async payCfg(): Promise<any> {
    const rows: any[] = await this.dataSource.query('SELECT `name`,`value` FROM `kuerp_user_sets`');
    const map: Record<string, any> = {};
    for (const r of rows) map[r.name] = r.value;
    return {
      appId: String(map['appid'] || process.env.WX_APPID || ''),
      mchId: String(map['mch_id'] || ''),
      apiKey: String(map['pay_key'] || ''),
      serialNo: String(map['serial_no'] || ''),
      serial: String(map['serial'] || ''),
      orderSend: String(map['order_send'] || '0') === '1',
      notifyUrl:
        String(process.env.PUBLIC_BASE_URL || '').replace(/\/+$/, '') +
        String(process.env.PUBLIC_BASE_URL ? '/shop/index/notify' : '/shop/index/notify'),
    };
  }

  /** 32 位随机串（大写十六进制，等价 bin2hex(random_bytes(16)) 大写） */
  private nonce(): string {
    return randomBytes(16).toString('hex').toUpperCase();
  }

  /**
   * v2 签名（等价 WxPayApi::MakeSign）：参数按 key 升序、k=v& 拼接后拼 &key= 取 MD5 大写。
   *
   * @param params 参与签名的参数
   * @param apiKey 商户 API 密钥
   */
  private signV2(params: Record<string, any>, apiKey: string): string {
    const keys = Object.keys(params)
      .filter((k) => params[k] !== undefined && params[k] !== null && params[k] !== '' && k !== 'sign')
      .sort();
    const str = keys.map((k) => `${k}=${params[k]}`).join('&') + '&key=' + apiKey;
    return createHash('md5').update(str, 'utf8').digest('hex').toUpperCase();
  }

  /** JSAPI 二次签名（等价 `md5("appId=..&nonceStr=..&package=..&signType=MD5&timeStamp=..&key=..")`） */
  private signJsapiV2(appId: string, nonceStr: string, pkg: string, timeStamp: string, apiKey: string): string {
    const str = `appId=${appId}&nonceStr=${nonceStr}&package=${pkg}&signType=MD5&timeStamp=${timeStamp}&key=${apiKey}`;
    return createHash('md5').update(str, 'utf8').digest('hex').toUpperCase();
  }

  /** 生成 XML（v2 请求体） */
  private toXml(params: Record<string, any>): string {
    const body = Object.keys(params)
      .map((k) => `<${k}><![CDATA[${params[k]}]]></${k}>`)
      .join('');
    return `<xml>${body}</xml>`;
  }

  /** 极简 XML 解析（v2 回调，仅处理一层平铺结构） */
  private parseXml(xml: string): Record<string, string> {
    const out: Record<string, string> = {};
    const re = /<(\w+)>(?:<!\[CDATA\[)?([\s\S]*?)(?:\]\]>)?<\/\1>/g;
    let m: RegExpExecArray | null;
    while ((m = re.exec(xml))) out[m[1]] = m[2];
    return out;
  }

  /**
   * v3 签名（等价 Index::generateSign，RSA-SHA256 + base64）。
   *
   * @param message 待签名字符串（含尾部换行）
   * @param privateKeyPem 商户私钥（不含头尾，或含 PEM 头尾均可）
   */
  private signV3(message: string, privateKeyPem: string): string {
    let pem = String(privateKeyPem || '').trim();
    if (!pem.includes('BEGIN')) {
      pem = '-----BEGIN PRIVATE KEY-----\n' + pem.match(/.{1,64}/g)!.join('\n') + '\n-----END PRIVATE KEY-----';
    }
    const signer = createSign('RSA-SHA256');
    signer.update(message, 'utf8');
    return signer.sign(pem, 'base64');
  }

  /**
   * 支付下单（等价 Index::wxpay / Index::wxpays）。
   *
   * @param orderNum 订单号
   * @param userId 会员 ID
   * @returns 小程序 wx.requestPayment 所需的 config
   */
  async pay(
    orderNum: string,
    userId: number,
  ): Promise<{ ok: boolean; msg?: string; data?: any }> {
    const payStatus = await this.dataSource
      .query('SELECT `value` FROM `kuerp_user_config` WHERE `name` = ? LIMIT 1', ['pay_status'])
      .then((r: any[]) => r?.[0]?.value ?? '');
    if (String(payStatus) !== '1') return { ok: false, msg: '系统未开启此功能' };
    if (!orderNum) return { ok: false, msg: '请选择要支付的订单' };

    const order: any = await this.dataSource
      .query(
        'SELECT * FROM `kuerp_user_order` WHERE `order_num` = ? AND `user_id` = ? AND `pay_status` = 0 LIMIT 1',
        [orderNum, userId],
      )
      .then((r: any[]) => r?.[0] ?? null);
    if (!order) return { ok: false, msg: '未找到相关订单' };

    const openid = await this.dataSource
      .query('SELECT `openid` FROM `kuerp_user_oauth` WHERE `user_id` = ? LIMIT 1', [userId])
      .then((r: any[]) => r?.[0]?.openid ?? '');
    if (!openid) return { ok: false, msg: '请先绑定微信或通过微信登陆' };

    const cfg = await this.payCfg();
    const totalFee = Math.round(Number(order.order_price || 0) * 100);

    return cfg.orderSend ? this.payV3(cfg, orderNum, totalFee, openid) : this.payV2(cfg, orderNum, totalFee, openid);
  }

  /**
   * 微信支付 APIv2（JSAPI）下单。
   * @param cfg 支付配置
   * @param orderNum 商户订单号
   * @param totalFee 金额（分）
   * @param openid 用户 openid
   */
  private async payV2(
    cfg: any,
    orderNum: string,
    totalFee: number,
    openid: string,
  ): Promise<{ ok: boolean; msg?: string; data?: any }> {
    if (!cfg.appId || !cfg.mchId || !cfg.apiKey) return { ok: false, msg: '未配置微信支付参数（appid / mch_id / pay_key）' };

    const params: Record<string, any> = {
      appid: cfg.appId,
      mch_id: cfg.mchId,
      nonce_str: this.nonce(),
      body: '订货通付款',
      detail: '订货通付款',
      out_trade_no: orderNum,
      total_fee: totalFee,
      spbill_create_ip: process.env.PUBLIC_IP || '127.0.0.1',
      notify_url: cfg.notifyUrl,
      trade_type: 'JSAPI',
      openid,
    };
    params.sign = this.signV2(params, cfg.apiKey);

    try {
      const res = await fetch('https://api.mch.weixin.qq.com/pay/unifiedorder', {
        method: 'POST',
        headers: { 'Content-Type': 'text/xml; charset=utf-8' },
        body: this.toXml(params),
      });
      const xml = await res.text();
      const data = this.parseXml(xml);
      if (data.return_code !== 'SUCCESS') return { ok: false, msg: '错误：' + (data.return_msg || '下单失败') };
      if (data.result_code !== 'SUCCESS') return { ok: false, msg: '错误：' + (data.err_code_des || '下单失败') };

      const timeStamp = String(this.now());
      const nonceStr = data.nonce_str || this.nonce();
      const pkg = 'prepay_id=' + data.prepay_id;
      return {
        ok: true,
        data: {
          config: {
            appId: cfg.appId,
            nonceStr,
            timeStamp,
            package: pkg,
            paySign: this.signJsapiV2(cfg.appId, nonceStr, pkg, timeStamp, cfg.apiKey),
            signType: 'MD5',
          },
          url: cfg.notifyUrl,
        },
      };
    } catch (e: any) {
      return { ok: false, msg: '错误：' + (e?.message || e) };
    }
  }

  /**
   * 微信支付 APIv3（JSAPI）下单（等价 Index::sendOrder）。
   * @param cfg 支付配置
   * @param orderNum 商户订单号
   * @param totalFee 金额（分）
   * @param openid 用户 openid
   */
  private async payV3(
    cfg: any,
    orderNum: string,
    totalFee: number,
    openid: string,
  ): Promise<{ ok: boolean; msg?: string; data?: any }> {
    if (!cfg.appId || !cfg.mchId || !cfg.serialNo || !cfg.serial) {
      return { ok: false, msg: '未配置 APIv3 参数（app_id / mch_id / serial_no / serial）' };
    }

    const path = '/v3/pay/transactions/jsapi';
    const body = JSON.stringify({
      appid: cfg.appId,
      mchid: cfg.mchId,
      description: '订货通付款',
      out_trade_no: orderNum,
      notify_url: cfg.notifyUrl,
      amount: { total: totalFee, currency: 'CNY' },
      payer: { openid },
    });

    const ts = String(this.now());
    const nonce = this.nonce();
    const message = `POST\n${path}\n${ts}\n${nonce}\n${body}\n`;
    let signature: string;
    try {
      signature = this.signV3(message, cfg.serial);
    } catch (e: any) {
      return { ok: false, msg: '秘钥错误：' + (e?.message || e) };
    }

    const authorization =
      `WECHATPAY2-SHA256-RSA2048 mchid="${cfg.mchId}",nonce_str="${nonce}",` +
      `signature="${signature}",timestamp="${ts}",serial_no="${cfg.serialNo}"`;

    try {
      const res = await fetch('https://api.mch.weixin.qq.com' + path, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          Authorization: authorization,
          'User-Agent': 'kuerp-erp/1.0',
        },
        body,
      });
      const data: any = await res.json();
      if (!data?.prepay_id) return { ok: false, msg: '错误：' + (data?.message || '下单失败') };

      // 二次签名：appId\ntimeStamp\nnonceStr\npackage\n
      const ts2 = String(this.now());
      const nonce2 = this.nonce();
      const pkg = 'prepay_id=' + data.prepay_id;
      let paySign: string;
      try {
        paySign = this.signV3(`${cfg.appId}\n${ts2}\n${nonce2}\n${pkg}\n`, cfg.serial);
      } catch (e: any) {
        return { ok: false, msg: '秘钥错误：' + (e?.message || e) };
      }

      return {
        ok: true,
        data: {
          config: { appId: cfg.appId, timeStamp: ts2, nonceStr: nonce2, package: pkg, signType: 'RSA', paySign },
          url: cfg.notifyUrl,
        },
      };
    } catch (e: any) {
      return { ok: false, msg: '错误：' + (e?.message || e) };
    }
  }

  /**
   * 支付回调（等价 Index::notify）。
   * 支持 v2（XML，MD5 验签）与 v3（JSON，AES-256-GCM 解密）两种报文。
   *
   * 处理逻辑：按 out_trade_no 找到订单 → 置 pay_status=1、pay_time=now、写 pay_info。
   * 返回体按微信要求分别回 v2 XML 或 v3 JSON。
   *
   * @param headers 请求头（v3 需要 Wechatpay-Signature 等，本实现以解密成功为可信依据）
   * @param body 原始报文（已解析的 JSON 或 XML 字符串）
   * @returns { reply, contentType }
   */
  async notify(headers: any, body: any): Promise<{ reply: string; contentType: string }> {
    const cfg = await this.payCfg();
    const isV3 = headers?.['wechatpay-signature'] || headers?.['Wechatpay-Signature'] || typeof body === 'object';

    try {
      if (isV3) {
        const payload = typeof body === 'string' ? JSON.parse(body) : body;
        // 仅处理支付成功事件
        if (payload?.event_type && payload.event_type !== 'TRANSACTION.SUCCESS') {
          return { reply: JSON.stringify({ code: 'SUCCESS', message: '成功' }), contentType: 'application/json' };
        }
        const plain = this.decryptV3Resource(payload?.resource, cfg.apiKey);
        if (!plain) throw new Error('解密失败');
        const trade = JSON.parse(plain);
        if (trade?.trade_state === 'SUCCESS') {
          await this.markPaid(String(trade.out_trade_no || ''), plain);
        }
        return { reply: JSON.stringify({ code: 'SUCCESS', message: '成功' }), contentType: 'application/json' };
      }

      // v2：XML 报文
      const xml = typeof body === 'string' ? body : String(body || '');
      const data = this.parseXml(xml);
      if (data.return_code !== 'SUCCESS' || data.result_code !== 'SUCCESS') {
        return { reply: '<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[失败]]></return_msg></xml>', contentType: 'text/xml' };
      }
      // 验签：重算 sign 与回调一致
      const expect = this.signV2(data, cfg.apiKey);
      if (data.sign && expect !== String(data.sign).toUpperCase()) {
        this.logger.warn('微信支付回调验签失败，已忽略：' + data.out_trade_no);
        return { reply: '<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[签名失败]]></return_msg></xml>', contentType: 'text/xml' };
      }
      await this.markPaid(String(data.out_trade_no || ''), xml);
      return { reply: '<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>', contentType: 'text/xml' };
    } catch (e: any) {
      this.logger.error('支付回调处理异常：' + (e?.message || e));
      return isV3
        ? { reply: JSON.stringify({ code: 'FAIL', message: String(e?.message || 'error') }), contentType: 'application/json' }
        : { reply: '<xml><return_code><![CDATA[FAIL]]></return_code></xml>', contentType: 'text/xml' };
    }
  }

  /**
   * 解密 APIv3 回调的 resource（AES-256-GCM，key 为 APIv3 密钥）。
   *
   * @param resource 回调中的 resource 节点
   * @param apiKey32 APIv3 密钥（32 位）
   * @returns 明文 JSON 字符串；失败返回 null
   */
  private decryptV3Resource(resource: any, apiKey32: string): string | null {
    try {
      if (!resource?.ciphertext || !apiKey32) return null;
      const key = Buffer.from(String(apiKey32), 'utf8');
      const iv = Buffer.from(String(resource.nonce || ''), 'utf8');
      const data = Buffer.from(String(resource.ciphertext), 'base64');
      // GCM 密文尾部 16 字节为 authTag
      const authTag = data.subarray(data.length - 16);
      const ciphertext = data.subarray(0, data.length - 16);
      const decipher = createDecipheriv('aes-256-gcm', key, iv);
      decipher.setAuthTag(authTag);
      if (resource.associated_data) decipher.setAAD(Buffer.from(String(resource.associated_data), 'utf8'));
      return Buffer.concat([decipher.update(ciphertext), decipher.final()]).toString('utf8');
    } catch (e: any) {
      this.logger.error('APIv3 回调解密失败：' + (e?.message || e));
      return null;
    }
  }

  /**
   * 把订单置为已支付（幂等）。
   * @param orderNum 商户订单号
   * @param payInfo 原始支付报文（落库备查）
   */
  private async markPaid(orderNum: string, payInfo: string): Promise<void> {
    if (!orderNum) return;
    const order: any = await this.dataSource
      .query('SELECT `id`,`pay_status` FROM `kuerp_user_order` WHERE `order_num` = ? LIMIT 1', [orderNum])
      .then((r: any[]) => r?.[0] ?? null);
    if (!order) return;
    if (Number(order.pay_status) === 1) return; // 已处理，直接返回

    await this.dataSource.query(
      'UPDATE `kuerp_user_order` SET `pay_status` = 1, `pay_time` = ?, `pay_info` = ?, `updatetime` = ? WHERE `id` = ?',
      [this.now(), String(payInfo).slice(0, 60000), this.now(), order.id],
    );
  }
}
