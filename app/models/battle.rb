class Battle
  include MongoMapper::Document

  key :name, String, required: true

  one :board

  def self.wage(args = {})
    board_args = args.delete :board

    battle = Battle.new(args)
    battle.board = Board.new(board_args)
    battle.save!
    battle
  end

  def prepare_for_battle!
    engine.prepare_for_battle!
    self
  end

  def find_by_id(id)
    self.find id
  end

  def engine
    @engine ||= Engine::Engine.instance(self)
  end

  def turn
    engine.turn if game_on?
  end

  def robots
    board.robots.sort_by(&:username)
  end

  def alive_robots
    robots.select(&:alive?)
  end

  def game_on?
    alive_robots.length >= 2
  end

  def game_over?
    !game_on?
  end

  def as_seen_by(robot)
    #t1 = Time.now
    hash = self.serializable_hash
    hide_robots hash, robot
    clear_turns hash, robot
    clear_ids hash
    #t2 = Time.now
    #puts "%.4f" % (t2-t1)
    hash
  end

  private

  def clear_ids(hash)
    hash.delete 'id'
    hash.each do |k, v|
      v.each { |h| clear_ids h } if v.is_a? Array
      clear_ids v if v.is_a? Hash
    end
  end

  def clear_turns(hash, robot)
    hash['board']['robots'].each do |robot_hash|
      robot_hash['turns'] = [ robot_hash['turns'].last ]
    end
  end

  def hide_robots(hash, robot)
    hash['board']['robots'].select! do |robot_hash|
      turn_hash = robot_hash['turns'].last
      robot.can_see? Pixel.new.at(turn_hash['x'], turn_hash['y'])
    end
  end
end
