/**
 * 后端装配冒烟测试（无需真实数据库）：
 * 1. 用桩 DataSource 覆盖 TypeORM，编译整个 AppModule —— 验证全部
 *    控制器/服务/守卫的依赖注入接线是否正确（如 RbacGuard 是否可解析）；
 * 2. 打印 Express 实际注册的路由表 —— 核对 /kuerp/:table/* 全量接口是否挂载；
 * 3. 任一环节失败即以非零码退出，可接入 CI。
 *
 * 运行：node scripts/smoke.js
 */
const { Test } = require('@nestjs/testing');
const { DataSource } = require('typeorm');
// 装饰器元数据依赖：main.ts 会导入，但本脚本直接 require dist 模块，必须在此提前加载
require('reflect-metadata');

(async () => {
  // 桩 DataSource：启动期不触库（各服务仅在请求处理时才会 query）。
  // 注意：@nestjs/typeorm 的 repository provider 工厂会读 entityMetadatas/getRepository，
  // 这些字段必须存在（可返回空值），否则 provider 实例化即抛错。
  // 桩 repository 需覆盖常用方法，保证 SystemService.seedDefaultAdmin 等
  // onModuleInit 钩子可完整走通（不触库、返回合理空值）。
  const makeRepo = () => ({
    count: async () => 0,
    findOne: async () => null,
    find: async () => [],
    findBy: async () => [],
    save: async (e) => e,
    create: (e) => e,
    update: async () => ({ affected: 1 }),
    delete: async () => ({ affected: 1 }),
    insert: async () => ({ raw: [] }),
    createQueryBuilder: () => {
      const q = {
        where: () => q, andWhere: () => q, orWhere: () => q,
        orderBy: () => q, addOrderBy: () => q, skip: () => q, take: () => q,
        leftJoin: () => q, innerJoin: () => q, leftJoinAndSelect: () => q,
        select: () => q, addSelect: () => q, groupBy: () => q, having: () => q,
        limit: () => q, offset: () => q, setParameter: () => q, setParameters: () => q,
        getMany: async () => [],
        getOne: async () => null,
        getManyAndCount: async () => [[], 0],
        getCount: async () => 0,
        getRawMany: async () => [],
        execute: async () => ({ affected: 0 }),
      };
      return q;
    },
  });
  const stub = {
    options: { type: 'mysql' },
    query: async () => [],
    entityMetadatas: [],
    manager: makeRepo(),
    getRepository: () => makeRepo(),
    getTreeRepository: () => makeRepo(),
    getMongoRepository: () => makeRepo(),
  };

  const { AppModule } = require('../dist/app.module');

  // —— 调试探针：compile 前后的实体注册状态 ——
  const dumpStorage = (tag) => {
    const g = global.typeormMetadataArgsStorage;
    console.log(
      `[probe ${tag}] storage=${typeof g} tables=${
        g && g.tables ? g.tables.length : 'UNDEFINED'
      } entities=${g && g.tables ? g.tables.map((t) => t.target && t.target.name).join(',') : '-'}`,
    );
  };
  dumpStorage('before-compile');

  const mod = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(DataSource)
    .useValue(stub)
    .compile();
  dumpStorage('after-compile');

  const app = await mod.createNestApplication();
  await app.init();

  // —— 提取 Express 路由（含子路由挂载前缀）——
  const server = app.getHttpAdapter && app.getHttpAdapter().getInstance
    ? app.getHttpAdapter().getInstance()
    : app.getHttpServer();
  const routes = [];
  const walk = (stack, prefix) => {
    (stack || []).forEach((l) => {
      if (l.route) {
        const methods = Object.keys(l.route.methods || {}).map((m) => m.toUpperCase()).join(',');
        routes.push(`${methods.padEnd(20)} ${prefix}${l.route.path}`);
      } else if (l.name === 'router' && l.handle && l.handle.stack) {
        // Express 4 挂载点：从 regexp 还原前缀（如 /^\/kuerp\/?(?=\/|$)/）
        let mount = '';
        const m = /^\/\^\\\/([a-z0-9_\-]+)\\\/\?/.exec(l.regexp && l.regexp.source);
        if (m) mount = `/${m[1]}`;
        walk(l.handle.stack, prefix + mount);
      }
    });
  };
  walk(server._router ? server._router.stack : [], '');

  const kuerpRoutes = routes.filter((r) => r.includes('/kuerp/')).sort();
  const otherRoutes = routes.filter((r) => !r.includes('/kuerp/')).sort();

  console.log('=== DI 编译成功，应用启动无异常 ===');
  console.log(`\n=== 路由总数: ${routes.length}（/kuerp 业务 ${kuerpRoutes.length}，框架 ${otherRoutes.length}）===\n`);
  console.log('--- /kuerp 业务接口 ---');
  kuerpRoutes.forEach((r) => console.log('  ' + r));
  console.log('\n--- 框架接口 ---');
  otherRoutes.forEach((r) => console.log('  ' + r));

  await app.close();

  // —— 关键接口断言：原系统标准动作必须全部挂载 ——
  const mustHave = [
    'GET /kuerp/:table/index',
    'GET /kuerp/:table/get',
    'GET /kuerp/:table/columns',
    'GET /kuerp/:table/recyclebin',
    'POST /kuerp/:table/add',
    'POST /kuerp/:table/edit',
    'POST /kuerp/:table/del',
    'DELETE /kuerp/:table/del',
    'POST /kuerp/:table/reduction',
    'POST /kuerp/:table/realdel',
    'POST /kuerp/:table/import',
    'POST /kuerp/:table/examine',
    'POST /kuerp/:table/counter',
    'POST /kuerp/initialize',
    'GET /kuerp/tables',
    'GET /kuerp/tables/stats',
    'GET /kuerp/checkout/current',
    'POST /kuerp/checkout/settle',
    'POST /kuerp/checkout/unsettle',
    'GET /kuerp/prefix/gen-code',
    'POST /kuerp/sets/prefix-save',
    'GET /kuerp/statistics/dashboard',
    'GET /kuerp/boards/replenishment',
    'GET /kuerp/boards/purchaseby',
    'POST /kuerp/boards/generate',
    'POST /kuerp/funds/post',
    'POST /kuerp/funds/unpost',
    'POST /auth/login',
  ];
  const norm = (s) => s.replace(/\s+/g, ' ').trim();
  const missing = mustHave.filter((m) => !routes.some((r) => norm(r) === norm(m)));
  if (missing.length) {
    console.error('\n❌ 缺少关键接口:', missing);
    process.exit(1);
  }
  console.log('\n✅ 关键接口断言全部通过（' + mustHave.length + ' 项）');
  process.exit(0);
})().catch((e) => {
  console.error('❌ SMOKE FAIL:', e && e.message ? e.message : e);
  if (e && e.stack) console.error(e.stack.split('\n').slice(0, 15).join('\n'));
  process.exit(1);
});
