/**
 * 五段式 cron 解析与匹配（零依赖实现）。
 *
 * 为什么不装 @nestjs/schedule：
 * 本项目所在环境的 npm 安装会被安全钩子中断（历史踩坑），而调度需求只有
 * 「每天固定时刻 + 每 N 分钟」两类，自研一套解析器成本远低于引入依赖的风险。
 *
 * 支持语法（与原系统 FastAdmin 的 crontab 配置习惯一致）：
 *   *        任意值
 *   n        具体值
 *   a-b      范围（含端点）
 *   a,b,c    枚举
 *   * /n     步长（含 a-b/n 形式）
 *
 * 语义细节：日（DOM）与周（DOW）**同时**被限定时按「或」匹配（与标准 cron 一致），
 * 只限定其中一个时按「且」匹配。
 */

/** 解析后的各字段取值集合 */
export interface CronSpec {
  /** 原始表达式 */
  expr: string;
  /** 分钟（0-59） */
  minute: Set<number>;
  /** 小时（0-23） */
  hour: Set<number>;
  /** 日（1-31） */
  day: Set<number>;
  /** 月（1-12） */
  month: Set<number>;
  /** 星期（0-6，0=周日） */
  dow: Set<number>;
  /** 日字段是否被限定（非 *） */
  dayRestricted: boolean;
  /** 周字段是否被限定（非 *） */
  dowRestricted: boolean;
}

/**
 * 解析单个字段为取值集合。
 * @param raw 原始字段文本
 * @param min 允许最小值
 * @param max 允许最大值
 * @returns 取值集合
 */
function parseField(raw: string, min: number, max: number): Set<number> {
  const out = new Set<number>();
  const text = String(raw || '*').trim();
  if (!text || text === '*') {
    for (let i = min; i <= max; i++) out.add(i);
    return out;
  }

  for (const part of text.split(',')) {
    const seg = part.trim();
    if (!seg) continue;

    // 步长：*/n、a-b/n、a/n
    let step = 1;
    let body = seg;
    const slash = seg.indexOf('/');
    if (slash >= 0) {
      body = seg.slice(0, slash);
      const n = Number(seg.slice(slash + 1));
      step = Number.isFinite(n) && n > 0 ? Math.floor(n) : 1;
    }

    let from = min;
    let to = max;
    if (body === '*' || body === '') {
      // 全范围
    } else if (body.includes('-')) {
      const [a, b] = body.split('-');
      const x = Number(a);
      const y = Number(b);
      if (!Number.isFinite(x) || !Number.isFinite(y)) continue;
      from = Math.max(min, Math.floor(x));
      to = Math.min(max, Math.floor(y));
    } else {
      const v = Number(body);
      if (!Number.isFinite(v)) continue;
      from = Math.max(min, Math.floor(v));
      // 单值时若无步长，只取该值
      to = step > 1 ? max : from;
    }

    for (let i = from; i <= to; i += step) out.add(i);
  }

  // 兜底：解析失败时给全范围，宁可多跑也不静默不跑
  if (!out.size) for (let i = min; i <= max; i++) out.add(i);
  return out;
}

/**
 * 解析 cron 表达式。
 * @param expr 五段式表达式（分 时 日 月 周）
 * @returns 解析结果
 * @throws Error 段数不为 5 时抛出
 */
export function parseCron(expr: string): CronSpec {
  const parts = String(expr || '').trim().split(/\s+/);
  if (parts.length !== 5) {
    throw new Error(`cron 表达式需为 5 段（分 时 日 月 周），当前 ${parts.length} 段：${expr}`);
  }
  const [mi, ho, dom, mo, dow] = parts;

  // 周字段兼容 7 表示周日
  const dowSet = parseField(dow, 0, 6);
  const rawDow = String(dow || '');
  if (/7/.test(rawDow)) dowSet.add(0);

  return {
    expr: parts.join(' '),
    minute: parseField(mi, 0, 59),
    hour: parseField(ho, 0, 23),
    day: parseField(dom, 1, 31),
    month: parseField(mo, 1, 12),
    dow: dowSet,
    dayRestricted: String(dom).trim() !== '*',
    dowRestricted: String(dow).trim() !== '*',
  };
}

/**
 * 判断某个时刻是否命中 cron。
 * @param spec 解析结果
 * @param d 待判断时刻
 * @returns 是否命中（精确到分钟）
 */
export function cronMatches(spec: CronSpec, d: Date): boolean {
  if (!spec.minute.has(d.getMinutes())) return false;
  if (!spec.hour.has(d.getHours())) return false;
  if (!spec.month.has(d.getMonth() + 1)) return false;

  const domHit = spec.day.has(d.getDate());
  const dowHit = spec.dow.has(d.getDay());
  if (spec.dayRestricted && spec.dowRestricted) return domHit || dowHit;
  if (spec.dayRestricted) return domHit;
  if (spec.dowRestricted) return dowHit;
  return true;
}

/**
 * 计算下一次命中时刻（用于管理页展示「下次执行时间」）。
 * @param spec 解析结果
 * @param from 起始时刻（默认当前）
 * @returns 下次命中时刻；一年内无命中返回 null
 */
export function nextRunAt(spec: CronSpec, from: Date = new Date()): Date | null {
  const d = new Date(from.getTime());
  d.setSeconds(0, 0);
  d.setMinutes(d.getMinutes() + 1); // 从下一分钟开始找

  // 一年 = 525600 分钟，逐分钟扫描足够快（单次解析结果已缓存集合，循环开销很小）
  for (let i = 0; i < 366 * 24 * 60; i++) {
    if (cronMatches(spec, d)) return new Date(d.getTime());
    d.setMinutes(d.getMinutes() + 1);
  }
  return null;
}

/**
 * 把 Date 压成「分钟键」，用于同一分钟内的去重。
 * @param d 时刻
 * @returns 形如 2026-10-26 08:00 的键
 */
export function minuteKey(d: Date = new Date()): string {
  const p = (x: number) => String(x).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}
