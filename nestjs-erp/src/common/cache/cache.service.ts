import { Injectable, Logger, OnModuleDestroy } from '@nestjs/common';

/**
 * 内存缓存服务（进程内 LRU + TTL）。
 *
 * 【为什么不用 Redis】
 * 本项目是单机部署的中小体量 ERP，缓存的对象只有三类：系统参数、下拉选项、权限节点。
 * 引入 Redis 会多出一个必须运维的组件，而收益仅是「多实例共享」——
 * 当前部署形态没有多实例，因此用进程内缓存即可（零依赖、零运维）。
 * 若将来横向扩容，只需把本服务的 get/set/del/delByPrefix 换成 Redis 实现，调用方无需改动。
 *
 * 【淘汰策略】
 * 两层：① 惰性过期——读取时发现已过期立即丢弃并计入 miss；
 *      ② 容量上限——超过 max 时按「最少使用」淘汰（Map 的插入顺序充当 LRU 链，
 *         get 命中后重新 set 把它移到链尾）。
 * 另有每 60 秒的后台清扫，避免大量写入后过期键长期占用内存。
 *
 * 【单例】
 * CacheModule 声明为 @Global()，全应用共享同一实例；
 * 因此 key 必须带业务前缀（如 `opt:kuerp_goods`、`set:stock_negative`），
 * 失效时按前缀批量删除，避免误伤其它模块的缓存。
 */
@Injectable()
export class CacheService implements OnModuleDestroy {
  private readonly logger = new Logger(CacheService.name);

  /** 缓存主体：key -> 条目；Map 的插入顺序即 LRU 顺序（队首最旧） */
  private readonly store = new Map<string, { value: any; expireAt: number }>();

  /** 容量上限，超过后按 LRU 淘汰 */
  private readonly max: number;

  /** 默认存活秒数（调用方未显式传 ttl 时使用） */
  private readonly defaultTtl: number;

  /** 命中/未命中/淘汰计数，供运维接口观测缓存收益 */
  private hits = 0;
  private misses = 0;
  private evictions = 0;

  /** 后台清扫定时器（unref 后不阻塞进程退出） */
  private readonly sweeper: NodeJS.Timeout;

  /**
   * 构造函数：读取环境变量配置并启动清扫定时器。
   *
   * 环境变量：
   *   CACHE_MAX        条目上限，默认 2000
   *   CACHE_TTL        默认存活秒数，默认 60
   *   CACHE_SWEEP_SEC  清扫间隔秒数，默认 60（0 表示关闭清扫）
   */
  constructor() {
    this.max = Math.max(100, Number(process.env.CACHE_MAX || 2000));
    this.defaultTtl = Math.max(1, Number(process.env.CACHE_TTL || 60));
    const sweepSec = Number(process.env.CACHE_SWEEP_SEC ?? 60);
    this.sweeper = setInterval(() => this.sweep(), Math.max(1, sweepSec) * 1000);
    // unref：定时器不应阻止 Node 进程自然退出（容器优雅停机时会用到）
    if (typeof this.sweeper.unref === 'function') this.sweeper.unref();
  }

  /**
   * 模块销毁时清理定时器。
   * @returns 无
   */
  onModuleDestroy(): void {
    clearInterval(this.sweeper);
  }

  /**
   * 读取缓存。
   *
   * @param key 缓存键（建议 `业务前缀:主键` 形式）
   * @returns 命中且未过期时返回缓存值；否则返回 null
   */
  get<T = any>(key: string): T | null {
    const hit = this.store.get(key);
    if (!hit) {
      this.misses += 1;
      return null;
    }
    if (hit.expireAt > 0 && hit.expireAt <= Date.now()) {
      // 惰性过期：顺手删除，避免过期键继续占位
      this.store.delete(key);
      this.misses += 1;
      return null;
    }
    // 命中后重新插入，把它移到 Map 尾部（LRU：尾部=最近使用）
    this.store.delete(key);
    this.store.set(key, hit);
    this.hits += 1;
    return hit.value as T;
  }

  /**
   * 写入缓存。
   *
   * @param key 缓存键
   * @param value 缓存值（注意：保存的是引用，调用方不要修改已放入缓存的对象）
   * @param ttl 存活秒数；<=0 表示永不过期（慎用，仅限静态字典）
   * @returns 无
   */
  set(key: string, value: any, ttl?: number): void {
    const seconds = ttl === undefined ? this.defaultTtl : ttl;
    if (!this.store.has(key) && this.store.size >= this.max) {
      // 容量已满：淘汰队首（最久未使用）的一条
      const oldest = this.store.keys().next().value as string | undefined;
      if (oldest !== undefined) {
        this.store.delete(oldest);
        this.evictions += 1;
      }
    }
    // 先删后插：保证同 key 更新时也移动到 LRU 链尾
    this.store.delete(key);
    this.store.set(key, { value, expireAt: seconds > 0 ? Date.now() + seconds * 1000 : 0 });
  }

  /**
   * 删除单个缓存键。
   * @param key 缓存键
   * @returns 是否确实删除了某一项
   */
  del(key: string): boolean {
    return this.store.delete(key);
  }

  /**
   * 按前缀批量删除（写操作后失效相关缓存的主要手段）。
   *
   * @param prefix 前缀，例如 `opt:kuerp_goods`
   * @returns 被删除的条目数量
   */
  delByPrefix(prefix: string): number {
    let n = 0;
    for (const k of [...this.store.keys()]) {
      if (k.startsWith(prefix)) {
        this.store.delete(k);
        n += 1;
      }
    }
    return n;
  }

  /**
   * 清空全部缓存（运维手动干预用）。
   * @returns 被清空的条目数量
   */
  clear(): number {
    const n = this.store.size;
    this.store.clear();
    return n;
  }

  /**
   * 读缓存，未命中则执行 loader 并回填（最常用的入口）。
   *
   * 注意：loader 抛错时不写缓存，异常原样上抛——
   * 不能把失败结果缓存住，否则一次数据库抖动会导致接口在 TTL 内持续报错。
   *
   * @param key 缓存键
   * @param ttl 存活秒数
   * @param loader 未命中时的加载函数
   * @returns loader 的返回值或缓存值
   */
  async wrap<T>(key: string, ttl: number, loader: () => Promise<T>): Promise<T> {
    const cached = this.get<T>(key);
    if (cached !== null && cached !== undefined) return cached;
    const value = await loader();
    this.set(key, value, ttl);
    return value;
  }

  /**
   * 统计信息（运维接口 /system/cache/stats 使用）。
   *
   * @returns 条目数、容量、命中率与各类计数
   */
  stats() {
    const total = this.hits + this.misses;
    return {
      size: this.store.size,
      max: this.max,
      defaultTtl: this.defaultTtl,
      hits: this.hits,
      misses: this.misses,
      evictions: this.evictions,
      hitRate: total ? Number((this.hits / total).toFixed(4)) : 0,
    };
  }

  /**
   * 后台清扫：遍历删除已过期条目。
   *
   * 为什么需要它：惰性过期只在「有人读这个 key」时生效，
   * 大量一次性 key（如按查询条件拼的下拉缓存）写入后可能再无人读取，
   * 会一直占着内存，必须靠定时清扫回收。
   *
   * @returns 无
   */
  private sweep(): void {
    const now = Date.now();
    let n = 0;
    for (const [k, v] of this.store) {
      if (v.expireAt > 0 && v.expireAt <= now) {
        this.store.delete(k);
        n += 1;
      }
    }
    if (n > 0) this.logger.debug(`缓存清扫：回收 ${n} 条过期数据，当前 ${this.store.size} 条`);
  }
}
