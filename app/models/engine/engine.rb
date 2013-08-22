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
          turn.board = @board
          turn.execute square
        end
      end
    end
    @board.save!
  end

end
