class StrategiesController

  def initialize(app)
    @app = app
  end

  def index
    strategies = Strategy.all
    erb :'strategy/index', locals: { strategies: strategies }
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
      erb :"strategy/new", locals: { strategy: strategy }
    else
      @app.redirect "/strategies/#{strategy.id}"
    end
  end

  def show(id)
    strategy = Strategy.find(id)
    erb :'strategy/show', locals: { strategy: strategy }
  end

  def new
    strategy = Strategy.new
    erb :"strategy/new", locals: { strategy: strategy }
  end

  def erb(*args)
    @app.erb(*args)
  end

end
