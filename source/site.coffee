Favoritable = require './favoritable'
_ = require 'lodash'
module.exports = class Site extends Favoritable
  @_collection = []
  constructor: ({@name, @domain, @count})->
    @name ||= @domain
    @constructor._collection.push(this)

  @find: ({domain})=>
    _.find(@_collection, {domain: domain}) || new @(arguments[0])

  toParams: ->
    super @domain
