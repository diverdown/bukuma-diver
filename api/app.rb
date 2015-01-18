lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sinatra'
require 'sinatra/json'
require 'hatena/bookmark'
require 'oj'
require 'public_suffix'

if production?
  require 'redis'
  require 'hiredis'
end

if development?
  require 'sinatra/reloader'
end

if development? or test?
  require 'pry'
  require 'fakeredis'
end

require 'dotenv'
Dotenv.load

Oj.default_options = { mode: :compat }
class << Oj
  alias_method :generate, :dump
end
set :json_encoder, Oj

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
      driver: settings.production? ? :hiredis : :memory
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

  def site_title(url)
    conn = Faraday.new(url: url) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects, limit: 5
      faraday.adapter Faraday.default_adapter
    end
    Nokogiri::HTML(conn.get.body).css('title').text
  end

  def site(domain)
    url = "http://#{domain}"
    cache "site:#{domain}", ex: 10_800 do
      Oj.dump(
        name: site_title(url),
        totalBookmarkCount: client.total_count(url)
      )
    end
  end
end

before do
  content_type :json
end

get '/hotentries' do
  cache do
    results = []
    Hatena::Bookmark::Category.all.each_with_index.map do |(id, name), i|
      Thread.new do
        results[i] = { name: name, pages: client.hotentry(id) }
      end
    end.each(&:join)
    Oj.dump results
  end
end

get '/domains/:domain/pages' do
  halt 400 unless PublicSuffix.valid?(params[:domain])
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

post '/favorites/:domain' do
  halt 400 unless PublicSuffix.valid?(params[:domain])
  created = redis.sadd params[:domain], request.host
  redis.zincrby 'popular_sites', 1, params[:domain] if created
  200
end

delete '/favorites/:domain' do
  halt 400 unless PublicSuffix.valid?(params[:domain])
  deleted = redis.srem params[:domain], request.host
  redis.zincrby 'popular_sites', -1, params[:domain] if deleted
  200
end
