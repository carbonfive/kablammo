module Engine
  class MoveHandler < TurnHandler
    attr_reader :move

    def initialize(robot, str, move)
      super robot, str
      @move = move
    end

    def execute
      p = Pixel.new robot.x, robot.y
      p.y += 1 if move == 'north'
      p.y -= 1 if move == 'south'
      p.x += 1 if move == 'east'
      p.x -= 1 if move == 'west'
      return unless board.in_bounds?(p) && ! board.occupied?(p)

      robot.x = p.x
      robot.y = p.y
    end
  end
end
