class Fire
  include MongoMapper::EmbeddedDocument
  include Target

  key :x,   Integer
  key :y,   Integer
  key :hit, Boolean, required: true
end
