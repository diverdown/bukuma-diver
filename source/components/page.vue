<style lang="scss">
.page {
  margin: 18px 0;
}
.comments {
  width: 100%;
  height: 10em;
  overflow-y: scroll;
  font-size: 10px;
  margin: 0.6em 0;
  box-shadow: -1px 1px 3px 1px #eee inset;
  .loading {
    padding: 2em;
    img { width: 6em; height: 6em; }
  }
  table {
    width: 100%;
    padding: 0.2em 0.5em;
  }
}
</style>

<template lang="jade">
.page
  .page-head
    h3.page-title
      a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)")
        img.favicon(v-attr="src: domain | favicon")
        | {{title | truncate 100}}
    a.bookmark-count(href="{{url | hatebuEntry}}" target="_blank") {{bookmark_count}}users
  .comments
    loading-circle(v-if="loading")
    table(v-if="!loading")
      tr(v-repeat="comments" v-component="comment")
  a.small(v-on="click: openModal(domain)" v-if="showPopularLink") このサイトの人気ページを見る
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
_ = require 'lodash'
module.exports =
  data: ->
    comments: []
    loading: true
  methods:
    openModal: (domain)->
      @$dispatch 'openModal', domain
    loadComments: ->
      BukumaDiver.comments(@url, (err, @comments)=> @loading = false)
    wasSeen: ->
      @unbindScroll() unless @$el
      {top, bottom} = @$el.getBoundingClientRect()
      0 < bottom and top < (window.innerHeight || document.documentElement.clientHeight)
    bindScroll: ->
      window.addEventListener 'scroll', @_loadCommentIfInsideWindow
    unbindScroll: ->
      window.removeEventListener 'scroll', @_loadCommentIfInsideWindow
  attached: ->
    # to wait rendering and get appropriate position
    @$root.constructor.nextTick =>
      return @loadComments() if @wasSeen()
      @_loadCommentIfInsideWindow = _.throttle(
        =>
          if @wasSeen()
            @loadComments()
            @unbindScroll()
        500
      )
      @bindScroll()
  detached: -> @unbindScroll()
</script>
