import { Injectable } from '@nestjs/common';
import { ChatModelService, ChatMessage, CompleteResult } from './chat-model.service';
import { ToolRegistry, ToolDefinition } from './tool.registry';
import { AiModelConfig } from './entities/ai-model-config.entity';

/**
 * Advisor：在请求发出前对 Prompt / 上下文做增强（Spring AI 同名概念）。
 * 例如 LoggingAdvisor（日志）、QuestionAnswerAdvisor（RAG 检索注入上下文）。
 */
export interface Advisor {
  name: string;
  before?: (ctx: AdvisorContext) => Promise<void> | void;
}

export interface AdvisorContext {
  messages: ChatMessage[];
  tools: ToolDefinition[];
  config?: AiModelConfig | null;
  modelConfigId?: number;
  responseFormat?: any;
}

export interface CallResponse {
  content: () => Promise<string>;
  responseEntity: () => Promise<CompleteResult>;
}

/**
 * ChatClient：流式 Builder API，等价 Spring AI 的 ChatClient。
 *
 * 用法：
 *   const client = chatClientService.create();
 *   const answer = await client
 *     .prompt()
 *     .system('你是进销存助手')
 *     .user('帮我查库存低于 10 的商品')
 *     .tools(toolRegistry)
 *     .advisors(new LoggingAdvisor())
 *     .call()
 *     .content();
 */
export class ChatClient {
  private _system?: string;
  private _user?: string;
  private toolDefs: ToolDefinition[] = [];
  private _advisors: Advisor[] = [];
  private responseFormat?: any;
  private config?: AiModelConfig | null;
  private modelConfigId?: number;

  constructor(private readonly chatModel: ChatModelService) {}

  prompt(): this {
    return this;
  }

  system(text: string): this {
    this._system = text;
    return this;
  }

  user(text: string): this {
    this._user = text;
    return this;
  }

  tools(defs: ToolDefinition[] | ToolRegistry): this {
    this.toolDefs = Array.isArray(defs) ? defs : defs.list();
    return this;
  }

  advisors(...ads: Advisor[]): this {
    this._advisors.push(...ads);
    return this;
  }

  withConfig(cfg: AiModelConfig): this {
    this.config = cfg;
    return this;
  }

  withModelConfigId(id: number): this {
    this.modelConfigId = id;
    return this;
  }

  withResponseFormat(rf: any): this {
    this.responseFormat = rf;
    return this;
  }

  private buildMessages(): ChatMessage[] {
    const msgs: ChatMessage[] = [];
    if (this._system) msgs.push({ role: 'system', content: this._system });
    if (this._user) msgs.push({ role: 'user', content: this._user });
    return msgs;
  }

  async call(): Promise<CallResponse> {
    const ctx: AdvisorContext = {
      messages: this.buildMessages(),
      tools: this.toolDefs,
      config: this.config,
      modelConfigId: this.modelConfigId,
      responseFormat: this.responseFormat,
    };
    for (const a of this._advisors) await a.before?.(ctx);
    const result = await this.chatModel.complete({
      config: this.config,
      modelConfigId: this.modelConfigId,
      messages: ctx.messages,
      tools: this.toolDefs.length ? ToolRegistry.toOpenAiTools(this.toolDefs) : undefined,
      responseFormat: this.responseFormat,
    });
    return {
      content: () => Promise.resolve(result.content),
      responseEntity: () => Promise.resolve(result),
    };
  }

  async *stream(): AsyncGenerator<string> {
    const r = await this.call();
    yield await r.content();
  }
}

/**
 * ChatClient 工厂：每个请求 new 一个 ChatClient（等价 Spring AI 的 ChatClient.Builder.build()）。
 */
@Injectable()
export class ChatClientService {
  constructor(private readonly chatModel: ChatModelService) {}

  create(): ChatClient {
    return new ChatClient(this.chatModel);
  }
}

/** 内置日志 Advisor：把本轮 system/user 打到控制台（落库由 ChatModelService 统一处理） */
export class LoggingAdvisor implements Advisor {
  name = 'LoggingAdvisor';
  before(ctx: AdvisorContext) {
    // 实际落库在 ChatModelService.complete 内完成；此处仅做请求级日志
    void ctx;
  }
}
