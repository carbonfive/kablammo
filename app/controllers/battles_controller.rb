class BattlesController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def create()
    name = request['name'] || 'Battle Royale'
    robots = { mwynholds: [0,4], dhendee: [15,4] }
    walls = [ [2,3],  [2,5],  [4, 4],
              [13,3], [13,5], [11,4],
              [6,1],  [7,1],  [8,1],  [9,1],
              [6,7],  [7,7],  [8,7],  [9,7] ]
    battle = Battle.wage({ name: name, board: { height: 9, width: 16 } })

    board = battle.board
    walls.each { |pos| board.add_wall pos[0], pos[1] }
    robots.each { |robot, pos| board.add_robot new_robot(robot.to_s), pos[0], pos[1] }
    battle.save!

    @app.redirect "/battles/#{battle.id}"
  end

  def show(id)
    battle = Battle.find_by_id id
    return [404, "Unknown battle: #{id}"] unless battle
    json = jbuilder :"battle/turn", locals: { battle: battle }
    erb :"battle/show", locals: { battle: battle, json: json }
  end

  def turn(id, count=1)
    battle = Battle.find_by_id id
    1.upto(count) { battle.turn } if battle
    jbuilder :"battle/turn", locals: { battle: battle }
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
