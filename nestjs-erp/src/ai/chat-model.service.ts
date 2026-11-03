import { Injectable } from '@nestjs/common';
import { AiModelConfig } from './entities/ai-model-config.entity';
import { AiModelConfigService } from './ai-model-config.service';
import { AiLogService } from './ai-log.service';
import { nowSec } from '../common/bigint.transformer';

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant' | 'tool';
  content: string;
  /** tool 角色回传时需要 */
  tool_call_id?: string;
  /** assistant 消息可能携带的工具调用（模型发起） */
  tool_calls?: Array<{ id: string; type: 'function'; function: { name: string; arguments: string } }>;
  name?: string;
}

export interface CompleteParams {
  config?: AiModelConfig | null;
  modelConfigId?: number;
  messages: ChatMessage[];
  tools?: any[];
  toolChoice?: any;
  responseFormat?: { type: 'json_object' } | { type: 'text' };
  temperature?: number;
  maxTokens?: number;
  /** 透传给日志的业务标签 */
  tag?: string;
}

export interface CompleteResult {
  content: string;
  toolCalls: Array<{ id: string; name: string; arguments: any }>;
  usage: { promptTokens: number; completionTokens: number };
  callLogId: number;
  raw: any;
}

/**
 * ChatModel 服务：底层调用 OpenAI 兼容的 /v1/chat/completions。
 * 等效 Spring AI 的 ChatModel 实现（此处为自研轻量版，零额外依赖，用原生 fetch）。
 * 负责：解析模型配置（数据库化）、发送请求、处理 tool_calls、记录调用日志。
 */
@Injectable()
export class ChatModelService {
  constructor(
    private readonly configService: AiModelConfigService,
    private readonly logService: AiLogService,
  ) {}

  async resolveConfig(param?: AiModelConfig | null, modelConfigId?: number): Promise<AiModelConfig> {
    if (param) return param;
    if (modelConfigId) {
      const c = await this.configService.get(modelConfigId);
      if (c) return c;
    }
    const active = await this.configService.getActiveConfig();
    if (active) return active;
    // 回退到 .env 默认配置
    return {
      id: 0,
      name: 'env-default',
      provider: 'openai',
      baseUrl: process.env.AI_DEFAULT_BASE_URL || 'https://api.openai.com/v1',
      apiKey: process.env.AI_DEFAULT_API_KEY || '',
      model: process.env.AI_DEFAULT_MODEL || 'gpt-4o-mini',
      temperature: Number(process.env.AI_DEFAULT_TEMPERATURE || 0.7),
      maxTokens: Number(process.env.AI_DEFAULT_MAX_TOKENS || 2048),
      topP: 1,
      isDefault: 1,
      enabled: 1,
      remark: '',
      createtime: nowSec(),
      updatetime: nowSec(),
      deletetime: 0,
    } as AiModelConfig;
  }

  async complete(params: CompleteParams): Promise<CompleteResult> {
    const cfg = await this.resolveConfig(params.config, params.modelConfigId);
    const url = `${cfg.baseUrl.replace(/\/$/, '')}/chat/completions`;
    const body: any = {
      model: cfg.model,
      messages: params.messages,
      temperature: params.temperature ?? cfg.temperature,
      max_tokens: params.maxTokens ?? cfg.maxTokens,
      top_p: cfg.topP,
    };
    if (params.tools && params.tools.length) {
      body.tools = params.tools;
      body.tool_choice = params.toolChoice || 'auto';
    }
    if (params.responseFormat) body.response_format = params.responseFormat;

    const started = Date.now();
    let callLogId = 0;
    try {
      const res = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${cfg.apiKey}`,
        },
        body: JSON.stringify(body),
      });
      const raw = await res.json();
      if (!res.ok) {
        const errMsg = raw?.error?.message || `HTTP ${res.status}`;
        callLogId = await this.logService.logCall({
          modelConfigId: cfg.id,
          model: cfg.model,
          prompt: JSON.stringify(params.messages),
          completion: '',
          elapsedMs: Date.now() - started,
          status: 0,
          error: errMsg,
        });
        throw new Error(errMsg);
      }

      const choice = raw.choices?.[0];
      const message = choice?.message || {};
      const content: string = message.content || '';
      const toolCalls = (message.tool_calls || []).map((tc: any) => ({
        id: tc.id,
        name: tc.function?.name,
        arguments: this.safeParse(tc.function?.arguments),
      }));

      callLogId = await this.logService.logCall({
        modelConfigId: cfg.id,
        model: cfg.model,
        prompt: JSON.stringify(params.messages),
        completion: content,
        tokensPrompt: raw.usage?.prompt_tokens || 0,
        tokensCompletion: raw.usage?.completion_tokens || 0,
        elapsedMs: Date.now() - started,
        status: 1,
      });

      return {
        content,
        toolCalls,
        usage: {
          promptTokens: raw.usage?.prompt_tokens || 0,
          completionTokens: raw.usage?.completion_tokens || 0,
        },
        callLogId,
        raw,
      };
    } catch (e: any) {
      if (!callLogId) {
        await this.logService.logCall({
          modelConfigId: cfg.id,
          model: cfg.model,
          prompt: JSON.stringify(params.messages),
          completion: '',
          elapsedMs: Date.now() - started,
          status: 0,
          error: e?.message || String(e),
        });
      }
      throw e;
    }
  }

  private safeParse(s?: string): any {
    if (!s) return {};
    try {
      return JSON.parse(s);
    } catch {
      return s;
    }
  }
}
