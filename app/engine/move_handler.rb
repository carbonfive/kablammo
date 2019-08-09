module Engine
  class MoveHandler < TurnHandler
    attr_reader :move, :skew

    def initialize(robot, str, move, skew)
      super robot, str
      @move = move
      @skew = skew
    end

    def execute
      p = Pixel.new robot.x, robot.y
      p.y += 1 if move == 'north'
      p.y -= 1 if move == 'south'
      p.x += 1 if move == 'east'
      p.x -= 1 if move == 'west'
      return unless board.in_bounds?(p) && ! board.occupied?(p)

      robot.rotate_by! skew
      robot.move_to! p.x, p.y
    end
  end
end
