class Battle
  SCORING = {
    tie: 1,
    win: 3,
    loss: -1
  }

  include MongoMapper::Document

  key :name, String, required: true

  many :board

  def self.wage(name, map, robots)
    battle = Battle.new name: name
    battle.board = Board.draw map, robots
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

  def score
    players = board.robots.flatten.compact
    if players.all?(&:alive?)
      # tie
      Hash[players.map(&:username).zip (players.count.times.map{SCORING[:tie]})]
    else
      results = {}
      alive, dead = robots.partition(&:alive?)
      alive.each do |r|
        results[r.username] = SCORING[:win]
      end
      dead.each do |r|
        results[r.username] = SCORING[:loss]
      end
      results
    end
  end

  def engine
    @engine ||= Engine::Engine.instance(self)
  end

  def turn
    engine.turn! if game_on?
  end

  def current_board
    boards.last
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
      json.board do
        json.(current_board, :width, :height)
        visible_robots = current_board.robots.select { |robot| the_robot.can_see? robot }
        json.robots visible_robots do |robot|
          json.(robot, :username)
          json.power_ups robot.power_ups do |power_up|
            json.(power_up, :name, :type, :duration)
          end
          json.turns [robot.turns.last] do |turn|
            json.(turn, :value, :x, :y, :rotation, :direction, :ammo, :armor, :abilities)
            json.fire do
              json.(turn.fire, :x, :y, :hit) if turn.fire
            end
          end
        end
        json.walls board.walls do |wall|
          json.(wall, :x, :y)
        end
        json.power_ups board.power_ups do |power_up|
          json.(power_up, :x, :y, :name, :type, :duration)
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
