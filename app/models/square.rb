class Square
  include MongoMapper::EmbeddedDocument

  key :x,     Integer, required: true
  key :y,     Integer, required: true
  key :state, String,  required: true, in: %w(empty wall tank), default: 'empty'

  embedded_in :board
  one :tank

  def place_wall
    @state = 'wall'
    self.tank = nil
  end

  def place_tank(tank)
    @state = 'tank'
    self.tank = tank
  end

  def clear
    @state = 'empty'
    self.tank = nil
  end

  def empty?
    @state == 'empty'
  end

  def tank?
    @state == 'tank'
  end
end
