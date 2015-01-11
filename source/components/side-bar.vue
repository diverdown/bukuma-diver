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
h2 ホットエントリー
.search-box
  input(v-model="query" type="text" placeholder="キーワードではてブ検索" v-on="keyup: search | key enter")
  i.fa.fa-search(v-on="click: search")

h2 ウォッチリスト
ul
  li(v-repeat="favorite: favorites", v-component="_favorite")

h2 おすすめサイト
ul
  li(v-repeat="site: recommends | orderBy 'count' -1", v-component="_site")

h2 人気サイト
ul
  li(v-repeat="site: popularSites", v-component="_site")
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
FavoriteCollection = require '../favorite_collection'
RecommendCollection = require '../recommend_collection'
module.exports =
  components:
    _site: require './_site.vue'
    _favorite: require './_favorite.vue'
  data: ->
    recommends: RecommendCollection.all()
    favorites: FavoriteCollection.all()
    popularSites: []
  methods:
    search: ->
      @$emit('search', @query)
  created: ->
    BukumaDiver.popularSites (err, @popularSites)=>
</script>
