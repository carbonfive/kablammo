class StrategiesController

  def initialize(app)
    @app = app
  end

  def index
    strategies = Strategy.all

    # compute wins/losses
    t = Time.now.to_f
    scoreboard = Hash[ strategies.map {|s| [s.id, s.score]} ]
    puts "StrategiesController spent %0.3f ms to compute scoreboard" % (Time.now - t.to_f)

    # sort strategies by score
    strategies.sort_by!{ |s| -scoreboard[s.id] || 1000000 } # put nil last
    erb :'strategy/index', locals: { strategies: strategies, scoreboard: scoreboard, active_nav: 'robots' }
  end

  def pull(id)
    # make sure the repo is up to date
    strategy = Strategy.find(id)
    strategy.fetch_repo bundle_update: true
    @app.redirect "/strategies/#{strategy.id}"
  end

  def create
    url = @app.request['github_url']
    name = @app.request['name']
    email = @app.request['email']

    if Strategy.count(name: name) > 0
      @app.flash[:error] = 'Your name must be unique.  Is your robot here?'
      @app.redirect '/strategies' and return
    end

    strategy = Strategy.create github_url: url, name: name, email: email
    if strategy.errors.any?
      puts "Found errors", strategy.errors.full_messages
      erb :"strategy/new", locals: { strategy: strategy, active_nav: 'robots' }
    else
      @app.redirect "/strategies/#{strategy.id}"
    end
  end

  def show(id)
    strategy = Strategy.find(id)
    strategy.fetch_repo unless strategy.repo_exists?
    erb :'strategy/show', locals: { strategy: strategy, active_nav: 'robots' }
  end

  def new
    strategy = Strategy.new
    erb :"strategy/new", locals: { strategy: strategy, active_nav: 'robots' }
  end

  def erb(*args)
    @app.erb(*args)
  end

end
