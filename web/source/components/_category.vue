<template lang="jade">
h2.hotentry-category(v-attr="id: name") {{name}}
ul
  li.margin-4unit(v-repeat="pages" v-component="page" v-with="withDomain: 1" v-on="openSite: showMorePages")
.center.padding-6unit-0unit
  a.button.button-default.padding-2unit-4unit(v-if="hasMore" v-on="click: showMorePages") もっと見る...
</template>

<script lang="coffee">
module.exports =
  components:
    page: require './_page.vue'
  methods:
    showMorePages: (index)->
      @pages.concat(@_hiddenPages)
      @hasMore = false
</script>
