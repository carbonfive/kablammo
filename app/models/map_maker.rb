module MapMaker
  def self.make(name, map, rotations = {
    1 => 0,
    2 => 180,
    3 => 90,
    4 => 270
  })
    width = map[0].length
    height = map.length

    # 0, 0 is at the bottom of the map, not the top.
    map = map.reverse

    walls = map_to_walls(map)
    starts = map_to_starts(map, rotations)

    Map.new({
      width: width,
      height: height,
      name: name,
      walls: walls,
      starts: starts
    })
  end

  def self.map_to_walls(map)
    walls = []

    each_cell(map) do |cell, x, y|
      next unless cell == "x"
      wall = Wall.new({x: x, y: y})
      walls.push(wall)
    end

    walls
  end

  def self.map_to_starts(map, rotations)
    starts = {}
    each_cell(map) do |cell, x, y|
      next unless cell =~ /[0-9]/

      player_number = cell.to_i
      rotation = rotations[player_number]

      start = Start.new(x, y, rotation)
      starts[player_number] = start
    end
    
    starts
      .sort_by { |n, start| n }
      .map { |n, start| start}
  end

  def self.each_cell(map, &block)
    map.reverse.each_with_index do |row, y|
      row.chars.to_a.each_with_index do |cell, x|
        block.call(cell, x, y)
      end
    end
  end
end
