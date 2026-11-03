import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

/**
 * AI 调用日志（落库）。记录每一次模型调用的入参/出参/耗时/状态，等效 Spring AI 的 Observation/日志 Advisor。
 */
@Entity('ai_call_log')
export class AiCallLog extends BaseEntity {
  @Column({ type: 'int', default: 0, comment: '关联模型配置ID' })
  modelConfigId: number;

  @Column({ type: 'varchar', length: 100, default: '', comment: '模型' })
  model: string;

  @Column({ type: 'text', comment: '提示词(合并后)' })
  prompt: string;

  @Column({ type: 'text', comment: '模型返回内容' })
  completion: string;

  @Column({ type: 'int', default: 0, comment: '提示 token 数' })
  tokensPrompt: number;

  @Column({ type: 'int', default: 0, comment: '补全 token 数' })
  tokensCompletion: number;

  @Column({ type: 'int', default: 0, comment: '耗时(ms)' })
  elapsedMs: number;

  @Column({ type: 'tinyint', default: 1, comment: '状态:1=成功,0=失败' })
  status: number;

  @Column({ type: 'text', comment: '错误信息' })
  error: string;
}
