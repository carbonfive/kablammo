json.(battle, :id, :name)
json.board do
  json.(battle.board, :height, :width)
  json.squares battle.board.squares do |square|
    json.power_up do
      json.name square.power_up.name
      json.type square.power_up.type
    end if square.power_up?
    json.(square, :x, :y, :state)
    json.robot do
      json.(square.robot, :username, :rotation, :ammo, :armor)
      json.turns square.robot.turns do |turn|
        json.(turn, :value, :line_of_fire)
      end
    end if square.robot
  end
end
