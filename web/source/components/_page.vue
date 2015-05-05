<template lang="jade">
.card
  .card-head.center-flexbox(v-if="withDomain")
    a(v-on="click: openModal(domain)")
      img.favicon(v-attr="src: domain | favicon")
      | {{domain}}
    button.small.pc-only(v-on="click: openModal(domain)") 人気ページを見る
  .card-body
    .center-flexbox.padding-1unt-0unit
      a.bookmark-count(href="{{url | hatebuEntry}}" target="_blank")
        .number {{bookmark_count}}
        | users
      h3.page-title
        a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)") {{title}}
    div(v-component="comments" v-with="url: url, bookmark_count: bookmark_count")
</template>

<script lang="coffee">
module.exports =
  components:
    comments: require './_page/_comments.vue'
  methods:
    openModal: (domain)->
      @$dispatch 'openModal', domain
</script>
