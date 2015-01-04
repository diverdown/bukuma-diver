lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sinatra'
require 'sinatra/json'
require 'hatena/bookmark'
require 'oj'
require 'redis'
require 'hiredis'
if development?
  require 'sinatra/reloader'
  require 'pry'
end

Oj.default_options = { mode: :compat }
class << Oj
  alias_method :generate, :dump
end
set :json_encoder, Oj

helpers do
  def client
    @client ||= Hatena::Bookmark.new(user_agent: 'Bukuma Diver', log: settings.development?)
  end

  def redis
    @redis ||= Redis.new(host: 'localhost', port: 6379, db: 1, driver: :hiredis)
  end
end

get '/hotentries' do
  results = []
  Hatena::Bookmark::Category.all.each_with_index.map do |(id, name), i|
    Thread.new do
      results[i] = { name: name, pages: client.hotentry(id) }
    end
  end.each(&:join)
  json results
end

get '/domain/:url/pages' do
  json client.search_by_domain(params.select{ |k,v| %w{url sort of}.include? k })
end

get '/pages' do
  json client.search(params)
end

get '/domains/popular' do
  json redis.zrevrange 'popular_sites', 0, -1
end

# O(user.favorites.size)
get '/users/:user_id/favorites' do
  content_type :json
  json redis.lrange "favorites:#{params[:user_id]}", 0, -1
end

post '/users/:user_id/favorites' do
  removed_count, _ = redis.pipelined do
    redis.lrem "favorites:#{params[:user_id]}", 0, params[:domain]
    redis.lpush "favorites:#{params[:user_id]}", params[:domain]
  end
  redis.zincrby 'popular_sites', 1, params[:domain] if removed_count == 0
  200
end

delete '/users/:user_id/favorites/:domain' do
  redis.pipelined do
    redis.lrem "favorites:#{params[:user_id]}", 0, params[:domain]
    redis.zincrby 'popular_sites', -1, params[:domain]
  end
  200
end
