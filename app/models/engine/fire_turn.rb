class FireTurn < Turn
  attr_reader :skew

  def initialize(skew)
    @skew = skew || 0
  end

  def execute
    return if ! tank.can_fire?

    puts "fire!"
    tank.fire
    enemy = tank.pointed_at @skew
    if enemy && enemy.tank?
      enemy.tank.hit
    end
  end

end
