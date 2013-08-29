require './app/models/geometry'

Pixel = Struct.new(:x, :y)
geometry = Geometry.new 16, 9
x = Integer(ARGV[0])
y = Integer(ARGV[1])
degrees = Float(ARGV[2])
puts geometry.line_of_sight(Pixel.new(x, y), degrees).map {|p| "#{p.x}, #{p.y}"}
