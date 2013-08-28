class Strategy
  attr_reader :tank, :board

  def execute_turn(tank)
    @tank = tank
    @board = tank.square.board
    next_turn
  end

  def for_use_by(strategy)
    @tank = strategy.tank
    @board = @tank.square.board
    self
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
    (@tank.rotation - @tank.direction_to(enemy)).abs <= FireTurn::MAX_SKEW
  end

  def can_fire_at_me?(enemy)
    (enemy.rotation - enemy.direction_to(@tank)).abs <= FireTurn::MAX_SKEW
  end

  def fire_at(enemy, compensate = 0)
    direction = @tank.direction_to(enemy).round
    skew = direction - @tank.rotation
    distance = @tank.distance_to(enemy)
    max_distance = Math.sqrt(@board.height * @board.height + @board.width * @board.width)
    compensation = ( 10 - ( (10 - 3) * (distance / max_distance) ) ).round
    #puts "10 - (10 - 3) * (#{distance} / #{max_distance}) = #{compensation}"
    compensation *= -1 if rand(0..1) == 0
    skew += compensation if compensate > rand
    "f#{skew}"
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

  def dodge(enemy)
    am = aggressive_moves enemy
    moves = [ am[1], am[2], am[3], am[4] ]
    moves.find { |m| can_move? m }
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
    return approach enemy if obscured? enemy
    return fire_at enemy, 0.75 if can_fire_at? enemy
    return point_at enemy unless pointed_at? enemy
    approach enemy
  end
end

class DefensiveStrategy < Strategy
  def next_turn
    enemy = find_enemies.first
    return dodge enemy if can_fire_at_me? enemy
    return rest if @tank.ammo < Tank::MAX_AMMO
    retreat_from enemy
  end
end

class CombinationStrategy < Strategy
  def initialize(agg_factor)
    @agg_factor = agg_factor
  end

  def next_turn
    aggressive = AggressiveStrategy.new.for_use_by self
    defensive = DefensiveStrategy.new.for_use_by self
    return aggressive.next_turn if rand <= @agg_factor
    defensive.next_turn
  end
end
