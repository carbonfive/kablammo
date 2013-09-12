class Robot
  include MongoMapper::EmbeddedDocument
  include Target

  MAX_AMMO  = 10
  MAX_ARMOR = 5

  key :username,  String,  required: true
  key :turn,      String,  required: true
  key :x,         Integer, required: true
  key :y,         Integer, required: true
  key :rotation,  Integer, required: true
  key :direction, Integer, required: true
  key :ammo,      Integer, required: true
  key :armor,     Integer, required: true
  key :abilities, Array,   required: true

  one :fire

  embedded_in :turn

  def initialize(*args)
    self.rotation = 0
    self.direction = -1
    self.ammo = MAX_AMMO
    self.armor = MAX_ARMOR
    self.abilities = []
    super
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

  def rest!
    self.ammo = [self.ammo + 1, MAX_AMMO].min
  end

  def fire!
    self.ammo -= 1
    hit = line_of_fire.last
    if hit
      robot.fire = Fire.new x: hit.x, y: hit.y, hit: true
    else
      robot.fire = Fire.new hit: false
    end
    robot.fire
  end

  def hit!
    self.armor -= 1
  end

  def rotate_by!(degrees)
    self.rotation = (self.rotation + degrees) % 360
  end

  def rotate_to!(degrees)
    self.rotation = degrees % 360
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

  def line_of_fire
    los = line_of_sight

    if can_fire_through_walls?
      hit = los.index { |p| board.robot? p }
    else
      hit = los.index { |p| board.hit? p }
    end

    hit ? los[0..hit] : los
  end
end
