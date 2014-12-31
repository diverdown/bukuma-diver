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
      mainParams: {}
    components: {
      'side-bar': require './components/side-bar.vue'
      'hot-entry': require './components/hot-entry.vue'
      'page': require './components/page.vue'
      'bookmark': require './components/bookmark.vue'
      'search-result': require './components/search-result.vue'
    }
  app.$on 'search', (q)->
    @mainParams = {q: q}
    if @currentView == 'search-result'
      @$broadcast('search')
    else
      @currentView = 'search-result'
