module Strategy
  class Defensive < Base
    def next_turn
      enemy = find_enemies.first
      return dodge enemy if can_fire_at_me? enemy
      return rest if @tank.ammo < ::Tank::MAX_AMMO
      retreat_from enemy
    end
  end
end
