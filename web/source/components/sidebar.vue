<template lang="jade">
header#sidebar-top.center-flexbox
  h1#title.center-flexbox
    i#logo.icon-bukuma-diver
    a(v-on="click: $transit('/')") ブクマダイバー

#sidebar-middle.padding-4unit-2unit
  a#hotentry.center-flexbox(v-on="click: $transit('/')")
    img.favicon(src="/image/hatenabookmark-logo.png" alt="はてなブックマーク")
    | ホットエントリー
  #search-box
    input(v-model="query" type="text" placeholder="キーワードではてブ検索" v-on="keyup: search | key enter")
    i.fa.fa-search(v-on="click: search")

#sidebar-bottom
  #favorites.margin-6unit-0unit(v-component="favorites" v-with="favorites: favorites")

  #recommends.margin-6unit-0unit(v-component="recommends" v-with="favorites: favorites")

  #popular-sites.margin-6unit-0unit(v-component="popular-sites")

  .extensions
    h2 拡張機能
    ul
      li.sidebar-list(v-if="chrome")
        a(href="https://chrome.google.com/webstore/detail/%E3%83%96%E3%82%AF%E3%83%9E%E3%83%80%E3%82%A4%E3%83%90%E3%83%BC-google-chrome-%E6%8B%A1%E5%BC%B5/akkdidfaignjdpencliimleoglchphld?hl=ja" target="_blank")
          img(src="/image/chrome_webstore.png" alt="Chrome拡張機能")
      li.sidebar-list
        a(href="javascript:%28function%28%29%7Bvar%20o%2Ct%3Bo%3Dlocation.href.split%28%22%2F%22%29%5B2%5D%2Ct%3D%22http%3A%2F%2Fbukuma-diver.com%2Fdomains%2F%22%2Bo%2B%22%3Fsort%3Dcount%22%2Copen%28t%29%7D%29.call%28this%29%3B" v-on="click: explainBookmarklet")
          i.fa.fa-bookmark
          | ブックマークレット
</template>

<script lang="coffee">
module.exports =
  components:
    favorites: require './sidebar/_favorites.vue'
    'popular-sites': require './sidebar/_popular-sites.vue'
    recommends: require './sidebar/_recommends.vue'
  data: ->
    chrome: navigator.userAgent.toLowerCase().indexOf('chrome') != -1
  methods:
    search: -> @$transit("/pages/?q=#{@query}") if @query
    explainBookmarklet: (e)->
      e.preventDefault()
      alert('このリンクをブックマークに追加すると、ブックマークから起動して現在見ているサイトの人気ページを見ることができます。')
      false
</script>
