<style lang="scss">
.fa-close { cursor: pointer; }
</style>

<template lang="jade">
a(v-on="click: $transit(favorite.toPath()), mouseenter: isRemovable = true, mouseleave: isRemovable = false")
  img(v-attr="src: favorite.domain | favicon" v-if="favorite.domain")
  i.fa.fa-search(v-if="!favorite.domain")
  | {{favorite.name}}
  i.fa.fa-close.right(v-if="isRemovable" v-on="click: unfavorite")
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
