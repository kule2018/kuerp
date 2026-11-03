import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AiModelConfig } from './entities/ai-model-config.entity';
import { nowSec } from '../common/bigint.transformer';

/**
 * 模型配置服务：CRUD + 选择「启用且默认」的配置作为运行时模型。
 * 数据库化配置意味着切换 DeepSeek / OpenAI / 本地 Ollama 无需改代码。
 */
@Injectable()
export class AiModelConfigService {
  constructor(
    @InjectRepository(AiModelConfig) private readonly repo: Repository<AiModelConfig>,
  ) {}

  async list() {
    return this.repo.find({ where: { deletetime: 0 } as any, order: { id: 'DESC' } });
  }

  async get(id: number) {
    return this.repo.findOne({ where: { id, deletetime: 0 } as any });
  }

  async create(dto: Partial<AiModelConfig>) {
    const entity = this.repo.create({
      ...dto,
      createtime: nowSec(),
      updatetime: nowSec(),
      deletetime: 0,
    } as any);
    return this.repo.save(entity);
  }

  async update(id: number, dto: Partial<AiModelConfig>) {
    await this.repo.update(id, { ...dto, updatetime: nowSec() } as any);
    return this.repo.findOne({ where: { id } as any });
  }

  async remove(id: number) {
    await this.repo.update(id, { deletetime: nowSec() } as any);
    return true;
  }

  /**
   * 取运行时生效的配置：优先「启用且默认」，其次「启用」中的第一条；都无则回退到 .env 默认值。
   */
  async getActiveConfig(): Promise<AiModelConfig | null> {
    const all = await this.repo.find({ where: { deletetime: 0, enabled: 1 } as any });
    if (all.length === 0) return null;
    return all.find((c) => c.isDefault === 1) || all[0];
  }
}
