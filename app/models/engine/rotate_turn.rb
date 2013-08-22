class RotateTurn < Turn
  attr_reader :rotation

  def initialize(rotation)
    @rotation = rotation
  end

  def rotate?
    true
  end
end
