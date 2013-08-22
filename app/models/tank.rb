class Tank
  include MongoMapper::EmbeddedDocument

  key :username, String,  required: true
  key :rotation, Integer, required: true, default: 0
  key :ammo,     Integer, required: true, default: 10
  key :armor,    Integer, required: true, default: 5

  def strategy
    Strategy.new
  end
end
