<template lang="jade">
a.site.draggable.center-flexbox(v-on="click: $transit(favorite.toPath()), mouseenter: isRemovable = true, mouseleave: isRemovable = false")
  img.favicon(v-attr="src: favorite.domain | favicon" v-if="favorite.domain")
  i.fa.fa-search(v-if="!favorite.domain")
  .site-title {{favorite.name | truncate 15}}
  i.fa.fa-close.right.clickable(v-if="isRemovable" v-on="click: unfavorite")
</template>

<script lang="coffee">
module.exports =
  data: ->
    isRemovable: false
  methods:
    unfavorite: (event)->
      event.stopPropagation()
      @favorite.unfavorite()
</script>
