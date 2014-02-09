# note
# $ cap production deploy:check
# $ cap production deploy

lock '3.1.0'
set :application, 'chef_rails_template'

# scm
set :scm, :git
set :repo_url, 'git://github.com/ntaku/chef_rails_template.git'
set :branch, 'master'
set :deploy_to, "/var/www/#{fetch(:application)}"
set :deploy_via, :remote_cache
set :keep_releases, 5

# rvm
set :rvm_type, :system
set :rvm_ruby_version, '2.0.0'

# logging
set :format, :pretty
set :log_level, :debug

# create symbolic link to shared directory
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


namespace :deploy do

  before :starting, :upload
  task :upload do
    on roles(:app) do |host|
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
    end
  end

  after :publishing, :restart
  task :restart do
    invoke 'unicorn:restart'
  end

  after :finishing, :cleanup
end
