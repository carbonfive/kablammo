class Wall
  include MongoMapper::EmbeddedDocument
  include Target

  key :x, Integer, required: true
  key :y, Integer, required: true

  embedded_in :board

  def doppel
    Wall.new x: x, y: y
  end
end
