class Robot
  include MongoMapper::EmbeddedDocument

  MAX_AMMO  = 10
  MAX_ARMOR = 5

  key :username,  String,  required: true
  key :rotation,  Integer, required: true, default: 0
  key :ammo,      Integer, required: true, default: MAX_AMMO
  key :armor,     Integer, required: true, default: MAX_ARMOR

  many :turns
  embedded_in :square

  def strategy
    Strategy::Base.lookup @username
  end

  def rest
    @ammo  = [MAX_AMMO,  @ammo  + 1].min
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

  def can_see?(other_square)
    return true if square == other_square

    direction = square.board.geometry.direction_to square, other_square
    los = square.board.line_of_sight square, direction
    return true if los.empty?

    hit = los.index { |s| ! s.empty? }
    return true unless hit

    other_index = los.index other_square
    other_index <= hit
  end

  def line_of_sight(skew = 0)
    pixels = square.board.line_of_sight(square, @rotation + skew)
    pixels.map { |p| square.board.square_at(p.x, p.y) }
  end

  def line_of_fire(skew = 0)
    los = line_of_sight skew
    hit = los.index { |s| ! s.empty? }
    hit ? los[0..hit] : los
  end

  def as_seen_by(robot)
    return self if robot == self
    clone = self.dup
    clone.turns = self.turns.empty? ? [] : [ self.turns.last ]
    clone
  end

end
