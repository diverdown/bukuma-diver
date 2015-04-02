<template lang="jade">
header.main-header(v-class="fixed: fixedHeader")
  .center-flexbox.main-title-box
    h1.main-title.center-flexbox
      img.favicon(v-attr="src: site.domain | favicon")
      span {{site.name}}
    i.fa.fa-heart.large.margin-0unit-1unit.clickable(v-on="click: toggleFavorite" v-class="favorited: site.favorited")

    .bookmark-count
      .number {{totalBookmarkCount}}
      | users

  nav
    ul.header-states
      li.header-state(v-class="active: params.sort == 'count'")
        a.padding-2unit(v-on="click: update({sort: 'count'})") 人気順
      li.header-state(v-class="active: params.sort == 'recent'")
        a.padding-2unit(v-on="click: update({sort: 'recent'})") 新着順
      li.header-state(v-class="active: params.sort == 'eid'")
        a.padding-2unit(v-on="click: update({sort: 'eid'})") すべて
loading-circle(v-if="loading")
ul.padding-6unit(v-if="!loading")
  li.margin-4unit(v-repeat="pages" v-component="page")
</template>

<script lang="coffee">
BukumaDiver = require '../bukuma_diver'
Site = require '../site'
module.exports =
  data: ->
    globalUpdate: true
    params: {sort: 'count'}
    site: {favorited: false}
    totalBookmarkCount: 0
    pages: []
    loading: true
    fixedHeader: true
  methods:
    update: (params)->
      if @globalUpdate
        @$transit(@site.toPath(params))
      else
        @search(params)
    search: (params = {})->
      @loading = true
      @params[k] = v for k,v of params
      @site = Site.find(@params)
      BukumaDiver.searchByDomain @params, (err, {name, @totalBookmarkCount, @pages})=>
        @loading = false
        @site.name = name
        @$pushMainContent() if @fixedHeader
    toggleFavorite: -> @site.toggleFavorite()
</script>
