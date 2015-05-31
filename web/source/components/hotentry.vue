<template lang="jade">
header.main-header.fixed.hotentry-header
  .center-flexbox.main-title-box
    h1.main-title ホットエントリー
  ul.header-states
    li.header-state(v-repeat="categories" v-class="active: active")
      a.header-category(href="#{{name}}" v-style="border-bottom-color: active ? color : 'white'" v-on="click: moveToCategory") {{name}}

.main-body
  loading-circle(v-if="loading")
  ul.hotentries(v-if="!loading")
    li.hotentry(v-repeat="categories" v-component="category" v-ref="categories")
</template>

<script lang="coffee">
_ = require 'lodash'
BukumaDiver = require '../bukuma_diver'
module.exports =
  components:
    category: require './_category.vue'
  data: ->
    { categories: [], loading: true, _headerHeight: null }
  methods:
    moveToCategory: (hashOrEvent)->
      hash =
        if hashOrEvent instanceof MouseEvent
          hashOrEvent.preventDefault()
          decodeURIComponent(hashOrEvent.target.hash)
        else
          hashOrEvent
      category = document.querySelector(hash)
      # +1 for safety margin to determine current category
      window.scrollTo(0, category.offsetTop - @_headerHeight + 1)

  created: ->
    BukumaDiver.hotEntries (err, categories)=>
      return unless @$el
      @categories = categories
      @loading = false
      @$pushMainContent =>
        @_headerHeight = document.querySelector('.hotentry-header').clientHeight
        if hash = decodeURIComponent(document.location.hash)
          @moveToCategory(hash)
        else
          @_activateCurrentCategory()

  attached: ->
    @_activateCurrentCategory = _.throttle(
      =>
        return unless @_headerHeight
        @$.categories.forEach (c)=>
          c.updateActiveState(headerHeight: @_headerHeight)
      200
    )
    window.addEventListener 'scroll', @_activateCurrentCategory
  detached: ->
    window.removeEventListener 'scroll', @_activateCurrentCategory

</script>
