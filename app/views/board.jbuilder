json.(board, :name, :height, :width)
json.squares board.squares do |square|
  json.(square, :x, :y, :state)
  json.tank do
    json.(square.tank, :username, :rotation, :ammo, :armor, :last_turn)
    json.last_fire square.tank.last_fire
  end if square.tank
end
