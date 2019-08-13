module Engine
  class Player
    attr_reader :handler
    attr_accessor :battle, :username

    def initialize(battle, username)
      # Note: these channel names look backwards, but it's correct because they
      #       are supposed to look right for the code on the other side
      @send    = channel "#{username}-receive"
      @receive = channel "#{username}-send"
      @battle = battle
      @username = username
      @timeouts = 0
      @disabled = false
      @ready = false
      listen_for_messages
    end

    def capsule
      RedisMessageCapsule.capsule
    end

    def turn
      @battle.current_turn
    end

    def robot
      turn.robot_named @username
    end

    def channel(name)
      channel = capsule.channel name
      channel.clear
      channel
    end

    def disabled?
      @disabled || too_many_timeouts?
    end

    def too_many_timeouts?
      @timeouts >= 3
    end

    def send(message, force = false)
      if disabled? && !force
        @ready = true
        @handler = RestHandler.new robot
        return
      end

      @ready = false
      @handler = nil
      @send.send message
    end

    def ready!(message)
      if message == 'ready'
        puts "Player #{@username} is ready!" unless @ready
      elsif message == 'error'
        print '!'
        @disabled = true
        @handler = RestHandler.new robot
      else
        print '.'
        @handler = TurnHandler.parse robot, message
      end
      @ready = true
      @timeouts = 0
    end

    def ready?
      @ready
    end

    def alive?
      robot.alive?
    end

    def priority
      handler.priority
    end

    def turn!
      handler.execute
    end

    def timeout
      puts "Player #{@username} turn timed out"
      @handler = RestHandler.new robot, "", 0
      @timeouts += 1
      puts "Too many timeouts - #{@username} is now disabled" if disabled?
    end

    def handle_power_ups
      robot.power_ups.each do |pu|
        pu.degrade
        robot.power_ups.delete pu if pu.exhausted?
      end
    end

    def sign_off
      return if @signed_off
      @signed_off = true
      send :shutdown, true
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
