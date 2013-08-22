class FireTurn < Turn
  attr_reader :skew

  def initialize(skew)
    @skew = skew
  end

  def fire?
    true
  end
end
