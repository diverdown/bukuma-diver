_ = require 'lodash'
Site = require './site'
module.exports = class RecommendedSites
  DEFAULT_RECOMMENDED_SITES = [
    {name: 'はてな', domain: 'hatena.ne.jp', count: 1},
    {name: 'はてなブログ', domain: 'hatenablog.com', count: 1},
    {name: 'YouTube', domain: 'youtube.com', count: 1},
    {name: 'vimeo', domain: 'vimeo.com', count: 1},
    {name: 'ニコ動', domain: 'nicovideo.jp', count: 1},
    {name: 'pxiv', domain: 'pixiv.net', count: 1},
    {name: 'Wikipedia', domain: 'wikipedia.org', count: 1},
    {name: 'Naver', domain: 'naver.jp', count: 1},
    {name: 'TED', domain: 'ted.com', count: 1},
    {name: 'クックパッド', domain: 'cookpad.com', count: 1},
    {name: '食べログ', domain: 'tabelog.com', count: 1},
    {name: 'Amazon', domain: 'amazon.co.jp', count: 1},
    {name: 'facebook', domain: 'facebook.com', count: 1},
    {name: 'Twitter', domain: 'twitter.com', count: 1},
    {name: 'note', domain: 'note.mu', count: 1},
    {name: 'ask.fm', domain: 'ask.fm', count: 1},
    {name: 'google', domain: 'google.com', count: 1},
  ]

  sites = JSON.parse(localStorage.getItem(@name)).map(Site.find)
  @all =  sites || DEFAULT_RECOMMENDED_SITES.map(Site.find)

  @countUp = (page)->
    domain = page.url.split('/')[2].replace(/^www\./, '')
    site = _.find(@all, {domain: domain})
    if site
      site.count++
    else
      @all.push Site.find(name: domain, domain: domain, count: 1)
    @save()

  @save = ->
    localStorage.setItem(@name, JSON.stringify(@all))
