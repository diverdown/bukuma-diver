request = require 'superagent'
_ = require 'lodash'
Site = require './site'
Query = require './query'
FavoriteCollection = require './favorite_collection'
module.exports = class BukumaDiver
  bindParams = (path, params)->
    [
      path.replace /:[^\/]+/g, (match)->
        name = match.substr(1)
        replacement = params[name]
        if replacement
          delete params[name]
          encodeURIComponent(replacement)
        else
           match
      params
    ]

  bindedMethod = (method)->
    (path, params, callback)->
      [path, params] = bindParams(path, params)
      request[method](path, params)
        .end (res)->
          callback?(null, JSON.parse(res.text))

  [get, post, del] = ['get', 'post', 'del'].map(bindedMethod)

  @hotEntries: (callback)->
    get '/stub/hotentries.json', null, callback

  @search: (params, callback)->
    get '/api/pages', params, callback

  @searchByDomain: (params, callback)->
    get '/api/domain/:domain/pages', _.pick(params, 'domain', 'sort', 'of'), callback

  @popularSites: (callback)->
    get '/api/domains/popular', null, (err, domains)->
      res =  domains.map((domain)-> Site.find(domain: domain)) if domains
      callback(err, res)

  Site.on 'favorite', (site)->
    post "/api/favorites/:domain", _.clone(site)

  Site.on 'unfavorite', (site)->
    del "/api/favorites/:domain", _.clone(site)
