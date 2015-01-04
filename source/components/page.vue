<style lang="scss">
.bookmarks {
  max-height: 10em;
  overflow-y: scroll;
  font-size: 10px;
}
</style>

<template lang="jade">
h3
  a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)")
    img(v-attr="src: domain | favicon")
  a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)") {{title | truncate 100}}
.bookmark-count {{bookmark_count}}users
.bookmarks
  table
    tr(v-repeat="bookmarks" v-component="bookmark")
a(v-on="click: openModal(domain)" v-if="showPopularLink") このサイトの人気ページを見る
</template>

<script lang="coffee">
jsonp = require 'jsonp'
module.exports =
  data: ->
    bookmarks: []
  methods:
    openModal: (domain)->
      @$dispatch 'openModal', domain
  created: ->
    jsonp(
      "http://b.hatena.ne.jp/entry/jsonlite/?url=#{encodeURIComponent @url}",
      (err, {@bookmarks})=>
    )
</script>
