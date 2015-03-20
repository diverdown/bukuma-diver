localforage = require 'localforage'
module.exports = class LocalStorable
  @all: ->
    @_collection

  @restore: (callback)->
    localforage.getItem(@name, callback)

  @save: (collection)->
    localforage.setItem(@name, collection or @_collection)
