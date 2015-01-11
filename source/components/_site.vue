<style lang="scss">
</style>

<template lang="jade">
div(v-on="click: $dispatch('searchBySite', site), mouseenter: isFavoritable = true, mouseleave: isFavoritable = false")
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
