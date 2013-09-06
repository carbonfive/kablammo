json.(battle, :id, :name)
json.board do
  json.(battle.board, :height, :width)
  json.squares battle.board.squares do |square|
    json.power_up do
      json.(square.power_up, :name, :type, :duration)
    end if square.power_up?
    json.(square, :x, :y, :state)
    json.robot do
      json.(square.robot, :username, :rotation, :ammo, :armor)
      json.turns square.robot.turns do |turn|
        json.(turn, :value, :line_of_fire)
      end
      json.power_ups square.robot.power_ups do |power_up|
        json.(power_up, :name, :type, :duration)
      end if ! square.robot.power_ups.empty?
    end if square.robot
  end
end
