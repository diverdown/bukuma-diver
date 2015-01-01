<style lang="scss">
.bookmarks {
  max-height: 10em;
  overflow-y: scroll;
  font-size: 10px;
}
</style>

<template lang="jade">
h3
  a(href="{{url}}" target="_blank")
    img(v-attr="src: faviconUrl")
  a(href="{{url}}" target="_blank") {{title | truncate 100}}
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
  computed:
    faviconUrl: ->
      "http://cdn-ak.favicon.st-hatena.com/?url=http%3A%2F%2F#{encodeURIComponent @domain}"
  methods:
    openModal: (domain)->
      @$dispatch 'openModal', domain
  created: ->
    jsonp(
      "http://b.hatena.ne.jp/entry/jsonlite/?url=#{encodeURIComponent @url}",
      (err, {@bookmarks})=>
    )
</script>
