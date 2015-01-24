<style lang="scss">
td {
  &:nth-child(1) {
    width: 2em;
    img {
      height: 2em;
      width: 2em;
    }
  }
  &:nth-child(2) {
    width: 5em;
  }
  &:last-child {
    text-alight: right;
    width: 5em;
  }
}
</style>

<template lang="jade">
td
 img(v-attr="src: userImageUrl" alt="{{user}}")
td {{user}}
td {{comment}}
td {{timestamp}}
</template>

<script lang="coffee">
module.exports =
  computed:
    userImageUrl: ->
      "http://cdn1.www.st-hatena.com/users/#{@user.substr(0,2)}/#{@user}/profile_s.gif"
</script>
