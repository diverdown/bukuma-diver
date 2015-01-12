<style lang="scss">
.search-box {
  position: relative;
  input {
    width: 100%;
  }
  .fa-search {
    position: absolute;
    right: 3px;
    top: 5px;
    color: #999;
    cursor: pointer;
  }
}
</style>

<template lang="jade">
h2(v-on="click: $transit('/')") ホットエントリー
.search-box
  input(v-model="query" type="text" placeholder="キーワードではてブ検索" v-on="keyup: $transit('/pages/?q='+query) | key enter")
  i.fa.fa-search(v-on="click: $transit('/pages/?q='+query)")

my-favorites

h2 おすすめサイト
ul
  li(v-repeat="site: recommends | orderBy 'count' -1", v-component="_site")

h2 人気サイト
ul
  li(v-repeat="site: popularSites", v-component="_site")
a(v-on="click: addMorePopularSites" v-if="doesHaveMorePopularSites") もっと見る...
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
RecommendCollection = require '../recommend_collection'
module.exports =
  components:
    'my-favorites': require './favorites.vue'
    _site: require './_site.vue'
  data: ->
    recommends: RecommendCollection.all()
    popularSites: []
    doesHaveMorePopularSites: true
  methods:
    addMorePopularSites: ->
      BukumaDiver.popularSites(
        offset: @popularSites.length
        (err, sites)=>
          @doesHaveMorePopularSites = sites.length == 10
          @popularSites = @popularSites.concat(sites)
      )
  created: ->
    BukumaDiver.popularSites(null, (err, @popularSites)=>)

</script>
