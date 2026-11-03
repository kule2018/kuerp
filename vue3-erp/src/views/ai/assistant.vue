<template>
  <DsCard class="ai-assistant">
    <template #title>
      <span>AI 经营助手</span>
      <span class="sub">基于业务数据的智能问答（自动调用查数工具）</span>
    </template>

    <!-- 对话区：复用 ds 设计系统的 DsChatView（支持思考过程 / 复制 / 重新生成） -->
    <div class="chat-wrap">
      <DsChatView
        :messages="messages"
        empty-title="我是你的进销存 AI 经营助手"
        empty-desc="试着问我：本月销售和利润怎么样？哪些商品库存告急？谁还欠我们钱？"
      />
    </div>

    <!-- 快捷提问 -->
    <div class="quick" v-if="!messages.length">
      <DsButton
        v-for="q in quickQuestions"
        :key="q"
        variant="default"
        size="sm"
        @click="ask(q)"
      >{{ q }}</DsButton>
    </div>

    <!-- 输入区 -->
    <div class="input-bar">
      <DsInput
        v-model="input"
        type="textarea"
        :rows="2"
        placeholder="输入经营问题，Enter 发送 / Shift+Enter 换行"
        @keyup.enter.exact.prevent="send"
      />
      <DsButton variant="primary" :loading="sending" @click="send">发送</DsButton>
    </div>
  </DsCard>
</template>

<script setup>
/**
 * AI 经营助手：对话式经营分析入口。
 * 后端走 Agent（/ai/agent），模型可自主调用业务工具（query_business_overview /
 * query_sales_summary / query_stock_warning / query_intercourse / query_profit 等）查数后作答。
 */
import { ref } from 'vue';
import { message } from '@/utils/ui';
import request from '../../utils/request';

const messages = ref([]);
const input = ref('');
const sending = ref(false);
let idSeq = 1;

/** 快捷提问，降低使用门槛 */
const quickQuestions = [
  '给我一份本月的经营概览',
  '哪些商品库存告急？',
  '这个月的利润和利润率怎么样？',
  '谁还欠我们钱，金额多少？',
];

function pushUser(text) {
  const msg = { id: idSeq++, role: 'user', content: text };
  messages.value.push(msg);
  return msg;
}

function pushAssistant() {
  const id = idSeq++;
  messages.value.push({ id, role: 'assistant', content: '', streaming: true });
  return id;
}

function findAssistant(id) {
  return messages.value.find((m) => m.id === id);
}

async function send() {
  const text = input.value.trim();
  if (!text || sending.value) return;
  pushUser(text);
  input.value = '';
  const aiId = pushAssistant();
  sending.value = true;
  try {
    const r = await request.post('/ai/agent', { message: text });
    const ai = findAssistant(aiId);
    if (ai) {
      ai.content = r?.content || '(无返回)';
      ai.streaming = false;
      ai.toolCalls = r?.toolCalls || [];
    }
  } catch (e) {
    const ai = findAssistant(aiId);
    if (ai) {
      ai.content = '调用失败：' + (e.message || e);
      ai.streaming = false;
      ai.error = true;
    }
    message.error('AI 调用失败，请确认已在「模型配置」中设置可用的 AI 模型');
  } finally {
    sending.value = false;
  }
}

/** 快捷提问点击：直接发送 */
function ask(q) {
  input.value = q;
  send();
}
</script>

<style scoped>
.ai-assistant { display: flex; flex-direction: column; height: calc(100vh - 140px); }
.sub { font-size: 12px; color: var(--ds-text-3); margin-left: 10px; font-weight: 400; }
.chat-wrap { flex: 1; min-height: 0; }
.quick { display: flex; flex-wrap: wrap; gap: 8px; margin: 10px 0; }
.input-bar { display: flex; gap: 10px; align-items: flex-end; margin-top: 10px; }
.input-bar :deep(.ds-input), .input-bar textarea { flex: 1; }
</style>
