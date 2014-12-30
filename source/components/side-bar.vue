<style lang="scss">
</style>

<template lang="jade">
h2 ホットエントリー
input(type="text" placeholder="キーワードではてブ検索")
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
</script>
