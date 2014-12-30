<style lang="scss">
h2 {
  border-bottom: 1px solid #eee;
}
</style>

<template lang="jade">
h1 ホットエントリー
ul
  li(v-repeat="categories")
    h2.title-border {{name}}
    ul
      li(v-repeat="pages" v-component="page")
    a(v-on="click: showMorePages") もっと見る...
</template>

<script lang="coffee">
module.exports =
  data: ->
    { categories: [] }
  methods:
    showMorePages: (e)->
      for pages, i in @_hiddenPages
        @categories[i].pages = @categories[i].pages.concat(pages)
      e.target.parentNode.removeChild(e.target)
  created: ->
    request = require 'superagent'
    request
      .get '/stub/hotentries.json'
      .end (res)=>
        categories = JSON.parse(res.text)
        @_hiddenPages = []
        for c, i in categories
          @_hiddenPages[i] = c.pages.splice(5)
        @categories = categories
</script>
