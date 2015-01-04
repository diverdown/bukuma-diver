<style lang="scss">
.favorited {
  color: rgb(249,180, 197);
}
</style>

<template lang="jade">
h1 {{params.name}}
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
module.exports =
  data: ->
    { favorited: false, pages: [] }
  methods:
    search: (params = {})->
      @params[k] = v for k,v of params
      @favorited = BukumaDiver.isFavorite(@params)
      BukumaDiver.searchByDomain @params, (err, {name, @pages})=>
        @params.name = name
    onDomainChange: ->
      @search(@params)
    toggleFavorite: ->
      BukumaDiver[(if @favorited then 'un' else '') + 'favorite'](@params)
      @favorited = !@favorited
  created: ->
    @$watch 'params.domain', @onDomainChange, true
</script>
