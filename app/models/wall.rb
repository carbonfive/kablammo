class Wall
  include Mongoid::Document # Embedded
  include Target

  validates :x, :y, presence: true

  field :x, type: Integer
  field :y, type: Integer

  embedded_in :board

  def doppel
    Wall.new x: x, y: y
  end
end
