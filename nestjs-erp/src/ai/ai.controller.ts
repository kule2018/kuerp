import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Query,
  UseGuards,
  Inject,
  BadRequestException,
} from '@nestjs/common';
import { ShopOrJwtGuard } from '../common/guards/shop-or-jwt.guard';
import { ok } from '../common/response.interceptor';
import { AiModelConfigService } from './ai-model-config.service';
import { PromptTemplateService } from './prompt-template.service';
import { ChatClientService } from './chat-client';
import { ChatModelService, ChatMessage } from './chat-model.service';
import { AgentService } from './agent.service';
import { JsonOutputService } from './json-output.service';
import { KeywordRetrievalService } from './keyword-retrieval.service';
import { ToolRegistry } from './tool.registry';
import { BizAiTools } from './biz-tools';
import { AiLogService } from './ai-log.service';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AiCallLog } from './entities/ai-call-log.entity';
import { AiToolCallLog } from './entities/ai-tool-call-log.entity';
import { AiModelConfig } from './entities/ai-model-config.entity';
import { AiPromptTemplate } from './entities/ai-prompt-template.entity';
import { DataSource } from 'typeorm';

/**
 * AI 能力对外接口：模型配置、Prompt 模板、对话、Agent、结构化输出、关键词检索、日志。
 * 全部需要登录（JwtAuthGuard）。
 */
@Controller('ai')
@UseGuards(ShopOrJwtGuard)
export class AiController {
  constructor(
    private readonly modelConfigSvc: AiModelConfigService,
    private readonly promptSvc: PromptTemplateService,
    private readonly chatClientSvc: ChatClientService,
    private readonly agentSvc: AgentService,
    private readonly jsonSvc: JsonOutputService,
    private readonly retrieval: KeywordRetrievalService,
    private readonly toolRegistry: ToolRegistry,
    private readonly logSvc: AiLogService,
    private readonly dataSource: DataSource,
    private readonly bizTools: BizAiTools,
    private readonly chatModel: ChatModelService,
    @InjectRepository(AiCallLog) private readonly callLogRepo: Repository<AiCallLog>,
    @InjectRepository(AiToolCallLog) private readonly toolLogRepo: Repository<AiToolCallLog>,
  ) {}

  // ---------------- 模型配置（数据库化）----------------
  /**
   * 列出全部模型配置（含停用记录）。
   * @returns 模型配置数组，含 base_url / model / temperature 等字段
   */
  @Get('model-config')
  async modelConfigs() {
    return ok(await this.modelConfigSvc.list());
  }

  /**
   * 新增模型配置。
   * @param dto 模型配置（name/base_url/api_key/model/temperature/max_tokens/is_default）
   * @returns 新增后的记录
   */
  @Post('model-config/add')
  async addModelConfig(@Body() dto: Partial<AiModelConfig>) {
    return ok(await this.modelConfigSvc.create(dto), '添加成功');
  }

  /**
   * 修改模型配置。
   * @param id 配置 ID
   * @param dto 待更新字段
   * @returns 更新后的记录
   */
  @Post('model-config/edit')
  async editModelConfig(@Body('id') id: number, @Body() dto: Partial<AiModelConfig>) {
    return ok(await this.modelConfigSvc.update(id, dto), '保存成功');
  }

  /**
   * 删除模型配置。
   * @param id 配置 ID
   * @returns null
   */
  @Delete('model-config/del')
  async delModelConfig(@Body('id') id: number) {
    await this.modelConfigSvc.remove(id);
    return ok(null, '删除成功');
  }

  // ---------------- Prompt 模板管理 ----------------
  /**
   * 列出全部 Prompt 模板。
   * @returns 模板数组，含 code / content / variables
   */
  @Get('prompt-template')
  async promptTemplates() {
    return ok(await this.promptSvc.list());
  }

  /**
   * 新增 Prompt 模板。
   * @param dto 模板内容（code 唯一、content 支持 {变量} 占位）
   * @returns 新增后的记录
   */
  @Post('prompt-template/add')
  async addPrompt(@Body() dto: Partial<AiPromptTemplate>) {
    return ok(await this.promptSvc.create(dto), '添加成功');
  }

  /**
   * 修改 Prompt 模板。
   * @param id 模板 ID
   * @param dto 待更新字段
   * @returns 更新后的记录
   */
  @Post('prompt-template/edit')
  async editPrompt(@Body('id') id: number, @Body() dto: Partial<AiPromptTemplate>) {
    return ok(await this.promptSvc.update(id, dto), '保存成功');
  }

  /**
   * 删除 Prompt 模板。
   * @param id 模板 ID
   * @returns null
   */
  @Delete('prompt-template/del')
  async delPrompt(@Body('id') id: number) {
    await this.promptSvc.remove(id);
    return ok(null, '删除成功');
  }

  /**
   * 按模板 code 渲染最终提示词（变量填充）。
   * @param code 模板唯一编码
   * @param variables 变量字典，如 { name: '张三', amount: 100 }
   * @returns 渲染后的文本
   */
  @Post('prompt-template/render')
  async renderPrompt(@Body('code') code: string, @Body('variables') variables: Record<string, any>) {
    return ok(await this.promptSvc.render(code, variables || {}));
  }

  // ---------------- 已注册工具（Function Calling）----------------
  /**
   * 列出当前注册的 AI 工具（供前端/模型选择可用能力）。
   * @returns [{ name, description, parameters }]
   */
  @Get('tools')
  async tools() {
    return ok(this.toolRegistry.list().map((t) => ({ name: t.name, description: t.description, parameters: t.parameters })));
  }

  // ---------------- 业务场景：智能补货 AI 建议 ----------------
  /**
   * 智能补货 AI 建议：接收看板当前补货清单，产出每个商品的紧急度/理由/风险 + 整体建议。
   * 前端智能补货看板（board.vue）在用户点「AI 智能补货建议」时调用，清单由前端传当前看板行。
   * @param dto.items 看板行 [{ goods_code, goods_name, sale_number, stock, suggest_number }]
   * @param dto.modelConfigId 可选模型配置 ID
   * @returns { items:[{goods_code,goods_name,suggest_number,unit_price,recommended_supplier_code,recommended_supplier_name,urgency,reason,risk}], summary }
   */
  @Post('replenish-advice')
  async replenishAdvice(
    @Body() dto: { items?: any[]; modelConfigId?: number },
  ) {
    const rawItems = Array.isArray(dto?.items) ? dto.items : [];
    if (!rawItems.length) throw new BadRequestException('缺少补货清单数据');
    try {
      // 批量附上默认采购单价与推荐供应商（取最近一次采购单的供应商），再交给模型做结构化建议
      const items = await this.bizTools.enrichReplenish(rawItems.slice(0, 30));
      const schema = {
        items: [
          {
            goods_code: '商品编号',
            goods_name: '商品名称',
            suggest_number: 0,
            unit_price: '建议采购单价（直接采用数据中的 unit_price 字段）',
            recommended_supplier_code: '推荐供应商编号（必须原样采用数据中提供的 recommended_supplier_code 字段值，无则空字符串）',
            recommended_supplier_name: '推荐供应商名称（必须原样采用数据中提供的 recommended_supplier_name 字段值，无则空字符串）',
            urgency: '高|中|低',
            reason: '建议采购理由',
            risk: '不补货的风险',
          },
        ],
        summary: '整体采购优先级与资金占用建议',
      };
      const system =
        '你是进销存系统的资深采购补货专家。根据每个商品的待发数量、当前库存、建议采购单价与推荐供应商，' +
        '给出合理的采购优先级与风险判断。urgency 只能取 "高"、"中"、"低" 三档之一。' +
        'unit_price、recommended_supplier_code 与 recommended_supplier_name 必须原样采用数据中提供的字段值，不要自行编造或改写。';
      const user = '以下是待补货商品清单（已附带默认采购单价与推荐供应商，JSON）：\n' + JSON.stringify(items);
      const { data, raw } = await this.jsonSvc.requestObject({
        user,
        system,
        schema,
        modelConfigId: dto.modelConfigId,
      });
      return ok(data || { raw });
    } catch (e: any) {
      throw new BadRequestException('AI 补货建议生成失败：' + (e?.message || e));
    }
  }

  // ---------------- 客户侧智能客服（小程序/商城端）----------------
  /**
   * 客户侧智能客服对话：面向商城/小程序终端客户，单轮或多轮闲聊式问答。
   * 与后台 Agent 不同——此处不挂载业务工具（避免越权查数），仅用模型知识 + 系统人设作答。
   * 注意：Uniapp 端需以 Authorization: Bearer <token> 调用，并由网关把 /ai 反代到本服务。
   * @param dto.message 客户问题；dto.history 历史消息 [{role,content}]；dto.modelConfigId 可选模型
   * @returns { content 回复文本, history 拼接后的完整上下文 }
   */
  @Post('customer-chat')
  async customerChat(
    @Body() dto: { message: string; history?: { role: string; content: string }[]; modelConfigId?: number },
  ) {
    if (!dto?.message || !dto.message.trim()) throw new BadRequestException('缺少 message 参数');
    try {
      const history = Array.isArray(dto.history) ? dto.history : [];
      const messages: ChatMessage[] = [
        {
          role: 'system',
          content:
            '你是本商城/进销存系统的智能客服，用简洁、友好、专业的中文回答客户关于商品、价格、订单、物流、退换货、账户与发票的问题。' +
            '不确定的信息如实说明，不要编造；涉及具体订单/账户数据时，请引导客户在“我的”页面查看或联系人工客服。',
        },
        ...history.map((h) => ({ role: h.role as 'user' | 'assistant' | 'system' | 'tool', content: h.content })),
        { role: 'user', content: dto.message },
      ];
      const cfg = await this.chatModel.resolveConfig(null, dto.modelConfigId);
      const res = await this.chatModel.complete({ config: cfg, messages, tag: 'customer-chat' });
      const content = res.content || '';
      return ok({
        content,
        history: [...history, { role: 'user', content: dto.message }, { role: 'assistant', content }],
      });
    } catch (e: any) {
      throw new BadRequestException('AI 客服调用失败：' + (e?.message || e));
    }
  }

  // ---------------- 普通对话（ChatClient）----------------
  /**
   * 单轮对话（不调工具）。
   * @param dto { message 用户输入, system 系统提示词, modelConfigId 指定模型配置 }
   * @returns { content: 模型回复正文 }
   */
  @Post('chat')
  async chat(@Body() dto: { message: string; system?: string; modelConfigId?: number }) {
    if (!dto?.message || !dto.message.trim()) throw new BadRequestException('缺少 message 参数');
    try {
      const client = this.chatClientSvc.create();
      const resp = await client
        .prompt()
        .system(dto.system || '你是进销存系统的 AI 助手，回答要简洁专业。')
        .user(dto.message)
        .withModelConfigId(dto.modelConfigId)
        .call();
      return ok({ content: await resp.content() });
    } catch (e: any) {
      throw new BadRequestException('AI 对话调用失败：' + (e?.message || e));
    }
  }

  // ---------------- Agent 多轮自主执行（带工具调用）----------------
  /**
   * Agent 模式：模型自主决定调用哪些工具、调用几轮，直到能回答。
   * @param dto { message, system, modelConfigId, maxTurns 最大轮数（默认 5） }
   * @returns { content 最终答复, turns 实际轮数, toolCalls 工具调用轨迹 }
   */
  @Post('agent')
  async agent(
    @Body()
    dto: { message: string; system?: string; modelConfigId?: number; maxTurns?: number },
  ) {
    if (!dto?.message || !dto.message.trim()) throw new BadRequestException('缺少 message 参数');
    try {
      const system =
        dto.system ||
        '你是进销存系统的智能经营 Agent。当用户问经营数据、查账、做分析时，请优先调用业务工具：' +
        'query_business_overview（经营概览）、query_sales_summary / query_purchase_summary（购销汇总）、' +
        'query_profit（利润表）、query_sales_ranking（商品排行榜）、query_stock_warning（库存预警）、' +
        'query_intercourse（往来欠款）；查具体商品/库存/客户可用 query_goods / query_stock / query_customer，计算用 calc。' +
        '根据工具返回结果自主决定下一步，直到能直接、简洁地回答用户。不要编造数据，数据缺失时如实说明。';
      const result = await this.agentSvc.run({
        user: dto.message,
        system,
        tools: this.toolRegistry,
        modelConfigId: dto.modelConfigId,
        maxTurns: dto.maxTurns,
      });
      return ok({
        content: result.content,
        turns: result.turns,
        toolCalls: result.toolCalls,
      });
    } catch (e: any) {
      throw new BadRequestException('AI Agent 调用失败：' + (e?.message || e));
    }
  }

  // ---------------- 结构化 JSON 输出 ----------------
  /**
   * 让模型按给定 schema 返回 JSON（生成单据草稿、字段抽取等场景）。
   * @param dto { message, schema JSON Schema 或字段说明, system, modelConfigId }
   * @returns { data 解析后的对象, raw 模型原始输出 }
   */
  @Post('structured')
  async structured(
    @Body()
    dto: { message: string; schema?: string | Record<string, any>; system?: string; modelConfigId?: number },
  ) {
    if (!dto?.message || !dto.message.trim()) throw new BadRequestException('缺少 message 参数');
    try {
      const r = await this.jsonSvc.requestObject({
        user: dto.message,
        system: dto.system,
        schema: dto.schema,
        modelConfigId: dto.modelConfigId,
      });
      return ok({ data: r.data, raw: r.raw });
    } catch (e: any) {
      throw new BadRequestException('AI 结构化输出调用失败：' + (e?.message || e));
    }
  }

  // ---------------- 关键词检索（RAG 检索环节）----------------
  /**
   * 把商品主档写入检索索引（RAG 的“建库”步骤）。
   * @param dto { keyword 可选，只索引名称匹配的商品 }
   * @returns { indexed 本次索引条数, datasets 当前已有索引的数据集列表 }
   */
  @Post('retrieve/index-goods')
  async indexGoods(@Body() dto: { keyword?: string }) {
    const kw = dto.keyword || '';
    try {
      const rows = await this.dataSource.query(
        `SELECT id,goods_name,goods_specification_id,unit_id,inventory,market_sell_price
         FROM kuerp_goods WHERE deletetime=0 ${kw ? 'AND goods_name LIKE ?' : ''} LIMIT 200`,
        kw ? [`%${kw}%`] : [],
      );
      this.retrieval.indexDataset(
      'goods',
      rows.map((r: any) => ({
        id: r.id,
        content: `商品:${r.goods_name} 规格:${r.goods_specification_id} 单位:${r.unit_id} 库存:${r.inventory} 零售价:${r.market_sell_price}`,
        source: 'kuerp_goods',
        meta: r,
      })),
    );
      return ok({ indexed: rows.length, datasets: this.retrieval.datasets() });
    } catch (e: any) {
      throw new BadRequestException('商品索引失败：' + (e?.message || e));
    }
  }

  /**
   * 在指定数据集里检索（RAG 的“召回”步骤）。
   * @param dto { dataset 数据集名（如 goods）, keyword 查询词, topK 返回条数 }
   * @returns { hits 命中列表, context 可直接拼进提示词的上下文文本 }
   */
  @Post('retrieve')
  async retrieve(@Body() dto: { dataset: string; keyword: string; topK?: number }) {
    const hits = this.retrieval.search(dto.dataset, dto.keyword, dto.topK || 5);
    return ok({ hits, context: KeywordRetrievalService.toContext(hits) });
  }

  // ---------------- 日志 ----------------
  /**
   * 分页查询模型调用日志（排查“为什么这次答得慢/答错了”）。
   * @param page 页码，从 1 开始
   * @param limit 每页条数
   * @returns { list, count }
   */
  @Get('call-logs')
  async callLogs(@Query('page') page = 1, @Query('limit') limit = 20) {
    const [list, count] = await this.callLogRepo
      .createQueryBuilder('t')
      .where('t.deletetime = 0 OR t.deletetime IS NULL')
      .orderBy('t.id', 'DESC')
      .skip((+page - 1) * +limit)
      .take(+limit)
      .getManyAndCount();
    return ok({ list, count }, 'success');
  }

  /**
   * 分页查询工具调用日志（Agent 每轮调了哪个工具、入参出参是什么）。
   * @param page 页码，从 1 开始
   * @param limit 每页条数
   * @returns { list, count }
   */
  @Get('tool-logs')
  async toolLogs(@Query('page') page = 1, @Query('limit') limit = 20) {
    const [list, count] = await this.toolLogRepo
      .createQueryBuilder('t')
      .where('t.deletetime = 0 OR t.deletetime IS NULL')
      .orderBy('t.id', 'DESC')
      .skip((+page - 1) * +limit)
      .take(+limit)
      .getManyAndCount();
    return ok({ list, count }, 'success');
  }
}
