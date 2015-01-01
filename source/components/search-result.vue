<style lang="scss">
</style>

<template lang="jade">
h1 「{{params.q}}」を検索
ul
  li
    a(v-on="click: search({sort: 'popular'})") 人気順
    a(v-on="click: search({sort: 'recent', users: 3})") 新着順
    a(v-on="click: search({sort: 'recent', users: 1})") すべて
ul
  li(v-repeat="pages" v-component="page")
a(v-on="click: searchMore") もっと見る...
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
_ = require 'lodash'
module.exports =
  data: ->
    { pages: [] }
  methods:
    search: (params = {})->
      @params[k] = v for k,v of params
      BukumaDiver.search @params, (err, @pages)=>
    searchMore: ->
      BukumaDiver.search _.merge({of: @pages.length}, @params), (err, res)=>
        @pages = @pages.concat(res)
  created: ->
    @$watch 'params.q', @search, true
</script>
