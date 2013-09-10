module Engine
  class MoveHandler < TurnHandler
    attr_reader :direction

    def initialize(robot, str, direction)
      super robot, str
      @direction = direction
    end

    def execute(base_turn)
      x, y = robot.x, robot.y
      board = robot.board
      direction = %w(south west north east).index @direction
      y += 1 if @direction == 'north' && y+1 < board.height
      y -= 1 if @direction == 'south' && y-1 >= 0
      x += 1 if @direction == 'east'  && x+1 < board.width
      x -= 1 if @direction == 'west'  && x-1 >= 0
      base_turn.extend value: @value, x: x, y: y, direction: direction
    end
  end
end
