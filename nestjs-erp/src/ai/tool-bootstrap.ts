import { Injectable, OnModuleInit } from '@nestjs/common';
import { ToolRegistry } from './tool.registry';
import { ErpDemoTools } from './demo-tools';
import { BizAiTools } from './biz-tools';

/**
 * 工具引导：把带 @Tool 的 provider 登记进 ToolRegistry，并在模块初始化后扫描注册。
 * 新增工具只需：1) 在任意 @Injectable() 类方法上写 @Tool；2) 在 AiModule providers 注册该类；
 * 3) 在此构造参数中注入它即可自动被 Agent 调用。
 */
@Injectable()
export class ToolBootstrap implements OnModuleInit {
  constructor(
    private readonly registry: ToolRegistry,
    private readonly erpDemoTools: ErpDemoTools,
    private readonly bizTools: BizAiTools,
  ) {
    this.registry.registerProvider(erpDemoTools);
    this.registry.registerProvider(bizTools);
  }

  onModuleInit() {
    this.registry.scan();
  }
}
