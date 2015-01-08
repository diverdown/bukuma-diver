module.exports = class Favoritable
  preprocess: -> JSON.parse(JSON.stringify(this))

  onFavorite: ->

  onUnfavorite: ->
