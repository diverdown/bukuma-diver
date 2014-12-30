'use strict'
Vue = require 'vue'
window.onload = ->
  Vue.filter 'truncate', (value, max)->
    if value.length > max
      value.substr(0, max) + "..."
    else
      value
  app = new Vue
    el: '#app'
    data:
      currentView: 'hot-entry'
    components: {
      'side-bar': require './components/side-bar.vue'
      'hot-entry': require './components/hot-entry.vue'
      'page': require './components/page.vue'
      'bookmark': require './components/bookmark.vue'
    }
