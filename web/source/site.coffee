request = require 'superagent'
Favoritable = require './favoritable'
_ = require 'lodash'
PathTemplate = require './path_template'
BukumaDiver = require './bukuma_diver'
module.exports = class Site extends Favoritable
  @pathTemplate: '/domains/:domain/'

  _collection = []

  @on 'favorite', BukumaDiver.favorite
  @on 'unfavorite', BukumaDiver.unfavorite

  constructor: ({@name, @domain, @count})->
    super
    if @name == @domain and !@count
      BukumaDiver.title domain: @domain, (err, {title})=> @name = title
    @name ||= @domain
    @count ||= 1
    _collection.push(this)

  @find: (params)=>
    if found = _.find(_collection, {domain: params.domain})
      _.merge(found, params)
    else
     new @(params)

  @popular: (params, callback)->
    self = this
    BukumaDiver.popularDomains params, (err, domains)->
      res =  domains.map((domain)-> self.find(domain: domain)) if domains
      callback(err, res)

  preprocess: -> {@name, @domain}

  toPath: (params)->
    params = _.merge(domain: @domain, params)
    PathTemplate.stringify(@constructor.pathTemplate, params)
