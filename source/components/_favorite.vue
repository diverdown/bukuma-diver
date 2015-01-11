<style lang="scss">
.fa-close { cursor: pointer; }
</style>

<template lang="jade">
div(v-on="click: searchByFavorite(favorite), mouseenter: isRemovable = true, mouseleave: isRemovable = false")
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
    searchByFavorite: (favorite)->
      switch favorite.constructor.name
        when 'Site' then @$dispatch('searchBySite', favorite)
        when 'Query' then @$dispatch('search', favorite.query)
    unfavorite: (event)->
      event.stopPropagation()
      @favorite.unfavorite()
</script>
