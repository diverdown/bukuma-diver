<style lang="scss">
</style>

<template lang="jade">
header
  h1 「{{query.query}}」を検索
  i.fa.fa-heart(v-on="click: toggleFavorite" v-class="favorited: query.favorited")

nav
  ul
    li
      a(v-on="click: $transit(query.toPath({sort: 'popular'}))") 人気順
    li
      a(v-on="click: $transit(query.toPath({sort: 'recent', users: 3}))") 新着順
    li
      a(v-on="click: $transit(query.toPath({sort: 'recent', users: 1}))") すべて

ul
  li(v-repeat="pages" v-component="page" v-with="showPopularLink: 1")
a(v-on="click: searchMore") もっと見る...
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
Query = require '../query'
FavoriteCollection = require '../favorite_collection'
_ = require 'lodash'
module.exports =
  data: ->
    { params: {}, query: {favorited: false}, pages: [] }
  methods:
    search: (params = {})->
      @params[k] = v for k,v of params
      @query = Query.find(@params)
      BukumaDiver.search @params, (err, @pages)=>
    searchMore: ->
      BukumaDiver.search _.merge({of: @pages.length}, @params), (err, res)=>
        @pages = @pages.concat(res)
    toggleFavorite: -> @query.toggleFavorite()
  created: ->
    @$watch 'params.q', @search, true
</script>
