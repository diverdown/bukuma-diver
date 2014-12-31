require 'addressable/uri'
require 'nokogiri'
require 'faraday'
require 'faraday_middleware'
require 'public_suffix'
require 'hatena/bookmark/category'

module Hatena
  class Bookmark
    class InvalidCategoryError < StandardError; end

    def initialize(user_agent: 'Hatena::Bookmark', log: false)
      @connection = Faraday.new(url: 'http://b.hatena.ne.jp') do |faraday|
        faraday.response :logger if log
        faraday.headers[:user_agent] = user_agent
        faraday.use FaradayMiddleware::FollowRedirects, limit: 5
        faraday.adapter Faraday.default_adapter
      end
    end

    def hotentry(category = nil)
      path, params = Category.to_query category
      api "/hotentry#{path}", params
    end

    def search(params)
      api '/search/text', params.merge(mode: 'rss')
    end

    def search_by_domain(params)
      api '/entrylist', params.merge(mode: 'rss')
    end

    private

    def api(path, params)
      Nokogiri::XML(@connection.get(path, params).body).css('item').map do |elem|
        url = elem.css('link').text
        {
          title: elem.css('title').text,
          url: url,
          bookmark_count: elem.css('hatena|bookmarkcount').text.to_i,
          domain: PublicSuffix.parse(Addressable::URI.parse(url).host).domain
        }
      end
    end
  end
end
