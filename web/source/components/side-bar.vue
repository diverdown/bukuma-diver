<template lang="jade">
header#title
  h1.container
    a(v-on="click: $transit('/')") ブクマダイバー

#nav-middle.padding-2unit-1unit
  a#hotentry(v-on="click: $transit('/')")
    i.fa.fa-fire.favicon
    | ホットエントリー
  #search-box.margin-1unit-0unit
    input(v-model="query" type="text" placeholder="キーワードではてブ検索" v-on="keyup: $transit('/pages/?q='+query) | key enter")
    i.fa.fa-search(v-on="click: $transit('/pages/?q='+query)")

.padding-1unit
  my-favorites.margin-3unit-0unit

  .margin-3unit-0unit
    h2 おすすめサイト
    ul
      li(v-repeat="site: recommends | orderBy 'count' -1", v-component="_site")

  .margin-3unit-0unit
    h2 人気サイト
    ul
      li(v-repeat="site: popularSites", v-component="_site")
    a(v-on="click: addMorePopularSites" v-if="doesHaveMorePopularSites") もっと見る...
</template>

<script lang="coffee">
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
