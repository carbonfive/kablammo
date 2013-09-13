class Turn
  include MongoMapper::Document
  #include MongoMapper::EmbeddedDocument

  one :board
  belongs_to :battle
  #embedded_in :battle

  def robot_named(username)
    board.robots.detect { |r| r.username == username }
  end

  def doppel
    Turn.new board: board.doppel
  end

  def to_s
    moves = board.robots.map {|r| "#{r.username}: #{r.last_turn}"}.join(', ')
    "#{id} - #{moves}"
  end
end
