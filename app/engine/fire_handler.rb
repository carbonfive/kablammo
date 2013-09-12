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

    def execute
      return if ! robot.can_fire?

      robot.rotate_by! skew
      fire = robot.fire!
      enemy = fire.hit && board.robot_at(fire)
      enemy.hit! if enemy
    end
  end
end
