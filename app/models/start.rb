class Start
  attr_accessor :position, :rotation

  def initialize(x, y, rotation)
    @position = Pixel.new x, y
    @rotation = rotation
  end
end
