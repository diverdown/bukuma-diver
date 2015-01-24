'use strict'
Vue = require 'vue'
RecommendCollection = require './recommend_collection'
page = require 'page'
qs = require 'qs'
_ = require 'lodash'
Site = require './site'
Query = require './query'

window.onload = ->
  Vue.config.debug = true

  Vue.filter 'truncate', (value, max)->
    if value.length > max
      value.substr(0, max) + "..."
    else
      value
  Vue.filter 'favicon', (domain)->
    "http://www.google.com/s2/favicons?domain=#{encodeURIComponent domain}"
  Vue.filter 'hatebuEntry', (url)->
    "http://b.hatena.ne.jp/entry/#{url.replace /^[a-z]+:\/\//, ''}"

  Vue.prototype.$transit = (path)->
    return if path == window.location.pathname + window.location.search
    page(path)

  app = new Vue
    el: '#app'
    data:
      currentView: ''
      mainParams: {}
      isModalOpen: false
    methods:
      search: (q)->
        @mainParams = {q: q}
        @currentView = 'search-result'
      closeModal: ->
        @isModalOpen = false
      toggleModal: ->
        @isModalOpen = !@isModalOpen
    components: {
      'side-bar': require './components/side-bar.vue'
      'hot-entry': require './components/hot-entry.vue'
      'page': require './components/page.vue'
      'comment': require './components/comment.vue'
      'search-result': require './components/search-result.vue'
      'modal': require './components/modal.vue'
      'domain': require './components/domain.vue'
      'loading-circle': require './components/loading-circle.vue'
    }
  app.$on 'openModal', (domain)->
    @isModalOpen = true
    @$broadcast 'updateModal', domain
  app.$on 'openSite', (page)->
    RecommendCollection.countUp(page)

  page '*', (ctx, next)->
    ctx.params = _.merge(qs.parse(ctx.querystring), ctx.params)
    next()

  page '/', ->
    app.currentView = 'hot-entry'

  page Site.pathTemplate, (ctx, next)->
    app.currentView = 'domain'
    app.$.main.search(ctx.params)

  page Query.pathTemplate, (ctx, next)->
    app.currentView = 'search-result'
    app.$.main.search(ctx.params)

  page()
