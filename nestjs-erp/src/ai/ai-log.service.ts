import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AiCallLog } from './entities/ai-call-log.entity';
import { AiToolCallLog } from './entities/ai-tool-call-log.entity';
import { nowSec } from '../common/bigint.transformer';

/**
 * AI 调用与工具调用日志服务（落库）。
 * 等效 Spring AI 的 LoggingAdvisor / Observation，用于审计每一次模型调用与 Function Calling。
 */
@Injectable()
export class AiLogService {
  private enabled = (process.env.AI_ENABLE_LOG || 'true') !== 'false';

  constructor(
    @InjectRepository(AiCallLog) private readonly callLogRepo: Repository<AiCallLog>,
    @InjectRepository(AiToolCallLog) private readonly toolLogRepo: Repository<AiToolCallLog>,
  ) {}

  async logCall(input: {
    modelConfigId?: number;
    model?: string;
    prompt?: string;
    completion?: string;
    tokensPrompt?: number;
    tokensCompletion?: number;
    elapsedMs?: number;
    status?: number;
    error?: string;
  }): Promise<number> {
    if (!this.enabled) return 0;
    try {
      const entity = this.callLogRepo.create({
        modelConfigId: input.modelConfigId || 0,
        model: input.model || '',
        prompt: input.prompt || '',
        completion: input.completion || '',
        tokensPrompt: input.tokensPrompt || 0,
        tokensCompletion: input.tokensCompletion || 0,
        elapsedMs: input.elapsedMs || 0,
        status: input.status ?? 1,
        error: input.error || '',
        createtime: nowSec(),
        updatetime: nowSec(),
        deletetime: 0,
      } as any);
      // TypeORM 单实体 save 会把自增主键写回传入实体，直接取 entity.id
      await this.callLogRepo.save(entity);
      return (entity as any).id as number;
    } catch (e: any) {
      // 日志失败绝不影响主流程（否则会在 finally 里覆盖正常返回，导致 500）
      console.error('[AiLogService] logCall 落库失败（已忽略）:', e?.message || e);
      return 0;
    }
  }

  async logToolCall(input: {
    callLogId?: number;
    toolName?: string;
    arguments?: string;
    result?: string;
    elapsedMs?: number;
    status?: number;
    error?: string;
  }): Promise<void> {
    if (!this.enabled) return;
    try {
      const entity = this.toolLogRepo.create({
        callLogId: input.callLogId || 0,
        toolName: input.toolName || '',
        arguments: input.arguments || '',
        result: input.result || '',
        elapsedMs: input.elapsedMs || 0,
        status: input.status ?? 1,
        error: input.error || '',
        createtime: nowSec(),
        updatetime: nowSec(),
        deletetime: 0,
      } as any);
      await this.toolLogRepo.save(entity);
    } catch (e: any) {
      console.error('[AiLogService] logToolCall 落库失败（已忽略）:', e?.message || e);
    }
  }

  setEnabled(v: boolean) {
    this.enabled = v;
  }
}
