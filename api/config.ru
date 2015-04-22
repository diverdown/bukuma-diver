require 'dotenv'
Dotenv.load("../.env.#{ENV['RACK_ENV']}")

require File.expand_path('../app.rb', __FILE__)
run Sinatra::Application
