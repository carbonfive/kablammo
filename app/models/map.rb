class Map
  attr_accessor :width, :height, :walls, :starts

  def initialize(args)
    @width = args[:width]
    @height = args[:height]
    @walls = args[:walls]
    @starts = args[:starts]
  end
end
