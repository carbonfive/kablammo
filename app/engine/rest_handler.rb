module Engine
  class RestHandler < TurnHandler

    attr_reader :skew

    def initialize(robot, value = ".", skew = 0)
      super robot, '.'

      @skew = skew
    end

    def execute
      robot.rotate_by! skew
      robot.rest!
    end

  end
end
