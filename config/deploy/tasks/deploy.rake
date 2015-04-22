namespace :deploy do
  task :start do
    on roles(:app) do
      execute :touch, "#{shared_path}/log/unicorn.log"
      within "#{current_path}/api/" do
        execute :unicorn, '-c', 'config/unicorn.rb', '-E', fetch(:env), '-D'
      end
    end
  end

  task :restart do
    on roles(:app) do
      if test "[ -f #{fetch :unicorn_pid} ]"
        execute :kill, '-s', 'USR2', "`cat #{fetch :unicorn_pid}`"
      else
        invoke 'deploy:start'
      end
    end
  end

  task :stop do
    on roles(:app) do
      execute :kill, '-s', 'QUIT',  "`cat #{fetch :unicorn_pid}`"
    end
  end
end
