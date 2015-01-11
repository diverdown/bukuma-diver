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
  offset = (params[:offset] || 0).to_i
  json redis.zrevrange 'popular_sites', offset, offset + 9
end

post '/favorites/:domain' do
  created = redis.sadd params[:domain], request.host
  redis.zincrby 'popular_sites', 1, params[:domain] if created
  200
end

delete '/favorites/:domain' do
  deleted = redis.srem params[:domain], request.host
  redis.zincrby 'popular_sites', -1, params[:domain] if deleted
  200
end
