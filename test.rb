require './app/models/geometry'

geometry = Geometry.new 10, 10
x = Integer(ARGV[0])
y = Integer(ARGV[1])
degrees = Float(ARGV[2])
puts geometry.line_of_sight x, y, degrees
