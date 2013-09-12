module Engine
  class TurnHandler

    MOVES = Hash[%w(north south east west).map {|d| [d[0], d]}]

    attr_accessor :value
    attr_accessor :robot

    def initialize(robot, value)
      @robot = robot
      @value = @robot.value = value
    end

    def self.parse(robot, str)
      return RestHandler.new robot unless str

      str = str.downcase
      type = str[0]
      value = Integer(str[1..-1]) if str.length > 1

      return MoveHandler.new(robot, str, MOVES[type]) if MOVES[type]
      return FireHandler.new(robot, str, value) if type == 'f'
      return RotateHandler.new(robot, str, value) if type == 'r'
      RestHandler.new robot
    end

    def board
      robot.board
    end

    # turns are prioritized by type, and secondarily by who has more rest (ie: armor)
    def priority
      order = [ MoveHandler, RotateHandler, FireHandler, RestHandler ]
      order.index(self.class) * 100 + (50 - @robot.armor)
    end

  end
end
