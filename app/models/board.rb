class Board
  include MongoMapper::EmbeddedDocument

  key :height, Integer, required: true
  key :width,  Integer, required: true

  many :squares
  embedded_in :battle

  attr_protected :squares

  def geometry
    @geometry ||= Geometry.new(@width, @height)
  end

  def rows
    squares.each_slice(@width).to_a
  end

  def square_at(x, y)
    return nil if x < 0 || x >= @width
    return nil if y < 0 || y >= @height
    squares[@width * y + x]
  end

  def add_wall(x, y)
    square_at(x, y).place_wall
  end

  def add_robot(robot, x, y)
    square_at(x, y).place_robot robot
  end

  def line_of_sight(source, degrees)
    los = geometry.line_of_sight source, degrees
    los.map { |p| square_at(p.x, p.y) }
  end

  def as_seen_by(robot)
    board = self.dup
    board.squares = self.squares.map { |s| s.as_seen_by robot }
    board
  end

  private

  def length
    height * width
  end

  def fill_in_empty_squares
    self.squares = Array.new(length).fill { Square.new }
    self.squares.each_with_index do |square, i|
      square.x = i % @width
      square.y = i / @width
    end
    self.squares.first.power_up = PowerUp.instance :golden_bullet
  end
end
