namespace :web do
  task :update do
    on roles(:web) do
      system("NODE_ENV=#{fetch :env} gulp")
      if $? == 0
        upload! 'web/build', "#{current_path}/web", recursive: true
      else
        raise "Build Error"
      end
    end
  end
end
