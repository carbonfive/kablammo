class Turn
  include MongoMapper::EmbeddedDocument

  one :board
  embedded_in :battle

  def deep_dup
    dup = self.dup
    dup.board = board.deep_dup
    dup
  end
end
