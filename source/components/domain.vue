<style lang="scss">
h1 img {
  width: 0.8em;
  height: 0.8em;
}
.favorited {
  color: rgb(249,180, 197);
}
</style>

<template lang="jade">
h1
  img(v-attr="src: params.domain | favicon")
  | {{params.name}}
i.fa.fa-heart(v-on="click: toggleFavorite" v-class="favorited: favorited")
ul
  li
    a(v-on="click: search({sort: 'count'})") 人気順
    a(v-on="click: search({sort: 'recent'})") 新着順
    a(v-on="click: search({sort: 'eid'})") すべて
ul
  li(v-repeat="pages" v-component="page")
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
FavoriteCollection = require '../favorite_collection'
Site = require '../site'
module.exports =
  data: ->
    { favorited: false, pages: [] }
  methods:
    search: (params = {})->
      @params[k] = v for k,v of params
      @favorited = FavoriteCollection.doesInclude(Site.find(@params))
      BukumaDiver.searchByDomain @params, (err, {name, @pages})=>
        @params.name = name
    onDomainChange: ->
      @search(@params)
    toggleFavorite: ->
      FavoriteCollection[if @favorited then 'remove' else 'add'](Site.find(@params))
      @favorited = !@favorited
  created: ->
    @$watch 'params.domain', @onDomainChange, true
</script>
