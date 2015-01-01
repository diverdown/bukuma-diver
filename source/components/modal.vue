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
  width: 600px;
  min-height: 300px;
  background-color: white;
  margin: 30px auto;
}
</style>

<template lang="jade">
#overlay(v-on="click: closeModal")
  .wrapper(v-on="click: doNothing")
    div(v-component="domain" v-with="params: modalParams" wait-for="updated")

</template>

<script lang="coffee">
module.exports =
  data: ->
    modalParams: {}
  methods:
    doNothing: (event)->
      event.stopPropagation()
    closeModal: ->
      @$emit('closeModal')
  created: ->
    @$on 'updateModal', (domain)->
      @modalParams = {domain: domain, name: '', sort: 'count'}
      @$emit 'updated'
</script>
