class Battle
  include MongoMapper::Document

  key :name, String, required: true

  one :board

  def self.wage(args = {})
    board_args = args.delete :board

    battle = Battle.new(args)
    battle.board = Board.new(board_args)
    battle.board.fill_in_empty_squares
    battle.save!
    battle
  end

  def find_by_id(id)
    self.find id
  end

  def engine
    @engine ||= Engine::Engine.new(self)
  end

  def turn
    engine.turn if game_on?
  end

  def robots
    self.board.squares.map(&:robot).compact.sort_by(&:username)
  end

  def alive_robots
    robots.select(&:alive?)
  end

  def game_on?
    alive_robots.length >= 2
  end
end
