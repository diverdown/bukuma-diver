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
  .pending {
    text-align: center;
    font-size: 1.2em;
    a {
      display: block;
      text-decoration: underline;
      font-size: 1.4em;
    }
  }
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
    .pending(v-if="pending")
      | ブックマーク数が多いため読み込みを手動にしました。
      a(v-on="click: loadComments") コメントを読み込む
      | コメントの読み込みには時間がかかることがあります。

    loading-circle(v-if="loading")
    table(v-if="loaded")
      tr(v-repeat="comments" v-component="comment")
  a.small(v-on="click: openModal(domain)" v-if="showPopularLink") このサイトの人気ページを見る
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
_ = require 'lodash'
PENDING_THRESHOULD = 2000
PENDING = 0
LOADING = 1
LOADED = 2
module.exports =
  data: ->
    comments: []
    state: LOADING
  computed:
    pending: -> @state == PENDING
    loading: -> @state == LOADING
    loaded: -> @state == LOADED
  methods:
    openModal: (domain)->
      @$dispatch 'openModal', domain
    loadComments: ->
      @state = LOADING
      BukumaDiver.comments(@url, (err, @comments)=> @state = LOADED)
    wasSeen: ->
      @unbindScroll() unless @$el
      {top, bottom} = @$el.getBoundingClientRect()
      0 < bottom and top < (window.innerHeight || document.documentElement.clientHeight)
    bindScroll: ->
      window.addEventListener 'scroll', @_loadCommentIfInsideWindow
    unbindScroll: ->
      window.removeEventListener 'scroll', @_loadCommentIfInsideWindow
  attached: ->
    return @state = PENDING if @bookmark_count > PENDING_THRESHOULD
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
