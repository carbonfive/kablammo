class Robot
  include MongoMapper::EmbeddedDocument
  include Target

  MAX_AMMO  = 10
  MAX_ARMOR = 5

  key :username,  String,  required: true
  key :x,         Integer, required: true
  key :y,         Integer, required: true
  key :start_x,   Integer, required: true
  key :start_y,   Integer, required: true
  key :rotation,  Integer, required: true, default: 0
  key :ammo,      Integer, required: true, default: MAX_AMMO
  key :armor,     Integer, required: true, default: MAX_ARMOR
  key :abilities, Array,   required: true, default: []

  many :turns
  many :power_ups
  embedded_in :board

  def initialize(*args)
    super
    @rotation = 0
    @ammo = MAX_AMMO
    @armor = MAX_ARMOR
    @abilities = []
    self.turns = []
    self.power_ups = []
  end

  def assign_abilities(abilities)
    new_abilities = self.abilities + abilities
    self.abilities = new_abilities.uniq
  end

  def revoke_abilities(abilities)
    updated_abilities = self.abilities - abilities
    self.abilities = updated_abilities
  end

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
    @rotation = rotation % 360
  end

  def rotate_by(degrees)
    @rotation = (@rotation + degrees) % 360
  end

  def move_to(target)
    @x = target.x
    @y = target.y
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

  def can_see?(target)
    return true if located_at? target

    direction = direction_to target
    los = line_of_sight_to direction
    return true if los.empty?

    first_hit = los.index { |p| board.hit? p }
    return true unless first_hit

    target_hit = los.index { |p| p.located_at? target }
    target_hit <= first_hit
  end

  def can_fire_through_walls?
    abilities.include? Ability::FIRE_THROUGH_WALLS
  end

  def line_of_sight(skew = 0)
    board.line_of_sight(self, @rotation + skew)
  end

  def line_of_fire(skew = 0)
    los = line_of_sight skew

    if can_fire_through_walls?
      hit = los.index { |p| board.robot? p }
    else
      hit = los.index { |p| board.hit? p }
    end

    hit ? los[0..hit] : los
  end

  def as_seen_by(robot)
    return self if robot == self
    clone = self.dup
    clone.turns = self.turns.empty? ? [] : [ self.turns.last ]
    clone
  end
end
