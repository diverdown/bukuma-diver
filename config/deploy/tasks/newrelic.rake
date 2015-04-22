namespace :newrelic do
  task :config do
    on roles(:app) do
      config = StringIO.new(File.read('config/deploy/newrelic.yml'))
      upload! config, "#{current_path}/api/config/newrelic.yml"
    end
  end
end
