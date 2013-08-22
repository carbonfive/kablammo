class Engine
  def initialize(board)
    @board = board
  end

  def turn
    @board.each_row do |row|
      row.each do |square|
        if square.tank?
          tank = square.tank
          turn = Turn.parse tank.strategy.next_turn(nil, tank, self)
          move square, turn if turn.move?
        end
      end
    end
    @board.save!
  end

  private

  def move(square, turn)
    x = square.x
    y = square.y
    move_to(square, x, y - 1) if turn.north?
    move_to(square, x, y + 1) if turn.south?
    move_to(square, x + 1, y) if turn.east?
    move_to(square, x - 1, y) if turn.west?
  end

  def move_to(square, x, y)
    return if x < 0 || x >= @board.width
    return if y < 0 || y >= @board.height

    tank = square.tank
    square.clear
    @board.square_at(x, y).place_tank tank
  end

end
