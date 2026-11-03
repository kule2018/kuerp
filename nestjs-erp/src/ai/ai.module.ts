import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TableModule } from '../kuerp/table/table.module';
import { AiModelConfig } from './entities/ai-model-config.entity';
import { AiPromptTemplate } from './entities/ai-prompt-template.entity';
import { AiCallLog } from './entities/ai-call-log.entity';
import { AiToolCallLog } from './entities/ai-tool-call-log.entity';
import { AiModelConfigService } from './ai-model-config.service';
import { PromptTemplateService } from './prompt-template.service';
import { ChatModelService } from './chat-model.service';
import { ChatClientService } from './chat-client';
import { AgentService } from './agent.service';
import { JsonOutputService } from './json-output.service';
import { KeywordRetrievalService } from './keyword-retrieval.service';
import { AiLogService } from './ai-log.service';
import { ToolRegistry } from './tool.registry';
import { ErpDemoTools } from './demo-tools';
import { BizAiTools } from './biz-tools';
import { ToolBootstrap } from './tool-bootstrap';
import { AiController } from './ai.controller';
import { ShopModule } from '../shop/shop.module';
import { AuthModule } from '../auth/auth.module';
import { ShopOrJwtGuard } from '../common/guards/shop-or-jwt.guard';

/**
 * AI 能力模块：等价 Spring AI 全套能力（模型配置库 / Prompt 模板 / @Tool / ToolCallbacks / Agent / 关键词检索 / JSON 输出 / 调用日志）。
 * 导出的服务可供 kuerp 业务模块直接复用（如单据审核时调用 AI、报表 AI 解读等）。
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([AiModelConfig, AiPromptTemplate, AiCallLog, AiToolCallLog]),
    TypeOrmModule,
    TableModule,
    ShopModule,
    AuthModule,
  ],
  providers: [
    AiModelConfigService,
    PromptTemplateService,
    ChatModelService,
    ChatClientService,
    AgentService,
    JsonOutputService,
    KeywordRetrievalService,
    AiLogService,
    ToolRegistry,
    ErpDemoTools,
    BizAiTools,
    ToolBootstrap,
    ShopOrJwtGuard,
  ],
  controllers: [AiController],
  exports: [
    ToolRegistry,
    ChatClientService,
    AgentService,
    JsonOutputService,
    KeywordRetrievalService,
    AiModelConfigService,
    PromptTemplateService,
    AiLogService,
    BizAiTools,
  ],
})
export class AiModule {}
