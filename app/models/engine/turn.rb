class Turn

  MOVES = Hash[%w(north south east west).map {|d| [d[0], d]}]

  attr_accessor :board

  def self.parse(str)
    str = str.downcase
    type = str[0]
    value = Integer(str[1..-1]) if str.length > 1

    return MoveTurn.new(MOVES[type]) if MOVES[type]
    return FireTurn.new(value) if type == 'f'
    return RotateTurn.new(value) if type == 'r'
    RestTurn.new
  end

end
