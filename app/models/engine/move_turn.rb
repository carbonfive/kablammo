class MoveTurn < Turn
  attr_reader :direction

  def initialize(direction)
    @direction = direction
  end

  def move?
    true
  end

  def north?
    @direction == 'north'
  end

  def south?
    @direction == 'south'
  end

  def east?
    @direction == 'east'
  end

  def west?
    @direction == 'west'
  end
end
