class PowerUp
  include MongoMapper::EmbeddedDocument
  include Target

  key :x,         Integer
  key :y,         Integer
  key :name,      String, required: true
  key :duration,  Integer
  key :abilities, Array
  key :type,      String, required: true

  embedded_in :board
  embedded_in :robot

  def grant
    robot.assign_abilities abilities
  end

  def degrade
    if @duration > 0
      @duration -= 1
    end

    robot.revoke_abilities abilities if exhausted?
  end

  def exhausted?
    duration <= 0
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
