<style lang="scss">
h1 img {
  width: 0.8em;
  height: 0.8em;
}
</style>

<template lang="jade">
header
  h1
    img.favicon(v-attr="src: site.domain | favicon")
    | {{site.name}}
  i.fa.fa-heart(v-on="click: toggleFavorite" v-class="favorited: site.favorited")

nav
  ul
    li
      a(v-on="click: $transit(site.toPath({sort: 'count'}))") 人気順
    li
      a(v-on="click: $transit(site.toPath({sort: 'recent'}))") 新着順
    li
      a(v-on="click: $transit(site.toPath({sort: 'eid'}))") すべて
  .count
    | Total
    span {{totalBookmarkCount}}
    | users
ul
  li(v-repeat="pages" v-component="page")
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
FavoriteCollection = require '../favorite_collection'
Site = require '../site'
module.exports =
  data: ->
    params: {}
    site: {favorited: false}
    totalBookmarkCount: 0
    pages: []
  methods:
    search: (params = {})->
      @params[k] = v for k,v of params
      @site = Site.find(@params)
      BukumaDiver.searchByDomain @params, (err, {name, @totalBookmarkCount, @pages})=>
        @site.name = name
    onDomainChange: ->
      @search(@params)
    toggleFavorite: -> @site.toggleFavorite()
  created: ->
    @$watch 'params.domain', @onDomainChange, true
</script>
