<template lang="jade">
.card
  .card-head(v-if="withDomain")
    a(href="http://{{domain}}")
      img.favicon(v-attr="src: domain | favicon")
      | {{domain}}
    button.right.small(v-on="click: openModal(domain)") 人気ページを見る
  .card-body
    .center-flexbox.padding-1unt-0unit
      a.bookmark-count(href="{{url | hatebuEntry}}" target="_blank")
        .number {{bookmark_count}}
        | users
      h3.page-title
        a(href="{{url}}" target="_blank" v-on="click: $dispatch('openSite', this)")
          | {{title | truncate 100}}
    div(v-component="comments" v-with="url: url")
</template>

<script lang="coffee">
module.exports =
  methods:
    openModal: (domain)->
      @$dispatch 'openModal', domain
</script>
