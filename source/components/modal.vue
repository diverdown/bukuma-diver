<style lang="scss">
#overlay {
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, .5);
  z-index: 1000;
  position: fixed;
  top: 0;
  left: 0;
  overflow-y: auto;
}

.wrapper {
  width: 720px;
  min-height: 300px;
  background-color: white;
  margin: 28px auto;
  padding: 32px 24px;
}
</style>

<template lang="jade">
#overlay(v-on="click: closeModal, scroll: propagateScroll")
  .wrapper(v-on="click: doNothing")
    div(v-component="domain" v-with="params: modalParams" wait-for="updated")

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
