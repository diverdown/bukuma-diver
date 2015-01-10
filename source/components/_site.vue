<style lang="scss">
</style>

<template lang="jade">
img(v-attr="src: site.domain | favicon")
a(v-on="click: $dispatch('searchBySite', site)")
  | {{site.name}}
i.fa.fa-heart(v-on="click: toggleFavorite(site)" v-class="favorited: site.favorited")
</template>

<script lang="coffee">
module.exports =
  methods:
    toggleFavorite: (site)-> site.toggleFavorite()
</script>
