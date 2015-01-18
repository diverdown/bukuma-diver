require 'addressable/uri'
require 'nokogiri'
require 'faraday'
require 'faraday_middleware'
require 'faraday-http-cache'
require 'public_suffix'
require 'hatena/bookmark/category'
require 'faraday/http_cache/redis_store'
require 'unindent'

module Hatena
  class Bookmark
    class InvalidCategoryError < StandardError; end

    def initialize(user_agent: 'Hatena::Bookmark', log: false, cache_store: nil, cache_serializer: nil)
      @connection = Faraday.new(url: 'http://b.hatena.ne.jp') do |faraday|
        if log
          require 'faraday/http_cache/development_logger'
          faraday.response :logger
          logger = Faraday::HttpCache::DevelopmentLogger.new
        end
        faraday.headers[:user_agent] = user_agent
        faraday.use Faraday::HttpCache, store: cache_store, serializer: cache_serializer, shared_cache: false, logger: logger
        faraday.use FaradayMiddleware::FollowRedirects, limit: 5
        faraday.adapter Faraday.default_adapter
      end
    end

    def hotentry(category = nil)
      path, params = Category.to_query category
      items "/hotentry#{path}", params
    end

    def search(params)
      items '/search/text', params.merge(mode: 'rss')
    end

    def search_by_domain(params)
      items '/entrylist', params.merge(mode: 'rss', url: params[:domain])
    end

    def total_count(url)
      xml = Nokogiri::XML(@connection.post('/xmlrpc', <<-XML.unindent
        <?xml version="1.0"?>
        <methodCall>
          <methodName>bookmark.getTotalCount</methodName>
          <params>
            <param>
              <value><string>#{url}</string></value>
            </param>
          </params>
        </methodCall>
      XML
      ).body)
      xml.css('value').text.to_i
    end

    private

    def extract_items(nokogiri_xml)
      nokogiri_xml.css('item').map do |elem|
        url = elem.css('link').text
        {
          title: elem.css('title').text,
          url: url,
          bookmark_count: elem.css('hatena|bookmarkcount').text.to_i,
          domain: PublicSuffix.parse(Addressable::URI.parse(url).host).domain
        }
      end
    end

    def request(path, params)
      Nokogiri::XML(@connection.get(path, params).body)
    end

    def items(path, params)
      extract_items request(path, params)
    end
  end
end
