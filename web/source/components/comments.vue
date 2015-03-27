<template lang="jade">
.comment-box
  .pending.center(v-if="pending")
    | ブックマーク数が多いため読み込みを手動にしました。
    .center.margin-2unit-0unit
      a.button.button-light.padding-2unit-4unit(v-on="click: fetch") コメントを読み込む
    | コメントの読み込みには時間がかかることがあります。

  loading-circle(v-if="loading")

  ul.comments(v-if="loaded")
    li.comment(v-repeat="comments" v-component="comment" v-with="eid: eid")

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
    eid: ''
    comments: []
    state: LOADING
  computed:
    pending: -> @state == PENDING
    loading: -> @state == LOADING
    loaded: -> @state == LOADED
  methods:
    fetch: ->
      @state = LOADING
      BukumaDiver.comments(@url, (err, {@eid,@comments})=> @state = LOADED)
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
      return @fetch() if @wasSeen()
      @_loadCommentIfInsideWindow = _.throttle(
        =>
          if @wasSeen()
            @fetch()
            @unbindScroll()
        500
      )
      @bindScroll()
  detached: ->
    @unbindScroll()

</script>
