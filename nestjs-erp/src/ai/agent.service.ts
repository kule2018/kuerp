import { Injectable } from '@nestjs/common';
import { ChatModelService, ChatMessage } from './chat-model.service';
import { ToolRegistry, ToolDefinition } from './tool.registry';
import { AiLogService } from './ai-log.service';

export interface AgentRunParams {
  user: string;
  system?: string;
  /** 工具：可传 ToolRegistry，或直接传 ToolDefinition 数组 */
  tools: ToolDefinition[] | ToolRegistry;
  modelConfigId?: number;
  /** 最大多轮次数（默认 6） */
  maxTurns?: number;
}

export interface AgentRunResult {
  content: string;
  messages: ChatMessage[];
  turns: number;
  toolCalls: Array<{ turn: number; name: string; arguments: any; result: string }>;
}

/**
 * Agent 多轮自主执行服务。
 * 等价 Spring AI 的 Agent / 多轮 ChatClient 循环：模型可主动发起 Function Calling，
 * 由 ToolCallbacks 执行后把结果回填，再次调用模型，直到模型给出最终答案（或达到 maxTurns）。
 */
@Injectable()
export class AgentService {
  constructor(
    private readonly chatModel: ChatModelService,
    private readonly logService: AiLogService,
  ) {}

  async run(params: AgentRunParams): Promise<AgentRunResult> {
    const registry = params.tools instanceof ToolRegistry ? params.tools : null;
    const defs: ToolDefinition[] = registry ? registry.list() : (params.tools as ToolDefinition[]);
    const maxTurns = params.maxTurns || 6;

    const messages: ChatMessage[] = [];
    if (params.system) messages.push({ role: 'system', content: params.system });
    messages.push({ role: 'user', content: params.user });

    const transcript: AgentRunResult['toolCalls'] = [];
    let lastContent = '';
    let turns = 0;

    for (let turn = 1; turn <= maxTurns; turn++) {
      turns = turn;
      const result = await this.chatModel.complete({
        modelConfigId: params.modelConfigId,
        messages,
        tools: defs.length ? ToolRegistry.toOpenAiTools(defs) : undefined,
      });

      const rawToolCalls = result.raw?.choices?.[0]?.message?.tool_calls;
      messages.push({
        role: 'assistant',
        content: result.content,
        tool_calls: rawToolCalls,
      });
      lastContent = result.content;

      if (!result.toolCalls.length) break;

      for (const tc of result.toolCalls) {
        const started = Date.now();
        let res: { result: string; ok: boolean; error?: string };
        if (registry) {
          res = await registry.invoke(tc.name, tc.arguments);
        } else {
          const def = defs.find((d) => d.name === tc.name);
          if (!def) {
            res = { result: `工具 ${tc.name} 不存在`, ok: false, error: 'NOT_FOUND' };
          } else {
            try {
              const raw = await def.execute(tc.arguments || {});
              res = { result: typeof raw === 'string' ? raw : JSON.stringify(raw), ok: true };
            } catch (e: any) {
              res = { result: `工具执行失败: ${e?.message}`, ok: false, error: e?.message };
            }
          }
        }
        await this.logService.logToolCall({
          callLogId: result.callLogId,
          toolName: tc.name,
          arguments: JSON.stringify(tc.arguments),
          result: res.result,
          elapsedMs: Date.now() - started,
          status: res.ok ? 1 : 0,
          error: res.error,
        });
        transcript.push({ turn, name: tc.name, arguments: tc.arguments, result: res.result });
        messages.push({ role: 'tool', tool_call_id: tc.id, content: res.result, name: tc.name });
      }
    }

    return { content: lastContent, messages, turns, toolCalls: transcript };
  }
}
