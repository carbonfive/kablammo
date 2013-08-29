class Turn
  include MongoMapper::EmbeddedDocument

  key :value, String, required: true

  embedded_in :tank

  def line_of_fire
    handler = Engine::TurnHandler.parse @value
    handler.tank = self.tank

    return nil unless handler.is_a?(Engine::FireHandler)
    handler.line_of_fire.map {|s| [s.x, s.y]}
  end
end
