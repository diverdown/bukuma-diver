<template lang="jade">
header.main-header(v-class="fixed: fixedHeader")
  .center-flexbox.main-title-box
    h1.main-title.center-flexbox
      img.favicon(v-attr="src: site.domain | favicon")
      a(href="http://{{site.domain}}" target="_blank" title="{{site.name}}") {{site.name}}
    i.fa.large.margin-0unit-1unit.clickable(v-on="click: toggleFavorite" v-class="favorited: site.favorited, fa-heart: site.favorited, fa-heart-o: !site.favorited")
    i.fa.fa-share-alt.large.margin-0unit-1unit.clickable(v-on="click: $.socialButtons.toggle()")
  div(v-ref="socialButtons" v-component="social-buttons" v-with="title: socialTitle")
  .main-sub-title
    | total
    span.total-bookmark-count {{totalBookmarkCount}}
    | users

  nav
    ul.header-states
      li.header-state(v-class="active: params.sort == 'count'")
        a.state-default(v-on="click: update({sort: 'count'})") 人気順
      li.header-state(v-class="active: params.sort == 'recent'")
        a.state-default(v-on="click: update({sort: 'recent'})") 新着順
      li.header-state(v-class="active: params.sort == 'eid'")
        a.state-default(v-on="click: update({sort: 'eid'})") すべて
loading-circle(v-if="loading")
ul.pages(v-if="!loading")
  li.margin-4unit(v-repeat="pages" v-component="page")
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
Site = require '../site'

module.exports =
  components:
    'social-buttons': require './_social_buttons.vue'
    page: require './_page.vue'
  data: ->
    globalUpdate: true
    params: {sort: 'count'}
    site: {favorited: false}
    totalBookmarkCount: 0
    pages: []
    loading: true
    fixedHeader: true
  computed:
    socialTitle: -> "ブクマダイバー - #{@site.domain}のブクマ"
  methods:
    update: (params)->
      if @globalUpdate
        @$transit(@site.toPath(params))
      else
        @search(params)
    search: (params = {})->
      @loading = true
      @params[k] = v for k,v of params
      @site = Site.find(@params)
      BukumaDiver.searchByDomain @params, (err, {name, @totalBookmarkCount, @pages})=>
        @loading = false
        @site.name = name
        @$pushMainContent() if @fixedHeader
    toggleFavorite: -> @site.toggleFavorite()
  attached: -> @$dispatch 'mainUpdated'
</script>
