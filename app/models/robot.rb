class Robot
  include Mongoid::Document # Embedded
  include Target

  MAX_AMMO  = 10
  MAX_ARMOR = 5

  validates :last_turn, :username, :turn, :x, :y, :rotation, :ammo, :armor, :abilities, presence: true

  field :last_turn, type: String, default: "*"
  field :username, type: String
  field :turn, type: String
  field :x, type: Integer
  field :y, type: Integer
  field :rotation, type: Float, default: 0.0
  field :ammo, type: Integer, default: MAX_AMMO
  field :armor, type: Integer, default: MAX_ARMOR
  field :abilities, type: Array, default: []

  embeds_one :fire
  embeds_many :power_ups

  def identifier
    username.hash.abs.to_s
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
    Strategy.lookup @username
  end

  def rest!
    self.ammo = [ammo + 1, MAX_AMMO].min
  end

  def fire!
    self.ammo -= 1
    hit = line_of_fire.last
    if board.hit? hit
      fire = Fire.new x: hit.x, y: hit.y, hit: true
    else
      fire = Fire.new hit: false
    end
    self.fire = fire
  end

  def hit!
    self.armor -= 1
  end

  def rotate_by!(degrees)
    self.rotation = (rotation + degrees) % 360
  end

  def rotate_to!(degrees)
    self.rotation = degrees % 360
  end

  def alive?
    armor > 0
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

  def doppel
    power_ups = self.power_ups.map {|p| p.doppel}
    Robot.new last_turn: last_turn, username: username, x: x, y: y, ammo: ammo, armor: armor,
              rotation: rotation, abilities: abilities, power_ups: power_ups
  end
end
