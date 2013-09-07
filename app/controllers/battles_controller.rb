class BattlesController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def new()
    strategies = Strategy.all
    erb :"battle/new", locals: { strategies: strategies }
  end

  def create()
    player_ids = [@app.request['player1'], @app.request['player2']].flatten.compact.uniq
    if player_ids.length < 2
      @app.redirect '/battles/new' and return # flash an error?
    end

    # get_players_from_request
    name = request['name'] || 'Battle Royale'

    player_names = player_ids.map{|player| activate_player(player)}

    #robots = Hash[player_names.zip([[0,4], [15,4]])]
    #walls = [ [2,3],  [2,5],  [4, 4],
             #[13,3], [13,5], [11,4],
             #[6,1],  [7,1],  [8,1],  [9,1],
             #[6,7],  [7,7],  [8,7],  [9,7] ]
    #battle = Battle.wage({ name: name, board: { height: 9, width: 16 } })

    robots = Hash[player_names.zip([[0,2], [4,2]])]
    walls = [[2, 2]]
    battle = Battle.wage({ name: name, board: { height: 5, width: 5 } })

    board = battle.board
    walls.each { |pos| board.add_wall pos[0], pos[1] }
    robots.each { |robot, pos| board.add_robot new_robot(robot.to_s), pos[0], pos[1] }
    #board.add_power_up new_power_up, 0, 0
    30.times { battle.turn }
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
    Robot.new username: name
  end

  def new_power_up
    PowerUp.instance :golden_bullet
  end

  def erb(*args)
    @app.erb(*args)
  end

  def jbuilder(*args)
    @app.jbuilder(*args)
  end

  def activate_player(id)
    s = Strategy.find(id)
    if s
      s.launch
      s.username
    else
      # this is to handle dhendee/mwynholds manual launch
      id
    end
  end
end
