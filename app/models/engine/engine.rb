class Engine::Engine
  def initialize(board)
    @board = board
  end

  def turn
    turns = @board.alive_tanks.map do |tank|
      Engine::Turn.next_turn tank
    end

    turns = turns.sort_by(&:priority)

    turns.each do |turn|
      #puts "#{turn.tank.username} - #{turn.tank.last_turn} - #{turn.priority}"
      turn.execute
    end

    @board.save!
  end

end
