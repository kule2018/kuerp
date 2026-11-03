#!/usr/bin/env node
/**
 * 接口文档生成器：扫描 src/**\/*.controller.ts，产出 docs/API.md。
 *
 * 【为什么要自动生成而不是手写】
 * 本项目有十余个控制器、两百多个接口，并且通用表接口（/kuerp/:table/*）
 * 是「一个控制器覆盖 159 张表」的形态。手写文档必然与代码脱节，
 * 一个月后没人敢信它。生成的文档可以随时 `npm run docs:api` 重跑，
 * 与代码同源，天然不会说谎。
 *
 * 【解析策略】
 * 不引 TypeScript 编译器（避免为一个脚本增加依赖），改用「正则 + 邻近扫描」：
 *   1. @Controller('x')            → 路由前缀
 *   2. 类上 @UseGuards(...)        → 鉴权方式（有 JwtAuthGuard 即需登录）
 *   3. @Get/@Post/@Put/@Patch/@Delete → 具体接口
 *   4. 紧邻其上的 /** ... *\/      → 接口说明（取第一行正文）
 *   5. 方法签名的 @Body/@Query/@Param → 入参来源
 * 对装饰器写法做了容错：单引号/双引号/反引号、无参数 @Get()、跨行签名。
 *
 * 用法：node scripts/gen-api-doc.js [输出路径]
 * 返回：无（副作用为写文件，并在控制台打印统计）
 */
const fs = require('fs');
const path = require('path');

const SRC_DIR = path.join(__dirname, '..', 'src');
const OUT_FILE = process.argv[2]
  ? path.resolve(process.argv[2])
  : path.join(__dirname, '..', 'docs', 'API.md');

/** 递归收集控制器文件 */
function walk(dir, acc = []) {
  for (const name of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, name.name);
    if (name.isDirectory()) walk(full, acc);
    else if (name.name.endsWith('.controller.ts')) acc.push(full);
  }
  return acc;
}

/**
 * 从装饰器位置向前找最近的 JSDoc 注释，取首个非空正文行作为说明。
 * @param {string} text 文件全文
 * @param {number} pos 装饰器起始下标
 * @returns {string} 说明文案（找不到则空串）
 */
function docSummaryBefore(text, pos) {
  const head = text.slice(0, pos);
  const start = head.lastIndexOf('/**');
  if (start < 0) return '';
  const end = head.indexOf('*/', start);
  if (end < 0) return '';
  // 严格相邻判定：注释结尾到装饰器之间不应出现语句结束符（} 或 ;）。
  // 出现了说明中间隔着上一个方法/字段，这段注释属于别人，
  // 拿它当本接口说明会让文档「看起来很全、其实是错的」，比留空更有害。
  const between = head.slice(end + 2);
  if (/[};]/.test(between) || between.length > 400) return '';
  const body = head.slice(start + 3, end);
  const lines = body
    .split('\n')
    .map((l) => l.replace(/^\s*\*\s?/, '').trim())
    .filter((l) => l && !l.startsWith('@'));
  return lines[0] || '';
}

/**
 * 解析单个控制器文件。
 * @param {string} file 绝对路径
 * @returns {{base:string, file:string, auth:string, routes:Array}}
 */
function parseController(file) {
  const text = fs.readFileSync(file, 'utf8');
  const baseMatch = text.match(/@Controller\(\s*(?:['"`]([^'"`]*)['"`])?\s*\)/);
  const base = baseMatch ? baseMatch[1] || '' : '';

  // 类级鉴权：取 export class 之前的 @UseGuards(...)
  const classPos = text.search(/export\s+class\s+\w+Controller/);
  const classHead = classPos > 0 ? text.slice(0, classPos) : text;
  const classGuards = [...classHead.matchAll(/@UseGuards\(([^)]*)\)/g)]
    .map((m) => m[1])
    .join(',');

  /**
   * 把守卫表达式翻译成人话。
   *
   * 注意必须合并「类级」与「方法级」两处：
   * 像 AuthController 这类控制器是类上不挂守卫、每个需要鉴权的方法单独挂，
   * 只看类级会把 /auth/profile 之类标成「公开」，是明确的错文档。
   *
   * @param {string} g 守卫表达式串（可能为空）
   * @returns {string} 鉴权描述
   */
  const describeGuards = (g) => {
    if (/JwtAuthGuard/.test(g) && /RbacGuard/.test(g)) return '登录 + 权限节点';
    if (/JwtAuthGuard/.test(g)) return '登录';
    return g.trim() ? g.trim() : '公开';
  };

  // 逐个匹配 HTTP 方法装饰器
  const routes = [];
  const re = /@(Get|Post|Put|Patch|Delete)\(\s*(?:['"`]([^'"`]*)['"`])?\s*\)/g;
  let m;
  while ((m = re.exec(text)) !== null) {
    const verb = m[1].toUpperCase();
    const sub = m[2] || '';
    const after = text.slice(m.index + m[0].length, m.index + m[0].length + 1200);
    // 跳过装饰器参数，定位方法名
    const sig = after.match(/\n\s+(?:(?:public|private|protected|async)\s+)*([A-Za-z_$][\w$]*)\s*\(/);
    const method = sig ? sig[1] : '';
    // 从方法名位置取括号内的参数串（允许跨行）
    let params = '';
    if (sig) {
      const parenStart = after.indexOf('(', sig.index);
      if (parenStart >= 0) {
        let depth = 0;
        for (let i = parenStart; i < after.length; i++) {
          if (after[i] === '(') depth++;
          else if (after[i] === ')') {
            depth--;
            if (depth === 0) {
              params = after.slice(parenStart + 1, i);
              break;
            }
          }
        }
      }
    }
    const rawSources = [...params.matchAll(/@(Body|Query|Param|Headers|CurrentUser|UploadedFile|Req)\(\s*(?:['"`]([^'"`]*)['"`])?/g)]
      .map((s) => (s[2] ? `${s[1]}(${s[2]})` : s[1]))
      .filter((v, i, arr) => arr.indexOf(v) === i);
    // 同一来源既有字段级（Body(id)）又有整体级（Body）时，只保留更精确的写法
    const detailed = new Set(rawSources.filter((v) => v.includes('(')).map((v) => v.split('(')[0]));
    const sources = rawSources.filter((v) => v.includes('(') || !detailed.has(v));

    // 方法级守卫：取「上一个成员结束（}）到本装饰器」之间的 @UseGuards
    const prevBrace = text.lastIndexOf('}', m.index);
    const localSegment = prevBrace > 0 ? text.slice(prevBrace + 1, m.index) : '';
    const localGuards = [...localSegment.matchAll(/@UseGuards\(([^)]*)\)/g)]
      .map((g) => g[1])
      .join(',');

    routes.push({
      verb,
      path: '/' + [base, sub].filter(Boolean).join('/'),
      method,
      summary: docSummaryBefore(text, m.index),
      params: sources.join('、'),
      // 方法级守卫优先于类级：单独挂 RbacGuard 的方法不应被写成「仅登录」
      auth: describeGuards(localGuards || classGuards),    });
  }

  // 开放对接接口不用 JWT，而是「账号 + 签名」校验（由 OpenApiService 内部完成），
  // 只按守卫推断会被误标成「公开」，必须显式覆盖。
  if (base.startsWith('openapi')) {
    for (const r of routes) r.auth = '开放接口（账号 + 签名）';
  }

  // 控制器整体鉴权口径：取所有接口中最严格的一档，用于小节标题展示
  const rank = { 公开: 0, 登录: 1, '登录 + 权限节点': 2 };
  const auth = routes.reduce(
    (acc, r) => ((rank[r.auth] ?? 1) > (rank[acc] ?? 0) ? r.auth : acc),
    '公开',
  );

  return { base: '/' + base, file: path.relative(path.join(__dirname, '..'), file), auth, routes };
}

/**
 * 主流程：扫描 → 生成 Markdown → 写盘。
 * @returns 无
 */
function main() {
  const files = walk(SRC_DIR).sort();
  const controllers = files.map(parseController).filter((c) => c.routes.length);
  const total = controllers.reduce((s, c) => s + c.routes.length, 0);

  const out = [];
  out.push('# 进销存 ERP 后端接口文档');
  out.push('');
  out.push('> 本文件由 `npm run docs:api`（`scripts/gen-api-doc.js`）从控制器源码自动生成，**请勿手工编辑**。');
  out.push('> 修改接口后重新执行即可同步。');
  out.push('');
  out.push('## 总览');
  out.push('');
  out.push('| 指标 | 数值 |');
  out.push('| --- | --- |');
  out.push(`| 控制器 | ${controllers.length} |`);
  out.push(`| 接口总数 | ${total} |`);
  out.push(`| 生成时间 | ${new Date().toLocaleString('zh-CN', { hour12: false })} |`);
  out.push('');
  out.push('统一约定：');
  out.push('');
  out.push('- 响应体固定为 `{ code, msg, data }`，`code = 1` 表示成功（与原 FastAdmin 一致）；');
  out.push('- 业务表接口形如 `/kuerp/<表名>/<动作>`，表名用连字符（`goods-type`）或下划线均可；');
  out.push('- 通用表动作固定为 `index / get / columns / options / add / edit / del / examine / import / export / recyclebin / reduction / realdel / counter / truncate`；');
  out.push('- 时间戳统一为秒级整数（`createtime` / `updatetime` / `deletetime`），`deletetime > 0` 表示软删除。');
  out.push('');

  // 按前缀分组，便于按模块查阅
  out.push('## 接口清单');
  out.push('');
  for (const c of controllers) {
    out.push(`### ${c.base}　<span>（${c.auth}）</span>`);
    out.push('');
    out.push(`源码：\`${c.file}\``);
    out.push('');
    out.push('| 方法 | 路径 | 方法名 | 鉴权 | 入参来源 | 说明 |');
    out.push('| --- | --- | --- | --- | --- | --- |');
    for (const r of c.routes) {
      out.push(
        `| ${r.verb} | \`${r.path}\` | ${r.method} | ${r.auth} | ${r.params || '-'} | ${r.summary || '-'} |`,
      );
    }
    out.push('');
  }

  fs.mkdirSync(path.dirname(OUT_FILE), { recursive: true });
  fs.writeFileSync(OUT_FILE, out.join('\n'), 'utf8');
  console.log(`已生成接口文档：${OUT_FILE}`);
  console.log(`控制器 ${controllers.length} 个，接口 ${total} 个`);
}

main();
