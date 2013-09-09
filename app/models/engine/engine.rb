module Engine
  class Engine
    def initialize(battle)
      @battle = battle
      capsule = RedisMessageCapsule.capsule
      @channels = build_channels capsule
    end

    def prepare_for_battle!
      puts "preparing for battle!"
      ready_handlers = {}
      ready_robots = []
      robots = @battle.robots
      robots.each do |robot|
        ready_handler = Proc.new do |str|
          puts "@#{robot.username} is prepared with message: #{str}"
          ready_robots << robot.username
          this_handler = ready_handlers[robot.username]
          receive_channel(robot).listener.unregister(&this_handler)
        end
        ready_handlers[robot.username] = ready_handler
        receive_channel(robot).register(&ready_handler)
        send_channel(robot).send :ready?
      end
      max_wait = 30 # seconds
      while max_wait > 0 and ready_robots.count < robots.count
        sleep 1
        max_wait -= 1
        # puts "waiting #{max_wait}: #{ready_robots}"
      end
    end

    def turn
      msg_handlers = {}
      turn_handlers = []
      alive_robots = @battle.alive_robots
      degrade_power_ups alive_robots
      alive_robots.each do |robot|
        msg_handler = Proc.new do |str|
          puts "Turn for #{robot.username}: #{str}"
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
        robot = turn_handler.robot
        base_turn = robot.turns.last.dup.extend fire: nil
        turn = turn_handler.execute base_turn
        robot.turns << turn
      end

      # handle hits (this needs to be refactored!)
      turn_handlers.each do |turn_handler|
        robot = turn_handler.robot
        fire = robot.turns.last.fire
        enemy = fire && robot.board.robot_at(fire)
        enemy.turns.last.armor -= 1 if enemy
      end

      @battle.save!

      if @battle.game_over?
        @battle.robots.each do |robot|
          if robot.alive?
            send_channel(robot).send :winner
          else
            send_channel(robot).send :looser
          end
        end
      end
    end

    private

    def degrade_power_ups(robots)
      robots.each do |robot|
        robot.power_ups.each do |power_up|
          power_up.degrade
          robot.power_ups.delete(power_up) if power_up.exhausted?
        end
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
        send.clear
        receive.clear
        channels[robot.username] = { send: send, receive: receive }
      end
      channels
    end
  end
end
