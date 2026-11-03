/** 临时调试：打印 prefix.test.js 失败时的完整堆栈。用完即删。 */
const fs = require('fs');
let src = fs.readFileSync(__dirname + '/prefix.test.js', 'utf8');
src = src.replace(
  "console.error('❌ 单号规则与对单测试失败:', e.message);",
  "console.error('❌ 单号规则与对单测试失败:', e.message); console.error(e.stack.split('\\n').slice(0, 12).join('\\n'));",
);
fs.writeFileSync(__dirname + '/_debug_prefix.js', src);
require('./_debug_prefix.js');
