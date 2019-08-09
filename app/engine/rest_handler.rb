module Engine
  class RestHandler < TurnHandler

    attr_reader :skew

    def initialize(robot, value, skew)
      super robot, '.'

      @skew = skew
    end

    def execute
      robot.rotate_by! skew
      robot.rest!
    end

  end
end
