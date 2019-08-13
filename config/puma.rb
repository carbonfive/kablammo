#!/usr/bin/env puma

threads 4, 16

bind 'tcp://0.0.0.0:9292'
bind 'unix://var/run/puma.sock'
pidfile 'var/run/puma.pid'

on_restart do
  # TODO redis
  # TODO mongodb
end