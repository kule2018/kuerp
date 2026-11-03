<template>
  <DsCard>
    <template #title>
      <span>AI 对话 / Agent 测试台</span>
    </template>

    <!-- 运行参数：模型配置 + 对话模式（原 el-form inline / el-radio-group） -->
    <div class="ds-form ds-form--inline row">
      <DsField label="模型配置ID">
        <DsInput type="number" v-model="modelConfigId" placeholder="0=默认首个" style="width: 120px" />
      </DsField>
      <DsField label="模式">
        <DsSegmented v-model="mode" :options="modeOptions" />
      </DsField>
    </div>

    <!-- 对话记录 -->
    <div class="chat">
      <div v-for="(m, i) in messages" :key="i" :class="['msg', m.role]">
        <div class="bubble">
          <div class="role">{{ m.role === 'user' ? '我' : 'AI' }}</div>
          <div class="text">{{ m.content }}</div>
          <div v-if="m.toolCalls && m.toolCalls.length" class="tools">
            <DsTag v-for="(t, j) in m.toolCalls" :key="j" size="sm" color="warning" style="margin:2px">
              🔧 {{ t.name }}
            </DsTag>
          </div>
        </div>
      </div>
    </div>

    <!-- 输入区 -->
    <div class="input-bar">
      <DsInput v-model="input" type="textarea" :rows="2" placeholder="输入消息，Enter 发送 / Shift+Enter 换行" @keyup.enter.exact.prevent="send" />
      <DsButton variant="primary" :loading="sending" @click="send" style="margin-top:8px">发送</DsButton>
    </div>
  </DsCard>
</template>

<script setup>
/**
 * 对话 / Agent 测试台：
 * - 普通对话模式调用 /ai/chat（ChatClient，等价 Spring AI ChatClient）
 * - Agent 模式调用 /ai/agent（多轮自主执行 + Function Calling 工具）
 */
import { ref } from 'vue';
import { message } from '@/utils/ui';
import request from '../../utils/request';

const mode = ref('agent');
const modelConfigId = ref(0);
const messages = ref([]);
const input = ref('');
const sending = ref(false);

/** 模式切换选项：chat=普通对话，agent=带工具调用的自主多轮 */
const modeOptions = [
  { label: '普通对话', value: 'chat' },
  { label: 'Agent(工具调用)', value: 'agent' },
];

/** 发送消息：按模式调用不同后端接口 */
async function send() {
  const text = input.value.trim();
  if (!text) return;
  messages.value.push({ role: 'user', content: text });
  input.value = '';
  sending.value = true;
  try {
    if (mode.value === 'agent') {
      const r = await request.post('/ai/agent', { message: text, modelConfigId: modelConfigId.value || undefined });
      messages.value.push({ role: 'ai', content: r?.content || '(无返回)', toolCalls: r?.toolCalls || [] });
    } else {
      const r = await request.post('/ai/chat', { message: text, modelConfigId: modelConfigId.value || undefined });
      messages.value.push({ role: 'ai', content: r?.content || '(无返回)' });
    }
  } catch (e) {
    message.error('调用失败：' + (e.message || e));
  } finally {
    sending.value = false;
  }
}
</script>

<style scoped>
.chat { min-height: 280px; max-height: 420px; overflow-y: auto; padding: 8px; background: var(--ds-bg-soft); border-radius: var(--ds-radius); }
/* 参数行：模型配置与模式切换横向排列 */
.row { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 16px; margin-bottom: 12px; }
.msg { display: flex; margin-bottom: 12px; }
.msg.user { justify-content: flex-end; }
.bubble { max-width: 72%; padding: 8px 12px; border-radius: 8px; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,.08); }
.msg.user .bubble { background: #409eff; color: #fff; }
.role { font-size: 12px; opacity: .7; margin-bottom: 2px; }
.text { white-space: pre-wrap; word-break: break-word; }
.tools { margin-top: 6px; }
.input-bar { margin-top: 12px; }
</style>
