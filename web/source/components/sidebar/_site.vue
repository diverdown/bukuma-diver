<template lang="jade">
a.site.center-flexbox(v-on="click: $transit(site.toPath({sort: 'recent'})), mouseenter: isFavoritable = true, mouseleave: isFavoritable = false")
  img.favicon(v-attr="src: site.domain | favicon")
  .site-title(title="{{site.name}}") {{site.name}}
  i.fa.fa-heart.right(v-if="isFavoritable" v-on="click: toggleFavorite" v-class="favorited:  site.favorited")

</template>

<script lang="coffee">
module.exports =
  data: ->
    isFavoritable: false
  methods:
    toggleFavorite: (event)->
      event.stopPropagation()
      @site.toggleFavorite()
    favoritable: (@isFavoritable)->
</script>
