request = require 'superagent'
module.exports = class BukumaDiver
  @hotEntries = (callback)->
    request
      .get '/stub/hotentries.json'
      .end (res)->
        callback(null, JSON.parse(res.text))

  @search = (params, callback)->
    request.get '/api/pages', params
      .end (res)->
        callback(null, JSON.parse(res.text))
