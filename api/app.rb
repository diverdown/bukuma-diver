lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sinatra'
require 'sinatra/json'
require 'sinatra/advanced_routes'
require 'hatena/bookmark'
require 'oj'
require 'public_suffix'

if production? or ENV['RACK_ENV'] == 'staging'
  require 'redis'
  require 'hiredis'
  require 'newrelic_rpm'
end

if production?
  require 'raven'
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.excluded_exceptions = %w(Sinatra::NotFound)
  end
  use Raven::Rack
end

if development?
  require 'sinatra/reloader'
end

if development? or test?
  require 'pry'
  require 'pry-remote'
  require 'fakeredis'
end

Oj.default_options = { mode: :compat }
class << Oj
  alias_method :generate, :dump
end
set :json_encoder, Oj

require 'rack/parser'
use Rack::Parser, parsers: {
  'application/json' => proc { |body| Oj.load(body) }
}

helpers do
  def client
    @client ||= Hatena::Bookmark.new(
      user_agent: 'Bukuma Diver',
      cache_store: Faraday::HttpCache::RedisStore.new(redis),
      cache_serializer: Oj,
      log: settings.development?
    )
  end

  def redis
    @redis ||= Redis.new(
      host: ENV['REDIS_HOST'],
      port: ENV['REDIS_PORT'],
      db: ENV['REDIS_DB'],
      driver: %{production staging}.include?(ENV['RACK_ENV']) ? :hiredis : :memory
    )
  end

  def cache_key
    "cache:#{request.fullpath}"
  end

  def cache(key = cache_key, options = {}, &block)
    if cached = redis.get(key)
      cached
    else
      res = instance_eval(&block)
      redis.set key, res, ex: options[:ex] || 60 #sec
      res
    end
  end

  def site_title(domain)
    cache "site:title:#{domain}", ex: 259_200 do
      begin
        url = url(domain)
        conn = Faraday.new(url: url) do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects, limit: 5
          faraday.adapter Faraday.default_adapter
        end
        Nokogiri::HTML(conn.get.body).css('title').text
      rescue Faraday::ConnectionFailed
        site_title("www.#{domain}") unless domain.start_with? 'www.'
      rescue
        domain
      end
    end
  end

  def site(domain)
    cache "site:#{domain}", ex: 10_800 do
      Oj.dump(
        name: site_title(domain),
        totalBookmarkCount: client.total_count(url(domain))
      )
    end
  end

  def url(domain)
    "http://#{domain}"
  end
end

before do
  content_type :json
  headers 'Access-Control-Allow-Origin' => ENV['BUKUMA_DIVER_URL']
end

get '/hotentries' do
  cache do
    results = []
    Hatena::Bookmark::Category.all.each_with_index.map do |c, i|
      Thread.new do
        results[i] = { name: c.name, pages: client.hotentry(c) }
      end
    end.each(&:join)
    Oj.dump results
  end
end

get '/domains/:domain/pages' do
  cache do
    Oj.dump({
      pages: client.search_by_domain(params)
    }.merge(Oj.load site(params[:domain])))
  end
end

get '/pages' do
  halt 400 unless params[:q]
  cache do
    Oj.dump(client.search(params))
  end
end

SITES_PER_PAGE = 10
get '/domains/popular' do
  # cache may be inconsist temporarily because of offset param,
  # but it is not serious problem.
  cache do
    offset = (params[:offset] || 0).to_i
    Oj.dump(redis.zrevrange 'popular_sites', offset, offset + SITES_PER_PAGE - 1)
  end
end

get '/domains/:domain' do
  cache do
    Oj.dump(title: site_title(params[:domain]))
  end
end

post '/favorites' do
  halt 400 unless PublicSuffix.valid?(params[:domain])
  created = redis.sadd params[:domain], request.host
  redis.zincrby 'popular_sites', 1, params[:domain] if created
  200
end

delete '/favorites' do
  halt 400 unless PublicSuffix.valid?(params[:domain])
  deleted = redis.srem params[:domain], request.host
  redis.zincrby 'popular_sites', -1, params[:domain] if deleted
  200
end

Sinatra::Application.each_route.group_by(&:path).each do |path, routes|
  options path do
    headers(
      'Access-Control-Allow-Methods': routes.map(&:verb).join(',').upcase,
      'Access-Control-Allow-Headers': %w(Accept Connection Content-Type Host Origin X-Requested-With).join(','),
      'Access-Control-x-Age': 2_592_000
    )
  end
end
