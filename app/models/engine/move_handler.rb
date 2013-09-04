module Engine
  class MoveHandler < TurnHandler
    attr_reader :direction

    def initialize(robot, str, direction)
      super robot, str
      @direction = direction
    end

    def execute
      x = square.x
      y = square.y
      move_to(square, x, y + 1) if @direction == 'north'
      move_to(square, x, y - 1) if @direction == 'south'
      move_to(square, x + 1, y) if @direction == 'east'
      move_to(square, x - 1, y) if @direction == 'west'
    end

    private

    def move_to(source, x, y)
      return if x < 0 || x >= board.width
      return if y < 0 || y >= board.height

      dest = board.square_at(x, y)

      if dest.power_up?
        robot = source.robot
        power_up = dest.power_up
        power_up.grant robot
      end

      if dest.empty?
        robot = source.robot
        source.clear
        dest.place_robot robot
      end
    end

  end
end
