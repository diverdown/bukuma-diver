<template lang="jade">
#overlay(v-on="click: closeModal, scroll: propagateScroll")
  #modal-panel(v-on="click: doNothing")
    div(v-component="domain" v-with="globalUpdate: false, fixedHeader: false" v-ref="domain" wait-for="updated")
</template>

<script lang="coffee">
module.exports =
  data: ->
    e = document.createEvent('MouseEvents')
    e.initEvent('scroll', false, true)
    modalParams: {}
    scrollEvent: e
  methods:
    doNothing: (event)->
      event.stopPropagation()
    closeModal: ->
      @$emit('closeModal')
    propagateScroll: ->
      window.dispatchEvent(@scrollEvent)
  created: ->
    @$on 'updateModal', (domain)->
      @$.domain.search(domain: domain, name: '', sort: 'count')
      @$emit 'updated'
</script>
