namespace :dotenv do
  task :upload do
    on roles(:app) do
      upload! ".env.#{fetch :env}", "#{shared_path}"
    end
  end
end
