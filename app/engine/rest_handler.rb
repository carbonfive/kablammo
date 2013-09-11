module Engine
  class RestHandler < TurnHandler

    MAX_AMMO = 10

    def initialize(robot)
      super robot, '.'
    end

    def execute(base_turn)
      ammo = [base_turn.ammo + 1, MAX_AMMO].min
      base_turn.extend value: '.', ammo: ammo
    end

  end
end
