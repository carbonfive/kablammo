class BattlesController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def default_board()
    Board.new({ width: 16,
      height: 9,
      walls: [[2,3],  [2,5],  [4, 4],
              [13,3], [13,5], [11,4],
              [6,1],  [7,1],  [8,1],  [9,1],
              [6,7],  [7,7],  [8,7],  [9,7]],
      starts: [[0,4], [15,4]]
    })
  end

  def random_darts(width, height, count, exclusions = [])
    darts = []
    while darts.length < count do 
      proposed = [Random.rand(width), Random.rand(height)]
      excluded = exclusions.include?(proposed) || darts.include?(proposed)
      darts.push proposed unless excluded
    end 
    darts 
  end

  def darts_board(width = 16, height = 9, seed = nil)
    Random.srand(seed) if seed

    walls = random_darts(width, height, 14)
    starts = random_darts(width, height, 2, walls)

    Board.new({ width: width,
      height: height,
      walls: walls,
      starts: starts})
  end

  def create()
    name = request['name'] || 'Battle Royale'

    battle = Battle.wage({ name: name, board: darts_board })

    board = battle.board
    robots = { mwynholds: 0, dhendee: 1 }
    robots.each { |robot, pos| board.add_robot new_robot(robot.to_s), pos }
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
