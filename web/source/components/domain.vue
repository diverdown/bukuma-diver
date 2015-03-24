<template lang="jade">
header.main-header(v-class="fixed: fixedHeader")
  .bottom-align-flexbox.padding-1unit-2unit
    h1.main-title
      img.favicon(v-attr="src: site.domain | favicon")
      | {{site.name}}
    i.fa.fa-heart.large.margin-0unit-1unit.clickable(v-on="click: toggleFavorite" v-class="favorited: site.favorited")

    .bookmark-count {{totalBookmarkCount}}users

  nav
    ul.header-states
      li.header-state(v-class="active: params.sort == 'count'")
        a.padding-1unit(v-on="click: $transit(site.toPath({sort: 'count'}))") 人気順
      li.header-state(v-class="active: params.sort == 'recent'")
        a.padding-1unit(v-on="click: $transit(site.toPath({sort: 'recent'}))") 新着順
      li.header-state(v-class="active: params.sort == 'eid'")
        a.padding-1unit(v-on="click: $transit(site.toPath({sort: 'eid'}))") すべて
loading-circle(v-if="loading")
ul.padding-2unit(v-if="!loading")
  li.margin-2unit(v-repeat="pages" v-component="page")
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
Site = require '../site'
module.exports =
  data: ->
    params: {sort: 'count'}
    site: {favorited: false}
    totalBookmarkCount: 0
    pages: []
    loading: true
    fixedHeader: true
  methods:
    search: (params = {})->
      @loading = true
      @params[k] = v for k,v of params
      @site = Site.find(@params)
      BukumaDiver.searchByDomain @params, (err, {name, @totalBookmarkCount, @pages})=>
        @loading = false
        @site.name = name
        @$pushMainContent() if @fixedHeader
    onDomainChange: ->
      @search(@params)
    toggleFavorite: -> @site.toggleFavorite()
  created: ->
    @$watch 'params.domain', @onDomainChange, true
</script>
