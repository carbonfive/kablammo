class StrategiesController

  def initialize(app)
    @app = app
  end

  def index
    strategies = Strategy.all

    # compute wins/losses
    t = Time.now.to_f
    scoreboard = Hash[ strategies.map {|s| [s.username, s.score]} ]
    puts "StrategiesController spent %0.3f ms to compute scoreboard" % (Time.now - t.to_f)

    # sort strategies by score
    strategies.sort_by!{ |s| -scoreboard[s.username] || 1000000 } # put nil last
    erb :'strategy/index', locals: { strategies: strategies, scoreboard: scoreboard, active_nav: 'robots' }
  end

  def pull(id)
    # make sure the repo is up to date
    strategy = Strategy.find(id)
    strategy.clone_repo
    @app.redirect "/strategies/#{strategy.id}"
  end

  def create
    url = @app.request['github_url']
    # given a github repo, clone it locally
    strategy = Strategy.find_or_create_by_url(url)
    if strategy.errors.any?
      puts "Found errors", strategy.errors.full_messages
      erb :"strategy/new", locals: { strategy: strategy, active_nav: 'robots' }
    else
      @app.redirect "/strategies/#{strategy.id}"
    end
  end

  def show(id)
    strategy = Strategy.find(id)
    strategy.clone_repo unless strategy.repo_exists?
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
