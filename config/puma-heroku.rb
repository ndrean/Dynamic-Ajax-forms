# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
# port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
# environment ENV.fetch("RAILS_ENV") || "development"

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

preload_app! ##

rackup      DefaultRackup ##
# app_dir =  File.expand_path("../..", __FILE__)

bind "unix:///tmp/nginx.socket" # UNIX VERSION USED

workers     ENV.fetch('WEB_CONCURRENCY') { 2 }
on_worker_fork { FileUtils.touch('/tmp/app-initialized') } ##
# before_fork { |server, worker| FileUtils.touch('/tmp/app-initialized') } ##

on_worker_boot { ActiveRecord::Base.establish_connection } ##

on_restart { Sidekiq.redis.shutdown(&:close) }

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
