class FireTurn < Turn
  attr_reader :skew

  def initialize(skew)
    @skew = skew || 0
    @skew = -5 if @skew < -5
    @skew = 5 if @skew > 5
  end

  def line_of_fire
    tank.line_of_fire @skew
  end

  def execute
    return if ! tank.can_fire?

    tank.fire
    lof = line_of_fire
    enemy = lof.last
    if enemy && enemy.tank?
      enemy.tank.hit
    end
  end

end
