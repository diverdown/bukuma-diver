<template lang="jade">
.social-buttons(v-on="blur: delayedHide" v-if="show" v-transition="expand" tabindex="-1")
  a(v-attr="href: hatebuUrl" target="_blank")
    i.icon-hatebu
  a(v-attr="href: twitterUrl" target="_blank")
    i.fa.fa-twitter
  a(v-attr="href: facebookUrl" target="_blank")
    i.fa.fa-facebook
  a(v-attr="href: googleUrl" target="_blank")
    i.fa.fa-google-plus
</template>

<script lang="coffee">
u = encodeURIComponent
module.exports =
  data: ->
    show: false
  computed:
    url: -> window.location.href
    hatebuUrl: ->
      "http://b.hatena.ne.jp/add?mode=confirm&url=#{u @url}&title=#{u @title}"
    twitterUrl: ->
      text = "#{@title} #{@url}"
      "https://twitter.com/intent/tweet?text=#{u text}"
    facebookUrl: ->
      "http://www.facebook.com/share.php?u=#{u @url}"
    googleUrl: ->
      "https://plus.google.com/share?url=#{u @url}&title=#{u @title}"
  methods:
    toggle: -> @show = !@show
    delayedHide: ->
      # to trigger buttons' click event
      setTimeout((=> @show = false), 10)
  attached: ->
    @$el.addEventListener('transitionend', =>
      if @show
        @$el.querySelector('.social-buttons').focus()
    )
</script>
