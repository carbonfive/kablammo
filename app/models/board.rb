class Board
  include MongoMapper::EmbeddedDocument

  key :height, Integer, required: true
  key :width,  Integer, required: true

  many :walls
  many :robots
  many :power_ups

  embedded_in :turn

  def self.draw(map, robots)
    raise "Too many robots!" if map.starts.length < robots.length
    board = Board.new width: map.width, height: map.height
    board.walls = map.walls
    robots.each_with_index { |r, i| board.add_robot(r, map.starts[i]) }
    board
  end

  def initialize(*args)
    self.walls = []
    self.robots = []
    self.power_ups = []
    super
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

  def in_bounds?(target)
    return false if target.x < 0 || target.x >= width
    return false if target.y < 0 || target.y >= height
    true
  end

  def add_robot(robot, start)
    r = robot.at start.position.x, start.position.y
    r.rotation = start.rotation
    self.robots << r
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

  def doppel
    doppelize = Proc.new { |o| o.doppel }
    walls = self.walls.map( &doppelize )
    robots = self.robots.map( &doppelize )
    power_ups = self.power_ups.map( &doppelize )
    Board.new width: width, height: height, walls: walls, robots: robots, power_ups: power_ups
  end
end
