class Turn

  def self.parse(str)
    str = str.downcase
    return MoveTurn.new('north') if str == 'n'
    return MoveTurn.new('south') if str == 's'
    return MoveTurn.new('east')  if str == 'e'
    return MoveTurn.new('west')  if str == 'w'
    return RestTurn.new
  end

  def move?
    false
  end

  def turn?
    false
  end
end
