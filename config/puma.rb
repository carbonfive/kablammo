#!/usr/bin/env puma

threads 4, 16

bind 'tcp://0.0.0.0:9292'

# Create pid file in a directory capistrano is sharing
FileUtils.mkdir_p("tmp/pids")
bind 'unix://tmp/sockets/puma.sock'
pidfile 'tmp/pids/puma.pid'

on_restart do
  # TODO redis
  # TODO mongodb
end