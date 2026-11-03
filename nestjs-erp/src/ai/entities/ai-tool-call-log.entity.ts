import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

/**
 * 工具调用日志（落库）。记录 Agent 每次 Function Calling 的工具名、入参、出参、耗时。
 */
@Entity('ai_tool_call_log')
export class AiToolCallLog extends BaseEntity {
  @Column({ type: 'int', default: 0, comment: '关联 AI 调用日志ID' })
  callLogId: number;

  @Column({ type: 'varchar', length: 100, default: '', comment: '工具名称' })
  toolName: string;

  @Column({ type: 'text', comment: '入参(JSON)' })
  arguments: string;

  @Column({ type: 'text', comment: '出参' })
  result: string;

  @Column({ type: 'int', default: 0, comment: '耗时(ms)' })
  elapsedMs: number;

  @Column({ type: 'tinyint', default: 1, comment: '状态:1=成功,0=失败' })
  status: number;

  @Column({ type: 'text', comment: '错误信息' })
  error: string;
}
