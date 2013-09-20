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
    ids = Array.new
    (1..4).each do |i|
      unless (@app.request["player#{i}"].nil? || @app.request["player#{i}"].empty?)
        ids << @app.request["player#{i}"]
      end
    end
    ids = ids.flatten.compact.uniq
    if ids.length < 2
      @app.flash[:error] = 'You must select at least two robots to battle.'
      @app.redirect '/battles/new' and return
    end

    strategies = activate_strategies ids

    map = Map.random
    robots = strategies.map { |s| Robot.new username: s.name }
    battle = Battle.wage map, robots

    ready = battle.prepare_for_battle! # wait for player processes to spawn up
    unless ready
      puts 'Players not prepared for battle'
      return [500, "Players not prepared"]
    end

    puts "Let the battle begin!"
    100.times do
      battle.turn!
    end
    battle.save!
    battle.finish!

    strategies.each { |s| s.kill }
    outcome = battle.robots.map { |r| "#{r.username}: #{r.armor} armor" }.join(', ')
    puts "Battle complete - #{outcome}"

    @app.redirect "/battles/#{battle.id}"
  end

  def show(id)
    battle = Battle.find_by_id id
    return [404, "Unknown battle: #{id}"] unless battle
    json = jbuilder :"battle/show", locals: { battle: battle }
    erb :"battle/show", locals: { battle: battle, json: json, active_nav: 'arena', scoreboard: Battle.scoreboard }
  end

  def turn(id, count=1)
    battle = Battle.find_by_id id
    1.upto(count) { battle.turn } if battle
    jbuilder :"battle/turn", locals: { battle: battle }
  end

  def autoplay(toggle)
    @app.session[:autoplay] = toggle
    @app.redirect "/battles/new"
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

  def activate_strategies(ids)
    strategies = Hash[ ids.map { |id| [id, Strategy.find(id)] } ]
    strategies.each { |id, s| raise "Missing strategy: #{id}" unless s }
    strategies.each { |id, s| s.fetch_repo }
    strategies.each { |id, s| s.launch }
    strategies.values
  end
end
