class PowerUp
  include MongoMapper::EmbeddedDocument

  key :name, String, required: true
  key :duration, Integer
  key :abilities, Array

  def grant(robot)
    robot.assign_abilities @abilities
  end

  def self.instance(type)
    case type
    when :golden_bullet
      PowerUp.new name: 'Golden Bullet',
                  abilities: [Ability::SHOOT_THROUGH_WALLS]
    end
  end
end
