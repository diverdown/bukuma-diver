namespace :web do
  task :build do
    on roles(:web) do
      within "#{release_path}/web/" do
        execute :npm, 'install', '--silent', '--no-spin'
        execute :bower, 'install'
        with(node_env: 'production') { execute :gulp }
      end
    end
  end
end
