'use strict'
Raven = require 'raven-js'
Raven.config(process.env.SENTRY_PUBLIC_DSN).install()
window.onload = Raven.wrap ->
  Vue = require 'vue'
  RecommendCollection = require './recommend_collection'
  page = require 'page'
  qs = require 'qs'
  _ = require 'lodash'
  Site = require './site'
  Query = require './query'
  BukumaDiver = require './bukuma_diver'
  stickifier = require 'stickifier'

  window.addEventListener 'scroll', stickifier(
    target: -> document.querySelector('#sidebar'),
    lowerBound: 0,
    bottomBarrier: -> document.querySelector('#footer')
    wait: 100
  )

  Vue.config.debug = true

  Vue.filter 'favicon', (domain)->
    "http://www.google.com/s2/favicons?domain=#{encodeURIComponent domain}"
  Vue.filter 'hatebuEntry', (url)->
    path = url.replace /^http(s)?:\/\/(.+)$/, (str, isHttps, urn)->
      (if isHttps then 's/' else '') + urn
    "http://b.hatena.ne.jp/entry/#{path}"
  Vue.filter 'toDate', (timestamp)->
    fragments = timestamp.split(/[/\s]/)
    "#{fragments[0]}年#{fragments[1]}月#{fragments[2]}日"
  Vue.filter 'u', encodeURIComponent

  Vue.prototype.$transit = (path)->
    return if path == window.location.pathname + window.location.search
    window.scrollTo(0, 0)
    page(path)

  Vue.prototype.$pushMainContent = (callback)->
    Vue.nextTick ->
      main = document.querySelector('#main')
      height = main.querySelector('.main-header').clientHeight
      main.style.paddingTop = "#{height}px"
      callback() if callback

  app = new Vue
    el: '#app'
    data:
      currentView: ''
      mainParams: {}
      isModalOpen: false
      footerContent: ''
    methods:
      search: (q)->
        @mainParams = {q: q}
        @currentView = 'search-result'
      closeModal: ->
        @isModalOpen = false
      toggleModal: ->
        @isModalOpen = !@isModalOpen
    components: {
      'sidebar': require './components/sidebar.vue'
      'hot-entry': require './components/hot-entry.vue'
      'page': require './components/page.vue'
      'comments': require './components/comments.vue'
      'comment': require './components/comment.vue'
      'search-result': require './components/search-result.vue'
      'modal': require './components/modal.vue'
      'domain': require './components/domain.vue'
      'loading-circle': require './components/loading-circle.vue'
    }
    attached: ->
      BukumaDiver.footer (err, @footerContent)=>

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
