class Geometry

  SLOP = 0.10
  POS = SLOP
  NEG = POS * -1

  def initialize(width, height)
    @width = width
    @height = height
  end

  def line_of_sight(source, degrees)
    degrees *= 1.0 # cast to float
    degrees %= 360 # normalize to 0...360 degrees
    radians = degrees * Math::PI / 180.0

    # steeper slopes require mapping the coordinate space
    steep = true if degrees.in?(45, 135, false) || degrees.in?(225, 315, false)

    # figure out if we're pointing forward or backward
    delta = POS if degrees.in?(0, 45) || degrees.in?(315, 360)
    delta = NEG if degrees.in?(135, 225)

    delta = POS if degrees.in?(45, 135, false)
    delta = NEG if degrees.in?(225, 315, false)

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

    #puts "line of sight: [#{source.x}, #{source.y}] @ #{degrees} -> " + los.join(' ')
    los
  end

  def direction_to(source, dest)
    x = dest.x - source.x
    y = dest.y - source.y
    radians = Math.atan( (y*1.0) / (x*1.0) )
    degrees = radians * 180 / Math::PI
    degrees += 180 if x < 0
    degrees % 360
  end

  def distance_to(source, dest)
    x = (dest.x - source.x).abs
    y = (dest.y - source.y).abs
    Math.sqrt(x*x + y*y)
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
    fractional < SLOP
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
