/**
 * 通用格式化工具（时间 / 金额 / 数量）。
 *
 * 与 utils/print.js 的区别：print.js 面向打印排版（固定两位小数、带币种符号），
 * 这里面向界面展示（自适应、带「几分钟前」这类相对时间），两者互不复用避免耦合。
 */

/**
 * 秒级时间戳 -> 'YYYY-MM-DD HH:mm:ss'。
 * @param {number|string} sec 秒级时间戳（后端全库统一用秒）
 * @param {string} fallback 空值时的占位
 * @returns {string}
 */
export function fmtTime(sec, fallback = '—') {
  const n = Number(sec);
  if (!n || Number.isNaN(n)) return fallback;
  const d = new Date(n * 1000);
  const p = (v) => String(v).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}

/**
 * 秒级时间戳 -> 'YYYY-MM-DD'。
 * @param {number|string} sec 秒级时间戳
 * @param {string} fallback 空值占位
 * @returns {string}
 */
export function fmtDay(sec, fallback = '—') {
  const s = fmtTime(sec, '');
  return s ? s.slice(0, 10) : fallback;
}

/**
 * 相对时间：如「3 分钟前」「2 天前」。
 * 超过 30 天直接显示日期，避免「217 天前」这种没有信息量的表述。
 * @param {number|string} sec 秒级时间戳
 * @param {string} fallback 空值占位
 * @returns {string}
 */
export function timeAgo(sec, fallback = '—') {
  const n = Number(sec);
  if (!n || Number.isNaN(n)) return fallback;
  const diff = Math.floor(Date.now() / 1000) - n;
  if (diff < 0) return fmtTime(sec, fallback);
  if (diff < 60) return '刚刚';
  if (diff < 3600) return `${Math.floor(diff / 60)} 分钟前`;
  if (diff < 86400) return `${Math.floor(diff / 3600)} 小时前`;
  if (diff < 86400 * 30) return `${Math.floor(diff / 86400)} 天前`;
  return fmtDay(sec, fallback);
}

/**
 * 数字千分位（保留指定小数位）。
 * @param {any} v 值
 * @param {number} digits 小数位，默认 2
 * @returns {string}
 */
export function fmtNum(v, digits = 2) {
  const n = Number(v);
  if (Number.isNaN(n)) return '—';
  return n.toLocaleString('zh-CN', { minimumFractionDigits: digits, maximumFractionDigits: digits });
}

/**
 * 金额展示：¥ 前缀 + 千分位。负数（如毛利为负）保留负号在 ¥ 之前，形如 -¥1,234.00。
 * @param {any} v 值
 * @param {number} digits 小数位，默认 2
 * @returns {string}
 */
export function fmtMoney(v, digits = 2) {
  const n = Number(v);
  if (Number.isNaN(n)) return '—';
  const abs = fmtNum(Math.abs(n), digits);
  return `${n < 0 ? '-' : ''}¥${abs}`;
}

/**
 * 文件字节数转可读体积。
 * @param {number} bytes 字节
 * @returns {string}
 */
export function fmtBytes(bytes) {
  const n = Number(bytes) || 0;
  if (n < 1024) return `${n} B`;
  if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`;
  if (n < 1024 * 1024 * 1024) return `${(n / 1024 / 1024).toFixed(1)} MB`;
  return `${(n / 1024 / 1024 / 1024).toFixed(2)} GB`;
}
