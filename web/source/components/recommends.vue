<template lang="jade">
h2 おすすめサイト
ul
  li.sidebar-list(v-repeat="site: sites", v-component="_site")
a(v-on="click: showMore" v-if="doesHaveMore") もっと見る...
</template>

<script lang="coffee">
_ = require 'lodash'
RecommendCollection = require '../recommend_collection'
PER_PAGE = 10
module.exports =
  data: ->
    recommends: []
    page: 1
  computed:
    sites: ->
      @_sites.slice(0, @page * PER_PAGE)
    doesHaveMore: ->
      @sites.length != @_sites.length
    _sites: ->
      _.sortBy(_.difference(@recommends, @favorites), (site)-> -site.count)
  methods:
    showMore: -> @page++
  created: ->
    RecommendCollection.restore (err, @recommends)=>
      @$watch(
        'recommends'
        -> RecommendCollection.save()
        true
      )
</script>
