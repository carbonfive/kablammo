class BattlesController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def new()
    strategies = Strategy.all
    erb :"battle/new", locals: { strategies: strategies, active_nav: 'arena' }
  end

  def create()
    player_ids = [@app.request['player1'], @app.request['player2']].flatten.compact.uniq
    if player_ids.length < 2
      @app.redirect '/battles/new' and return # flash an error?
    end

    # get_players_from_request
    name = request['name'] || 'Battle Royale'
    map = Map.new({
      width: 9,
      height: 9,
      walls: [ [2,3], [2,5], [6,3], [6,5] ],
      starts: [ [0,4], [8,4] ],
    })
    player_names = player_ids.map{|player| activate_player(player)}
    robots = player_names.map { |n| Robot.new username: n }
    battle = Battle.wage name, map, robots

    ready = battle.prepare_for_battle! # wait for player processes to spawn up
    unless ready
      puts 'Players not prepared for battle'
      return [500, "Players not prepared"]
    end

    100.times { battle.turn }
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
