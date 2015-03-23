<template lang="jade">
.card
  .card-head(v-if="withDomain")
    a(href="http://{{domain}}")
      img.favicon(v-attr="src: domain | favicon")
      | {{domain}}
    button.right.small(v-on="click: openModal(domain)") {{domain}}の人気ページ
  .page.padding-1unit
    .top-align-flexbox
      h3.page-title
        a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)")
          | {{title | truncate 100}}
      a.bookmark-count(href="{{url | hatebuEntry}}" target="_blank") {{bookmark_count}}users
    .comments.margin-1unit-0unit
      .pending.center.padding-1unit-0unit(v-if="pending")
        | ブックマーク数が多いため読み込みを手動にしました。
        .center.margin-1unit-0unit
          a.button.button-light.padding-1unit-2unit(v-on="click: loadComments") コメントを読み込む
        | コメントの読み込みには時間がかかることがあります。

      loading-circle(v-if="loading")
      table(v-if="loaded")
        tr(v-repeat="comments" v-component="comment")

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
  detached: ->
    @unbindScroll()
</script>
