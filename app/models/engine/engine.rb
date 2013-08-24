class Engine
  def initialize(board)
    @board = board
  end

  def turn
    turns = @board.alive_tanks.map do |tank|
      Turn.next_turn tank
    end

    turns.sort_by(&:priority)
    #p turns.map(&:tank).map(&:username)

    turns.each do |turn|
      turn.execute
    end

    @board.save!
  end

end
