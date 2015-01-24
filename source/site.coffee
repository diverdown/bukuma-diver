request = require 'superagent'
Favoritable = require './favoritable'
_ = require 'lodash'
PathTemplate = require './path_template'
module.exports = class Site extends Favoritable
  @pathTemplate: '/domains/:domain/'

  _collection = []

  constructor: ({@name, @domain, @count})->
    super
    @name ||= @domain
    @count ||= 1
    _collection.push(this)

  @find: ({domain})=>
    _.find(_collection, {domain: domain}) || new @(arguments[0])

  preprocess: -> {@name, @domain}

  toPath: (params)->
    params = _.merge(domain: @domain, params)
    PathTemplate.stringify(@constructor.pathTemplate, params)
