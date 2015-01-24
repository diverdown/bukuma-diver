<style lang="scss">
.site {
  display: block;
}
</style>

<template lang="jade">
a.site(v-on="click: $transit(site.toPath()), mouseenter: isFavoritable = true, mouseleave: isFavoritable = false")
  img.favicon(v-attr="src: site.domain | favicon")
  | {{site.name | truncate 15}}
  i.fa.fa-heart.right(v-if="isFavoritable" v-on="click: toggleFavorite" v-class="favorited: site.favorited")
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
