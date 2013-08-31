module Strategy
  class Aggressive < Base
    def next_turn
      enemy = find_enemies.first
      return rest if @robot.ammo == 0
      return approach enemy if obscured? enemy
      return fire_at enemy, 0.75 if can_fire_at? enemy
      return point_at enemy unless pointed_at? enemy
      approach enemy
    end
  end
end
