<template lang="jade">
header#sidebar-top.center-flexbox
  h1#title.center-flexbox
    i#logo.icon-bukuma-diver
    a(v-on="click: $transit('/')") ブクマダイバー

#sidebar-middle.padding-4unit-2unit
  a#hotentry.center-flexbox(v-on="click: $transit('/')")
    img.favicon(src="/image/hatenabookmark-logo.png" alt="はてなブックマーク")
    | ホットエントリー
  #search-box
    input(v-model="query" type="text" placeholder="キーワードではてブ検索" v-on="keyup: $transit('/pages/?q='+query) | key enter")
    i.fa.fa-search(v-on="click: $transit('/pages/?q='+query)")

.padding-4unit-0unit
  .margin-6unit-0unit(v-component="my-favorites" v-with="favorites: favorites")

  .margin-6unit-0unit
    h2 おすすめサイト
    ul
      li.sidebar-list(v-repeat="site: filteredRecommends | orderBy 'count' -1", v-component="_site")

  .margin-6unit-0unit
    h2 人気サイト
    ul
      li.sidebar-list(v-repeat="site: popularSites", v-component="_site")
    a(v-on="click: addMorePopularSites" v-if="doesHaveMorePopularSites") もっと見る...
</template>

<script lang="coffee">
_ = require 'lodash'
Site = require '../site'
RecommendCollection = require '../recommend_collection'
module.exports =
  components:
    'my-favorites': require './favorites.vue'
    _site: require './_site.vue'
  data: ->
    recommends: []
    popularSites: []
    doesHaveMorePopularSites: true
  computed:
    filteredRecommends: ->
      _.difference @recommends, @favorites
  methods:
    addMorePopularSites: ->
      Site.popular(
        offset: @popularSites.length
        (err, sites)=>
          @doesHaveMorePopularSites = sites.length == 10
          @popularSites = @popularSites.concat(sites)
      )
  created: ->
    Site.popular(null, (err, @popularSites)=>)
    RecommendCollection.restore (err, @recommends)=>
      @$watch(
        'recommends'
        -> RecommendCollection.save()
        true
      )
</script>
