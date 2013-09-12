json.(battle, :id, :name)
json.board do
  json.turns battle.turns do |turn|
    json.board do
      json.(turn.board, :height, :width)
      json.robots turn.board.robots do |robot|
        json.(robot, :last_turn, :username, :x, :y, :rotation, :direction, :ammo, :armor, :abilities)
        json.fire do
          json.(robot.fire, :x, :y, :hit)
        end if robot.fire
        json.power_ups robot.power_ups do |power_up|
          json.(power_up, :name, :type, :duration)
        end
      end
      json.walls turn.board.walls do |wall|
        json.(wall, :x, :y)
      end
      json.power_ups turn.board.power_ups do |power_up|
        json.(power_up, :x, :y, :name, :type, :duration)
      end
    end
  end
end
