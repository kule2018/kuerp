/** 临时调试：打印 counter 链路下发的 SQL。用完即删。 */
require('reflect-metadata');
const { TableService } = require('../dist/kuerp/table/table.service');

const COLUMNS = {
  kuerp_goods_purchase: [
    { name: 'id', type: 'int', ckey: 'PRI' },
    { name: 'purchase_code', type: 'varchar' },
    { name: 'purchase_time', type: 'bigint' },
    { name: 'examine_status', type: 'enum' },
    { name: 'check_status', type: 'enum' },
    { name: 'operation_id', type: 'int' },
    { name: 'updatetime', type: 'bigint' },
  ],
};
const store = {
  kuerp_goods_purchase: [
    { id: 1, purchase_code: 'GHD1', purchase_time: 1000, examine_status: '1', check_status: '0', operation_id: 0 },
    { id: 2, purchase_code: 'GHD2', purchase_time: 2000, examine_status: '0', check_status: '1', operation_id: 0 },
  ],
  kuerp_checkout: [],
};
const fake = {
  options: { type: 'mysql' },
  async query(sql, params = []) {
    const s = String(sql).replace(/\s+/g, ' ').trim();
    console.log('SQL>', s, '||', JSON.stringify(params));
    if (/^SELECT TABLE_NAME AS/.test(s)) return [{ table: 'kuerp_goods_purchase' }];
    if (/^SELECT COLUMN_NAME AS name/.test(s)) return COLUMNS.kuerp_goods_purchase;
    if (/^SELECT checktime FROM/.test(s)) return [];
    if (/^SELECT COUNT/.test(s)) return [{ c: 1 }];
    if (/^UPDATE/.test(s)) {
      const to = params[0];
      const from = params[params.length - 1 - (params.length - 3)];
      for (const r of store.kuerp_goods_purchase) {
        if (String(r.check_status) === String(params[params.length - 1])) {
          r.check_status = String(to);
        }
      }
      return { affectedRows: 1 };
    }
    return [];
  },
};
const svc = new TableService(fake, {}, {});
svc.counter('goods-purchase', [1, 2], 1, 7).then((r) => {
  console.log('RESULT:', JSON.stringify(r));
  console.log('STORE:', JSON.stringify(store.kuerp_goods_purchase.map((r) => ({ id: r.id, check_status: r.check_status, operation_id: r.operation_id }))));
}).catch((e) => console.log('ERR:', e.message));
