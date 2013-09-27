class Turn
  include MongoMapper::Document

  timestamps!
  one :board
  belongs_to :battle

  def robots
    board.robots
  end

  def robot_named(username)
    robots.detect { |r| r.username == username }
  end

  def doppel
    Turn.new board: board.doppel
  end

  def to_s
    moves = board.robots.map {|r| "#{r.username}: #{r.last_turn}, #{r.rotation}, #{r.fire}"}.join(', ')
    "#{id} - #{moves}"
  end
end
