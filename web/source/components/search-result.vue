<template lang="jade">
header.main-header.fixed
  .center-flexbox.main-title-box
    h1.main-title 「{{query.query}}」の検索結果
    i.fa.fa-heart.large.clickable(v-on="click: toggleFavorite" v-class="favorited: query.favorited")
    i.fa.fa-share-alt.large.margin-0unit-1unit.clickable(v-on="click: $.socialButtons.toggle()")

  div(v-ref="socialButtons" v-component="social-buttons" v-with="title: socialTitle")

  nav
    ul.header-states
      li.header-state(v-class="active: popular")
        a.state-default(v-on="click: $transit(query.toPath({sort: 'popular'}))") 人気順
      li.header-state(v-class="active: new")
        a.state-default(v-on="click: $transit(query.toPath({sort: 'recent', users: 3}))") 新着順
      li.header-state(v-class="active: all")
        a.state-default(v-on="click: $transit(query.toPath({sort: 'recent', users: 1}))") すべて

loading-circle(v-if="loading")
ul.pages(v-if="!loading")
  li.margin-4unit(v-repeat="pages" v-component="page" v-with="withDomain: 1")
.center.padding-6uni-0unit(v-if="hasMore")
  a.button.button-default.padding-2unit-4unit(v-on="click: searchMore" v-if="!loading") もっと見る...

</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
Query = require '../query'
_ = require 'lodash'
module.exports =
  components:
    'social-buttons': require './_social_buttons.vue'
    page: require './_page.vue'
  data: ->
    params: {sort: 'popular', users: null}
    query: {favorited: false}
    pages: []
    loading: true
    hasMore: true
  computed:
    popular: -> @params.sort == 'popular'
    new: -> @params.sort == 'recent' and @params.users == '3'
    all: -> @params.sort == 'recent' and @params.users == '1'
    socialTitle: -> "ブクマダイバー - 「#{@query.query}」の検索結果"
  methods:
    search: (params = {})->
      @loading = true
      @params[k] = v for k,v of params
      @query = Query.find(@params)
      BukumaDiver.search @params, (err, @pages)=>
        @loading = false
        @$pushMainContent()
    searchMore: ->
      BukumaDiver.search _.merge({of: @pages.length}, @params), (err, res)=>
        @pages = @pages.concat(res)
        @hasMore = false if res.length == 0
    toggleFavorite: -> @query.toggleFavorite()
  attached: -> @$dispatch 'mainUpdated'
</script>
