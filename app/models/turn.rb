class Turn
  include MongoMapper::EmbeddedDocument
  include Target

  MAX_AMMO = 10
  MAX_ARMOR = 5

  key :value,     String,  required: true
  key :x,         Integer, required: true
  key :y,         Integer, required: true
  key :rotation,  Integer, required: true
  key :direction, Integer, required: true
  key :ammo,      Integer, required: true
  key :armor,     Integer, required: true
  key :abilities, Array,   required: true

  one :fire

  embedded_in :robot

  def initialize(*args)
    self.rotation = 0
    self.direction = -1
    self.ammo = MAX_AMMO
    self.armor = MAX_ARMOR
    self.abilities = []
    super
  end

  def extend(props = {})
    props.each do |key, value|
      send "#{key}=", value
    end
    self
  end

  def board
    robot.board
  end
end
