module Engine
  class TurnHandler

    MOVES = Hash[%w(north south east west).map {|d| [d[0], d]}]

    attr_accessor :value
    attr_accessor :tank

    def self.next_turn(tank)
      strategy = tank.strategy
      str = strategy.execute_turn tank

      handler = parse str
      handler.value = str
      handler.tank = tank
      handler
    end

    def self.parse(str)
      return RestHandler.new unless str

      str = str.downcase
      type = str[0]
      value = Integer(str[1..-1]) if str.length > 1

      return MoveHandler.new(MOVES[type]) if MOVES[type]
      return FireHandler.new(value) if type == 'f'
      return RotateHandler.new(value) if type == 'r'
      RestHandler.new
    end

    def turn
      turn = ::Turn.new
      turn.value = @value
      turn
    end

    def square
      tank.square
    end

    def board
      square.board
    end

    # turns are prioritized by type, and secondarily by who has more rest (ie: armor)
    def priority
      order = [ MoveHandler, RotateHandler, FireHandler, RestHandler ]
      order.index(self.class) * 100 + (50 - @tank.armor)
    end

  end
end
