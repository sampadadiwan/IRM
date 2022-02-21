#!/usr/bin/env puma

directory '/home/ubuntu/IRM/current'
rackup "/home/ubuntu/IRM/current/config.ru"
environment 'staging'

tag ''

pidfile "/home/ubuntu/IRM/shared/tmp/pids/puma.pid"
state_path "/home/ubuntu/IRM/shared/tmp/pids/puma.state"
stdout_redirect '/home/ubuntu/IRM/current/log/puma.error.log', '/home/ubuntu/IRM/current/log/puma.access.log', true

threads 0, 16

bind 'unix:///home/ubuntu/IRM/shared/tmp/sockets/IRM-puma.sock'

workers 2

restart_command 'bundle exec puma'

preload_app!

on_restart do
  Rails.logger.debug 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
