class Board
  include MongoMapper::EmbeddedDocument

  key :height, Integer, required: true
  key :width,  Integer, required: true

  many :walls
  many :robots
  many :power_ups
  embedded_in :battle

  def initialize(*args)
    walls = args[0].delete :walls
    super
    self.walls = walls.map { |w| Wall.new.at(w[0], w[1]) }
    self.robots = []
    self.power_ups = []
  end

  def geometry
    @geometry ||= Geometry.new(@width, @height)
  end

  def hittable(target)
    walls.detect { |w| w.located_at? target } || robots.detect { |r| r.located_at? target }
  end
  alias_method :hit?, :hittable
  alias_method :occupied?, :hittable

  def robot_at(target)
    robots.detect { |r| r.located_at? target }
  end
  alias_method :robot?, :robot_at

  def add_robot(robot)
    raise "Too many robots!" if robots.length == @starts.length
    start = @starts[robots.length]
    turn = Turn.new.at start[0], start[1]
    turn.value = '*'
    robot.turns << turn
    self.robots << robot
  end

  def add_power_up(power_up, x, y)
    self.power_ups << power_up.at(x, y)
  end

  def move_robot(robot, target)
    power_up = power_ups.detect { |p| p.located_at? target }
    if power_up
      power_ups.delete power_up
      power_up.x = nil
      power_up.y = nil
      robot.power_ups << power_up
      power_up.grant
    end

    robot.move_to target unless occupied? target
  end

  def line_of_sight(source, degrees)
    geometry.line_of_sight source, degrees
  end
end
