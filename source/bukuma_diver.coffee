request = require 'superagent'
_ = require 'lodash'
Site = require './site'
Query = require './query'
FavoriteCollection = require './favorite_collection'
module.exports = class BukumaDiver
  @_get: (path, params, callback)->
    request
      .get(path, params)
      .end (res)->
        callback(null, JSON.parse(res.text))

  @hotEntries: (callback)->
    @_get '/stub/hotentries.json', null, callback

  @search: (params, callback)->
    @_get '/api/pages', params, callback

  @searchByDomain: (params, callback)->
    @_get "/api/domain/#{encodeURIComponent params.domain}/pages", _.pick(params, 'sort', 'of'), callback

  @popularSites: (callback)->
    @_get "/api/domains/popular", null, (err, domains)->
      res =  domains.map((domain)-> Site.find(domain: domain)) if domains
      callback(err, res)
