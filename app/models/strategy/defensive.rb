module Strategy
  class Defensive < Base
    def next_turn
      enemy = find_enemies.first
      return dodge enemy if can_fire_at_me? enemy
      return rest if @robot.ammo < ::Robot::MAX_AMMO
      retreat_from enemy
    end
  end
end
