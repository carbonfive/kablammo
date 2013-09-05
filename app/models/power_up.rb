class PowerUp
  include MongoMapper::EmbeddedDocument

  key :name, String, required: true
  key :duration, Integer
  key :abilities, Array
  key :type, String, required: true

  embedded_in :square
  embedded_in :robot

  def grant
    robot.assign_abilities abilities
  end

  def degrade
    p "DEgrading"
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
