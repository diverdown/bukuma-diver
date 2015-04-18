<template lang="jade">
header.main-header.fixed.hotentry-header
  .center-flexbox.main-title-box
    h1.main-title ホットエントリー
  ul.header-states
    li.header-state(v-repeat="categories" v-class="active: active")
      a.header-category(href="#{{name}}" v-style="border-bottom-color: active ? color : 'white'" v-on="click: moveToCategory"){{name}}

.main-body
  loading-circle(v-if="loading")
  ul.hotentries(v-if="!loading")
    li.hotentry.margin-5unit(v-repeat="categories" v-attr="id: name")
      h2.hotentry-category(v-style="border-bottom-color: color") {{name}}
      ul
        li.margin-4unit(v-repeat="pages" v-component="page" v-with="withDomain: 1")
      .center.padding-6unit-0unit
        a.button.button-default.padding-2unit-4unit(v-on="click: showMorePages($event, $index)") もっと見る...
</template>

<script lang="coffee">
CATEGORY_COLORS =
  '総合': '#008FDE'
  '世の中': '#A88357'
  '政治と経済': '#A88357'
  '暮らし': '#228C7D'
  '学び': '#228C7D'
  'テクノロジー': '#00A5DE'
  'おもしろ': '#F5AC0F'
  'エンタメ': '#F5AC0F'
  'アニメとゲーム': '#F5AC0F'

_ = require 'lodash'
BukumaDiver = require '../bukuma_diver'
module.exports =
  data: ->
    { categories: [], loading: true, _headerHeight: null }
  methods:
    showMorePages: (e, index)->
      category = @categories[index]
      category.pages = category.pages.concat(@_hiddenPages[index])
      e.target.parentNode.removeChild(e.target)
    moveToCategory: (hashOrEvent)->
      hash =
        if hashOrEvent instanceof MouseEvent
          hashOrEvent.preventDefault()
          hashOrEvent.target.hash
        else
          hashOrEvent
      category = document.querySelector(hash)
      # +1 for safety margin to determine current category
      window.scrollTo(0, category.offsetTop - @_headerHeight + 1)

  created: ->
    BukumaDiver.hotEntries (err, categories)=>
      @_hiddenPages = []
      for c, i in categories
        c.color = CATEGORY_COLORS[c.name]
        c.active = false
        @_hiddenPages[i] = c.pages.splice(if c.name == '総合' then 10 else 5)
      @categories = categories
      @loading = false
      @$pushMainContent =>
        @_headerHeight = document.querySelector('.hotentry-header').clientHeight
        if hash = document.location.hash
          @moveToCategory(hash)
        else
          @_activateCurrentCategory()

  attached: ->
    @_activateCurrentCategory = _.throttle(
      =>
        return unless @_headerHeight
        c.active = false for c in @categories
        for i in [(@categories.length-1)..0] by -1
          c = @categories[i]
          {top, bottom} = document.querySelector("##{c.name}").getBoundingClientRect()
          if top <= @_headerHeight
            history.pushState(null, null, "##{c.name}")
            c.active = true
            break
      200
    )
    window.addEventListener 'scroll', @_activateCurrentCategory
  detached: ->
    window.removeEventListener 'scroll', @_activateCurrentCategory

</script>
