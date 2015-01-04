_ = require 'lodash'
module.exports = class Site
  @_collection = []
  constructor: ({@name, @domain, @count})->
    @name ||= @domain
    Site._collection.push(this)

  @find: ({domain})->
    _.find(@_collection, {domain: domain}) || new Site(arguments[0])
