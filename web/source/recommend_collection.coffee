_ = require 'lodash'
Site = require './site'
LocalStorable = require './local_storable'
module.exports = class RecommendCollection extends LocalStorable
  @klass = 'RecommendCollection' # for minify
  DEFAULT_RECOMMENDED_SITES = [
    {name: 'はてな', domain: 'www.hatena.ne.jp'},
    {name: 'はてなブログ | シンプルでモダンなブログライフを無料で。', domain: 'hatenablog.com'},
    {name: 'YouTube', domain: 'www.youtube.com'},
    {name: 'Vimeo、動画がいちばん輝く世界', domain: 'vimeo.com'},
    {name: 'niconico', domain: 'www.nicovideo.jp'},
    {name: 'イラストコミュニケーションサービス[pixiv(ピクシブ)]', domain: 'www.pixiv.net'},
    {name: 'Wikipedia', domain: 'ja.wikipedia.org'},
    {name: 'NAVER まとめ[情報をデザインする。キュレーションプラットフォーム]', domain: 'matome.naver.jp'},
    {name: 'TED: Ideas worth spreading', domain: 'www.ted.com'},
    {name: 'レシピ検索No.1／料理レシピ載せるなら クックパッド', domain: 'cookpad.com'},
    {name: '食べログ - ランキングと口コミで探せるグルメサイト', domain: 'tabelog.com'},
    {name: 'Amazon.co.jp |  通販 - ファッション、家電から食品まで【通常配送無料】', domain: 'www.amazon.co.jp'},
    {name: 'Facebook', domain: 'www.facebook.com'},
    {name: 'Twitter', domain: 'twitter.com'},
    {name: 'note ――つくる、つながる、とどける。', domain: 'note.mu'},
    {name: 'Ask.fm', domain: 'ask.fm'},
    {name: 'Google', domain: 'www.google.com'},
  ]

  @restore: (callback)->
    super (err, val)=>
      @_collection = (val || DEFAULT_RECOMMENDED_SITES).map(Site.find)
      callback(err, @_collection)

  @countUp: (page)->
    domain = page.url.split('/')[2].replace(/^www\./, '')
    site = _.find(@_collection, {domain: domain})
    if site
      site.count++
    else
      @_collection.push Site.find(name: domain, domain: domain)
    @save()
