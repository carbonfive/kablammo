class Tank
  include MongoMapper::EmbeddedDocument

  key :username, String,  required: true
  key :rotation, Integer, required: true, default: 0
  key :ammo,     Integer, required: true, default: 10
  key :armor,    Integer, required: true, default: 5

  embedded_in :square

  def strategy
    Strategy.new
  end

  def stats
    s = self.square
    "#{@username} - [#{s.x}, #{s.y}] dir #{@rotation}, ammo #{@ammo}, armor #{@armor}"
  end
end
