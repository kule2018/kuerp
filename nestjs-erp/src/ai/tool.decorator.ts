/**
 * @Tool 装饰器：将一个方法注册为 AI 可调用的「工具/函数」。
 * 等效 Spring AI 的 @Tool 注解。元数据挂在方法函数上，运行时由 ToolRegistry 扫描收集。
 *
 * 用法：
 *   @Tool({ name: 'queryGoods', description: '按关键字查询商品', parameters: {...jsonSchema} })
 *   async queryGoods(args: { keyword: string }) { ... }
 */
export interface ToolMetadata {
  name: string;
  description: string;
  /** JSON Schema 描述入参 */
  parameters: {
    type: 'object';
    properties: Record<string, any>;
    required?: string[];
  };
}

export const TOOL_METADATA = '__ai_tool__';

export function Tool(metadata: ToolMetadata): MethodDecorator {
  return (target: any, propertyKey: string | symbol, descriptor: PropertyDescriptor) => {
    descriptor.value[TOOL_METADATA] = metadata;
    return descriptor;
  };
}

/** 判断一个对象方法是否标记了 @Tool，并返回其元数据 */
export function getToolMetadata(target: any, propertyKey: string): ToolMetadata | undefined {
  const fn = target[propertyKey];
  if (typeof fn !== 'function') return undefined;
  return fn[TOOL_METADATA];
}
