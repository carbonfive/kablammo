module Engine
  class Engine
    def initialize(board)
      @board = board
    end

    def turn
      handlers = @board.alive_tanks.map do |tank|
        handler = TurnHandler.next_turn tank
        tank.turns << handler.turn
        handler
      end

      handlers = handlers.sort_by(&:priority)

      handlers.each do |handler|
        handler.execute
      end

      @board.save!
    end

  end
end
