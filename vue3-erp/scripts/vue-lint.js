/**
 * 轻量 .vue 静态检查：找出模板中引用但脚本里未定义的标识符。
 * 目的：补上没有 eslint/tsc 时最容易漏掉的一类运行时错误（undefined is not a function）。
 */
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..', 'src');
const files = [];
(function walk(d) {
  for (const e of fs.readdirSync(d, { withFileTypes: true })) {
    const p = path.join(d, e.name);
    if (e.isDirectory()) walk(p);
    else if (e.name.endsWith('.vue')) files.push(p);
  }
})(root);

// 模板作用域变量：v-for / slot props / 指令自带
const scoped = new Set();
const BUILTIN = new Set([
  'Math','Number','String','Object','Array','JSON','Date','Boolean','Symbol','Map','Set','Promise','RegExp',
  'parseInt','parseFloat','isNaN','isFinite','encodeURIComponent','decodeURIComponent','setTimeout','clearTimeout',
  'setInterval','clearInterval','console','window','document','localStorage','sessionStorage','process',
  'undefined','null','true','false','this','in','of','new','typeof','return','if','else','await','async',
  'item','items','row','col','c','f','o','v','k','i','index','key','val','value','label','option','seg','n','x','y','r','e','a','b',
  'slotProps','scoped','props','emit','$slots','$props','$emit','$route','$router','$refs','$el','$event','$event_',
  'NodeJS','globalThis','string','number','boolean','any','void','unknown','never','Record','Array','as','is','keyof','typeof','readonly','Function','Promise','Required','Partial','Blob','File','FormData','URL','FileReader','Image','AbortController','fetch',
]);

function stripStrings(s) {
  // 去掉字符串字面量与注释，避免把里面的单词当标识符
  return s.replace(/'[^']*'/g, "''").replace(/"[^"]*"/g, '""').replace(/`[^`]*`/g, '``')
          .replace(/\/\/[^\n]*/g, '').replace(/\/\*[\s\S]*?\*\//g, '');
}

function collectTemplateIdents(tpl) {
  const out = new Set();
  // v-for / slot 解构里的局部变量
  for (const m of tpl.matchAll(/v-for\s*=\s*"([^"]+)"/g)) {
    const parts = m[1].split(/\s+(?:in|of)\s+/);
    const left = parts[0];
    for (const id of left.replace(/[()]/g, ' ').split(/[\s,]+/)) if (/^[A-Za-z_$][\w$]*$/.test(id)) out.add(id);
    if (parts[1]) for (const id of parts[1].matchAll(/(?<![.\w$])[A-Za-z_$][\w$]*/g)) out.add(id[0]);
  }
  for (const m of tpl.matchAll(/#(\w+)\s*=\s*"\{?\s*([A-Za-z_$][\w$]*)/g)) out.add(m[2]);
  // 指令值 / 插值
  const exprs = [];
  for (const m of tpl.matchAll(/\{\{([\s\S]+?)\}\}/g)) exprs.push(m[1]);
  for (const m of tpl.matchAll(/\s(?:v-if|v-else-if|v-show|v-model|v-bind|:[\w-]+|@[\w.-]+)="([^"]*)"/g)) exprs.push(m[1]);
  for (const m of tpl.matchAll(/\s(?:v-if|v-else-if|v-show|v-model|v-bind|:[\w-]+|@[\w.-]+)='([^']*)'/g)) exprs.push(m[1]);
  for (const e of exprs) {
    const s = stripStrings(e);
    for (const m of s.matchAll(/(?<![.\w$'"`])[A-Za-z_$][\w$]*/g)) out.add(m[0]);
  }
  return out;
}

function collectDeclared(script) {
  const out = new Set();
  for (const m of script.matchAll(/\b(?:const|let|var)\s*\{?([^=;{]+)/g)) {
    for (const id of m[1].split(/[\s,]+/)) if (/^[A-Za-z_$][\w$]*$/.test(id)) out.add(id);
  }
  for (const m of script.matchAll(/\bfunction\s+([A-Za-z_$][\w$]*)/g)) out.add(m[1]);
  for (const m of script.matchAll(/\bimport\s+([\s\S]*?)\s+from\b/g)) {
    const chunk = m[1].replace(/[{}]/g, ' ');
    for (const id of chunk.split(/[\s,]+/)) if (/^[A-Za-z_$][\w$]*$/.test(id) && id !== 'as') out.add(id);
  }
  // props / emits 声明：模板里用到的是组件入参，不算未定义
  for (const m of script.matchAll(/defineProps\s*<([\s\S]*?)>\s*\(/g)) {
    for (const id of m[1].matchAll(/[A-Za-z_$][\w$]*/g)) out.add(id[0]);
  }
  for (const m of script.matchAll(/defineProps\s*\(([\s\S]*?)\)\s*;?/g)) {
    for (const id of m[1].matchAll(/[A-Za-z_$][\w$]*/g)) out.add(id[0]);
  }
  for (const m of script.matchAll(/defineEmits\s*<([\s\S]*?)>\s*\(/g)) {
    for (const id of m[1].matchAll(/[A-Za-z_$][\w$]*/g)) out.add(id[0]);
  }
  for (const m of script.matchAll(/defineExpose\s*\(([\s\S]*?)\)/g)) {
    for (const id of m[1].matchAll(/[A-Za-z_$][\w$]*/g)) out.add(id[0]);
  }
  // 解构赋值 const { a, b } = 已在上面粗略覆盖；再补一层
  return out;
}

const GLOBAL_COMPONENTS = /^(Ds|Base)[A-Z]/;
const report = [];
for (const f of files) {
  const src = fs.readFileSync(f, 'utf8');
  const tplM = src.match(/<template>([\s\S]*?)<\/template>/);
  const scM = src.match(/<script[^>]*>([\s\S]*?)<\/script>/);
  if (!tplM || !scM) continue;
  const tpl = tplM[1];
  const script = scM[1];
  const declared = collectDeclared(script);
  // v-for 局部变量与 slot props 视为已声明
  const locals = collectTemplateIdents(tpl);
  const used = new Set(locals);
  // 模板里出现的全局组件名
  const tplComps = new Set([...tpl.matchAll(/<([A-Z][\w-]*)/g)].map((m) => m[1]));
  const missing = [];
  for (const id of used) {
    if (BUILTIN.has(id)) continue;
    if (declared.has(id)) continue;
    if (tplComps.has(id)) continue;
    if (GLOBAL_COMPONENTS.test(id)) continue;
    // 属性访问后半段（如 a.b 的 b）已在 locals 收集时一并加入，这里放宽：只报疑似顶层引用
    missing.push(id);
  }
  if (missing.length && f.includes(path.join('views'))) report.push({ file: path.relative(root, f), missing: [...new Set(missing)].sort() });
}
for (const r of report) console.log(r.file, '=>', r.missing.join(', '));
