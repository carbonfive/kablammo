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

  def pointed_at?(enemy)
    @tank.line_of_sight.include?(enemy)
  end

  def obscured?(enemy)
    los = @tank.line_of_sight_to enemy
    hit = los.find { |s| ! s.empty? }
    los.include?(enemy.square) && hit != enemy.square
  end

  def can_fire_at?(enemy)
    (@tank.rotation - @tank.direction_to(enemy)).abs <= 5
    #@tank.pointed_at == enemy.square
  end

  def can_fire_at_me?(enemy)
    (enemy.rotation - enemy.direction_to(@tank)).abs <= 5
    #enemy.pointed_at == @tank.square
  end

  def fire_at(enemy, skew = false)
    "f#{skew ? 5 : ''}"
  end

  def point_at(enemy)
    degrees = @tank.direction_to(enemy).round
    "r#{degrees}"
  end

  def approach(enemy)
    aggressive_moves(enemy).find { |m| can_move? m }
  end

  def retreat_from(enemy)
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

  def square_for(move)
    x, y = @tank.square.x, @tank.square.y
    y += 1 if move == 'n'
    y -= 1 if move == 's'
    x += 1 if move == 'e'
    x -= 1 if move == 'w'
    @board.square_at x, y
  end

  def can_move?(move)
    next_square = square_for move
    next_square && next_square.empty?
  end

  def rest
    '.'
  end

  def next_turn
    throw 'not implemented'
  end
end

class AggressiveStrategy < Strategy
  def next_turn
    enemy = find_enemies.first
    return rest if @tank.ammo == 0
    return fire_at enemy if can_fire_at? enemy
    return approach enemy if obscured? enemy
    return point_at enemy unless pointed_at? enemy
    approach enemy
  end
end

class DefensiveStrategy < Strategy
  def next_turn
    enemy = find_enemies.first
    return retreat_from enemy if can_fire_at_me? enemy
    return rest if ! @tank.full_armor?
    retreat_from enemy
  end
end
