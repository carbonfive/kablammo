class Wall
  include MongoMapper::EmbeddedDocument
  include Target

  key :x, Integer, required: true
  key :y, Integer, required: true

  embedded_in :board
end
