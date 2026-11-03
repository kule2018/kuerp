/**
 * 省市区联动数据工具：从通用表接口 /kuerp/area/index 拉取 kuerp_area（3713 条），
 * 按 pid（父级 id）/ level（1=省 2=市 3=区）建索引，供动态表单渲染三级联动下拉。
 *
 * - 全量数据进程内缓存（Promise 复用，多页面共享，只拉一次）；
 * - 选项按 adcode（行政区划码）排序，顺序与常见行政区划一致（北京→天津→河北…）；
 * - 取值存区域 id（int），与 kuerp_address 等表的 province/city/area 列直接对应。
 */
import request from './request';
import { ref } from 'vue';

let cachePromise = null;
/** id -> 区域记录；pid -> 子级数组；level -> 该级选项数组 */
let byId = new Map();
let childrenOf = new Map();
const optionsByLevel = { 1: [], 2: [], 3: [] };

/**
 * 响应式版本号：区域索引本身是普通 Map（数千条记录，包成 reactive 开销大），
 * 读取函数里引用它建立依赖 —— 列表先渲染、区域后到时，加载完成会触发重渲染，
 * 省市区单元格才能从裸 id 变成中文名称。
 */
const version = ref(0);

/**
 * 拉取并索引区域数据（并发调用共享同一请求）。
 * @returns {Promise<boolean>} 是否加载成功
 */
export function loadRegions() {
  if (!cachePromise) {
    cachePromise = request
      .get('/kuerp/area/index', { params: { page: 1, limit: 5000 } })
      .then((r) => {
        const rows = r?.list || [];
        byId = new Map(rows.map((x) => [x.id, x]));
        childrenOf = new Map();
        for (const x of rows) {
          if (!childrenOf.has(x.pid)) childrenOf.set(x.pid, []);
          childrenOf.get(x.pid).push(x);
        }
        // 每级按行政区划码排序，展示顺序稳定
        for (const x of rows) {
          const arr = optionsByLevel[x.level];
          if (arr) arr.push(x);
        }
        for (const key of Object.keys(optionsByLevel)) {
          optionsByLevel[key].sort((a, b) => String(a.adcode).localeCompare(String(b.adcode)));
        }
        for (const arr of childrenOf.values()) {
          arr.sort((a, b) => String(a.adcode).localeCompare(String(b.adcode)));
        }
        version.value++; // 通知依赖区域数据的渲染（单元格/下拉）重渲染
        return true;
      })
      .catch(() => {
        cachePromise = null; // 失败允许重试
        return false;
      });
  }
  return cachePromise;
}

/**
 * 某一级别的选项列表（{value,label}）。
 * @param {1|2|3} level 1=省 2=市 3=区
 */
export function regionOptions(level) {
  version.value; // 建立响应依赖
  return (optionsByLevel[level] || []).map((x) => ({ value: x.id, label: x.name }));
}

/**
 * 指定父级下的子级选项（省下的市 / 市下的区）。
 * @param {number} pid 父级区域 id
 */
export function regionChildren(pid) {
  version.value; // 建立响应依赖
  return (childrenOf.get(Number(pid)) || []).map((x) => ({ value: x.id, label: x.name }));
}

/**
 * 区域 id → 名称（表格单元格翻译用），未命中原样返回。
 * @param {any} id 区域 id
 */
export function regionName(id) {
  version.value; // 建立响应依赖：区域数据加载完成后单元格重渲染为名称
  const hit = byId.get(Number(id));
  return hit ? hit.name : id;
}

/** 表单里是否选了有效省/市（联动重置判断用） */
export function isValidRegion(v) {
  return v !== '' && v !== null && v !== undefined && byId.has(Number(v));
}
