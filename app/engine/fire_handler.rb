module Engine
  class FireHandler < TurnHandler
    MAX_SKEW = 10

    attr_reader :skew

    def initialize(robot, str, skew)
      super robot, str
      @skew = skew
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
