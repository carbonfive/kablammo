class Battle

  SCORING = { tie: 1, win: 3, loss: -1 }


  include MongoMapper::Document

  key :name, String, required: true

  many :turns

  def self.wage(name, map, robots)
    battle = Battle.new name: name
    turn = Turn.new
    turn.board = Board.draw map, robots
    turn.save!
    battle.turns << turn
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

  def score
    survivors, losers = robots.partition(&:alive?)

    # if more than one survivor, survivors get a :tie score
    survivors_booty = (survivors.count > 1) ? SCORING[:tie] : SCORING[:win]
    Hash[ survivors.map(&:username).zip ([survivors_booty] * survivors.length) +
          losers.map(&:username).zip([SCORING[:loss]] * losers.length) ]
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
            json.(robot, :last_turn, :username, :x, :y, :rotation, :direction, :ammo, :armor, :abilities)
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
