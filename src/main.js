import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import Element from 'element-ui'
import "element-ui/lib/theme-chalk/index.css"
import axios from 'axios'
import mavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import EcTimeline from "ec-vue-timeline";
import "ec-vue-timeline/lib/ec-vue-timeline.css";


import './axios'
import './permisssion'

Vue.config.productionTip = false
Vue.use(EcTimeline);
Vue.use(Element)
Vue.use(mavonEditor)

import FloatingButtons from 'vue-floating-buttons'
import Affix from 'vue-affix';

Vue.use(Affix);
Vue.component('FloatingButtons', FloatingButtons)
Vue.prototype.$axios = axios

//在main.js设置全局的请求次数，请求的间隙

new Vue({
  "el": '#app',
  router,
  store,
  render: h => h(App)
}).$mount('#app')
