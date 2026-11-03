<template>
  <div class="ai-copilot">
    <!-- 悬浮入口：右下角圆形按钮，点击展开对话面板 -->
    <button v-if="!open" class="ai-fab" type="button" title="AI 经营助手" @click="open = true">
      <IconFont name="Magic" :size="22" />
    </button>

    <!-- 对话面板：复用 DsChatView 调 /ai/agent -->
    <div v-else class="ai-panel">
      <div class="ai-panel-head">
        <span><IconFont name="Magic" :size="16" /> AI 经营助手</span>
        <button class="ai-close" type="button" title="收起" @click="open = false">✕</button>
      </div>

      <div class="ai-chat">
        <DsChatView
          :messages="messages"
          empty-title="随时问我经营问题"
          empty-desc="如：本月销售和利润怎么样？哪些商品库存告急？谁还欠我们钱？"
        />
      </div>

      <div v-if="!messages.length" class="ai-quick">
        <DsButton v-for="q in quick" :key="q" variant="default" size="sm" @click="ask(q)">{{ q }}</DsButton>
      </div>

      <div class="ai-input">
        <DsInput
          v-model="input"
          type="textarea"
          :rows="2"
          placeholder="输入经营问题，Enter 发送 / Shift+Enter 换行"
          @keyup.enter.exact.prevent="send"
        />
        <DsButton variant="primary" :loading="sending" @click="send">发送</DsButton>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * 全局 AI 经营助手（悬浮窗）。
 * 挂在 layout/index.vue 的 DsAppShell 内、router-view 之外，因此跨业务页面常驻，
 * 对话上下文不会因路由切换而丢失。逻辑与「AI 经营助手」页面一致，均走 /ai/agent。
 */
import { ref } from 'vue';
import { IconFont } from '../../components';
import { message } from '@/utils/ui';
import request from '../../utils/request';

const open = ref(false);
const messages = ref([]);
const input = ref('');
const sending = ref(false);
let idSeq = 1;

/** 快捷提问，降低使用门槛 */
const quick = ['本月经营概览', '哪些商品库存告急？', '这个月利润多少？', '谁还欠我们钱？'];

function pushUser(text) {
  const m = { id: idSeq++, role: 'user', content: text };
  messages.value.push(m);
  return m;
}
function pushAi() {
  const id = idSeq++;
  messages.value.push({ id, role: 'assistant', content: '', streaming: true });
  return id;
}
function findAi(id) {
  return messages.value.find((m) => m.id === id);
}

async function send() {
  const text = input.value.trim();
  if (!text || sending.value) return;
  pushUser(text);
  input.value = '';
  const aiId = pushAi();
  sending.value = true;
  try {
    const r = await request.post('/ai/agent', { message: text });
    const ai = findAi(aiId);
    if (ai) {
      ai.content = r?.content || '(无返回)';
      ai.streaming = false;
      ai.toolCalls = r?.toolCalls || [];
    }
  } catch (e) {
    const ai = findAi(aiId);
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
/* 悬浮容器：固定右下角，置于内容之上 */
.ai-copilot { position: fixed; right: 24px; bottom: 24px; z-index: 1000; }

.ai-fab {
  width: 52px; height: 52px; border-radius: 50%; border: none; cursor: pointer;
  background: var(--ds-brand, #4f46e5); color: #fff;
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.18);
  transition: filter var(--ds-dur, 0.15s) var(--ds-ease, ease);
}
.ai-fab:hover { filter: brightness(1.06); }

/* 对话面板 */
.ai-panel {
  width: 420px; height: 72vh; max-height: 720px;
  background: var(--ds-bg, #fff);
  border: 1px solid var(--ds-border, #e5e7eb);
  border-radius: 14px;
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.18);
  display: flex; flex-direction: column; overflow: hidden;
}
.ai-panel-head {
  display: flex; align-items: center; justify-content: space-between; gap: 8px;
  padding: 10px 14px; border-bottom: 1px solid var(--ds-border, #e5e7eb); font-weight: 600;
}
.ai-panel-head span { display: inline-flex; align-items: center; gap: 6px; }
.ai-close { border: none; background: transparent; cursor: pointer; font-size: 16px; color: var(--ds-text-3, #9ca3af); }
.ai-close:hover { color: var(--ds-text, #374151); }

.ai-chat { flex: 1; min-height: 0; display: flex; }
.ai-quick { display: flex; flex-wrap: wrap; gap: 6px; padding: 8px 12px; }
.ai-input { display: flex; gap: 8px; align-items: flex-end; padding: 10px 12px; border-top: 1px solid var(--ds-border, #e5e7eb); }
.ai-input :deep(textarea) { flex: 1; }
</style>
