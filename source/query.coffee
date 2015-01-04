Favoritable = require './favoritable'
_ = require 'lodash'
module.exports = class Query extends Favoritable
  @_collection: []
  constructor: ({q})->
    @query = q
    @name = "「#{@query}」"
    @constructor._collection.push(this)

  @find: ({q})=>
    _.find(@_collection, {query: q}) || new @(arguments[0])

  toParams: ->
    super @query
