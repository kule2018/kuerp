import { Injectable, Logger, OnModuleInit, Optional } from '@nestjs/common';
import { getToolMetadata, ToolMetadata } from './tool.decorator';

/**
 * 工具定义（运行时结构）：含描述 + 绑定到具体实例的可执行函数。
 */
export interface ToolDefinition {
  name: string;
  description: string;
  parameters: ToolMetadata['parameters'];
  /** 执行工具：传入解析后的参数对象，返回结果（会被序列化为字符串回传给模型） */
  execute: (args: any) => Promise<any> | any;
  /** 来源 provider 名称，便于排查 */
  source?: string;
}

/**
 * ToolRegistry：扫描所有注册进来的 provider 实例，收集其 @Tool 方法，构建工具注册表。
 * 等效 Spring AI 的 ToolCallback 注册与 ToolCallbacks.builder()。
 */
@Injectable()
export class ToolRegistry implements OnModuleInit {
  private readonly logger = new Logger(ToolRegistry.name);
  private readonly defs = new Map<string, ToolDefinition>();

  /** 由模块通过 registerTools() 注入带 @Tool 的 provider 实例 */
  private providers: any[] = [];

  registerProvider(provider: any) {
    if (provider) this.providers.push(provider);
  }

  onModuleInit() {
    this.scan();
  }

  /** 扫描所有 provider 的原型方法，提取 @Tool 元数据 */
  scan() {
    this.defs.clear();
    for (const provider of this.providers) {
      const proto = Object.getPrototypeOf(provider);
      const names = Object.getOwnPropertyNames(proto);
      for (const name of names) {
        if (name === 'constructor') continue;
        const meta = getToolMetadata(provider, name);
        if (!meta) continue;
        this.defs.set(meta.name, {
          name: meta.name,
          description: meta.description,
          parameters: meta.parameters,
          source: provider.constructor?.name,
          execute: (args: any) => provider[name](args),
        });
        this.logger.log(`注册工具: ${meta.name} <- ${provider.constructor?.name}.${name}`);
      }
    }
  }

  /** 列出所有已注册工具（用于 OpenAI tools 参数 / 管理界面展示） */
  list(): ToolDefinition[] {
    return Array.from(this.defs.values());
  }

  get(name: string): ToolDefinition | undefined {
    return this.defs.get(name);
  }

  /**
   * ToolCallbacks：把工具定义转换为 OpenAI function-calling 的 tools 数组（Spring AI 同名概念）。
   */
  static toOpenAiTools(defs: ToolDefinition[]) {
    return defs.map((d) => ({
      type: 'function',
      function: {
        name: d.name,
        description: d.description,
        parameters: d.parameters,
      },
    }));
  }

  /**
   * 执行某个工具调用（由 Agent 在多轮循环中调用），并落日志。
   * 返回字符串结果，供模型下一轮消费。
   */
  async invoke(name: string, args: any): Promise<{ result: string; ok: boolean; error?: string }> {
    const def = this.defs.get(name);
    if (!def) return { result: `工具 ${name} 不存在`, ok: false, error: 'NOT_FOUND' };
    try {
      const raw = await def.execute(args || {});
      const result = typeof raw === 'string' ? raw : JSON.stringify(raw);
      return { result, ok: true };
    } catch (e: any) {
      return { result: `工具执行失败: ${e?.message || e}`, ok: false, error: e?.message };
    }
  }
}

/** 在模块里用这个 Provider 把带 @Tool 的实例登记进注册表 */
export class ToolProviderRegistrar {
  constructor(private readonly registry: ToolRegistry, private readonly providers: any[]) {
    providers.forEach((p) => registry.registerProvider(p));
  }
}
