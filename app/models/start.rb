class Start
  attr_accessor :position, :rotation, :direction

  def initialize(x, y, rotation, direction)
    @position = Pixel.new x, y
    @rotation = rotation
    @direction = direction
  end
end
