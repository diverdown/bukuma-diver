namespace :unicorn do
  task :config do
    on roles(:app) do
      config = ERB.new(File.read('config/deploy/unicorn.rb.erb')).result(binding)
      upload! StringIO.new(config), "#{current_path}/api/config/unicorn.rb"

      config = ERB.new(File.read('config/deploy/monit/unicorn.conf.erb')).result(binding)
      upload! StringIO.new(config), "/tmp/#{fetch :application}_unicorn.conf"
      sudo :mv, "/tmp/#{fetch :application}_unicorn.conf /etc/monit.d/#{fetch :application}_unicorn.conf"
      sudo :chown, 'root:root', "/etc/monit.d/#{fetch :application}_unicorn.conf"
      sudo :chmod, '700', "/etc/monit.d/#{fetch :application}_unicorn.conf"
    end
  end
end
