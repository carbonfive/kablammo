module Engine
  class RestHandler < TurnHandler

    MAX_AMMO = 10

    def initialize(robot)
      super robot, '.'
    end

    def execute
      robot.rest!
    end

  end
end
