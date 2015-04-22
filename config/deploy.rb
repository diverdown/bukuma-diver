# config valid only for current version of Capistrano
lock '3.4.0'

require 'dotenv'
Dotenv.load(".env.#{fetch :stage}")
set :env, fetch(:stage)

set :scm, :git
set :application, 'bukuma-diver'
set :repo_url, "git@github.com/webken/#{fetch :application}.git"

set :user, ENV['DEPLOY_USER']
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_to, "/home/#{fetch :user}/#{fetch :application}"

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, ->{ %W(.env.#{fetch :env}) }

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

# capistrano-rbenv
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_path, '/opt/rbenv'

# capistano-bundler
set :bundle_without, 'development test deployment'
set :bundle_jobs, ENV['BUNDLE_JOBS']
set :bundle_bins, fetch(:bundle_bins, []).push('unicorn')

role :web,  "#{fetch :user}@#{ENV['WEB_HOST']}"
role :app,  "#{fetch :user}@#{ENV['API_HOST']}"

set :server_name, ENV['BUKUMA_DIVER_URL'].split('/').last
set :api_server_name, ENV['BUKUMA_DIVER_API_URL'].split('/').last
set :unicorn_processes, ENV['UNICORN_PROCESSES']

set :ssh_options, {
  user: fetch(:user),
  port: ENV['SSH_PORT'],
  forward_agent: true,
  auth_methods: %w(publickey),
  keys: %w{~/.ssh/id_rsa}
}

set :slack_webhook, ENV['SLACK_WEBHOOK_URL']

after 'nginx:setup', 'nginx:restart'

after 'deploy:started', 'dotenv:upload'
after 'deploy:publishing', 'deploy:restart'
before 'deploy:restart', 'unicorn:config'
before 'unicorn:config', 'newrelic:config'
after 'deploy:restart', 'web:update'
