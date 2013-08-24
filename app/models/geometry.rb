class Geometry
  def initialize(height, width)
    @height = height
    @width = width
  end

  def line_of_sight(source, degrees)
    degrees *= 1.0 # cast to float
    degrees %= 360
    radians = degrees * Math::PI / 180.0

    # steeper slopes require mapping the coordinate space
    steep = true if degrees.in?(45, 135, false) || degrees.in?(225, 315, false)

    # figure out if we're pointing forward or backward
    delta = 0.01  if degrees.in?(0, 45) || degrees.in?(315, 360)
    delta = -0.01 if degrees.in?(135, 225)

    delta = 0.01  if degrees.in?(45, 135, false)
    delta = -0.01 if degrees.in?(225, 315, false)

    # each grid square is 1.0 x 1.0.  we measure from the middle
    offset_x = source.x + 0.5
    offset_y = source.y + 0.5

    x, y = 0, 0

    los = []
    while in_bounds?(x + offset_x, y + offset_y)
      if steep
        y += delta
        x = (1 / Math.tan(radians)) * y
      else
        x += delta
        y = Math.tan(radians) * x
      end
      add_to_line(los, x + offset_x, y + offset_y)
    end
    los.delete Pixel.new(source.x, source.y)

    puts "line of sight: [#{source.x}, #{source.y}] @ #{degrees} -> " + los.join(' ')

    los
  end

  def direction_to(source, dest)
    x = dest.x - source.x
    y = dest.y - source.y
    puts x
    puts y
    radians = Math.atan( (y*1.0) / (x*1.0) )
    degrees = radians * 180 / Math::PI
    degrees += 180 if x < 0
    degrees % 360
  end

  private

  def in_bounds?(x, y)
    return false if x < 0 || x > @width
    return false if y < 0 || y > @height
    true
  end

  def add_to_line(los, x, y)
    #puts "-> [#{x}, #{y}]"
    return unless in_bounds?(x, y)
    return if in_slop?(x) || in_slop?(y)
    pixel = Pixel.new(x.floor, y.floor)
    los << pixel unless los.include? pixel
  end

  def in_slop?(f)
    fractional = f - f.floor
    fractional < 0.05
  end
end

class Float
  def in?(s, e, inclusive = true)
    if inclusive
      self >= s && self <= e
    else
      self > s && self < e
    end
  end
end

Pixel = Struct.new(:x, :y) do
  def to_s
    "[#{x}, #{y}]"
  end
end
