<template lang="jade">
.comment-box
  .pending.center-flexbox(v-if="pending")
    .pending-inner.center
      | ブックマーク数が多いため読み込みを手動にしました。
      .center.margin-2unit-0unit
        a.button.button-light.padding-2unit-4unit(v-on="click: fetch") コメントを読み込む
      | コメントの読み込みには時間がかかることがあります。

  loading-circle(v-if="loading")

  ul.comments(v-if="!noComment")
    li.comment(v-repeat="comments" v-component="comment" v-with="eid: eid")
  .comment-state.center-flexbox(v-if="noComment")
    .message まだブックマークコメントがありません
  .comment-state.center-flexbox(v-if="error")
    .message.error
      | コメントの読み込みに失敗しました
      .center.margin-2unit-0unit
        a.button.button-light.padding-2unit-4unit(v-on="click: fetch") リトライ
</template>

<script lang="coffee">
BukumaDiver = require '../../bukuma_diver'
_ = require 'lodash'

PENDING_THRESHOULD = 2000
ERROR = -1
PENDING = 0
LOADING = 1
LOADED = 2

module.exports =
  components:
    comment: require './_comments/_comment.vue'
  data: ->
    eid: ''
    comments: []
    state: LOADING
  computed:
    pending: -> @state == PENDING
    loading: -> @state == LOADING
    loaded: -> @state == LOADED
    error: -> @state == ERROR
    isEmpty: -> @comments.length == 0
    noComment: -> @loaded and @isEmpty
  methods:
    fetch: ->
      @state = LOADING
      BukumaDiver.comments @url, (err, res)=>
        return unless @$el
        return @state = ERROR if err
        {@eid, @comments} = res
        @state = LOADED
    wasSeen: ->
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
      @_loadCommentIfInsideWindow = _.debounce(
        =>
          if @wasSeen()
            @fetch()
            @unbindScroll()
        100
      )
      @bindScroll()
  beforeDestroy: ->
    @unbindScroll()
</script>
