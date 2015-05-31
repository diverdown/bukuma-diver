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
        a.state-default(href="javascript:void(0)" v-on="click: update({sort: 'count'})") 人気順
      li.header-state(v-class="active: params.sort == 'recent'")
        a.state-default(href="javascript:void(0)" v-on="click: update({sort: 'recent'})") 新着順
      li.header-state(v-class="active: params.sort == 'eid'")
        a.state-default(href="javascript:void(0)" v-on="click: update({sort: 'eid'})") すべて
loading-circle(v-if="loading")
ul.pages(v-if="!loading")
  li.margin-4unit(v-repeat="pages" v-component="page")
.center.padding-6uni-0unit(v-if="hasMore")
  a.button.button-default.padding-2unit-4unit(href="{{hatebuLink}}" target="_blank") はてブでもっと見る

</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
Site = require '../site'
_ = require 'lodash'
MAX_PAGES = 30
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
    hasMore: -> @pages.length == MAX_PAGES
    socialTitle: -> "ブクマダイバー - #{@site.domain}のブクマ"
    hatebuLink: -> "http://b.hatena.ne.jp/entrylist?sort=#{@params.sort}&url=#{@site.domain}&of=#{MAX_PAGES}"
  methods:
    update: (params)->
      if @globalUpdate
        @$transit(@site.toPath(params))
      else
        @search(_.merge(@params, params))
    search: (params = {})->
      @loading = true
      @params[k] = v for k,v of params
      @site = Site.find(@params)
      BukumaDiver.searchByDomain @params, (err, res)=>
        return if !@$el or @params.domain != params.domain
        {name, @totalBookmarkCount, @pages} = res
        @loading = false
        @site.name = name
        @$pushMainContent() if @fixedHeader
    toggleFavorite: -> @site.toggleFavorite()
  attached: -> @$dispatch 'mainUpdated'
</script>
