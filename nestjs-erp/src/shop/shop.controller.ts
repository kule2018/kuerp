import { Body, Controller, Get, Ip, Post, Req, Res } from '@nestjs/common';
import { ShopAuthService, ShopResult } from './shop-auth.service';
import { ShopService } from './shop.service';
import { ShopSmsService } from './shop-sms.service';
import { ShopWechatService } from './shop-wechat.service';

/**
 * 订货通（微信小程序端）接口控制器集合。
 *
 * 路由前缀统一为 `shop`，与原系统 `application/api/controller/kuerp/order/*`
 * 的映射关系（因原系统 `/kuerp/:table/:action` 已被通用 CRUD 控制器占用，
 * 故换用独立前缀，避免路由冲突；方法名与参数完全保持 1:1）：
 *
 *   原 api/kuerp/order/common/init          → POST shop/common/init
 *   原 api/kuerp/order/address/getlist      → POST shop/address/getlist
 *   原 api/kuerp/order/config/getdetail     → POST shop/config/getdetail
 *   原 api/kuerp/order/sms/send             → POST shop/sms/send
 *   原 api/kuerp/order/user/login           → POST shop/user/login
 *   原 api/kuerp/order/weixin/wxpay         → POST shop/weixin/wxMiniProgramOauth
 *   原 api/kuerp/order/index/goodsGoodsList → POST shop/index/goodsGoodsList
 *
 * 响应结构沿用订货通约定：{ code, msg, time, data }，200=成功 / 250=未登录 / 500=失败。
 */

// =====================================================================
// 一、Index（商品 / 购物车 / 订单 / 支付 / 轮播 / 地区）
// =====================================================================

@Controller('shop/index')
export class ShopIndexController {
  constructor(
    private readonly shop: ShopService,
    private readonly auth: ShopAuthService,
    private readonly wechat: ShopWechatService,
  ) {}

  /**
   * 取当前会员（未登录返回 null）。
   * @param req 请求对象
   * @param body 请求体
   */
  private async actor(req: any, body: any): Promise<any | null> {
    return this.auth.init(this.auth.pickToken(req, body));
  }

  /** 组装「请先登陆」响应 */
  private needLogin(): ShopResult {
    return this.auth.err('请先登陆', 250);
  }

  /** 支付配置（等价 Index::getConfig） */
  @Post('getConfig')
  async getConfig() {
    return this.auth.succ('查询成功', await this.shop.payConfig());
  }

  /** 支付下单（等价 Index::wxpays / Index::wxpay，两代接口同一实现） */
  @Post('wxpays')
  async wxpays(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.wechat.pay(String(body?.order_num || ''), Number(user.id));
    return res.ok ? this.auth.succ('成功', res.data) : this.auth.err(res.msg || '支付失败', 400);
  }

  /** 支付下单（v2 入口，逻辑同 wxpays） */
  @Post('wxpay')
  async wxpay(@Body() body: any, @Req() req: any) {
    return this.wxpays(body, req);
  }

  /**
   * 微信支付回调（等价 Index::notify）。
   * 需要把响应体按微信要求返回 XML / JSON，故直接写原始响应。
   */
  @Post('notify')
  async notify(@Body() body: any, @Req() req: any, @Res() res: any) {
    const out = await this.wechat.notify(req.headers || {}, body);
    res.setHeader('Content-Type', out.contentType + '; charset=utf-8');
    res.send(out.reply);
  }

  /** 地区详情（等价 Index::getArea） */
  @Post('getArea')
  async getArea(@Body() body: any) {
    const area = await this.shop.getArea(Number(body?.id || 0));
    return area ? this.auth.succ('查询成功', area) : this.auth.err('查询失败', 500);
  }

  /** 发货地址 / 自提门店列表（等价 Index::address_list） */
  @Post('address_list')
  async addressList(@Body() body: any) {
    return this.auth.succ('查询成功', await this.shop.addressList(body));
  }

  /** 轮播图（等价 Index::banner） */
  @Post('banner')
  async banner(@Body() body: any) {
    const res = await this.shop.banner(body?.type_id);
    return res.ok ? this.auth.succ('查询成功', res.data) : this.auth.err(res.msg || '查询失败', 406);
  }

  /** 商品分类（等价 Index::goodsTypeList） */
  @Post('goodsTypeList')
  async goodsTypeList(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    return this.auth.succ('查询成功', await this.shop.goodsTypeList(body, user));
  }

  /** 商品列表（等价 Index::goodsGoodsList） */
  @Post('goodsGoodsList')
  async goodsGoodsList(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    return this.auth.succ('查询成功', await this.shop.goodsGoodsList(body, user));
  }

  /** 商品详情（等价 Index::goodsGoodsInfo） */
  @Post('goodsGoodsInfo')
  async goodsGoodsInfo(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    const res = await this.shop.goodsGoodsInfo(body, user);
    return res.ok ? this.auth.succ('查询成功', res.data) : this.auth.err(res.msg || '查询失败', 500);
  }

  /** 商品多单位与单位价（等价 Index::getGoodsUnit） */
  @Post('getGoodsUnit')
  async getGoodsUnit(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    return this.auth.succ(
      '查询成功',
      await this.shop.getGoodsUnit(Number(body?.id || 0), body?.goods_unit, body?.goods_attr, user),
    );
  }

  /** 商品辅助属性（等价 Index::getGoodsAuxiliary） */
  @Post('getGoodsAuxiliary')
  async getGoodsAuxiliary(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    return this.auth.succ('查询成功', await this.shop.getGoodsAuxiliary(Number(body?.id || 0), user));
  }

  /** 浏览历史（等价 Index::getHistory） */
  @Post('getHistory')
  async getHistory(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    return this.auth.succ('查询成功', await this.shop.getHistory(body, user));
  }

  /** 购物车数量（等价 Index::getCartNumber） */
  @Post('getCartNumber')
  async getCartNumber(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    return this.auth.succ('查询成功', await this.shop.getCartNumber(Number(user.id)));
  }

  /** 购物车列表（等价 Index::getCart） */
  @Post('getCart')
  async getCart(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const list = await this.shop.getCart(user);
    return list.length ? this.auth.succ('查询成功', list) : this.auth.err('购物车空空如也', 500);
  }

  /** 加入购物车（等价 Index::addCart） */
  @Post('addCart')
  async addCart(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.addCart(body, Number(user.id));
    return res.ok ? this.auth.succ('添加成功', res.data) : this.auth.err(res.msg || '添加失败', 500);
  }

  /** 修改购物车（等价 Index::editCart） */
  @Post('editCart')
  async editCart(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.editCart(body, Number(user.id));
    return res.ok ? this.auth.succ('编辑成功', '') : this.auth.err(res.msg || '编辑失败', 500);
  }

  /** 删除购物车商品（等价 Index::delCart） */
  @Post('delCart')
  async delCart(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.delCart(body, Number(user.id));
    return res.ok ? this.auth.succ('操作成功', '') : this.auth.err(res.msg || '操作失败', 500);
  }

  /** 清空购物车（等价 Index::cancelCart） */
  @Post('cancelCart')
  async cancelCart(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.cancelCart(Number(user.id));
    return res.ok ? this.auth.succ('操作成功', '') : this.auth.err(res.msg || '操作失败', 500);
  }

  /** 商品留言（等价 Index::leaving） */
  @Post('leaving')
  async leaving(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.leaving(body, Number(user.id));
    return res.ok ? this.auth.succ('留言成功', '') : this.auth.err(res.msg || '留言失败', 500);
  }

  /** 创建订货单（等价 Index::createOrder） */
  @Post('createOrder')
  async createOrder(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.createOrder(body, user);
    return res.ok ? this.auth.succ('订单创建成功', res.data) : this.auth.err(res.msg || '订单创建失败', 500);
  }

  /** 订单列表（等价 Index::getOrderList） */
  @Post('getOrderList')
  async getOrderList(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    return this.auth.succ('查询成功', await this.shop.getOrderList(body, user));
  }

  /** 订单详情（等价 Index::orderInfo） */
  @Post('orderInfo')
  async orderInfo(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.orderInfo(body, user);
    return res.ok ? this.auth.succ('查询成功', res.data) : this.auth.err(res.msg || '未找到相关信息', 500);
  }

  /** 确认收货（等价 Index::receiving） */
  @Post('receiving')
  async receiving(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.receiving(body, user);
    return res.ok ? this.auth.succ('确认收货成功', '') : this.auth.err(res.msg || '确认收货失败', 500);
  }

  /** 取消订单（等价 Index::cancelOrder） */
  @Post('cancelOrder')
  async cancelOrder(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.needLogin();
    const res = await this.shop.cancelOrder(body, user);
    return res.ok ? this.auth.succ('取消订单成功', '') : this.auth.err(res.msg || '取消订单失败', 500);
  }
}

// =====================================================================
// 二、Address（会员收货地址 + 地区联动）
// =====================================================================

@Controller('shop/address')
export class ShopAddressController {
  constructor(
    private readonly shop: ShopService,
    private readonly auth: ShopAuthService,
  ) {}

  /** 取当前会员 */
  private async actor(req: any, body: any): Promise<any | null> {
    return this.auth.init(this.auth.pickToken(req, body));
  }

  /** 收货地址列表（等价 Order\Address::getlist） */
  @Post('getlist')
  async getlist(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    return this.auth.succ('查询成功', await this.shop.addrList(body, Number(user.id)));
  }

  /** 收货地址详情（等价 Order\Address::getdetail） */
  @Post('getdetail')
  async getdetail(@Body() body: any, @Req() req: any) {
    const id = Number(body?.id || 0);
    if (!id) return this.auth.err('请输入查询参数', 500);
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const row = await this.shop.addrDetail(id, Number(user.id));
    return row ? this.auth.succ('查询成功', row) : this.auth.err('未找到相关信息', 500);
  }

  /** 新增收货地址（等价 Order\Address::adddetail） */
  @Post('adddetail')
  async adddetail(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const res = await this.shop.addrAdd(body, Number(user.id));
    return res.ok ? this.auth.succ('添加成功', res.data) : this.auth.err(res.msg || '添加失败', 500);
  }

  /** 编辑收货地址（等价 Order\Address::editdetail） */
  @Post('editdetail')
  async editdetail(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const res = await this.shop.addrEdit(body, Number(user.id));
    return res.ok ? this.auth.succ('更新成功', '') : this.auth.err(res.msg || '更新失败', 500);
  }

  /** 删除收货地址（等价 Order\Address::deldetail） */
  @Post('deldetail')
  async deldetail(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const res = await this.shop.addrDel(Number(body?.id || 0), Number(user.id));
    return res.ok ? this.auth.succ('删除成功', '') : this.auth.err(res.msg || '删除失败', 500);
  }

  /** 省市区联动（等价 Order\Address::area） */
  @Post('area')
  async area(@Body() body: any) {
    return this.auth.succ('查询成功', await this.shop.areaList(body));
  }
}

// =====================================================================
// 三、Config（系统配置读取，小程序启动时获取）
// =====================================================================

@Controller('shop/config')
export class ShopConfigController {
  constructor(
    private readonly shop: ShopService,
    private readonly auth: ShopAuthService,
  ) {}

  /** 配置详情（等价 Order\Config::getdetail） */
  @Post('getdetail')
  async getdetail(@Body() body: any) {
    const row = await this.shop.configGetDetail(String(body?.name || ''));
    return this.auth.succ('查询成功', row);
  }

  /** 新增配置（等价 Order\Config::adddetail） */
  @Post('adddetail')
  async adddetail(@Body() body: any) {
    const res = await this.shop.configAddDetail(body);
    return res.ok ? this.auth.succ('添加成功', '') : this.auth.err(res.msg || '添加失败', 500);
  }

  /** 编辑配置（等价 Order\Config::editdetail） */
  @Post('editdetail')
  async editdetail(@Body() body: any) {
    const res = await this.shop.configEditDetail(body);
    return res.ok ? this.auth.succ('更新成功', '') : this.auth.err(res.msg || '更新失败', 500);
  }

  /** 取单个配置值（等价 Order\Config::getSet） */
  @Post('getSet')
  async getSet(@Body() body: any) {
    const res = await this.shop.getSet(String(body?.name || ''));
    return res.ok ? this.auth.succ('查询成功', res.data) : this.auth.err(res.msg || '查询失败', 400);
  }

  /** 批量取订货通配置（等价 Order\Config::getConfig） */
  @Post('getConfig')
  async getConfig(@Body() body: any) {
    const data = await this.shop.setsConfig(body?.name ?? []);
    return Object.keys(data).length ? this.auth.succ('查询成功', data) : this.auth.err('查询失败', 400);
  }
}

// =====================================================================
// 四、Sms（验证码）
// =====================================================================

@Controller('shop/sms')
export class ShopSmsController {
  constructor(
    private readonly sms: ShopSmsService,
    private readonly auth: ShopAuthService,
  ) {}

  /** 发送验证码（等价 Order\Sms::send） */
  @Post('send')
  async send(@Body() body: any, @Ip() ip: string) {
    const mobile = String(body?.mobile || '');
    const event = String(body?.event || 'register');
    const res = await this.sms.send(mobile, event, ip);
    if (!res.ok) return this.auth.err(res.msg, 500);
    // 调试模式下把验证码一并回传（生产必须关闭 SMS_DEBUG）
    return this.auth.succ(res.msg, res.code ? { code: res.code } : '');
  }

  /** 校验验证码（等价 Order\Sms::check，供联调自测） */
  @Post('check')
  async check(@Body() body: any) {
    const pass = await this.sms.check(
      String(body?.mobile || ''),
      String(body?.captcha || ''),
      String(body?.event || 'register'),
    );
    return pass ? this.auth.succ('验证成功', '') : this.auth.err('验证码不正确', 500);
  }
}

// =====================================================================
// 五、User（会员中心）
// =====================================================================

@Controller('shop/user')
export class ShopUserController {
  constructor(
    private readonly shop: ShopService,
    private readonly auth: ShopAuthService,
    private readonly sms: ShopSmsService,
  ) {}

  /** 取当前会员 */
  private async actor(req: any, body: any): Promise<any | null> {
    return this.auth.init(this.auth.pickToken(req, body));
  }

  /** 会员中心欢迎语（等价 Order\User::index） */
  @Post('index')
  async index(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    return this.auth.succ('', { welcome: user?.nickname || '' });
  }

  /** 账号密码登录（等价 Order\User::login） */
  @Post('login')
  async login(@Body() body: any) {
    const res = await this.auth.login(String(body?.account || ''), String(body?.password || ''));
    if (!res.ok) return this.auth.err(res.msg || '登录失败', 500);
    const info: any = this.auth.toUserInfo(res.user);
    if (info) info.avatar = this.shop.cdnUrl(info.avatar);
    return this.auth.succ('登陆成功', { userinfo: info });
  }

  /** 手机验证码登录，未注册则自动注册（等价 Order\User::mobilelogin） */
  @Post('mobilelogin')
  async mobilelogin(@Body() body: any) {
    const mobile = String(body?.mobile || '');
    const captcha = String(body?.captcha || '');
    if (!/^1\d{10}$/.test(mobile)) return this.auth.err('手机号格式错误', 500);

    const pass = await this.sms.check(mobile, captcha, 'mobilelogin');
    if (!pass) return this.auth.err('验证码错误', 500);

    const exist = await this.shop.findUserByMobile(mobile);

    let res: any;
    if (exist) {
      if (exist.status && exist.status !== 'normal') return this.auth.err('账户已禁用', 500);
      res = await this.auth.direct(Number(exist.id));
    } else {
      res = await this.auth.register(mobile, mobile, '', this.auth.randomSalt(12), '', mobile, { binding: 2 });
    }
    if (!res.ok) return this.auth.err(res.msg || '登录失败', 500);

    await this.sms.flush(mobile, 'mobilelogin');
    const info: any = this.auth.toUserInfo(res.user);
    if (info) info.avatar = this.shop.cdnUrl(info.avatar);
    return this.auth.succ('登录成功', { userinfo: info });
  }

  /** 注册会员（等价 Order\User::register） */
  @Post('register')
  async register(@Body() body: any) {
    const mobile = String(body?.mobile || '');
    const password = String(body?.password || '');
    const email = String(body?.email || '');
    const code = String(body?.code || '');
    if (!password) return this.auth.err('请输入密码', 500);
    if (!/^1\d{10}$/.test(mobile)) return this.auth.err('手机号格式错误', 500);
    if (email && !/^[\w.+-]+@[\w-]+\.[\w.-]+$/.test(email)) return this.auth.err('邮箱格式错误', 500);

    const pass = await this.sms.check(mobile, code, 'register');
    if (!pass) return this.auth.err('验证码错误', 500);

    const res = await this.auth.register(mobile, mobile, '', password, email, mobile, { binding: 2 });
    if (!res.ok) return this.auth.err(res.msg || '注册失败', 500);

    await this.sms.flush(mobile, 'register');
    const info: any = this.auth.toUserInfo(res.user);
    if (info) info.avatar = this.shop.cdnUrl(info.avatar);
    return this.auth.succ('注册成功', { userinfo: info });
  }

  /** 退出登录（等价 Order\User::logout） */
  @Post('logout')
  async logout(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (user) await this.auth.logout(Number(user.id));
    return this.auth.succ('退出成功', '');
  }

  /** 修改昵称/头像（等价 Order\User::profile） */
  @Post('profile')
  async profile(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登录', 500);
    const res = await this.shop.updateProfile(Number(user.id), body);
    return res.ok ? this.auth.succ('更新成功', '') : this.auth.err(res.msg || '更新失败', 500);
  }

  /**
   * 修改邮箱（等价 Order\User::changeemail）。
   * 原系统依赖邮件验证码（Ems）插件；本重建库未接邮件通道，
   * 因此仅在 EMAIL_VERIFY_DISABLED=true 时允许直接改，否则提示未开放。
   */
  @Post('changeemail')
  async changeemail(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登录', 500);
    const email = String(body?.email || '');
    if (!/^[\w.+-]+@[\w-]+\.[\w.-]+$/.test(email)) return this.auth.err('邮箱格式错误', 500);
    if (String(process.env.EMAIL_VERIFY_DISABLED || '').toLowerCase() !== 'true') {
      return this.auth.err('邮件验证服务未配置，暂不支持修改邮箱', 500);
    }
    if (await this.shop.emailTaken(email, Number(user.id))) return this.auth.err('邮箱已被占用', 500);
    await this.shop.updateEmail(Number(user.id), email);
    return this.auth.succ('更新成功', '');
  }

  /** 绑定手机号（等价 Order\User::changemobile） */
  @Post('changemobile')
  async changemobile(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const mobile = String(body?.mobile || '');
    const captcha = String(body?.captcha || '');
    if (!/^1\d{10}$/.test(mobile)) return this.auth.err('手机号格式错误', 500);

    const pass = await this.sms.check(mobile, captcha, 'changemobile');
    if (!pass) return this.auth.err('验证码错误', 500);

    const res = await this.shop.bindMobile(Number(user.id), mobile);
    if (!res.ok) return this.auth.err(res.msg || '绑定失败', 500);

    await this.sms.flush(mobile, 'changemobile');
    return this.auth.succ('绑定成功', '');
  }

  /** 重置密码（等价 Order\User::resetpwd） */
  @Post('resetpwd')
  async resetpwd(@Body() body: any) {
    const type = String(body?.type || '');
    const mobile = String(body?.mobile || '');
    const newpassword = String(body?.newpassword || '');
    const captcha = String(body?.captcha || '');
    if (!newpassword || !captcha) return this.auth.err('参数错误', 500);
    if (type !== 'mobile') return this.auth.err('类型错误', 500);
    if (!/^1\d{10}$/.test(mobile)) return this.auth.err('手机号格式错误', 500);

    const user = await this.shop.findUserByMobile(mobile);
    if (!user) return this.auth.err('未找到用户或用户未绑定手机号', 500);

    const pass = await this.sms.check(mobile, captcha, 'resetpwd');
    if (!pass) return this.auth.err('验证码错误', 500);

    await this.sms.flush(mobile, 'resetpwd');
    const res = await this.shop.resetPassword(Number(user.id), newpassword);
    return res.ok ? this.auth.succ('密码修改成功', '') : this.auth.err(res.msg || '修改失败', 500);
  }

  /** 通过 token 取会员信息（等价 Order\User::userInfo） */
  @Post('userInfo')
  async userInfo(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    const info: any = this.auth.toUserInfo(user);
    if (info) info.avatar = this.shop.cdnUrl(info.avatar);
    return this.auth.succ('用户信息', { userinfo: info });
  }
}

// =====================================================================
// 六、Weixin（小程序登录 / 三方绑定）
// =====================================================================

@Controller('shop/weixin')
export class ShopWeixinController {
  constructor(
    private readonly wechat: ShopWechatService,
    private readonly auth: ShopAuthService,
  ) {}

  /** 取当前会员 */
  private async actor(req: any, body: any): Promise<any | null> {
    return this.auth.init(this.auth.pickToken(req, body));
  }

  /**
   * code 换 session_key（等价 Weixin::getWxMiniProgramSessionKey）。
   * body.autoLogin=true 时，若该 openid 已注册则直接登录并回传 token。
   */
  @Post('getWxMiniProgramSessionKey')
  async getSessionKey(@Body() body: any) {
    const res = await this.wechat.code2Session(String(body?.code || ''));
    if (!res.ok) return this.auth.err(res.msg || '登录失败', 401);

    // 已绑定该 openid 的会员可直接登录
    const autoLogin = Boolean(body?.autoLogin);
    if (autoLogin) {
      const userId = await this.wechat.findUserIdByOpenid(String(res.data.openid || ''));
      if (userId) {
        const direct = await this.auth.direct(userId);
        if (direct.ok) {
          return this.auth.succ('登陆成功', {
            token: direct.token,
            session_key: res.data.session_key,
            openid: res.data.openid,
          });
        }
      }
    }
    return this.auth.succ('', {
      openid: res.data.openid,
      session_key: res.data.session_key,
      unionid: res.data.unionid ?? null,
    });
  }

  /** 小程序授权登录（等价 Weixin::wxMiniProgramOauth） */
  @Post('wxMiniProgramOauth')
  async miniProgramOauth(@Body() body: any) {
    const res = await this.wechat.miniProgramOauth(body);
    if (!res.ok) return this.auth.err(res.msg || '登录失败', res.code || 500);
    return this.auth.succ('登陆成功', res.data);
  }

  /** 绑定手机号（等价 Weixin::bind） */
  @Post('bind')
  async bind(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const res = await this.wechat.bind(
      Number(user.id),
      String(body?.mobile || ''),
      String(body?.captcha || ''),
    );
    return res.ok ? this.auth.succ('绑定成功', { token: res.token }) : this.auth.err(res.msg || '绑定失败', 500);
  }

  /** 三方授权信息（等价 Weixin::thirdOauthInfo） */
  @Post('thirdOauthInfo')
  async thirdOauthInfo(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const platform = String(body?.platform || req?.headers?.['platform'] || 'wxMiniPrograms');
    return this.auth.succ('获取成功', await this.wechat.thirdOauthInfo(Number(user.id), platform));
  }

  /** 解除三方绑定（等价 Weixin::unbindThirdOauth） */
  @Post('unbindThirdOauth')
  async unbindThirdOauth(@Body() body: any, @Req() req: any) {
    const user = await this.actor(req, body);
    if (!user) return this.auth.err('请先登陆', 250);
    const res = await this.wechat.unbindThirdOauth(
      Number(user.id),
      String(body?.platform || 'wxMiniPrograms'),
      String(body?.provider || 'Wechat'),
    );
    return res.ok ? this.auth.succ('解绑成功', '') : this.auth.err(res.msg || '解绑失败', 500);
  }
}

// =====================================================================
// 七、Common（小程序初始化）
// =====================================================================

@Controller('shop/common')
export class ShopCommonController {
  constructor(private readonly auth: ShopAuthService) {}

  /**
   * 小程序启动初始化（等价 Order\Common::init）。
   * 原系统返回 citydata/versiondata/uploaddata/coverdata；
   * 本重建库无「版本升级」「云存储」体系，故只回传可用的 cover 配置。
   */
  @Post('init')
  async init(@Body() body: any) {
    if (!body?.version) return this.auth.err('Invalid parameters', 500);
    return this.auth.succ('', { citydata: null, versiondata: null, uploaddata: null, coverdata: null });
  }

  /** 健康检查（便于小程序端联调确认服务可达） */
  @Get('ping')
  ping() {
    return this.auth.succ('pong', { time: Math.floor(Date.now() / 1000) });
  }
}
