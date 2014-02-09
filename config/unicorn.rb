# -*- coding: utf-8 -*-

application = 'chef_rails_template'

current_path = "/var/www/#{application}/current"
shared_path = "/var/www/#{application}/shared"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

listen "#{shared_path}/tmp/pids/unicorn.sock"
pid "#{shared_path}/tmp/pids/unicorn.pid"

worker_processes 4;
timeout 30
preload_app true

before_fork do |server, worker|
  # マスタープロセスの接続を解除
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # 古いマスタープロセスをKILL
  old_pid = "#{shared_path}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # preload_app=trueの場合は必須
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
