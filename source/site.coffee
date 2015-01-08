request = require 'superagent'
Favoritable = require './favoritable'
_ = require 'lodash'
module.exports = class Site extends Favoritable
  _collection = []

  constructor: ({@name, @domain, @count})->
    @name ||= @domain
    @count ||= 1
    _collection.push(this)

  @find: ({domain})=>
    _.find(_collection, {domain: domain}) || new @(arguments[0])

  preprocess: -> {@name, @domain}

  onFavorite: ->
    super
    request
      .post("/api/favorites/#{@domain}")
      .end()

  onUnfavorite: ->
    super
    request
      .del("/api/favorites/#{@domain}")
      .end()
