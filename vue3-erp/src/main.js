import { createApp } from 'vue';
import { createPinia } from 'pinia';
import { installDsUi } from './components';
import App from './App.vue';
import router from './router';
import './style.css';
// 表单排版（DsField 标签 / 栅格 / 必填星号等全局规则）
import './styles/form.css';

const app = createApp(App);
app.use(createPinia());
app.use(router);
// 激活 ds 设计系统（DeepSeek UI 风格组件，全局注册 DsXxx / BaseXxx）
installDsUi(app);
app.mount('#app');
