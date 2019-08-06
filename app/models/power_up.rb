class PowerUp
  include Mongoid::Document # Embedded
  include Target

  validates :name, :type, presence: true

  field :x, type: Integer
  field :y, type: Integer
  field :name, type: String
  field :duration, type: Integer
  field :abilities, type: Array
  field :type, type: String

  embedded_in :board
  embedded_in :robot

  def grant
    robot.assign_abilities abilities
  end

  def degrade
    if duration > 0
      duration -= 1
    end

    robot.revoke_abilities abilities if exhausted?
  end

  def exhausted?
    duration <= 0
  end

  def doppel
    PowerUp.new x: x, y: y, name: name, duration: duration, abilities: abilities, type: type
  end

  def self.instance(type)
    case type
    when :golden_bullet
      PowerUp.new name: 'Golden Bullet',
                  abilities: [Ability::FIRE_THROUGH_WALLS],
                  type: :golden_bullet,
                  duration: 10
    end
  end
end
