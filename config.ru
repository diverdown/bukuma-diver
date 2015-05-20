unless %w{test development}.include? ENV['RACK_ENV']
  raise 'Invalid RACK_ENV'
end

$stdout.sync = true

require 'dotenv'
Dotenv.load(".env.#{ENV['RACK_ENV']}")

require File.expand_path('../development-proxy.rb', __FILE__)
require File.expand_path('../api/app.rb', __FILE__)

if ENV['RACK_ENV'] == 'test'
  require File.expand_path('../spec/support/fake_comment_server.rb', __FILE__)
  map '/comments' do
    run FakeCommentServer
  end
end

map '/api' do
  run Sinatra::Application
end

map '/' do
  run DevelopmentProxy
end
