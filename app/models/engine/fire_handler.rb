module Engine
  class FireHandler < TurnHandler
    MAX_SKEW = 10

    attr_reader :skew

    def initialize(robot, str, skew)
      super robot, str
      @skew = skew || 0
      @skew = MAX_SKEW * -1 if @skew < MAX_SKEW * -1
      @skew = MAX_SKEW      if @skew > MAX_SKEW
    end

    def line_of_fire
      robot.line_of_fire @skew
    end

    def execute
      return if ! robot.can_fire?

      robot.rotate_by skew
      robot.fire
      lof = line_of_fire
      target = lof.last
      enemy = target && robot.board.robot_at(target)
      enemy.hit if enemy
    end
  end
end
