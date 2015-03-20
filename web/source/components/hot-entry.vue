<style lang="scss">
h2.title-border {
  border-bottom: 1px solid #eee;
}
</style>

<template lang="jade">
h1 ホットエントリー
loading-circle(v-if="loading")
ul(v-if="!loading")
  li(v-repeat="categories")
    h2.title-border {{name}}
    ul
      li(v-repeat="pages" v-component="page" v-with="showPopularLink: 1")
    a(v-on="click: showMorePages") もっと見る...
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
module.exports =
  data: ->
    { categories: [], loading: true }
  methods:
    showMorePages: (e)->
      for pages, i in @_hiddenPages
        @categories[i].pages = @categories[i].pages.concat(pages)
      e.target.parentNode.removeChild(e.target)
  created: ->
    BukumaDiver.hotEntries (err, categories)=>
      @_hiddenPages = []
      for c, i in categories
        @_hiddenPages[i] = c.pages.splice(5)
      @categories = categories
      @loading = false
</script>
