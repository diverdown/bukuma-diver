<template lang="jade">
h2.hotentry-category(v-attr="id: name") {{name}}
ul
  li.margin-4unit(v-repeat="shownPages" v-component="page" v-with="withDomain: 1")
.center.padding-6unit-0unit
  a.button.button-default.padding-2unit-4unit(href="javascript:void(0)" v-if="hasMore" v-on="click: showMorePages") もっと見る...
  a.button.button-default.padding-2unit-4unit(href="{{hatebuLink}}" v-if="!hasMore" target="_blank" title="はてブで{{name}}") はてブでもっと見る
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

module.exports =
  components:
    page: require './_page.vue'
  data: ->
    color: ''
    hatebuLink: ''
    active: false
    hasMore: true
  computed:
    shownPages: ->
      if @hasMore
        @pages.slice(0, if @name == '総合' then 10 else 5)
      else
        @pages
  methods:
    updateActiveState: ({headerHeight})->
      @active = false
      {top, bottom} = @$el.getBoundingClientRect()
      if top <= headerHeight and headerHeight < bottom
        history.pushState(null, null, "##{@name}")
        @active = true

    showMorePages: -> @hasMore = false
  created: ->
    @color = CATEGORY_COLORS[@name]
    @hatebuLink =
      if @name == '総合'
        "http://b.hatena.ne.jp/hotentry?of=30"
      else
        "http://b.hatena.ne.jp/entrylist/#{@id}?sort=hot"

    @$on 'openSite', @showMorePages
</script>
