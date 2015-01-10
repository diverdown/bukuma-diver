request = require 'superagent'
Favoritable = require './favoritable'
_ = require 'lodash'
module.exports = class Site extends Favoritable
  _collection = []

  constructor: ({@name, @domain, @count})->
    super
    @name ||= @domain
    @count ||= 1
    _collection.push(this)

  @find: ({domain})=>
    _.find(_collection, {domain: domain}) || new @(arguments[0])

  preprocess: -> {@name, @domain}
