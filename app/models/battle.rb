class Battle

  include MongoMapper::Document

  key :name,      String, required: true
  key :usernames, Array,  required: true
  timestamps!

  many :turns, order: :created_at

  def self.wage(map, robots)
    battle = Battle.new name: map.name, usernames: robots.map(&:username)
    turn = Turn.new
    turn.board = Board.draw map, robots
    turn.save!
    battle.turns << turn
    battle.save!
    battle
  end

  def self.for_strategy(strategy)
    Battle.where(usernames: strategy.name).all
  end

  def self.scoreboard
    query = [
      { '$group' => { '_id' => '$battle_id', 'board' => { '$last' => '$board' } } },
      { '$project' => { 'robots' => '$board.robots' } },
      { '$unwind' => '$robots' },
      { '$project' => { 'username' => '$robots.username', 'armor' => '$robots.armor' } },
      { '$group' => { '_id' => '$_id', 'usernames' => { '$push' => '$username' }, 'armors' => { '$push' => '$armor' } } }
    ]
    scores = Turn.collection.aggregate query
    scoreboard = {}
    scores.each do |score|
      armors = score['armors']
      # 1pt for TIE, 3pts for WIN
      pts = ( armors.count { |a| a > 0 } ) > 1 ? 1 : 3
      armors.each_with_index do |a, i|
        username = score['usernames'][i]
        scoreboard[username] ||= 0
        scoreboard[username] += pts if a > 0
      end
    end
    scoreboard
  end

  def prepare_for_battle!
    engine.prepare_for_battle!
    self
  end

  def finish!
    engine.finish!
  end

  def engine
    @engine ||= Engine::Engine.instance(self)
  end

  def turn!
    engine.turn! if game_on?
  end

  def current_turn
    turns[turns.length - 1]
  end

  def current_board
    current_turn.board
  end

  def robots
    current_board.robots.sort_by(&:username)
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
    JsonValue.new jbuild(robot)
  end

  private

  def jbuild(the_robot)
    Jbuilder.encode do |json|
      json.(self, :name)
      json.turn do
        turn = current_turn
        json.board do
          json.(turn.board, :width, :height)
          visible_robots = turn.board.robots.select { |robot| the_robot.can_see? robot }
          json.robots visible_robots do |robot|
            json.(robot, :last_turn, :username, :x, :y, :rotation, :ammo, :armor, :abilities)
            json.fire do
              json.(robot.fire, :x, :y, :hit)
            end if robot.fire
            json.power_ups robot.power_ups do |power_up|
              json.(power_up, :name, :type, :duration)
            end
          end
          json.walls turn.board.walls do |wall|
            json.(wall, :x, :y)
          end
          json.power_ups turn.board.power_ups do |power_up|
            json.(power_up, :x, :y, :name, :type, :duration)
          end
        end
      end
    end
  end
end

class JsonValue
  def initialize(value)
    @value = value
  end

  def to_json
    @value
  end
end
