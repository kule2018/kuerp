import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Tool } from './tool.decorator';

/**
 * ERP 示例工具集：用 @Tool 暴露给 AI 调用，演示 Function Calling + Agent 自主执行。
 * 这些工具直接查 Kuerp 业务库（kuerp_* 表），让模型能「动手」查数据/算数。
 * 你可在任意 Service 上用 @Tool 新增工具，注册进 ToolRegistry 即可被 Agent 调用。
 */
@Injectable()
export class ErpDemoTools {
  constructor(private readonly ds: DataSource) {}

  @Tool({
    name: 'query_goods',
    description: '按关键字/条码/编号查询商品，返回商品编号、名称、规格、单位、库存、价格',
    parameters: {
      type: 'object',
      properties: {
        keyword: { type: 'string', description: '商品名称/条码/编号关键字' },
        limit: { type: 'number', description: '返回条数，默认 10' },
      },
      required: ['keyword'],
    },
  })
  async queryGoods(args: { keyword: string; limit?: number }) {
    const limit = Math.min(Number(args.limit) || 10, 50);
    const rows = await this.ds.query(
      `SELECT goods_code,goods_name,goods_specification_id,unit_id,inventory,market_sell_price,wholesale_price,status
       FROM kuerp_goods WHERE deletetime=0 AND (goods_name LIKE ? OR goods_barcode LIKE ? OR goods_code LIKE ?)
       ORDER BY id DESC LIMIT ?`,
      [`%${args.keyword}%`, `%${args.keyword}%`, `%${args.keyword}%`, limit],
    );
    return { count: rows.length, list: rows };
  }

  @Tool({
    name: 'query_stock',
    description: '查询指定商品的库存总量与分仓库存明细',
    parameters: {
      type: 'object',
      properties: { goods_id: { type: 'number', description: '商品ID' } },
      required: ['goods_id'],
    },
  })
  async queryStock(args: { goods_id: number }) {
    const goods = await this.ds.query(
      `SELECT id,goods_name,inventory FROM kuerp_goods WHERE id=? AND deletetime=0`,
      [args.goods_id],
    );
    const stocks = await this.ds.query(
      `SELECT warehouse_id,stock,price FROM kuerp_goods_stock WHERE goods_id=?`,
      [args.goods_id],
    );
    return { goods: goods[0] || null, stocks };
  }

  @Tool({
    name: 'query_customer',
    description: '按关键字查询客户（往来单位），返回客户名称、类型、欠款等',
    parameters: {
      type: 'object',
      properties: { keyword: { type: 'string', description: '客户名称/编号关键字' } },
      required: ['keyword'],
    },
  })
  async queryCustomer(args: { keyword: string }) {
    const rows = await this.ds.query(
      `SELECT id,customer_code,customer_name,customer_type_id,amount_receivable,amount_payable
       FROM kuerp_customers WHERE deletetime=0 AND (customer_name LIKE ? OR customer_code LIKE ?) LIMIT 20`,
      [`%${args.keyword}%`, `%${args.keyword}%`],
    );
    return { count: rows.length, list: rows };
  }

  @Tool({
    name: 'calc',
    description: '安全四则运算计算（支持 + - * / 和括号），用于金额/数量汇总',
    parameters: {
      type: 'object',
      properties: { expression: { type: 'string', description: '例如 (12.5+3)*2' } },
      required: ['expression'],
    },
  })
  async calc(args: { expression: string }) {
    const expr = String(args.expression).replace(/[^0-9+\-*/().%\s]/g, '');
    if (!expr) return { error: '非法表达式' };
    // eslint-disable-next-line no-new-func
    const value = Function(`"use strict"; return (${expr});`)();
    return { expression: expr, value };
  }
}
