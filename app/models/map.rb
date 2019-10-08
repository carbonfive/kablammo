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
    [
      MapMaker.make("Battle Royale", [
        "____3____",
        "_________",
        "_________",
        "_________",
        "1_______2",
        "_________",
        "_________",
        "_________",
        "____4____",
      ]),
      MapMaker.make("Balanced Team", [
        "____3____",
        "_________",
        "_________",
        "__x___x__",
        "1_x___x_2",
        "__x___x__",
        "_________",
        "_________",
        "____4____",
      ]),
      MapMaker.make("Decoupled Objects", [
        "x___3___x",
        "_________",
        "__x___x__",
        "_________",
        "1___x___2",
        "_________",
        "__x___x__",
        "_________",
        "x___4___x",
      ]),
      MapMaker.make("KISS", [
        "____3____",
        "_________",
        "_________",
        "_________",
        "1___x___2",
        "_________",
        "_________",
        "_________",
        "____4____",
      ]),
      MapMaker.make("NASCAR", [
        "xx__3__xx",
        "x_______x",
        "____x____",
        "___xxx___",
        "1_xxxxx_2",
        "___xxx___",
        "____x____",
        "x_______x",
        "xx__4__xx",
      ]),
      MapMaker.make("Gladiator Pit", [
        "__x_3_x__",
        "_________",
        "x_x_x_x_x",
        "_________",
        "1_x___x_2",
        "_________",
        "x_x_x_x_x",
        "_________",
        "__x_4_x__",
      ]),
      MapMaker.make("X Marks The Spot", [
        "x_____3_____x",
        "_____________",
        "__x_______x__",
        "_____________",
        "____x___x____",
        "_____________",
        "1_____x_____2",
        "_____________",
        "____x___x____",
        "_____________",
        "__x_______x__",
        "_____________",
        "x_____4_____x",
      ]),
      MapMaker.make("Carbon Five", [
        "_____xxx_____",
        "____x_3_x____",
        "___x_____x___",
        "__x_______x__",
        "_x___xxxxxxx_",
        "x___________x",
        "x1_________2x",
        "x___________x",
        "_xx__xxx___x_",
        "__xx_____xx__",
        "____xx4xx____",
        "_____xxx_____",
        "______x______",
      ]),
      MapMaker.make("Duel", [
        "x__1__x__3__x",
        "x_____x_____x",
        "x_____x_____x",
        "x_____x_____x",
        "x___________x",
        "x_____x_____x",
        "x___________x",
        "x_____x_____x",
        "x___________x",
        "x_____x_____x",
        "x_____x_____x",
        "x_____x_____x",
        "x__2__x__4__x",
      ], {
        1 => 270,
        2 => 90,
        3 => 270,
        4 => 90,
      })
    ]
  end
end
