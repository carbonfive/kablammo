class Robot
  include MongoMapper::EmbeddedDocument
  include Target

  MAX_AMMO  = 10
  MAX_ARMOR = 5

  key :username,  String,  required: true

  many :turns
  many :power_ups
  embedded_in :board

  def initialize(*args)
    self.turns = []
    self.power_ups = []
    super
  end

  def x
    turns.last.x
  end

  def y
    turns.last.y
  end

  def armor
    turns.last.armor
  end

  def ammo
    turns.last.ammo
  end

  def rotation
    turns.last.rotation
  end

  def abilities
    turns.last.abilities
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

  def alive?
    turns.last.armor >= 0
  end

  def dead?
    ! alive?
  end

  def can_fire?
    ammo > 0
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
    board.line_of_sight(self, rotation + skew)
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
