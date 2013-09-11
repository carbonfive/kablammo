class Map
  attr_accessor :width, :height, :walls, :starts

  def initialize(args)
    self.width = args[:width]
    self.height = args[:height]
    self.walls = args[:walls]
    self.starts = args[:starts]
  end
end
