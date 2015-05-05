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

  STICK_THRESHOULD_WIDTH = 520
  onScroll = stickifier(
    target: -> document.querySelector('#sidebar'),
    lowerBound: 0,
    bottomBarrier: -> document.querySelector('#footer')
    wait: 100
  )
  if window.innerWidth > STICK_THRESHOULD_WIDTH
    window.addEventListener 'scroll', onScroll

  window.addEventListener 'resize', _.throttle(
    do ->
      oldWidth = window.innerWidth
      y = 0
      ->
        currentWidth = window.innerWidth
        stateChanged = (currentWidth - STICK_THRESHOULD_WIDTH)*(oldWidth - STICK_THRESHOULD_WIDTH) < 0
        sidebar = document.querySelector('#sidebar')

        if stateChanged
          if currentWidth > STICK_THRESHOULD_WIDTH
            main = document.querySelector('#main')
            y -= main.getBoundingClientRect().top
            sidebar.style.cssText = "position: absolute; top: #{y}px"
            app.isSidebarActive = false
            window.addEventListener 'scroll', onScroll
          else
            document.querySelector('#sidebar-wrapper').scrollTop = -y
            sidebar.style.cssText = ''
            window.removeEventListener 'scroll', onScroll

        oldWidth = currentWidth
        y = sidebar.getBoundingClientRect().top
    100
  )

  Vue.config.debug = (process.env.NODE_ENV == 'development')

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

  e = document.createEvent('MouseEvents')
  e.initEvent('scroll', false, true)

  app = new Vue
    el: '#app'
    data:
      canonicalPath: location.pathname
      currentView: ''
      isModalOpen: false
      isSidebarActive: false
      transitionEnd: false
      footerContent: ''
      sidebarHeight: 0
      scrollEvent: e
    computed:
      hasActiveContent: -> @isModalOpen || @isSidebarActive
    methods:
      scrollTop: -> scrollTo(scrollX, 0)
      closeModal: ->
        @isModalOpen = false
      toggleModal: ->
        @isModalOpen = !@isModalOpen
      closeSidebar: (e)->
        return unless e.target.id == 'sidebar-wrapper'
        @isSidebarActive = false
        false
      toggleSidebar: ->
        @transitionEnd = false
        @isSidebarActive = !@isSidebarActive
      propagateScroll: ->
        window.dispatchEvent(@scrollEvent)
    components: {
      'sidebar': require './components/sidebar.vue'
      'hotentry': require './components/hotentry.vue'
      'search-result': require './components/search-result.vue'
      'modal': require './components/modal.vue'
      'domain': require './components/domain.vue'
      'loading-circle': require './components/_loading-circle.vue'
    }
    attached: ->
      BukumaDiver.footer (err, @footerContent)=>

  app.$on 'openModal', (domain)->
    return if window.innerWidth < STICK_THRESHOULD_WIDTH
    @isModalOpen = true
    @$broadcast 'updateModal', domain

  app.$on 'openSite', (page)->
    RecommendCollection.countUp(page)

  app.$on 'sidebarChanged', ->
    Vue.nextTick =>
      @sidebarHeight = (document.querySelector('#sidebar').clientHeight + 24) + 'px'

  page '*', (ctx, next)->
    ctx.params = _.merge(qs.parse(ctx.querystring), ctx.params)
    ga 'send', 'pageview', ctx.path
    app.canonicalPath = ctx.canonicalPath
    app.isSidebarActive = false
    next()

  page '/', ->
    app.currentView = 'hotentry'
    app.canonicalPath = '/'

  updateAndSearch = (view)->
    (ctx, next)->
      if app.currentView == view
        app.$.main.search(ctx.params)
      else
        app.$once 'mainUpdated', -> app.$.main.search(ctx.params)
        app.currentView = view

  page Site.pathTemplate, updateAndSearch('domain')

  page Query.pathTemplate, updateAndSearch('search-result')

  # push root path if not found
  page '*', -> page('/')

  page()
