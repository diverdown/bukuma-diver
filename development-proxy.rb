require 'sinatra'
require 'rack-livereload'

class Rack::DevelopmentProxy
  def initialize(app)
    @app = app
  end

  def call(env)
    unless env['PATH_INFO'].match /\A\/(?:css|js|image|font)\//
      env['REQUEST_URI'].sub(env['REQUEST_PATH'][1..-1], '')
      env['REQUEST_PATH'] = '/index.html'
      env['PATH_INFO'] = '/index.html'
    end
    @app.call(env)
  end
end

use Rack::LiveReload
use Rack::DevelopmentProxy

set :public_folder, File.dirname(__FILE__) + '/web/build'
