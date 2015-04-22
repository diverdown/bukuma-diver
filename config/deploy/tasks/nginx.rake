namespace :nginx do
  desc 'Adds NginX configuration and enables it.'
  task :setup do
    on roles(:web) do
      %w{web api}.each do |type|
        config = ERB.new(File.read("config/deploy/#{type}.nginx.conf.erb")).result(binding)
        upload! StringIO.new(config), "/tmp/#{type}.#{fetch :application}"
        sudo :mv, "/tmp/#{type}.#{fetch :application} /etc/nginx/conf.d/#{type}.#{fetch :application}.conf"
      end
    end
  end

  desc 'Restarts nginx'
  task :restart do
    on roles(:web) do
      sudo :service, 'nginx',  'restart'
    end
  end

  desc 'Removes NginX configuration and disables it.'
  task :destroy do
    on roles(:web) do
      %w(web api).each do |type|
        nginx_conf = "/etc/nginx/conf.d/#{type}.#{fetch :application}.conf"
        if test "[ -f #{nginx_conf} ]"
          sudo :rm, nginx_conf
        end
      end
      sudo :service, 'nginx', 'restart'
    end
  end
end
