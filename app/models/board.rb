class Board
  include MongoMapper::EmbeddedDocument

  key :height, Integer, required: true
  key :width,  Integer, required: true

  many :walls
  many :robots
  many :power_ups
  embedded_in :battle

  def initialize(*args)
    super
    self.walls = []
    self.robots = []
    self.power_ups = []
  end

  def geometry
    @geometry ||= Geometry.new(@width, @height)
  end

  def square_at(x, y)
    return nil if x < 0 || x >= @width
    return nil if y < 0 || y >= @height
    squares[@width * y + x]
  end

  def hittable(target)
    walls.detect { |w| w.located_at? target } || robots.detect { |r| r.located_at? target }
  end
  alias_method :hit?, :hittable

  def add_wall(x, y)
    self.walls << Wall.new.at(x, y)
  end

  def add_robot(robot, x, y)
    self.robots << robot.at(x, y)
  end

  def add_power_up(power_up, x, y)
    self.power_ups << power_up.at(x, y)
  end

  def line_of_sight(source, degrees)
    los = geometry.line_of_sight source, degrees
    los
    #los.map { |p| square_at(p.x, p.y) }
  end

  def as_seen_by(robot)
    board = self.dup
    board.robots = self.robots.select { |r| robot.can_see? r }
    board
  end
end
