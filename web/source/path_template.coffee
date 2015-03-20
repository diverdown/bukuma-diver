_ = require 'lodash'
qs = require 'qs'
module.exports =
  bind: (path, params)->
    [
      path.replace /:[^\d\/]+/g, (match)->
        name = match.substr(1)
        replacement = params[name]
        if replacement
          delete params[name]
          encodeURIComponent(replacement)
        else
           match
      params
    ]
  stringify: (path, params)->
    [path, params] = @bind(path, params)
    queryString = qs.stringify(params)
    queryString = "?#{queryString}" if queryString.length > 0
    "#{path}#{queryString}"
