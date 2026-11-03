import { ValueTransformer } from 'typeorm';

/**
 * bigint 与 JS number 的相互转换。
 * 原系统大量使用 bigint(16) 存储时间戳（秒级），这里统一在实体层转成 number 使用。
 */
export const BigIntTransformer: ValueTransformer = {
  to: (value?: number | null) => (value === null || value === undefined ? null : value),
  from: (value?: string | number | null) => {
    if (value === null || value === undefined || value === '') return null;
    return typeof value === 'string' ? Number(value) : value;
  },
};

/**
 * 生成当前秒级时间戳（与原系统 createtime/updatetime 一致）
 */
export function nowSec(): number {
  return Math.floor(Date.now() / 1000);
}
