<template lang="jade">
header.main-header.fixed
  .center-flexbox.main-title-box
    h1.main-title 「{{query.query}}」の検索結果
    i.fa.fa-heart.large.clickable(v-on="click: toggleFavorite" v-class="favorited: query.favorited")

  nav
    ul.header-states
      li.header-state(v-class="active: popular")
        a.padding-2unit(v-on="click: $transit(query.toPath({sort: 'popular'}))") 人気順
      li.header-state(v-class="active: new")
        a.padding-2unit(v-on="click: $transit(query.toPath({sort: 'recent', users: 3}))") 新着順
      li.header-state(v-class="active: all")
        a.padding-2unit(v-on="click: $transit(query.toPath({sort: 'recent', users: 1}))") すべて

loading-circle(v-if="loading")
ul.padding-6unit(v-if="!loading")
  li.margin-4unit(v-repeat="pages" v-component="page" v-with="withDomain: 1")
a(v-on="click: searchMore" v-if="!loading") もっと見る...

</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
Query = require '../query'
_ = require 'lodash'
module.exports =
  data: ->
    { params: {sort: 'popular', users: null}, query: {favorited: false}, pages: [], loading: true }
  computed:
    popular: -> @params.sort == 'popular'
    new: -> @params.sort == 'recent' and @params.users == '3'
    all: -> @params.sort == 'recent' and @params.users == '1'
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
    toggleFavorite: -> @query.toggleFavorite()
</script>
