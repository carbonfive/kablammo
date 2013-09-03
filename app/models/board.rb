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

  def add_wall(x = nil, y = nil)
    square = y == nil ? random_square : square_at(x, y)
    square.place_wall
  end

  def add_robot(robot, x = nil, y = nil)
    square = y == nil ? random_square : square_at(x, y)
    square.place_robot robot
  end

  def line_of_sight(source, degrees)
    los = geometry.line_of_sight source, degrees
    los.map { |p| square_at(p.x, p.y) }
  end

  private

  def length
    height * width
  end

  def random_square
    square = squares[rand(0..length)] until square && square.empty?
    square
  end

  def fill_in_empty_squares
    self.squares = Array.new(length).fill { Square.new }
    self.squares.each_with_index do |square, i|
      square.x = i % @width
      square.y = i / @width
    end
  end
end
