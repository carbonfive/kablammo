module Engine
  class TurnHandler

    MAX_SKEW = 15
    MOVES = Hash[%w(north south east west).map {|d| [d[0], d]}]

    attr_accessor :value
    attr_accessor :robot

    def initialize(robot, value)
      @robot = robot
      @value = robot.last_turn = value
    end

    def self.parse(robot, str)
      return RestHandler.new robot, str, 0 unless str

      str = str.downcase
      type = str[0]
      rotation = Float(str[1..-1]) if str.length > 1

      skew = rotation || 0
      skew = MAX_SKEW * -1 if skew < MAX_SKEW * -1
      skew = MAX_SKEW      if skew > MAX_SKEW

      return MoveHandler.new(robot, str, MOVES[type], skew) if MOVES[type]
      return FireHandler.new(robot, str, skew) if type == 'f'
      return RotateHandler.new(robot, str, rotation) if type == 'r'
      RestHandler.new robot, str, skew
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
