class StrategiesController

  def initialize(app)
    @app = app
  end

  def index
    def histogram inp; hash = Hash.new(0); inp.each {|k,v| hash[k]+=1}; hash; end

    strategies = Strategy.all

    # compute wins/losses
    plays = Battle.all.map(&:board).flatten.map(&:robots).flatten.compact
    wins = histogram plays.select(&:alive?).map(&:username)
    losses = histogram plays.select(&:dead?).map(&:username)

    scoreboard = {}.tap do |scores|
      (wins.keys + losses.keys).flatten.compact.uniq.each do |k|
        scores[k] = {wins: wins[k].to_i, losses: losses[k].to_i}
      end
    end

    erb :'strategy/index', locals: { strategies: strategies, scoreboard: scoreboard }
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
