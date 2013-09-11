require 'benchmark'

module Engine
  class Player
    attr_reader :robot, :handler

    def initialize(robot)
      # Note: these channel names look backwards, but it's correct because they
      #       are supposed to look right for the code on the other side
      @send    = channel "#{robot.username}-receive"
      @receive = channel "#{robot.username}-send"
      @robot   = robot
      listen_for_messages
    end

    def capsule
      RedisMessageCapsule.capsule
    end

    def channel(name)
      channel = capsule.channel name
      channel.clear
      channel
    end

    def send(message)
      @ready = false
      @handler = nil
      @send.send message
    end

    def ready!(message)
      if message == 'ready'
        puts "Player #{@robot.username} is ready!"
      else
        @handler = TurnHandler.parse @robot, message
      end
      @ready = true
    end

    def ready?
      @ready
    end

    def alive?
      @robot.alive?
    end

    def priority
      @handler.priority
    end

    def turn!
      base_turn = @robot.turns.last.dup.extend fire: nil
      turn = @handler.execute base_turn
      @robot.turns << turn
    end

    def timeout
      puts "Player #{@robot.username} turn timed out"
      @handler = RestHandler.new @robot
    end

    def handle_hits
      fire = @robot.turns.last.fire
      enemy = fire && @robot.board.robot_at(fire)
      enemy.turns.last.armor -= 1 if enemy
    end

    def handle_power_ups
      @robot.power_ups.each do |pu|
        pu.degrade
        @robot.power_ups.delete pu if pu.exhausted?
      end
    end

    def sign_off
      if @robot.alive?
        puts "Winner - #{@robot.username}!"
        send :winner
      else
        send :loser
      end
      clear
    end

    private

    def listen_for_messages
      @listener = Proc.new do |message|
        ready! message
      end
      @receive.register(&@listener)
    end

    def clear
      @receive.unregister(&@listener)
    end
  end
end
