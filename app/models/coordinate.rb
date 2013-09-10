class Coordinate
  include MongoMapper::EmbeddedDocument
  include Target

  key :x, Integer, required: true
  key :y, Integer, required: true
end
