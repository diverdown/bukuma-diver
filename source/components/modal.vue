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
  height: 900px;
  background-color: white;
  margin: 30px auto;
}
</style>

<template lang="jade">
#overlay(v-on="click: closeModal")
  .wrapper(v-on="click: doNothing")

</template>

<script lang="coffee">
module.exports =
  methods:
    doNothing: (event)->
      event.stopPropagation()
    closeModal: ->
      @$emit('closeModal')
</script>
