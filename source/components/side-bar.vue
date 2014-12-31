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
    li(v-repeat="domains")
      a {{$value}}
</template>

<script lang="coffee">
module.exports =
  data: ->
    navCategories: [
      {
        name: 'お気に入りサイト',
        domains: [
          'example.com'
          'test.example.com'
        ]
      },
      {
        name: 'おすすめサイト',
        domains: [
          'example.com'
          'test.example.com'
        ]
      },
      {
        name: '人気サイト',
        domains: [
          'example.com'
          'test.example.com'
        ]
      }
    ]
  methods:
    search: ->
      @$dispatch('search', @query)
</script>
