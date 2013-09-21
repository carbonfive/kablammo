module Target
  attr_reader :x, :y

  def at(x, y)
    self.x = x
    self.y = y
    self
  end

  def direction_to(target)
    board.geometry.direction_to self, target
  end

  def line_of_sight_to(direction)
    board.geometry.line_of_sight self, direction
  end

  def located_at?(target)
    return false unless target
    x == target.x && y == target.y
  end
end
