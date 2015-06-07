namespace :web do
  task :build do
    on roles(:web) do
      within release_path do
        execute :npm, 'install', '--silent', '--no-spin'
        execute :bower, 'install', '--quiet', '--config.interactive=false'
        with(node_env: 'production', dotenv_file: "#{shared_path}/.env.#{fetch :env}") do
          execute :gulp
        end
      end
    end
  end
end
