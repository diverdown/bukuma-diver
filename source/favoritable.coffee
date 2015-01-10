module.exports = class Favoritable
  @on: (event, callback, context = window)->
    @_callbacks ||= []
    @_callbacks[event] ||= []
    @_callbacks[event].push(callback.bind(context))

  @emit: (event, args...)->
    (@_callbacks[event] || []).forEach (callback)->
      callback.apply(window, args)

  constructor: -> @favorited = false

  preprocess: -> JSON.parse(JSON.stringify(this))

  toggleFavorite: ->
    this[if @favorited then 'unfavorite' else 'favorite']()

  favorite: ->
    @favorited = true
    @constructor.emit('favorite', this)

  unfavorite: ->
    @favorited = false
    @constructor.emit('unfavorite', this)
