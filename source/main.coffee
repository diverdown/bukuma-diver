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
    methods:
      search: (q)->
        @mainParams = {q: q}
        if @currentView == 'search-result'
          @$broadcast('searchAgain')
        else
          @currentView = 'search-result'
      searchBySite: (site)->
        @mainParams = site
        @currentView = 'domain'
    components: {
      'side-bar': require './components/side-bar.vue'
      'hot-entry': require './components/hot-entry.vue'
      'page': require './components/page.vue'
      'bookmark': require './components/bookmark.vue'
      'search-result': require './components/search-result.vue'
      'domain': require './components/domain.vue'
    }
