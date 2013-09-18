class Map
  attr_accessor :width, :height, :walls, :starts, :name

  def initialize(args)
    @width = args[:width]
    @height = args[:height]
    @walls = args[:walls]
    @starts = args[:starts]
    @name = args[:name]
  end
end
