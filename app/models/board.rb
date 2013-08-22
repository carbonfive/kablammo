class Board
  include MongoMapper::Document

  key :name,   String,  required: true, unique: true
  key :height, Integer, required: true
  key :width,  Integer, required: true

  many :squares

  attr_protected :squares

  before_create :fill_in_empty_board

  def engine
    @engine ||= Engine.new(self)
  end

  def turn
    engine.turn
  end

  def find_by_name(name)
    self.where(name: name).first
  end

  def each_row
    (0..height).each do |y|
      yield squares[(@width * y)...(@width * (y+1))]
    end
  end

  def square_at(x, y)
    squares[@width * y + x]
  end

  def add_wall(x = nil, y = nil)
    square = y == nil ? random_square : square_at(x, y)
    square.place_wall
  end

  def add_tank(tank, x = nil, y = nil)
    square = y == nil ? random_square : square_at(x, y)
    square.place_tank tank
  end

  def tanks
    self.squares.map(&:tank).compact.sort_by(&:username)
  end

  private

  def length
    height * width
  end

  def random_square
    square = squares[rand(0..length)] until square && square.empty?
    square
  end

  def fill_in_empty_board
    self.squares = Array.new(length).fill(Square.new)
    self.squares.each_with_index do |square, i|
      square.x = i % @width
      square.y = i / @width
    end
  end
end
