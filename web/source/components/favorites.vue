<template lang="jade">
h2
  i.fa.fa-heart
  = ' ウォッチリスト'
ul
  li.side-bar-list.draggable(v-repeat="favorite: favorites" v-component="_favorite" draggable="true"
    v-on="dragstart: onDragStart, dragenter: onDragEnter, dragover: onDragOver, drop: onDrop, dragend: onDragEnd")
</template>

<script lang="coffee">
FavoriteCollection = require '../favorite_collection'
module.exports =
  components:
    _favorite: require './_favorite.vue'
  data: ->
    favorites: []
  methods:
    onDragStart: (e)->
      @dragged = e.currentTarget
      e.dataTransfer.effectAllowed = 'move'
      e.dataTransfer.setData('text/html', e.currentTarget)
    onDragEnter: (e)->
      @dragged.style.display = 'none'
    onDragOver: (e)->
      e.preventDefault()
      y = e.clientY + window.pageYOffset
      threshold = e.target.offsetTop + e.target.offsetHeight / 2
      li = e.target.parentNode
      [].forEach.call(li.parentNode.children, (e)->
        e.classList.remove('before')
        e.classList.remove('after')
      )
      if y > threshold
        li.classList.add('after')
      else
        li.classList.add('before')
      false
    onDrop: (e)->
      e.stopPropagation()
      false
    onDragEnd: (e)->
      @dragged.style.display = 'list-item'

      iBefore = [].indexOf.call(@dragged.parentNode.children, @dragged)
      over = document.querySelector('li.before,li.after')
      iOver = [].indexOf.call(@dragged.parentNode.children, over)
      return if iOver == -1
      iAfter =
        if over.classList.contains('before')
          iOver - 1
        else
          iOver
      iAfter++ if iBefore > iOver

      [].forEach.call(e.target.parentNode.children, (e)->
        e.classList.remove('before')
        e.classList.remove('after')
      )

      @favorites.splice(iAfter, 0, @favorites.splice(iBefore, 1)[0])
      FavoriteCollection.save()
  created: ->
    FavoriteCollection.restore (err, @favorites)=>
</script>
