def usage
  puts "Usage: ruby index.rb <channel> <strategy>"
  exit 1
end

usage if ARGV.empty?
username = ARGV[0]

require 'rubygems'
require 'bundler'
Bundler.require 'default'

require './lib/index'

require './player.rb'

strategy = Player.load_strategy username

raise "Player.load_strategy must return a Strategy not a #{strategy.class.name}!" unless strategy.kind_of? Strategy::Base
def next_turn(strategy, args)
  battle = Strategy::Model::Battle.new args
  strategy.execute_turn battle
end

capsule = RedisMessageCapsule.capsule
send_channel = capsule.channel "#{username}-send"
receive_channel = capsule.channel "#{username}-receive"

send_channel.clear
receive_channel.clear
Thread.abort_on_exception = true

receive_channel.register do |msg|
  turn = next_turn strategy, msg
  send_channel.send turn
end

puts "Welcome to Kablammo, #{username}!"
sleep
