
set :application, "chef_rails_template"

require 'capistrano_colors'
require "bundler/capistrano"
require "rvm/capistrano"

# rvm
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system

# リポジトリ
set :scm, :git
set :repository, "git://github.com/ntaku/chef_rails_template.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"

# SSH
set :user, "vagrant"
ssh_options[:keys] = ["/Users/ntaku/.vagrant.d/insecure_private_key"]
ssh_options[:auth_methods] = ["publickey"]
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

# デプロイ先
role :web, "192.168.50.12"
role :app, "192.168.50.12"
role :db, "192.168.50.12", :primary => true

# precompile
load 'deploy/assets'

# cap deploy:setup 後に実行
namespace :setup do
  task :fix_permissions do
    sudo "chown -R #{user}.#{user} #{deploy_to}"
  end
end
after "deploy:setup", "setup:fix_permissions"

# Unicorn用に起動/停止タスクを変更
namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end
  task :restart, :roles => :app do
    if File.exist? "/tmp/unicorn_#{application}.pid"
      run "kill -s USR2 `cat /tmp/unicorn_#{application}.pid`"
    end
  end
  task :stop, :roles => :app do
    run "kill -s QUIT `cat /tmp/unicorn_#{application}.pid`"
  end
end
