<template lang="jade">
header.main-header.fixed
  h1.main-title.padding-1unit-2unit ホットエントリー
  ul.header-states
    li.header-state(v-repeat="categories" v-class="active: active")
      a.header-category.padding-1unit(href="#{{name}}" v-style="border-bottom-color: active ? color : 'white'"){{name}}

loading-circle(v-if="loading")
ul.hotentries(v-if="!loading")
  li.margin-6unit.hotentry(v-repeat="categories" v-attr="id: name")
    h2.padding-0unit-2unit.hotentry-category(v-style="border-bottom-color: color") {{name}}
    ul.padding-2unit
      li.margin-2unit(v-repeat="pages" v-component="page" v-with="withDomain: 1")
    .center
      a.button.button-default.padding-1unit-2unit(v-on="click: showMorePages") もっと見る...
</template>

<script lang="coffee">
CATEGORY_COLORS =
  '一般': '#008FDE'
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
    { categories: [], loading: true }
  methods:
    showMorePages: (e)->
      for pages, i in @_hiddenPages
        @categories[i].pages = @categories[i].pages.concat(pages)
      e.target.parentNode.removeChild(e.target)
  created: ->
    BukumaDiver.hotEntries (err, categories)=>
      @_hiddenPages = []
      for c, i in categories
        c.color = CATEGORY_COLORS[c.name]
        c.active = false
        @_hiddenPages[i] = c.pages.splice(5)
      @categories = categories
      @loading = false
  attached: ->
    @_activateCurrentCategory = do =>
      headerHeight = null
      _.throttle(
        =>
          headerHeight ||= document.querySelector('.main-header').clientHeight
          c.active = false for c in @categories
          for i in [(@categories.length-1)..0] by -1
            c = @categories[i]
            {top, bottom} = document.querySelector("##{c.name}").getBoundingClientRect()
            if top <= headerHeight
              history.pushState(null, null, "##{c.name}")
              c.active = true
              break
        200
      )

    window.addEventListener 'scroll', @_activateCurrentCategory
  detached: ->
    window.removeEventListener 'scroll', @_activateCurrentCategory

</script>
