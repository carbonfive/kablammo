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
      alive_robots.each do |robot|
        msg_handler = Proc.new do |turn|
          turn_handler = TurnHandler.parse turn
          turn_handler.value = turn
          turn_handler.robot = robot
          turn_handlers << turn_handler
        end
        msg_handlers[robot.username] = msg_handler
        receive_channel(robot).register(&msg_handler)
        send_channel(robot).send 'next_turn'
      end

      sleep 0.1 while turn_handlers.length < alive_robots.length

      alive_robots.each do |robot|
        msg_handler = msg_handlers[robot.username]
        listener = receive_channel(robot).listener
        listener.unregister(&msg_handler)
      end

      turn_handlers = turn_handlers.sort_by(&:priority)

      turn_handlers.each do |turn_handler|
        turn_handler.robot.turns << turn_handler.turn
        turn_handler.execute
      end

      @battle.save!
    end

    private

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
