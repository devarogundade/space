import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import Utils from './plugins/Utils'

import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';

const app = createApp(App)

app.use(router)
app.use(Utils)
app.component('VueDatePicker', VueDatePicker)

app.mount('#app')
