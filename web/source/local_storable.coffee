localforage = require 'localforage'
module.exports = class LocalStorable
  @all: ->
    @_collection

  @restore: (callback)->
    localforage.getItem(@klass, callback)

  @save: (collection)->
    localforage.setItem(@klass, collection or @_collection)
