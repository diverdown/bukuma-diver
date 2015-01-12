Favoritable = require './favoritable'
_ = require 'lodash'
PathTemplate = require './path_template'
module.exports = class Query extends Favoritable
  @pathTemplate: '/pages/'

  _collection = []
  constructor: ({q})->
    super
    @query = q
    @name = "「#{@query}」"
    _collection.push(this)

  @find: ({q})=>
    _.find(_collection, {query: q}) || new @(arguments[0])

  preprocess: ->
    {
      type: @constructor.name
      q: @query
    }

  toPath: (params = {})->
    params = _.merge(q: @query, params)
    PathTemplate.stringify(@constructor.pathTemplate, params)
