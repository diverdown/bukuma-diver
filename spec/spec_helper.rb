require 'rspec'
require File.expand_path('../../development-proxy.rb', __FILE__)
require File.expand_path('../../api/app.rb', __FILE__)

require 'capybara/rspec'

ENV['RACK_ENV'] = 'test'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = ENV['TRAVIS'] ? :selenium : :selenium_chrome

Capybara.app = Rack::Builder.new do
  map '/api' do
    run Sinatra::Application
  end

  map '/' do
    run DevelopmentProxy
  end
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  # config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
