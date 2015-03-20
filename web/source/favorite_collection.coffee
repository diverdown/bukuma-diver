Site = require './site'
Query = require './query'
LocalStorable = require './local_storable'
_ = require 'lodash'
module.exports = class FavoriteCollection extends LocalStorable
  TYPES = [Site, Query]

  @restore: (callback)->
    super (err, val)=>
      @_collection = (val || []).map (obj)->
        fav = TYPES[obj.type].find(obj)
        fav.favorited = true
        fav
      callback(err, @_collection)

  @save: ->
    collection = @_collection.map (favoritable)->
      obj = favoritable.preprocess()
      obj.type = _.indexOf(TYPES, favoritable.constructor)
      obj
    super(collection)

  add = (favoritable)->
    @_collection.unshift(favoritable) unless @doesInclude(favoritable)
    @save()

  Site.on 'favorite', add, this
  Query.on 'favorite', add, this

  remove = (favoritable)->
    # need to use splice for Vue
    for e,i in @_collection
      if e == favoritable
        @_collection.splice(i, 1)
        break
    @save()

  Site.on 'unfavorite', remove, this
  Query.on 'unfavorite', remove, this

  @doesInclude: (favoritable)->
    _.contains(@_collection, favoritable)
