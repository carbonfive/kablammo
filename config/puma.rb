#!/usr/bin/env puma

# Configure “min” to be the minimum number of threads to use to answer
# requests and “max” the maximum.
#
# The default is “0, 16”.
#
threads 4, 16

# Bind the server to “url”. “tcp://”, “unix://” and “ssl://” are the only
# accepted protocols.
#
# The default is “tcp://0.0.0.0:9292”.
#
bind 'tcp://0.0.0.0:9292'

on_restart do
  # TODO redis
  # TODO mongodb
end