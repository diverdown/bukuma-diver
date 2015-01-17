<style lang="scss">
.comments {
  height: 10em;
  overflow-y: scroll;
  font-size: 10px;
}
</style>

<template lang="jade">
h3
  a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)")
    img(v-attr="src: domain | favicon")
  a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)") {{title | truncate 100}}
  a.right.bookmark-count(href="{{url | hatebuEntry}}" target="_blank") {{bookmark_count}}users
.comments
  table
    tr(v-repeat="comments" v-component="comment")
a(v-on="click: openModal(domain)" v-if="showPopularLink") このサイトの人気ページを見る
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
_ = require 'lodash'
module.exports =
  data: ->
    comments: []
  methods:
    openModal: (domain)->
      @$dispatch 'openModal', domain
    loadComments: ->
      BukumaDiver.comments(@url, (err, @comments)=>)
    wasSeen: ->
      {top, bottom} = @$el.getBoundingClientRect()
      0 < bottom and top < (window.innerHeight || document.documentElement.clientHeight)
  attached: ->
    # to wait rendering and get appropriate position
    @$root.constructor.nextTick =>
      return @loadComments() if @wasSeen()
      @_loadCommentIfInsideWindow = _.throttle(
        =>
          if @wasSeen()
            @loadComments()
            window.removeEventListener 'scroll', @_loadCommentIfInsideWindow
        500
      )
      window.addEventListener 'scroll', @_loadCommentIfInsideWindow
  detached: ->
    window.removeEventListener 'scroll', @_loadCommentIfInsideWindow
</script>
