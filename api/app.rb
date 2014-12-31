lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sinatra'
require 'sinatra/json'
require 'hatena/bookmark'
require 'oj'
Oj.default_options = { mode: :compat }
class << Oj
  alias_method :generate, :dump
end
set :json_encoder, Oj

helpers do
  def client
    @client ||= Hatena::Bookmark.new(user_agent: 'Bukuma Diver', log: settings.development?)
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

get '/pages/popular' do
  # 人気サイト
end

post '/favourites' do
  # お気に入り登録
end

delete '/favourites/:id' do
  # お気に入り削除
end
