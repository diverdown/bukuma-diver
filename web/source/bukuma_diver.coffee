request = require 'superagent'
_ = require 'lodash'
PathTemplate = require './path_template'
jsonp = require 'jsonp'
module.exports = class BukumaDiver
  bindedMethod = (method)->
    (path, params, callback)->
      [path, params] = PathTemplate.bind(path, params)
      request[method](path)[if method == 'get' then 'query' else 'send'](params)
        .end (res)->
          callback?(null, if res.type.match('json') then JSON.parse(res.text) else res.text)

  [get, post, del] = ['get', 'post', 'del'].map(bindedMethod)

  BUKUMA_DIVER_API_URL = process.env.BUKUMA_DIVER_API_URL

  @hotEntries: (callback)->
    get "#{BUKUMA_DIVER_API_URL}/hotentries", null, callback

  @search: (params, callback)->
    get "#{BUKUMA_DIVER_API_URL}/pages", params, callback

  @searchByDomain: (params, callback)->
    get "#{BUKUMA_DIVER_API_URL}/domains/:domain/pages", _.pick(params, 'domain', 'sort', 'of'), callback

  @title: (params, callback)->
    get "#{BUKUMA_DIVER_API_URL}/domains/:domain", params, callback

  @popularDomains: (params, callback)->
    get "#{BUKUMA_DIVER_API_URL}/domains/popular", params, callback

  @comments: (url, callback)->
    jsonp(
      "http://b.hatena.ne.jp/entry/jsonlite/?url=#{encodeURIComponent url}",
      (err, res)->
        {eid, bookmarks} = res if res
        callback(err, eid: eid, comments: _.reject(bookmarks, comment: ''))
    )

  @footer: (callback)->
    get 'http://api.webken-apps.com/page_parts/footer', null, callback

  @favorite: (site)->
    post "#{BUKUMA_DIVER_API_URL}/favorites", _.pick(site, 'domain')

  @unfavorite: (site)->
    del "#{BUKUMA_DIVER_API_URL}/favorites", _.pick(site, 'domain')
