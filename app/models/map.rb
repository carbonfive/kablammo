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

  def self.for_name(name)
    @maps = create_maps unless @maps
    @maps.detect { |m| m.name == name }
  end

  def self.create_maps
    template = { width: 9, height: 9,
                 starts: [ [0,4,0], [8,4,180], [4,0,90], [4,8,270] ].map { |s| Start.new(*s) } }

    [
      MapMaker.map("Battle Royale", [
        "____4____",
        "_________",
        "_________",
        "_________",
        "1_______2",
        "_________",
        "_________",
        "_________",
        "____3____",
      ]),
      MapMaker.make("Balanced Team", [
        "____4____",
        "_________",
        "_________",
        "__x___x__",
        "1_x___x_2",
        "__x___x__",
        "_________",
        "_________",
        "____3____",
      ]),
      MapMaker.make("Decoupled Objects", [
        "x___4___x",
        "_________",
        "__x___x__",
        "_________",
        "1___x___2",
        "_________",
        "__x___x__",
        "_________",
        "x___3___x",
      ]),
      MapMaker.make("KISS", [
        "____4____",
        "_________",
        "_________",
        "_________",
        "1___x___2",
        "_________",
        "_________",
        "_________",
        "____3____",
      ]),
      MapMaker.make("NASCAR", [
        "xx__4__xx",
        "x_______x",
        "____x____",
        "___xxx___",
        "1_xxxxx_2",
        "___xxx___",
        "____x____",
        "x_______x",
        "xx__3__xx",
      ]),
      MapMaker.make("Gladiator Pit", [
        "__x_4_x__",
        "_________",
        "x_x_x_x_x",
        "_________",
        "1_x___x_2",
        "_________",
        "x_x_x_x_x",
        "_________",
        "__x_3_x__",
      ]),
    ]
  end
end
