def usage
  puts "Usage: ruby index.rb <channel> <strategy>"
  exit 1
end

usage if ARGV.empty?
username = ARGV[0]

require 'rubygems'
require 'bundler'
Bundler.require 'default'

require 'redis_message_capsule'

strategy = Player.load_strategy username

raise "Player.load_strategy must return a Strategy not a #{strategy.class.name}!" unless strategy.kind_of? Strategy::Base

def next_turn(strategy, args)
  battle = Strategy::Model::Battle.new args
  strategy.execute_turn battle
end

def shutdown(process)
  exit 0
end

capsule = RedisMessageCapsule.capsule
send_channel = capsule.channel "#{username}-send"
receive_channel = capsule.channel "#{username}-receive"

send_channel.clear
Thread.abort_on_exception = true

process = Thread.current

receive_channel.register do |msg|
  if 'ready?'.eql? msg
    send_channel.send :ready
  elsif 'loser'.eql? msg
    shutdown process
  elsif 'winner'.eql? msg
    shutdown process
  elsif 'shutdown'.eql? msg
    shutdown process
  else
    turn = next_turn strategy, msg
    send_channel.send turn
  end
end

begin
  sleep
rescue SignalException => e
end
