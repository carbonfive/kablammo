class Square
  include MongoMapper::EmbeddedDocument

  key :x,     Integer, required: true
  key :y,     Integer, required: true
  key :state, String,  required: true, in: %w(empty wall robot power_up), default: 'empty'

  embedded_in :board
  one :robot
  one :power_up

  def place_wall
    @state = 'wall'
    self.robot = nil
  end

  def place_robot(robot)
    @state = 'robot'
    self.robot = robot
  end

  def place_power_up(power_up)
    @state = 'power_up'
    self.power_up = power_up
  end

  def clear
    @state = 'empty'
    self.robot = nil
    self.power_up = nil
  end

  def empty?
    @state == 'empty'
  end

  def robot?
    @state == 'robot'
  end

  def wall?
    @state == 'wall'
  end

  def power_up?
    @state == 'power_up'
  end

  def as_seen_by(robot)
    square = self.dup
    return square if square.wall?
    unless robot.can_see?(self)
      square.state = 'obscured'
      square.robot = nil
    end
    square.robot = self.robot.as_seen_by(robot) if square.robot
    square
  end

  def position
    "[#{@x}, #{@y}]"
  end
end
