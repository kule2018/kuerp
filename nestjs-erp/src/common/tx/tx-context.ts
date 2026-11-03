import { AsyncLocalStorage } from 'async_hooks';
import { DataSource, QueryRunner } from 'typeorm';

/**
 * 事务上下文（基于 AsyncLocalStorage）。
 *
 * 【为什么需要它】
 * PostingService 里的过账逻辑很长（1400+ 行），内部有几十处 `this.dataSource.query(...)`。
 * 如果为了包事务就把每一处都改成 `manager.query(...)`，需要把 manager 一路当参数传过
 * 十几个私有方法——改动面大、容易漏，且一旦漏一处就会「事务里的一部分操作跑到事务外」，
 * 反而比没有事务更隐蔽。
 *
 * 这里用 AsyncLocalStorage 做「隐式事务上下文」：
 * - runInTx() 开启事务并把 QueryRunner 放进当前异步上下文；
 * - 业务代码照旧调用 query()，由 txQuery() 判断当前是否有事务，
 *   有则走事务连接，没有则走连接池——调用方零改动。
 *
 * 【为什么不用实例字段保存 QueryRunner】
 * Nest 的 Service 默认是单例。把 QueryRunner 存到 this 上，并发请求会互相覆盖，
 * 出现「A 请求的事务里执行了 B 请求的 SQL」这种灾难性问题。
 * AsyncLocalStorage 的存储是按异步调用链隔离的，天然并发安全。
 */

/** 保存当前异步调用链上的事务连接 */
const als = new AsyncLocalStorage<QueryRunner>();

/**
 * 在当前异步上下文里执行一个事务。
 *
 * 回调内的所有 query()（经由 txQuery 或 txQueryOr）都会落在同一个事务连接上；
 * 回调抛错则整体回滚。
 *
 * @param dataSource TypeORM 数据源
 * @param fn 事务内要执行的业务逻辑
 * @returns 回调返回值
 */
export async function runInTx<T>(dataSource: DataSource, fn: () => Promise<T>): Promise<T> {
  // 已在事务中：直接复用，避免嵌套事务导致内层 COMMIT 提前提交外层
  if (als.getStore()) return fn();

  const runner = dataSource.createQueryRunner();
  await runner.connect();
  await runner.startTransaction();
  try {
    const result = await als.run(runner, fn);
    await runner.commitTransaction();
    return result;
  } catch (e) {
    try {
      await runner.rollbackTransaction();
    } catch {
      // 回滚失败（如连接已断）不覆盖原始异常，交由上层记录
    }
    throw e;
  } finally {
    await runner.release();
  }
}

/**
 * 在事务上下文中执行查询；无事务时返回 null。
 *
 * @param sql SQL 语句
 * @param params 参数数组
 * @returns 查询结果，或 null 表示当前不在事务中
 */
export async function txQuery(sql: string, params?: any[]): Promise<any[] | null> {
  const runner = als.getStore();
  if (!runner) return null;
  return await runner.query(sql, params);
}

/**
 * 当前是否处于事务中（供需要区分行为的场景使用）。
 * @returns 是否在事务上下文
 */
export function inTx(): boolean {
  return !!als.getStore();
}
