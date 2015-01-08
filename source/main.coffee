'use strict'
Vue = require 'vue'
RecommendCollection = require './recommend_collection'
window.onload = ->
  Vue.filter 'truncate', (value, max)->
    if value.length > max
      value.substr(0, max) + "..."
    else
      value
  Vue.filter 'favicon', (domain)->
    "http://www.google.com/s2/favicons?domain=#{encodeURIComponent domain}"

  app = new Vue
    el: '#app'
    data:
      currentView: 'hot-entry'
      mainParams: {}
      isModalOpen: false
    methods:
      search: (q)->
        @mainParams = {q: q}
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
  app.$on 'openModal', (domain)->
    @isModalOpen = true
    @$broadcast 'updateModal', domain
  app.$on 'openSite', (page)->
    RecommendCollection.countUp(page)
