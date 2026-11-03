import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

/**
 * Prompt 模板管理（数据库化）。等效 Spring AI 的 PromptTemplate / PromptTemplateService。
 * variables 存 JSON 数组，如 ["name","type"]，渲染时按 {name} 占位替换。
 */
@Entity('ai_prompt_template')
export class AiPromptTemplate extends BaseEntity {
  @Column({ type: 'varchar', length: 50, default: '', comment: '模板名称' })
  name: string;

  @Column({ type: 'varchar', length: 50, default: '', comment: '模板编码(唯一)' })
  code: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: '标题' })
  title: string;

  @Column({ type: 'text', comment: '模板内容(支持 {var} 占位)' })
  content: string;

  @Column({ type: 'varchar', length: 500, default: '', comment: '变量列表(JSON数组)' })
  variables: string;

  @Column({ type: 'varchar', length: 20, default: 'system', comment: '角色(system/user)' })
  role: string;

  @Column({ type: 'varchar', length: 255, default: '', comment: '备注' })
  remark: string;
}
