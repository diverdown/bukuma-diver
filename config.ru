unless %w{test development}.include? ENV['RACK_ENV']
  raise 'Invalid RACK_ENV'
end

$stdout.sync = true

require 'dotenv'
Dotenv.load(".env.#{ENV['RACK_ENV']}")

require File.expand_path('../development-proxy.rb', __FILE__)
require File.expand_path('../api/app.rb', __FILE__)

map '/api' do
  run Sinatra::Application
end

map '/' do
  run DevelopmentProxy
end
