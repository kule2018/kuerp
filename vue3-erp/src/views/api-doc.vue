<template>
  <div class="api-doc">
    <header class="api-doc__head">
      <h2>{{ doc.title }}</h2>
      <code class="api-doc__base">{{ doc.base }}</code>
    </header>

    <p class="api-doc__desc">{{ doc.desc }}</p>

    <!-- 总控/签名鉴权说明 -->
    <template v-if="doc.sign">
      <div class="api-doc__card">
        <h3>公共参数（每个接口必传）</h3>
        <ul class="api-doc__params">
          <li v-for="p in doc.signParams" :key="p"><code>{{ p }}</code></li>
        </ul>
        <h3>签名规则</h3>
        <p class="api-doc__hint">
          取接口对应的「参与签名参数」组成数组，逐字段 <code>trim</code> 后按键名小写、
          字典序 (ksort) 排序，拼接为 <code>k=v</code> 用 <code>&amp;</code> 连接，
          末尾追加 <code>key=&lt;salt&gt;</code>，对整体取 <code>MD5</code> 得到 <code>sign</code>。
          请求时间 <code>request_time</code> 与服务器误差须小于 300 秒，否则返回「无效请求(23)」。
        </p>
        <table class="api-doc__table">
          <thead>
            <tr><th>接口</th><th>参与签名参数</th></tr>
          </thead>
          <tbody>
            <tr v-for="r in doc.signRules" :key="r.api">
              <td><code>{{ r.api }}</code></td>
              <td>{{ r.params }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>

    <!-- 接口列表 -->
    <template v-else>
      <table class="api-doc__table">
        <thead>
          <tr><th style="width:90px">方法</th><th>接口路径</th><th>说明</th></tr>
        </thead>
        <tbody>
          <tr v-for="e in doc.endpoints" :key="e.action">
            <td><span class="api-doc__method" :class="e.method === 'GET' ? 'is-get' : 'is-post'">{{ e.method }}</span></td>
            <td><code>{{ doc.base }}/{{ e.action }}</code></td>
            <td>{{ e.note }}</td>
          </tr>
        </tbody>
      </table>
    </template>

    <footer class="api-doc__foot">
      响应结构：<code>{ code, msg, time, data }</code>
      （code: 1/200=成功，250=未登录，20=接口地址错误，21=账户不存在，22=账户异常，23=无效请求，24=签名错误，25=参数错误，27=业务失败）。
      后端实现：<code>nestjs-erp/src/shop/*</code> 与 <code>nestjs-erp/src/openapi/*</code>。
    </footer>
  </div>
</template>

<script setup>
/**
 * API 接口说明页（只读参考）。
 * 由后台菜单「接口管理」分组下的各控制器叶子节点驱动，
 * 通过 route.meta.docKey 取内置接口字典渲染，不调用任何业务接口。
 */
import { computed } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();

// 各控制器接口字典（与原系统 api/kuerp/order/* 与 api/kuerp/third/* 1:1 对齐）
const DOCS = {
  'order-index': {
    title: 'Index · 商品/订单/支付',
    base: '/shop/index',
    desc: '小程序商城核心接口：商品浏览、购物车、订货单、微信支付、轮播与地区。',
    endpoints: [
      { method: 'POST', action: 'getConfig', note: '支付配置' },
      { method: 'POST', action: 'wxpays', note: '微信支付下单（v1）' },
      { method: 'POST', action: 'wxpay', note: '微信支付下单（v2 入口）' },
      { method: 'POST', action: 'notify', note: '微信支付回调' },
      { method: 'POST', action: 'getArea', note: '地区详情' },
      { method: 'POST', action: 'address_list', note: '发货地址 / 自提门店列表' },
      { method: 'POST', action: 'banner', note: '轮播图' },
      { method: 'POST', action: 'goodsTypeList', note: '商品分类' },
      { method: 'POST', action: 'goodsGoodsList', note: '商品列表' },
      { method: 'POST', action: 'goodsGoodsInfo', note: '商品详情' },
      { method: 'POST', action: 'getGoodsUnit', note: '商品多单位与单位价' },
      { method: 'POST', action: 'getGoodsAuxiliary', note: '商品辅助属性' },
      { method: 'POST', action: 'getHistory', note: '浏览历史' },
      { method: 'POST', action: 'getCartNumber', note: '购物车数量' },
      { method: 'POST', action: 'getCart', note: '购物车列表' },
      { method: 'POST', action: 'addCart', note: '加入购物车' },
      { method: 'POST', action: 'editCart', note: '修改购物车' },
      { method: 'POST', action: 'delCart', note: '删除购物车商品' },
      { method: 'POST', action: 'cancelCart', note: '清空购物车' },
      { method: 'POST', action: 'leaving', note: '商品留言' },
      { method: 'POST', action: 'createOrder', note: '创建订货单' },
      { method: 'POST', action: 'getOrderList', note: '订单列表' },
      { method: 'POST', action: 'orderInfo', note: '订单详情' },
      { method: 'POST', action: 'receiving', note: '确认收货' },
      { method: 'POST', action: 'cancelOrder', note: '取消订单' },
    ],
  },
  'order-user': {
    title: 'User · 会员',
    base: '/shop/user',
    desc: '小程序会员中心：登录、注册、资料与手机/邮箱绑定。',
    endpoints: [
      { method: 'POST', action: 'index', note: '会员中心欢迎语' },
      { method: 'POST', action: 'login', note: '账号密码登录' },
      { method: 'POST', action: 'mobilelogin', note: '手机验证码登录 / 自动注册' },
      { method: 'POST', action: 'register', note: '注册会员' },
      { method: 'POST', action: 'logout', note: '退出登录' },
      { method: 'POST', action: 'profile', note: '修改昵称 / 头像' },
      { method: 'POST', action: 'changeemail', note: '修改邮箱' },
      { method: 'POST', action: 'changemobile', note: '绑定手机号' },
      { method: 'POST', action: 'resetpwd', note: '重置密码' },
      { method: 'POST', action: 'userInfo', note: '取会员信息' },
    ],
  },
  'order-weixin': {
    title: 'Weixin · 微信',
    base: '/shop/weixin',
    desc: '小程序微信登录、会话密钥换取与三方授权绑定。',
    endpoints: [
      { method: 'POST', action: 'getWxMiniProgramSessionKey', note: 'code 换 session_key' },
      { method: 'POST', action: 'wxMiniProgramOauth', note: '小程序授权登录' },
      { method: 'POST', action: 'bind', note: '绑定手机号' },
      { method: 'POST', action: 'thirdOauthInfo', note: '三方授权信息' },
      { method: 'POST', action: 'unbindThirdOauth', note: '解除三方绑定' },
    ],
  },
  'order-sms': {
    title: 'Sms · 短信',
    base: '/shop/sms',
    desc: '验证码发送与校验（注册 / 登录 / 改绑）。',
    endpoints: [
      { method: 'POST', action: 'send', note: '发送验证码' },
      { method: 'POST', action: 'check', note: '校验验证码' },
    ],
  },
  'order-address': {
    title: 'Address · 地址',
    base: '/shop/address',
    desc: '会员收货地址管理与省市区联动。',
    endpoints: [
      { method: 'POST', action: 'getlist', note: '收货地址列表' },
      { method: 'POST', action: 'getdetail', note: '收货地址详情' },
      { method: 'POST', action: 'adddetail', note: '新增收货地址' },
      { method: 'POST', action: 'editdetail', note: '编辑收货地址' },
      { method: 'POST', action: 'deldetail', note: '删除收货地址' },
      { method: 'POST', action: 'area', note: '省市区联动' },
    ],
  },
  'order-config': {
    title: 'Config · 配置',
    base: '/shop/config',
    desc: '小程序启动时读取 / 维护订货通配置。',
    endpoints: [
      { method: 'POST', action: 'getdetail', note: '配置详情' },
      { method: 'POST', action: 'adddetail', note: '新增配置' },
      { method: 'POST', action: 'editdetail', note: '编辑配置' },
      { method: 'POST', action: 'getSet', note: '取单个配置值' },
      { method: 'POST', action: 'getConfig', note: '批量取订货通配置' },
    ],
  },
  'order-common': {
    title: 'Common · 通用',
    base: '/shop/common',
    desc: '小程序初始化与健康检查。',
    endpoints: [
      { method: 'POST', action: 'init', note: '小程序初始化' },
      { method: 'GET', action: 'ping', note: '健康检查' },
    ],
  },
  'third-thirds': {
    title: 'Thirds · 总控（签名鉴权）',
    base: '/openapi/third',
    desc: '第三方对接总控：所有 third 接口的统一签名校验入口（等价原系统 Thirds.php）。',
    sign: true,
    signParams: ['account 开放平台账号', 'sign 签名串（MD5）', 'request_time 请求时间戳（与服务器误差 < 300 秒）'],
    signRules: [
      { api: 'goods/goodsTypeList', params: 'account' },
      { api: 'goods/getGoodsList', params: 'account' },
      { api: 'goods/getGoodsInfo', params: 'account, id' },
      { api: 'customers/getSalesList', params: 'account' },
      { api: 'customers/getCustomersList', params: 'account' },
      { api: 'customers/joinCustomers', params: 'account, name, mobile' },
      { api: 'customers/customersInfo', params: 'account, mobile' },
      { api: 'customers/editCustomers', params: 'account, code, name, mobile' },
      { api: 'customers/delCustomers', params: 'account, mobile' },
      { api: 'sales/getSalesList', params: 'account' },
      { api: 'sales/sales', params: 'account, order_num, mobile, goods' },
      { api: 'sales/salesInfo', params: 'account, purchase_code' },
      { api: 'sales/returnSales', params: 'account, order_num, mobile, goods' },
      { api: 'sales/returnSalesInfo', params: 'account, purchase_code' },
    ],
  },
  'third-goods': {
    title: 'Goods · 商品',
    base: '/openapi/third/goods',
    desc: '三方系统拉取商品分类 / 列表 / 详情（含多单位与库存）。',
    endpoints: [
      { method: 'POST', action: 'goodsTypeList', note: '商品分类列表' },
      { method: 'POST', action: 'getGoodsList', note: '商品列表（分页）' },
      { method: 'POST', action: 'getGoodsInfo', note: '商品详情' },
    ],
  },
  'third-customers': {
    title: 'Customers · 客户',
    base: '/openapi/third/customers',
    desc: '三方系统查询 / 维护客户与职员。',
    endpoints: [
      { method: 'POST', action: 'getSalesList', note: '职员（业务员）列表' },
      { method: 'POST', action: 'getCustomersList', note: '客户列表（分页）' },
      { method: 'POST', action: 'joinCustomers', note: '添加客户' },
      { method: 'POST', action: 'customersInfo', note: '客户详情' },
      { method: 'POST', action: 'editCustomers', note: '编辑客户' },
      { method: 'POST', action: 'delCustomers', note: '注销客户' },
    ],
  },
  'third-sales': {
    title: 'Sales · 销货',
    base: '/openapi/third/sales',
    desc: '三方系统下单 / 退货 / 查单（自动生成单号并过账）。',
    endpoints: [
      { method: 'POST', action: 'getSalesList', note: '销货单列表（分页）' },
      { method: 'POST', action: 'sales', note: '新增销货单（含明细）' },
      { method: 'POST', action: 'salesInfo', note: '销货单详情' },
      { method: 'POST', action: 'returnSales', note: '新增销货退货单' },
      { method: 'POST', action: 'returnSalesInfo', note: '销货退货单详情' },
    ],
  },
};

const doc = computed(() => DOCS[route.meta.docKey] || { title: '接口说明', base: '', desc: '未找到该接口的说明配置。', endpoints: [] });
</script>

<style scoped>
.api-doc {
  padding: 20px 24px;
  max-width: 960px;
  margin: 0 auto;
  color: #1f2329;
}
.api-doc__head {
  display: flex;
  align-items: baseline;
  gap: 12px;
  flex-wrap: wrap;
}
.api-doc__head h2 {
  margin: 0;
  font-size: 20px;
}
.api-doc__base {
  background: #f2f3f5;
  border-radius: 4px;
  padding: 2px 8px;
  font-size: 13px;
  color: #646a73;
}
.api-doc__desc {
  color: #646a73;
  margin: 8px 0 18px;
  line-height: 1.6;
}
.api-doc__card {
  border: 1px solid #e5e6eb;
  border-radius: 8px;
  padding: 16px 18px;
  background: #fafbfc;
}
.api-doc__card h3 {
  margin: 14px 0 8px;
  font-size: 15px;
}
.api-doc__card h3:first-child {
  margin-top: 0;
}
.api-doc__params {
  margin: 0;
  padding-left: 18px;
  line-height: 1.9;
}
.api-doc__hint {
  color: #646a73;
  line-height: 1.7;
  font-size: 13px;
}
.api-doc__table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 6px;
  background: #fff;
  border: 1px solid #e5e6eb;
  border-radius: 8px;
  overflow: hidden;
  font-size: 14px;
}
.api-doc__table th,
.api-doc__table td {
  text-align: left;
  padding: 10px 14px;
  border-bottom: 1px solid #f0f1f3;
}
.api-doc__table th {
  background: #f7f8fa;
  font-weight: 600;
  color: #1f2329;
}
.api-doc__table tr:last-child td {
  border-bottom: none;
}
.api-doc__table code {
  background: #f2f3f5;
  padding: 1px 6px;
  border-radius: 4px;
  font-size: 12.5px;
  color: #2a2f36;
}
.api-doc__method {
  display: inline-block;
  min-width: 46px;
  text-align: center;
  font-size: 12px;
  font-weight: 600;
  padding: 2px 6px;
  border-radius: 4px;
  color: #fff;
}
.api-doc__method.is-post {
  background: #2f7d34;
}
.api-doc__method.is-get {
  background: #1f6feb;
}
.api-doc__foot {
  margin-top: 18px;
  color: #8a9099;
  font-size: 12.5px;
  line-height: 1.7;
}
.api-doc__foot code {
  background: #f2f3f5;
  padding: 1px 5px;
  border-radius: 4px;
}
</style>
