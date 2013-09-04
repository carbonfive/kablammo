class Square
  include MongoMapper::EmbeddedDocument

  key :x,     Integer, required: true
  key :y,     Integer, required: true
  key :state, String,  required: true, in: %w(empty wall robot), default: 'empty'

  embedded_in :board
  one :robot

  def place_wall
    @state = 'wall'
    self.robot = nil
  end

  def place_robot(robot)
    @state = 'robot'
    self.robot = robot
  end

  def clear
    @state = 'empty'
    self.robot = nil
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
