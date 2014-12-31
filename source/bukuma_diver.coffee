request = require 'superagent'
_ = require 'lodash'
module.exports = class BukumaDiver
  @_call = (path, params, callback)->
    request
      .get(path, params)
      .end (res)->
        callback(null, JSON.parse(res.text))

  @hotEntries = (callback)->
    @_call '/stub/hotentries.json', {}, callback

  @search = (params, callback)->
    @_call '/api/pages', params, callback

  @searchByDomain = (params, callback)->
    @_call "/api/domain/#{encodeURIComponent params.domain}/pages", _.pick(params, 'sort', 'of'), callback
