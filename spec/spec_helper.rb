require 'rspec'
require 'capybara/rspec'
require 'faraday'
require 'webmock/rspec'
require_relative 'support/fake_hatena_bookmark'

ENV['RACK_ENV'] = 'test'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.configure do |config|
  config.javascript_driver = ENV['TRAVIS'] ? :selenium : :selenium_chrome
  config.server_port = 50_000
  config.app = Rack::Builder.parse_file(File.expand_path('../../config.ru', __FILE__))[0]
end

WebMock.disable_net_connect!(allow_localhost: true)

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

  config.before :each do
    stub_request(:any, /b.hatena.ne.jp/).to_rack(FakeHatenaBookmark)
    allow_any_instance_of(Sinatra::Application).to receive(:site_title) { 'サイト名' }
  end
end
