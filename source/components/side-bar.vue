<style lang="scss">
#hotentry {
  font-weight: bold;
  font-size: 1.2em;
  .fa-fire { color: #fe8687; }
}
.search-box {
  position: relative;
  margin: 8px 0px;
  input {
    width: 100%;
    padding: 4px;
  }
  .fa-search {
    position: absolute;
    right: 3px;
    top: 5px;
    color: #999;
    cursor: pointer;
  }
}
#side-bar {
  li {
   margin: 4px 0px;
  }
}
</style>

<template lang="jade">
a#hotentry(v-on="click: $transit('/')")
  i.fa.fa-fire.favicon
  | ホットエントリー
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
