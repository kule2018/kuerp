/**
 * 检测 node_modules 中被写坏的包（本环境 npm install 被中断会丢文件）。
 * 方法：对 package.json 直接依赖逐个 require()，收集加载失败清单。
 *
 * 用法：node scripts/detect-broken.js
 * 输出：每行一个损坏包名（含版本探测），供 fix-pkgs.js 批量修复。
 */
const fs = require('fs');
const path = require('path');
const Module = require('module');

const root = path.resolve(__dirname, '..');
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
const deps = Object.keys(pkg.dependencies || {});

// 关键传递依赖（Nest/Express 运行时链，不在 dependencies 里但必须可用）
const extra = [
  'express', 'qs', 'side-channel', 'object-inspect', 'iconv-lite', 'iterare',
  'tslib', 'uuid', 'raw-body', 'bytes', 'body-parser', 'raw-body',
  'readable-stream', 'bl', 'buffer', 'ieee754', 'inherits', 'process-nextick-args',
  'safe-buffer', 'string_decoder', 'util-deprecate', 'setprototypeof',
  'statuses', 'mime-types', 'mime-db', 'destroy', 'encodeurl', 'escape-html',
  'etag', 'fresh', 'http-errors', 'merge-descriptors', 'methods', 'path-to-regexp',
  'proxy-addr', 'range-parser', 'send', 'serve-static', 'type-is', 'vary',
  'content-disposition', 'cookie', 'cookie-signature', 'debug', 'depd',
  'finalhandler', 'forwarded', 'ipaddr.js', 'media-typer', 'negotiator',
  'on-finished', 'parseurl', 'qs', 'router', 'utils-merge', 'array-flatten',
];

const all = Array.from(new Set([...deps, ...extra]));
const broken = [];
const ok = [];

for (const name of all) {
  try {
    // 绕过 require 缓存，确保真实加载
    const resolved = require.resolve(name, { paths: [root] });
    delete require.cache[resolved];
    require(resolved);
    ok.push(name);
  } catch (e) {
    broken.push(`${name}  ${String(e.message).split('\n')[0].slice(0, 120)}`);
  }
}

console.log(`检测 ${all.length} 个包：正常 ${ok.length}，损坏 ${broken.length}\n`);
if (broken.length) {
  console.log('=== 损坏清单 ===');
  broken.forEach((b) => console.log('  ❌ ' + b));
  // 输出纯包名清单，供 shell 批量修复
  const names = broken.map((b) => b.split(' ')[0]);
  fs.writeFileSync(path.join(root, '.broken-pkgs.txt'), names.join('\n') + '\n');
  console.log('\n已写入 .broken-pkgs.txt（' + names.length + ' 个）');
  process.exit(2);
}
console.log('✅ 全部可加载');
process.exit(0);
