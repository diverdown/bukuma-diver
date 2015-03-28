require 'sinatra'
require 'rack-livereload'

class Rack::DevelopmentProxy
  def initialize(app)
    @app = app
  end

  def call(env)
    unless env['PATH_INFO'].match /\A\/(?:css|js|image|font)\//
      env['REQUEST_URI'].sub(env['PATH_INFO'][1..-1], '') if env['REQUEST_URI']
      env['REQUEST_PATH'] = '/index.html'
      env['PATH_INFO'] = '/index.html'
    end
    @app.call(env)
  end
end

class DevelopmentProxy < Sinatra::Base
  use Rack::LiveReload if development?
  use Rack::DevelopmentProxy

  set :public_folder, File.dirname(__FILE__) + '/web/build'
end
