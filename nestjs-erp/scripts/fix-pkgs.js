/**
 * 修复被中断的 npm install 写坏的 node_modules 包（本环境安全删除钩子会导致
 * npm 写入过程中丢文件：缺 package.json 入口字段 / 缺子模块 / 缺 .d.ts 等）。
 *
 * 方法：对目标包 npm pack 拉官方 tarball → 解包 → 覆盖式拷回 node_modules。
 * 版本探测顺序：package-lock.json → 已装 package.json → FALLBACKS 表。
 *
 * 用法：
 *   node scripts/fix-pkgs.js <pkg>[@<ver>] ...     # 显式指定
 *   node scripts/fix-pkgs.js --from-file .broken-pkgs.txt   # 批量（detect-broken.js 产出）
 */
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const root = path.resolve(__dirname, '..');
const tmp = path.join(root, '.pkgfix');

/** 版本探测失败时的兜底版本（与 package.json 依赖范围兼容） */
const FALLBACKS = {
  'iconv-lite': '0.6.3',
  uuid: '9.0.1',
  'readable-stream': '3.6.2',
  bl: '5.1.0',
  'process-nextick-args': '2.0.1',
  'util-deprecate': '1.0.2',
  router: '2.2.0',
  'safe-buffer': '5.2.1',
  string_decoder: '1.3.0',
  inherits: '2.0.4',
  ieee754: '1.2.1',
  buffer: '6.0.3',
  qs: '6.13.0',
  'side-channel': '1.1.0',
  'object-inspect': '1.13.4',
  tslib: '2.8.1',
};

/** 从 lock 文件探测某包已安装版本 */
function detectVersion(name) {
  // 1. lock 文件
  try {
    const lock = JSON.parse(fs.readFileSync(path.join(root, 'package-lock.json'), 'utf8'));
    const key = Object.keys(lock.packages || {}).find((k) => k === `node_modules/${name}`);
    if (key && lock.packages[key].version) return lock.packages[key].version;
  } catch (_) {}
  // 2. 已装 package.json（可能损坏，读不到 version 就跳过）
  try {
    const p = JSON.parse(fs.readFileSync(path.join(root, 'node_modules', name, 'package.json'), 'utf8'));
    if (p.version) return p.version;
  } catch (_) {}
  // 3. 兜底表
  return FALLBACKS[name] || null;
}

/** 递归拷贝目录（覆盖式，不删除目标多余文件，避免触发删除钩子） */
function copyDir(src, dst) {
  fs.mkdirSync(dst, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, entry.name);
    const d = path.join(dst, entry.name);
    if (entry.isDirectory()) copyDir(s, d);
    else fs.copyFileSync(s, d);
  }
}

/** 拆出包名（支持 @scope/pkg@ver 与 pkg@ver） */
function splitSpec(spec) {
  if (spec.startsWith('@')) {
    const at = spec.indexOf('@', 1);
    return at === -1 ? [spec, null] : [spec.slice(0, at), spec.slice(at + 1)];
  }
  const at = spec.indexOf('@');
  return at === -1 ? [spec, null] : [spec.slice(0, at), spec.slice(at + 1)];
}

(async () => {
  let specs = [];
  if (process.argv[2] === '--from-file') {
    specs = fs
      .readFileSync(process.argv[3], 'utf8')
      .split('\n')
      .map((s) => s.trim())
      .filter(Boolean);
  } else {
    specs = process.argv.slice(2);
  }
  if (!specs.length) {
    console.error('用法: node scripts/fix-pkgs.js <pkg>[@<ver>] ... | --from-file <file>');
    process.exit(1);
  }

  fs.mkdirSync(tmp, { recursive: true });
  let fixed = 0;
  let failed = 0;
  try {
    for (const spec of specs) {
      const [name, ver] = splitSpec(spec);
      const version = ver || detectVersion(name);
      if (!version) {
        console.error(`⚠️  ${name} 无法探测版本且无兜底值，跳过`);
        failed++;
        continue;
      }
      try {
        execSync(`npm pack ${name}@${version} --silent`, { cwd: tmp, stdio: 'pipe' });
        // npm pack 输出文件名；--silent 时仅一行 tarball 名
        const tarballs = fs.readdirSync(tmp).filter((f) => f.endsWith('.tgz'));
        const tgz = tarballs[tarballs.length - 1];
        // MSYS tar 会把盘符（F:）误判为远程主机，必须用相对路径（cwd=tmp）
        // tar 解压产物为 <tmp>/package/（npm tarball 固定根目录名）
        execSync(`tar -xzf "${tgz}"`, { cwd: tmp });
        copyDir(path.join(tmp, 'package'), path.join(root, 'node_modules', name));
        fs.rmSync(path.join(tmp, tgz), { force: true });
        console.log(`✅ ${name}@${version} 已修复`);
        fixed++;
      } catch (e) {
        console.error(`❌ ${name}@${version} 修复失败: ${String(e.message).split('\n')[0]}`);
        failed++;
      }
    }
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
  }
  console.log(`\n结果: 修复 ${fixed} 个，失败 ${failed} 个`);
  if (failed) process.exit(2);
  process.exit(0);
})();
