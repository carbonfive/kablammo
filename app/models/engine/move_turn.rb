class MoveTurn < Turn
  attr_reader :direction

  def initialize(direction)
    @direction = direction
  end

  def execute(square)
    x = square.x
    y = square.y
    move_to(square, x, y - 1) if @direction == 'north'
    move_to(square, x, y + 1) if @direction == 'south'
    move_to(square, x + 1, y) if @direction == 'east'
    move_to(square, x - 1, y) if @direction == 'west'
  end

  private

  def move_to(source, x, y)
    return if x < 0 || x >= @board.width
    return if y < 0 || y >= @board.height

    dest = @board.square_at(x, y)
    if dest.empty?
      tank = source.tank
      source.clear
      dest.place_tank tank
    end
  end

end
