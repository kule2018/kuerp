import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AiPromptTemplate } from './entities/ai-prompt-template.entity';
import { nowSec } from '../common/bigint.transformer';

/**
 * Prompt 模板服务：CRUD + 渲染。等效 Spring AI 的 PromptTemplateService。
 * 渲染规则：把内容中的 {varName} 替换为传入的变量值。
 */
@Injectable()
export class PromptTemplateService {
  constructor(
    @InjectRepository(AiPromptTemplate) private readonly repo: Repository<AiPromptTemplate>,
  ) {}

  async list() {
    return this.repo.find({ where: { deletetime: 0 } as any, order: { id: 'DESC' } });
  }

  async get(id: number) {
    return this.repo.findOne({ where: { id, deletetime: 0 } as any });
  }

  async create(dto: Partial<AiPromptTemplate>) {
    const entity = this.repo.create({
      ...dto,
      createtime: nowSec(),
      updatetime: nowSec(),
      deletetime: 0,
    } as any);
    return this.repo.save(entity);
  }

  async update(id: number, dto: Partial<AiPromptTemplate>) {
    await this.repo.update(id, { ...dto, updatetime: nowSec() } as any);
    return this.repo.findOne({ where: { id } as any });
  }

  async remove(id: number) {
    await this.repo.update(id, { deletetime: nowSec() } as any);
    return true;
  }

  /** 按编码渲染模板：template.render('goods_query', { keyword: '手机' }) */
  async render(code: string, variables: Record<string, any> = {}): Promise<string> {
    const tpl = await this.repo.findOne({ where: { code, deletetime: 0 } as any });
    if (!tpl) throw new NotFoundException(`Prompt 模板不存在: ${code}`);
    return PromptTemplateService.fill(tpl.content, variables);
  }

  static fill(content: string, variables: Record<string, any>): string {
    return content.replace(/\{(\w+)\}/g, (_, key) =>
      variables[key] !== undefined ? String(variables[key]) : `{${key}}`,
    );
  }
}
