/* eslint-disable */
/**
 * 前后端接口契约核对脚本。
 * 用途：静态比对「前端 request.xxx 的路径」与「后端 @Controller + @Get/@Post 路由」，
 * 找出前端调了但后端没有（或路径拼接错）的接口；本项目没有 eslint/tsc，用它兜底。
 * 用法：node nestjs-erp/scripts/api-audit.js
 */
const fs=require('fs'),path=require('path');
const ROOT = path.join(__dirname, '..', '..');
const FE = path.join(ROOT, 'vue3-erp', 'src');
const BE = path.join(ROOT, 'nestjs-erp', 'src');
function walk(d,ext,out=[]){for(const e of fs.readdirSync(d,{withFileTypes:true})){const p=path.join(d,e.name);if(e.isDirectory())walk(p,ext,out);else if(e.name.endsWith(ext))out.push(p);}return out;}

// ---- 后端路由 ----
const routes=new Set();
for(const f of walk(BE,'.controller.ts')){
  const s=fs.readFileSync(f,'utf8');
  const baseM=[...s.matchAll(/@Controller\(\s*['"`]([^'"`]*)['"`]/g)].pop();
  const base=baseM?baseM[1]:'';
  for(const m of s.matchAll(/@(Get|Post|Put|Delete|Patch|All)\(\s*['"`]([^'"`]*)['"`]\s*\)/g)){
    let p='/'+[base,m[2]].filter(Boolean).join('/');
    p=p.replace(/\/+/g,'/').replace(/:([a-zA-Z0-9_]+)/g,':p');
    routes.add(m[1].toUpperCase()+' '+p);
  }
}
// ---- 前端请求 ----
const fe=new Set();
for(const f of walk(FE,'.vue').concat(walk(FE,'.js')).concat(walk(FE,'.ts'))){
  const s=fs.readFileSync(f,'utf8');
  for(const m of s.matchAll(/request\.(get|post|put|delete|patch|download)\(\s*[`'"]([^`'"]+)[`'"]/g)){
    let p=m[2].replace(/\$\{[^}]*\}/g,':p');
    if(!p.startsWith('/'))continue;
    fe.add(m[1].toUpperCase()+' '+p.replace(/\/+/g,'/'));
  }
}
// 动态表路由展开成匹配器
function match(method,p){
  const segs=p.split('/').filter(Boolean);
  for(const r of routes){
    const [vm,rp]=r.split(' ');
    const rs=rp.split('/').filter(Boolean);
    if(rs.length!==segs.length)continue;
    let vmOk=(vm===method)||((method==='GET')&&(vm==='ALL'))||((method==='POST')&&(vm==='ALL'));
    if(!vmOk)continue;
    let ok=true;
    for(let i=0;i<rs.length;i++){
      // 任一侧是参数占位即视为通配（前端模板变量 / 后端 :param）
      if(rs[i].startsWith(':')||segs[i]===':p')continue;
      if(rs[i]!==segs[i]){ok=false;break;}
    }
    if(ok)return true;
  }
  return false;
}
const bad=[...fe].filter(x=>{const [m,p]=x.split(' ');return !match(m,p);});
console.log('后端路由数:',routes.size,'| 前端请求路径数:',fe.size);
console.log('--- 未匹配 ---');
bad.forEach(b=>console.log('  ',b));
