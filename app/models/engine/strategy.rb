class Strategy
  attr_reader :tank, :board

  def execute_turn(tank)
    @tank = tank
    @board = tank.square.board
    next_turn
  end

  def find_enemies
    @board.tanks.reject {|t| t == @tank}
  end

  def can_fire_at?(enemy)
    @tank.pointed_at == enemy.square
  end

  def can_fire_at_me?(enemy)
    enemy.pointed_at == @tank.square
  end

  def fire_at(enemy, skew = false)
    "f#{skew ? 5 : ''}"
  end

  def point_at(enemy)
    degrees = @tank.direction_to(enemy).round
    "r#{degrees}"
  end

  def move_toward(enemy)
    aggressive_moves(enemy).find { |m| can_move? m }
  end

  def move_away_from(enemy)
    aggressive_moves(enemy).reverse.find { |m| can_move? m }
  end

  def aggressive_moves(enemy)
    degrees = @tank.direction_to(enemy)
    return %w(e n s w) if degrees >= 0   && degrees <= 45
    return %w(n e w s) if degrees >= 45  && degrees <= 90
    return %w(n w e s) if degrees >= 90  && degrees <= 135
    return %w(w n s e) if degrees >= 135 && degrees <= 180
    return %w(w s n e) if degrees >= 180 && degrees <= 225
    return %w(s w e n) if degrees >= 225 && degrees <= 270
    return %w(s e w n) if degrees >= 270 && degrees <= 315
    return %w(e s n w) if degrees >= 315 && degrees <= 360
    throw "unknown direction: #{degrees}"
  end

  def can_move?(move)
    x, y = @tank.square.x, @tank.square.y
    y += 1 if move == 'n'
    y -= 1 if move == 's'
    x += 1 if move == 'e'
    x -= 1 if move == 'w'
    next_square = @board.square_at x, y
    next_square && next_square.empty?
  end

  def rest
    nil
  end

  def next_turn
    throw 'not implemented'
  end
end

class AggressiveStrategy < Strategy
  def next_turn
    enemy = find_enemies.first
    if can_fire_at? enemy
      fire_at enemy, false
    else
      point_at enemy
    end
  end
end

class DefensiveStrategy < Strategy
  def next_turn
    enemy = find_enemies.first
    if can_fire_at_me? enemy
      move_away_from enemy
    else
      rest
    end
  end
end
