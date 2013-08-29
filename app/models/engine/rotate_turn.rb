class Engine::RotateTurn < Engine::Turn
  attr_reader :rotation

  def initialize(rotation)
    @rotation = rotation
  end

  def execute
    tank.rotate_to @rotation
  end

end
