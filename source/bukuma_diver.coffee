request = require 'superagent'
_ = require 'lodash'
Site = require './site'
Query = require './query'
FavoriteCollection = require './favorite_collection'
PathTemplate = require './path_template'
jsonp = require 'jsonp'
module.exports = class BukumaDiver
  bindedMethod = (method)->
    (path, params, callback)->
      [path, params] = PathTemplate.bind(path, params)
      request[method](path, params)
        .end (res)->
          callback?(null, JSON.parse(res.text))

  [get, post, del] = ['get', 'post', 'del'].map(bindedMethod)

  @hotEntries: (callback)->
    get '/api/hotentries', null, callback

  @search: (params, callback)->
    get '/api/pages', params, callback

  @searchByDomain: (params, callback)->
    get '/api/domains/:domain/pages', _.pick(params, 'domain', 'sort', 'of'), callback

  @popularSites: (params, callback)->
    get '/api/domains/popular', params, (err, domains)->
      res =  domains.map((domain)-> Site.find(domain: domain)) if domains
      callback(err, res)

  @comments: (url, callback)->
    jsonp(
      "http://b.hatena.ne.jp/entry/jsonlite/?url=#{encodeURIComponent url}",
      (err, {bookmarks})->
        callback(err, _.reject(bookmarks, comment: ''))
    )

  Site.on 'favorite', (site)->
    post "/api/favorites/:domain", _.clone(site)

  Site.on 'unfavorite', (site)->
    del "/api/favorites/:domain", _.clone(site)
