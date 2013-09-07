module Engine
  class MoveHandler < TurnHandler
    attr_reader :direction

    def initialize(robot, str, direction)
      super robot, str
      @direction = direction
    end

    def execute
      x, y = robot.x, robot.y
      move_to(robot, x, y + 1) if @direction == 'north'
      move_to(robot, x, y - 1) if @direction == 'south'
      move_to(robot, x + 1, y) if @direction == 'east'
      move_to(robot, x - 1, y) if @direction == 'west'
    end

    private

    def move_to(robot, x, y)
      return if x < 0 || x >= board.width
      return if y < 0 || y >= board.height

      dest = Pixel.new x, y
      board.move_robot robot, dest
    end

  end
end
