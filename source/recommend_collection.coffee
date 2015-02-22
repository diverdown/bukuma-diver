_ = require 'lodash'
Site = require './site'
LocalStorable = require './local_storable'
module.exports = class RecommendCollection extends LocalStorable
  DEFAULT_RECOMMENDED_SITES = [
    {name: 'はてな', domain: 'hatena.ne.jp'},
    {name: 'はてなブログ', domain: 'hatenablog.com'},
    {name: 'YouTube', domain: 'youtube.com'},
    {name: 'vimeo', domain: 'vimeo.com'},
    {name: 'ニコ動', domain: 'nicovideo.jp'},
    {name: 'pxiv', domain: 'pixiv.net'},
    {name: 'Wikipedia', domain: 'wikipedia.org'},
    {name: 'Naver', domain: 'naver.jp'},
    {name: 'TED', domain: 'ted.com'},
    {name: 'クックパッド', domain: 'cookpad.com'},
    {name: '食べログ', domain: 'tabelog.com'},
    {name: 'Amazon', domain: 'amazon.co.jp'},
    {name: 'facebook', domain: 'facebook.com'},
    {name: 'Twitter', domain: 'twitter.com'},
    {name: 'note', domain: 'note.mu'},
    {name: 'ask.fm', domain: 'ask.fm'},
    {name: 'google', domain: 'google.com'},
  ]

  @restore (err, val)=>
    @_collection = (val || DEFAULT_RECOMMENDED_SITES).map(Site.find)

  @countUp: (page)->
    domain = page.url.split('/')[2].replace(/^www\./, '')
    site = _.find(@_collection, {domain: domain})
    if site
      site.count++
    else
      @_collection.push Site.find(name: domain, domain: domain)
    @save()
