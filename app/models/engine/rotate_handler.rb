module Engine
  class RotateHandler < TurnHandler
    attr_reader :rotation

    def initialize(robot, str, rotation)
      super robot, str
      @rotation = rotation
    end

    def execute(base_turn)
      base_turn.extend value: @value, rotation: @rotation
    end
  end
end
