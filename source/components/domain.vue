<style lang="scss">
</style>

<template lang="jade">
h1 {{params.name}}
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
    { pages: [] }
  methods:
    search: (params = {})->
      @params[k] = v for k,v of params
      BukumaDiver.searchByDomain @params, (err, @pages)=>
  compiled: ->
    @search(@params)
</script>
