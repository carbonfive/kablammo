class Turn

  MOVES = Hash[%w(north south east west).map {|d| [d[0], d]}]

  attr_accessor :tank

  def self.next_turn(tank)
    strategy = tank.strategy
    str = strategy.execute_turn tank
    tank.last_turn = str
    turn = parse str
    turn.tank = tank
    turn
  end

  def self.parse(str)
    return RestTurn.new unless str

    str = str.downcase
    type = str[0]
    value = Integer(str[1..-1]) if str.length > 1

    return MoveTurn.new(MOVES[type]) if MOVES[type]
    return FireTurn.new(value) if type == 'f'
    return RotateTurn.new(value) if type == 'r'
    RestTurn.new
  end

  def square
    tank.square
  end

  def board
    square.board
  end

  # turns are prioritized by type, and secondarily by who has more rest (ie: armor)
  def priority
    order = [MoveTurn, RotateTurn, FireTurn, RestTurn]
    order.index(self.class) * 100 + (50 - @tank.armor)
  end

end
