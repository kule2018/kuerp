/**
 * 从原系统 install.sql 生成干净可执行的 MySQL schema（1:1 还原 159 张 kuerp_* 表）。
 * 仅做前缀替换与编码规整，不改动表结构与初始数据，保证数据库层 1:1。
 */
const fs = require('fs');
const path = require('path');

const srcPath = path.join(__dirname, '..', '..', 'kuerp-1.6.13-extended', 'install.sql');
const outDir = path.join(__dirname, '..', 'db');
const outPath = path.join(outDir, 'schema.sql');

if (!fs.existsSync(srcPath)) {
  console.error('未找到原 install.sql:', srcPath);
  process.exit(1);
}

let sql = fs.readFileSync(srcPath, 'utf8');
const before = (sql.match(/CREATE TABLE/gi) || []).length;
// 替换表前缀占位符（原表名 __PREFIX__kuerp_xxx -> kuerp_xxx）
sql = sql.replace(/__PREFIX__/g, '');
// 统一引擎/字符集（兼容 MySQL 5.7+）
sql = sql.replace(/DEFAULT CHARSET=utf8\b/gi, 'DEFAULT CHARSET=utf8mb4');
sql = sql.replace(/ENGINE=MyISAM/gi, 'ENGINE=InnoDB');

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(outPath, sql, 'utf8');

const tables = (sql.match(/CREATE TABLE IF NOT EXISTS `/g) || []).length;
console.log(`✅ schema 已生成: ${outPath}`);
console.log(`   原始 CREATE TABLE 语句: ${before} 条`);
console.log(`   生成表数量: ${tables} 张`);
