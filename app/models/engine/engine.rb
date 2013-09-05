module Engine
  class Engine
    def initialize(battle)
      @battle = battle
      capsule = RedisMessageCapsule.capsule
      @channels = build_channels capsule
    end

    def turn
      msg_handlers = {}
      turn_handlers = []
      alive_robots = @battle.alive_robots
      degrade_power_ups alive_robots
      alive_robots.each do |robot|
        msg_handler = Proc.new do |str|
          turn_handlers << TurnHandler.parse(robot, str)
        end
        msg_handlers[robot.username] = msg_handler
        receive_channel(robot).register(&msg_handler)
        send_channel(robot).send @battle.as_seen_by(robot)
      end

      # timeout the turn after 1/2 second
      start = Time.now.to_f
      sleep 0.01 while turn_handlers.length < alive_robots.length && Time.now.to_f - start <= 0.5

      alive_robots.each do |robot|
        msg_handler = msg_handlers[robot.username]
        listener = receive_channel(robot).listener
        listener.unregister(&msg_handler)
        unless turn_handlers.find {|t| t.robot == robot}
          puts "Turn timeout for: #{robot.username}"
          turn_handlers << RestHandler.new(robot)
        end
      end

      turn_handlers = turn_handlers.sort_by(&:priority)

      turn_handlers.each do |turn_handler|
        turn_handler.robot.turns << turn_handler.turn
        turn_handler.execute
      end

      @battle.save!
    end

    private

    def degrade_power_ups(robots)
      power_ups = robots.map(&:power_ups).flatten
      power_ups.each do |power_up|
        power_up.degrade
      end
    end

    def send_channel(robot)
      @channels[robot.username][:send]
    end

    def receive_channel(robot)
      @channels[robot.username][:receive]
    end

    def build_channels(capsule)
      channels = {}
      @battle.robots.each do |robot|
        # Note: these channel names look backwards, but it's correct because they
        #       are supposed to look right for the code on the other side
        send = capsule.channel "#{robot.username}-receive"
        receive = capsule.channel "#{robot.username}-send"
        channels[robot.username] = { send: send, receive: receive }
      end
      channels
    end
  end
end
