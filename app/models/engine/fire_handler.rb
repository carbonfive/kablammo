module Engine
  class FireHandler < TurnHandler
    MAX_SKEW = 10

    attr_reader :skew

    def initialize(skew)
      @skew = skew || 0
      @skew = MAX_SKEW * -1 if @skew < MAX_SKEW * -1
      @skew = MAX_SKEW      if @skew > MAX_SKEW
    end

    def line_of_fire
      robot.line_of_fire @skew
    end

    def execute
      return if ! robot.can_fire?

      robot.fire
      lof = line_of_fire
      enemy = lof.last
      if enemy && enemy.robot?
        enemy.robot.hit
      end
    end
  end
end
