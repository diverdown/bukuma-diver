<template lang="jade">
#overlay(v-on="click: closeModal, scroll: propagateScroll")
  #modal-panel(v-on="click: doNothing")
    div(v-component="domain" v-with="params: modalParams, fixedHeader: false" wait-for="updated")
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
      @modalParams = {domain: domain, name: '', sort: 'count'}
      @$emit 'updated'
</script>
