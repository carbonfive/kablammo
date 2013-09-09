class Turn
  include MongoMapper::EmbeddedDocument

  key :value, String, required: true

  embedded_in :robot

  def hit
    handler = Engine::TurnHandler.parse self.robot, @value

    return nil unless handler.is_a?(Engine::FireHandler)
    lof = handler.line_of_fire
    robot.board.hit?(lof.last) ? [lof.last.x, lof.last.y] : nil
  end
end
