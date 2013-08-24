class Tank
  include MongoMapper::EmbeddedDocument

  MAX_AMMO  = 10
  MAX_ARMOR = 5

  key :username,  String,  required: true
  key :rotation,  Integer, required: true, default: 0
  key :ammo,      Integer, required: true, default: MAX_AMMO
  key :armor,     Integer, required: true, default: MAX_ARMOR
  key :last_turn, String

  embedded_in :square

  def strategy
    return AggressiveStrategy.new if @username == '0'
    return DefensiveStrategy.new if @username == '1'
    Strategy.new
  end

  def rest
    @ammo  = [MAX_AMMO,  @ammo  + 1].min
    @armor = [MAX_ARMOR, @armor + 1].min
  end

  def hit
    @armor -= 1
  end

  def fire
    @ammo -= 1
  end

  def rotate_to(rotation)
    @rotation = rotation
  end

  def alive?
    @armor >= 0
  end

  def dead?
    ! alive?
  end

  def can_fire?
    @ammo > 0
  end

  def line_of_sight(skew = 0)
    degrees = @rotation + skew
    pixels = square.board.line_of_sight(square, degrees)
    los = pixels.map { |p| square.board.square_at(p.x, p.y) }
    hit = los.find_index { |s| ! s.empty? }
    hit ? los[0..hit] : los
  end

  def pointed_at(skew = 0)
    los = line_of_sight skew
    puts "hit? #{los.last && !los.last.empty? ? los.last.position : ''}"
    return false if los.empty?
    los.last.empty? ? nil : los.last
  end

  def direction_to(enemy)
    square.board.direction_to(square, enemy.square)
  end

  def stats
    s = self.square
    "#{@username} - [#{s.x}, #{s.y}] - dir #{@rotation}, ammo #{@ammo}, armor #{@armor} - #{@last_turn}"
  end
end
