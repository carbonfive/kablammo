json.(board, :name, :height, :width)
json.squares board.squares do |square|
  json.(square, :x, :y, :state)
  json.tank do
    json.(square.tank, :username, :rotation, :ammo, :armor)
    json.turns square.tank.turns do |turn|
      json.(turn, :value, :line_of_fire)
    end
  end if square.tank
end
