#!/usr/bin/env puma

threads 4, 16

bind 'tcp://0.0.0.0:9292'
bind 'unix://shared/tmp/sockets/puma.sock'
pidfile 'shared/tmp/pids/puma.pid'

on_restart do
  # TODO redis
  # TODO mongodb
end