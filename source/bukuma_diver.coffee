request = require 'superagent'
_ = require 'lodash'
PathTemplate = require './path_template'
jsonp = require 'jsonp'
module.exports = class BukumaDiver
  bindedMethod = (method)->
    (path, params, callback)->
      [path, params] = PathTemplate.bind(path, params)
      request[method](path, params)
        .end (res)->
          callback?(null, if res.type.match('json') then JSON.parse(res.text) else res.text)

  [get, post, del] = ['get', 'post', 'del'].map(bindedMethod)

  @hotEntries: (callback)->
    get '/api/hotentries', null, callback

  @search: (params, callback)->
    get '/api/pages', params, callback

  @searchByDomain: (params, callback)->
    get '/api/domains/:domain/pages', _.pick(params, 'domain', 'sort', 'of'), callback

  @title: (params, callback)->
    get '/api/domains/:domain', params, callback

  @popularDomains: (params, callback)->
    get '/api/domains/popular', params, callback

  @comments: (url, callback)->
    jsonp(
      "http://b.hatena.ne.jp/entry/jsonlite/?url=#{encodeURIComponent url}",
      (err, {bookmarks})->
        callback(err, _.reject(bookmarks, comment: ''))
    )

  @footer: (callback)->
    get 'http://api.webken-apps.com/page_parts/footer', null, callback

  @favorite: (site)->
    post "/api/favorites/:domain", _.clone(site)

  @unfavorite: (site)->
    del "/api/favorites/:domain", _.clone(site)
