module Engine
  class RestHandler < TurnHandler

    def initialize(robot)
      super robot, '.'
    end

    def execute
      robot.rest
    end

  end
end
