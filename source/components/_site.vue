<style lang="scss">
.site {
  display: block;
}
</style>

<template lang="jade">
a.site(v-on="click: $transit(site.toPath()), mouseenter: isFavoritable = true, mouseleave: isFavoritable = false")
  img(v-attr="src: site.domain | favicon")
  | {{site.name}}
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
