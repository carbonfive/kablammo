class Battle
  include MongoMapper::Document

  key :name, String, required: true

  one :board

  def self.wage(args = {})
    board_args = args.delete :board

    battle = Battle.new(args)
    battle.board = Board.new(board_args)
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
    board.robots.sort_by(&:username)
  end

  def alive_robots
    robots.select(&:alive?)
  end

  def game_on?
    alive_robots.length >= 2
  end

  def game_over?
    !game_on?
  end

  def as_seen_by(robot)
    battle = self.dup
    battle.board = self.board.as_seen_by robot
    battle
  end
end
