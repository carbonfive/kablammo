class Fire
  include Mongoid::Document # Embedded
  include Target

  validates :hit, presence: true

  field :x, type: Integer
  field :y, type: Integer
  field :hit, type: Boolean

  embedded_in :robot
end
