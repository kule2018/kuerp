import { Injectable } from '@nestjs/common';
import { ChatModelService } from './chat-model.service';

/**
 * 结构化 JSON 输出服务。等效 Spring AI 的 BeanOutputConverter / MapOutputConverter。
 * 通过 response_format=json_object + 系统指令，强制模型返回可解析的结构化 JSON。
 */
@Injectable()
export class JsonOutputService {
  constructor(private readonly chatModel: ChatModelService) {}

  /**
   * 请求模型返回结构化 JSON。
   * @param schema 结构描述文本（如 "{name:string, total:number}"）或 JSON Schema
   * @param user 用户问题
   * @param system 可选系统提示
   */
  async requestObject(opts: {
    user: string;
    system?: string;
    schema?: string | Record<string, any>;
    modelConfigId?: number;
  }): Promise<{ data: any; raw: string }> {
    const schemaText =
      typeof opts.schema === 'string'
        ? opts.schema
        : opts.schema
        ? JSON.stringify(opts.schema, null, 2)
        : '自由结构';

    const system =
      (opts.system || '') +
      `\n你是一个结构化数据提取器。只输出一个合法的 JSON 对象，不要包含任何解释性文字、不要使用 markdown 代码块。` +
      `\n要求字段结构如下：\n${schemaText}`;

    const result = await this.chatModel.complete({
      modelConfigId: opts.modelConfigId,
      messages: [
        { role: 'system', content: system },
        { role: 'user', content: opts.user },
      ],
      responseFormat: { type: 'json_object' },
    });

    const raw = result.content.trim();
    let data: any = null;
    try {
      // 兜底去掉可能的 ```json ``` 包裹
      const cleaned = raw.replace(/^```(?:json)?/i, '').replace(/```$/, '').trim();
      data = JSON.parse(cleaned);
    } catch {
      data = null;
    }
    return { data, raw };
  }
}
