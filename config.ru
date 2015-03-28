require File.expand_path('../development-proxy.rb', __FILE__)
require File.expand_path('../api/app.rb', __FILE__)

map '/api' do
  run Sinatra::Application
end

map '/' do
  run DevelopmentProxy
end
