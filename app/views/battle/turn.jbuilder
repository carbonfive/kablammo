json.(battle, :id, :name)
json.board do
  json.(battle.board, :height, :width)

  json.robots battle.board.robots do |robot|
    json.(robot, :username, :x, :y, :start_x, :start_y, :rotation, :ammo, :armor)
    json.power_ups robot.power_ups do |power_up|
      json.(power_up, :name, :type, :duration)
    end
    json.turns robot.turns do |turn|
      json.(turn, :value)
    end
  end

  json.walls battle.board.walls do |wall|
    json.(wall, :x, :y)
  end

  json.power_ups battle.board.power_ups do |power_up|
    json.(power_up, :x, :y, :name, :type, :duration)
  end
end
