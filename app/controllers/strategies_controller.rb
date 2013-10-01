class StrategiesController

  def initialize(app)
    @app = app
  end

  def index
    strategies = Strategy.all
    scoreboard = Battle.scoreboard
    strategies.sort_by!{ |s| (scoreboard[s.name] || -1000000) * -1 } # sort strategies, put nil last
    erb :'strategy/index', locals: { strategies: strategies, scoreboard: scoreboard, active_nav: 'robots' }
  end

  def pull(id)
    # make sure the repo is up to date
    strategy = Strategy.find(id)
    strategy.fetch_repo
    @app.redirect "/strategies/#{strategy.id}"
  end

  def create
    url = @app.request['github_url'].squish if @app.request['github_url']
    name = @app.request['name'].squish if @app.request['name']
    email = @app.request['email']

    if url.blank?
      @app.flash[:error] = "Your robot's program is loaded from GitHub. Where is your code?"
      @app.redirect '/strategies' and return
    end

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
    unless strategy
      @app.flash[:error] = "Unknown robot strategy: #{id}"
      @app.redirect '/strategies' and return
    end

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
