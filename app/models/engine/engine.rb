module Engine
  class Engine
    def initialize(battle)
      @battle = battle
    end

    def turn
      handlers = @battle.alive_robots.map do |robot|
        handler = TurnHandler.next_turn robot
        robot.turns << handler.turn
        handler
      end

      handlers = handlers.sort_by(&:priority)

      handlers.each do |handler|
        handler.execute
      end

      @battle.save!
    end

  end
end
