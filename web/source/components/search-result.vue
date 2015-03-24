<template lang="jade">
header.main-header.fixed
  .container
    h1.padding-1unit-2unit.left 「{{query.query}}」を検索
    i.right.fa.fa-heart(v-on="click: toggleFavorite" v-class="favorited: query.favorited")

  nav
    ul.header-states
      li.header-state(v-class="active: popular")
        a.padding-1unit(v-on="click: $transit(query.toPath({sort: 'popular'}))") 人気順
      li.header-state(v-class="active: new")
        a.padding-1unit(v-on="click: $transit(query.toPath({sort: 'recent', users: 3}))") 新着順
      li.header-state(v-class="active: all")
        a.padding-1unit(v-on="click: $transit(query.toPath({sort: 'recent', users: 1}))") すべて

loading-circle(v-if="loading")
ul.padding-2unit(v-if="!loading")
  li.margin-2unit(v-repeat="pages" v-component="page" v-with="withDomain: 1")
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
  created: ->
    @$watch 'params.q', @search, true
</script>
