/**
 * 打印相关公共工具。
 * ------------------------------------------------------------------
 * 打印页（print.vue / print-center.vue / print-report.vue）共用的取数与格式化逻辑，
 * 避免每个页面各写一份「公司抬头」「金额/日期格式化」。
 */
import request from './request';

/** 公司抬头兜底值（系统参数未维护时使用） */
const DEFAULT_COMPANY = '进销存管理系统';

/**
 * 读取打印抬头公司名（原系统 Prints 控制器取 kuerp_sets.company_name）。
 * @returns {Promise<string>} 公司名称，取不到时返回兜底值
 */
export async function fetchCompanyName() {
  try {
    const r = await request.get('/kuerp/sets/index', { params: { limit: 500 } });
    const rows = r?.list || [];
    const hit = rows.find((x) => x.name === 'company_name' || x.name === 'company');
    const val = hit?.value ? String(hit.value).trim() : '';
    return val || DEFAULT_COMPANY;
  } catch {
    return DEFAULT_COMPANY;
  }
}

/**
 * 金额格式化：¥ + 千分位 + 两位小数。
 * @param {any} v 金额
 * @returns {string}
 */
export function money(v) {
  return (
    '¥' +
    (Number(v) || 0).toLocaleString('zh-CN', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })
  );
}

/**
 * 数值格式化：千分位，默认最多 2 位小数。
 * @param {any} v 数值
 * @param {number} [digits=2] 最大小数位
 * @returns {string}
 */
export function fmtNum(v, digits = 2) {
  return (Number(v) || 0).toLocaleString('zh-CN', { maximumFractionDigits: digits });
}

/**
 * 秒级时间戳 / 日期串 -> YYYY-MM-DD。
 * @param {any} v 秒级时间戳或可解析日期串
 * @returns {string} 空值返回 '-'
 */
export function fmtDate(v) {
  if (v === null || v === undefined || v === '') return '-';
  const n = Number(v);
  const d = Number.isNaN(n) ? new Date(String(v)) : new Date(n * 1000);
  if (Number.isNaN(d.getTime())) return String(v);
  const p = (x) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}

/**
 * 判断列是否为日期/时间列（列名以 _time/_date 结尾，或类型为 datetime/date）。
 * @param {{name:string,type:string}} col 列元信息
 * @returns {boolean}
 */
export function isDateCol(col) {
  if (!col) return false;
  return /_(time|date)$/i.test(col.name) || ['datetime', 'date', 'timestamp'].includes(col.type);
}
