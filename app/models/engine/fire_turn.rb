class FireTurn < Turn
  attr_accessor :skew

  def initialize(skew)
    @skew = skew
  end

  def fire?
    true
  end
end
