module Engine
  class RestHandler < TurnHandler

    def execute
      robot.rest
    end

  end
end
