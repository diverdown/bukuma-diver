<style lang="scss">
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
