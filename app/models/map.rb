class Map
  attr_accessor :width, :height, :walls, :starts, :name

  def initialize(args)
    @width = args[:width]
    @height = args[:height]
    @walls = args[:walls]
    @starts = args[:starts]
    @name = args[:name]
  end

  def self.random
    @maps = create_maps unless @maps
    @maps[rand(@maps.length)]
  end

  def self.create_maps
    template = { width: 9, height: 9,
                 starts: [ [0,4,0], [8,4,180], [4,0,90], [4,8,270] ].map { |s| Start.new(*s) } }

    maps = Array.new
    maps << Map.new({ name: 'Battle Royale' }.merge(template))
    maps << Map.new({
      walls: [ [2,3], [2,4], [2,5], [6,3], [6,4], [6,5] ].map {|w| Wall.new.at(*w) },
      name: 'Balanced Team'
    }.merge(template))
    maps << Map.new({
      walls: [ [0,0], [8,0], [2,2], [2,6], [4,4], [6,2], [6,6], [0,8], [8,8] ].map {|w| Wall.new.at(*w) },
      name: 'Decoupled Objects'
    }.merge(template))
    maps << Map.new({
      walls: [ [4,4] ].map {|w| Wall.new.at(*w) },
      name: 'KISS'
    }.merge(template))
    maps << Map.new({
      walls: [ [0,0], [1,0], [7,0], [8,0],
               [0,1], [8,1],
               [4,2],
               [3,3], [4,3], [5,3],
               [2,4], [3,4], [4,4], [5,4], [6,4],
               [3,5], [4,5], [5,5],
               [4,6],
               [0,7], [8,7],
               [0,8], [1,8], [7,8], [8,8] ].map {|w| Wall.new.at(*w) },
      name: 'NASCAR'
    }.merge(template))
    maps << Map.new({
      walls: [ [2,0], [6,0],
               [0,2], [2,2], [4,2], [6,2], [8,2],
               [2,4], [6,4],
               [0,6], [2,6], [4,6], [6,6], [8,6],
               [2,8], [6,8] ].map {|w| Wall.new.at(*w) },
      name: 'Gladiator Pit'
    }.merge(template))
    maps
  end
end
