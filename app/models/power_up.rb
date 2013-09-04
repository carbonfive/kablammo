class PowerUp
  include MongoMapper::EmbeddedDocument

  key :name, String, required: true
  key :duration, Integer
  key :abilities, Array
  key :type, String, required: true

  def grant(robot)
    robot.assign_abilities @abilities
  end

  def self.instance(type)
    case type
    when :golden_bullet
      PowerUp.new name: 'Golden Bullet',
                  abilities: [Ability::FIRE_THROUGH_WALLS],
                  type: :golden_bullet
    end
  end
end
