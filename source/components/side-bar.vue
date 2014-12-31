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
div(v-repeat="navCategories")
  h2 {{name}}
  ul
    li(v-repeat="site: sites")
      a(v-on="click: searchBySite(site)") {{site.name}}
</template>

<script lang="coffee">
module.exports =
  data: ->
    dummySites = [
      {name: 'YouTube', domain: 'youtube.com'},
      {name: 'Exmample', domain: 'example.com'}
    ]
    navCategories: [
      {
        name: 'お気に入りサイト',
        sites: dummySites
      },
      {
        name: 'おすすめサイト',
        sites: dummySites
      },
      {
        name: '人気サイト',
        sites: dummySites
      }
    ]
  methods:
    search: ->
      @$emit('search', @query)
    searchBySite: (site)->
      @$emit('searchBySite', site)
</script>
