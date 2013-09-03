class BattlesController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def create()
    name = request['name'] || 'Battle Royale'
    #robots = %w(mwynholds dhendee carbonfive)
    robots = %w(mwynholds dhendee)
    walls = 6
    battle = Battle.wage({ name: name, board: { height: 9, width: 16 } })

    board = battle.board
    walls.times { board.add_wall }
    robots.each { |robot| board.add_robot(new_robot robot) }
    battle.save!

    @app.redirect "/battles/#{battle.id}"
  end

  def show(id)
    battle = Battle.find_by_id id
    return [404, "Unknown battle: #{id}"] unless battle
    json = jbuilder :battle, locals: { battle: battle }
    erb :battle, locals: { battle: battle, json: json }
  end

  def turn(id, count=1)
    battle = Battle.find_by_id id
    1.upto(count) { battle.turn } if battle
    jbuilder :battle, locals: { battle: battle }
  end

  private

  def new_robot(name)
    robot = Robot.new
    robot.username = name
    robot
  end

  def erb(*args)
    @app.erb(*args)
  end

  def jbuilder(*args)
    @app.jbuilder(*args)
  end
end
