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
      isModalOpen: false
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
      closeModal: ->
        @isModalOpen = false
      toggleModal: ->
        @isModalOpen = !@isModalOpen
    components: {
      'side-bar': require './components/side-bar.vue'
      'hot-entry': require './components/hot-entry.vue'
      'page': require './components/page.vue'
      'bookmark': require './components/bookmark.vue'
      'search-result': require './components/search-result.vue'
      'modal': require './components/modal.vue'
      'domain': require './components/domain.vue'
    }
  app.$on 'openModal', ->
    @isModalOpen = true
