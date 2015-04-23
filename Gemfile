source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'nokogiri'
gem 'oj'
gem 'public_suffix'
gem 'addressable'
gem 'faraday'
gem 'faraday_middleware'
gem 'faraday-http-cache'
gem 'dotenv'
gem 'unindent'
gem 'rack-parser'

group :production, :staging do
  gem 'redis'
  gem 'hiredis'
  gem 'unicorn'
  gem 'newrelic_rpm'
  gem 'sentry-raven'
end

group :development do
  gem 'foreman'
  gem 'compass'
  gem 'susy'
  gem 'rack-livereload'
end

group :development, :test do
  gem 'pry'
  gem 'pry-remote'
  gem 'fakeredis'
  gem 'rspec'
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'sshkit-sudo'
  gem 'capistrano-rbenv'
  gem 'slackistrano', require: false
end
