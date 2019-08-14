require 'rubygems'
require 'bundler'
Bundler.require 'default'

require 'redis_message_capsule'

def next_turn(strategy, args)
  battle = Strategy::Model::Battle.new args
  strategy.execute_turn battle
end

def shutdown(process)
  exit 0
end

begin
  raise "No username given" if ARGV.empty?
  username = ARGV[0]
  strategy = Player.load_strategy username
  raise "Player.load_strategy must return a Strategy not a #{strategy.class.name}!" unless strategy.kind_of? Strategy::Base
  puts "Strategy loaded"

  Thread.abort_on_exception = true
  capsule = RedisMessageCapsule.capsule
  send_channel = capsule.channel "#{username}-send"
  receive_channel = capsule.channel "#{username}-receive"
  send_channel.clear
  puts "Established channel communication"

  receive_channel.register do |msg|
    if 'ready?'.eql? msg
      puts "Ready"
      send_channel.send :ready
    elsif 'shutdown'.eql? msg
      puts "Shutdown"
      exit 1
    else
      begin
        turn = next_turn strategy, msg
      rescue Exception => e
        puts "----------- Error: #{username} -----------"
        puts e.message
        puts
        puts e.backtrace.join("\n")
        puts
        puts "#{username} is now disabled."
        puts "-------------------#{'-' * username.length}------------"
        turn = 'error'
      end
      send_channel.send turn
    end
  end

  begin
    sleep
  rescue SignalException => e
    puts "Killed by signal: #{e.signo}"
  end
rescue SystemExit => e
  exit e.status
rescue Exception => e
  puts e.message
  puts
  puts e.backtrace.join("\n")
  send_channel.send :error
  exit 1
end
