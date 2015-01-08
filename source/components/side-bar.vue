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

h2 巡回リスト
ul
  li(v-repeat="favorite: favorites")
    img(v-attr="src: favorite.domain | favicon" v-if="favorite.domain")
    i.fa.fa-search(v-if="!favorite.domain")
    a(v-on="click: searchByFavorite(favorite)") {{favorite.name}}

h2 おすすめサイト
ul
  li(v-repeat="site: recommendedSites | orderBy 'count' -1")
    img(v-attr="src: site.domain | favicon")
    a(v-on="click: searchBySite(site)") {{site.name}}

h2 人気サイト
ul
  li(v-repeat="site: popularSites")
    img(v-attr="src: site.domain | favicon")
    a(v-on="click: searchBySite(site)") {{site.name}}
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
FavoriteCollection = require '../favorite_collection'
RecommendCollection = require '../recommend_collection'
module.exports =
  data: ->
    recommendedSites: RecommendCollection.all()
    favorites: FavoriteCollection.all()
    popularSites: []
  methods:
    search: ->
      @$emit('search', @query)
    searchBySite: (site)->
      @$emit('searchBySite', site)
    searchByFavorite: (favorite)->
      switch favorite.constructor.name
        when 'Site' then @searchBySite(favorite)
        when 'Query'
          @query = favorite.query
          @search()
  created: ->
    BukumaDiver.popularSites (err, @popularSites)=>
</script>
