import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

/**
 * AI 模型配置（数据库化）。等效 Spring AI 的 ChatModel 连接配置。
 * 运行时以「启用」标记 + is_default 决定实际使用的模型，无需改代码即可切换 DeepSeek/OpenAI/本地 Ollama 等。
 */
@Entity('ai_model_config')
export class AiModelConfig extends BaseEntity {
  @Column({ type: 'varchar', length: 50, default: '', comment: '配置名称' })
  name: string;

  @Column({ type: 'varchar', length: 30, default: 'openai', comment: '供应商(openai/deepseek/ollama...)' })
  provider: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: 'API Base URL（OpenAI 兼容）' })
  baseUrl: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: 'API Key' })
  apiKey: string;

  @Column({ type: 'varchar', length: 100, default: '', comment: '模型名称' })
  model: string;

  @Column({ type: 'double', default: 0.7, comment: '温度' })
  temperature: number;

  @Column({ type: 'int', default: 2048, comment: '最大生成 token' })
  maxTokens: number;

  @Column({ type: 'double', default: 1, comment: 'top_p' })
  topP: number;

  @Column({ type: 'tinyint', default: 0, comment: '是否默认配置' })
  isDefault: number;

  @Column({ type: 'tinyint', default: 1, comment: '是否启用' })
  enabled: number;

  @Column({ type: 'varchar', length: 255, default: '', comment: '备注' })
  remark: string;
}
