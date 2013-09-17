module Engine
  class MoveHandler < TurnHandler
    attr_reader :move

    def initialize(robot, str, move)
      super robot, str
      @move = move
    end

    def execute
      robot.y += 1 if move == 'north' && robot.y + 1 < robot.board.height
      robot.y -= 1 if move == 'south' && robot.y - 1 >= 0
      robot.x += 1 if move == 'east'  && robot.x + 1 < robot.board.width
      robot.x -= 1 if move == 'west'  && robot.x - 1 >= 0
    end
  end
end
