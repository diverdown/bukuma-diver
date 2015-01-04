request = require 'superagent'
_ = require 'lodash'
Fingerprint = require 'fingerprint'
Site = require './site'
fingerprint = new Fingerprint(canvas: true).get()

module.exports = class BukumaDiver
  @_get = (path, params, callback)->
    request
      .get(path, params)
      .end (res)->
        callback(null, JSON.parse(res.text))

  @hotEntries = (callback)->
    @_get '/stub/hotentries.json', null, callback

  @search = (params, callback)->
    @_get '/api/pages', params, callback

  @searchByDomain = (params, callback)->
    @_get "/api/domain/#{encodeURIComponent params.domain}/pages", _.pick(params, 'sort', 'of'), callback

  @popularSites = (callback)->
    @_get "/api/domains/popular", null, (err, domains)->
      res =  domains.map((domain)-> Site.find(domain: domain)) if domains
      callback(err, res)

  @isFavorite: ({domain})->
    !!_.find(@_favorites, domain: domain)

  @favorites = (callback)->
    @_get "/api/users/#{fingerprint}/favorites", null, (err, domains)=>
      @_favorites =  domains.map((domain)-> Site.find(domain: domain)) if domains
      callback(err, @_favorites)

  @favorite = (params)->
    site = Site.find(params)
    @_favorites.push(site) unless _.contains(@_favorites, site)
    request
      .post("/api/users/#{fingerprint}/favorites")
      .type('form')
      .send(params)
      .end()

  @unfavorite = (params)->
    # need to use splice for Vue
    for e,i in @_favorites
      if e.domain == params.domain
        @_favorites.splice(i, 1)
        break
    request
      .del("/api/users/#{fingerprint}/favorites/#{params.domain}")
      .end()
