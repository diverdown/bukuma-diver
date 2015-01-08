Site = require './site'
Query = require './query'
LocalStorable = require './local_storable'
_ = require 'lodash'
module.exports = class FavoriteCollection extends LocalStorable
  TYPES = [Site, Query]

  @_collection: (@restore() || []).map (obj)-> TYPES[obj.type].find(obj)

  @save: ->
    collection = @_collection.map (favoritable)->
      obj = favoritable.preprocess()
      obj.type = _.indexOf(TYPES, favoritable.constructor)
      obj
    localStorage.setItem(@name, JSON.stringify(collection))

  @add: (favoritable)->
    @_collection.unshift(favoritable) unless @doesInclude(favoritable)
    favoritable.onFavorite()
    @save()

  @remove: (favoritable)->
    # need to use splice for Vue
    for e,i in @_collection
      if e == favoritable
        @_collection.splice(i, 1)
        break
    favoritable.onUnfavorite()
    @save()

  @doesInclude: (favoritable)->
    _.contains(@_collection, favoritable)
