class Board
  include MongoMapper::EmbeddedDocument

  key :height, Integer, default: 9
  key :width,  Integer, default: 16
  key :starts, Array, required: true

  many :squares
  embedded_in :battle

  attr_protected :squares
  def initialize(attrs)
    walls = attrs.delete(:walls)
    super(attrs)

    self.squares = Array.new(@height * @width).fill do |i|
      Square.new({ x: i % @width, y: i / @width })
    end 

    walls.each { |pos| add_wall pos[0], pos[1] }
  end

  def geometry
    @geometry ||= Geometry.new(@width, @height)
  end

  def rows
    squares.each_slice(@width).to_a
  end

  def square_at(x, y)
    squares[@width * y + x]
  end

  def add_wall(x, y)
    square_at(x, y).place_wall
  end

  def add_robot(robot, start)
    start = starts[start]
    square_at( start[0], start[1] ).place_robot robot
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

end
