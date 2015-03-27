<template lang="jade">
.center-flexbox
  a(href="http://b.hatena.ne.jp/{{user}}" target="_blank")
    img.comment-user-icon(v-attr="src: userImageUrl" alt="{{user}}")
.comment-body
  .container
    a.comment-user.left(href="http://b.hatena.ne.jp/{{user}}" target="_blank") {{user}}
    a.comment-timestamp.right(href="http://b.hatena.ne.jp/entry/{{eid}}/comment/{{user}}" target="_blank") {{timestamp}}
  .comment-content {{comment}}
</template>

<script lang="coffee">
module.exports =
  computed:
    userImageUrl: ->
      "http://cdn1.www.st-hatena.com/users/#{@user.substr(0,2)}/#{@user}/profile_s.gif"
</script>
