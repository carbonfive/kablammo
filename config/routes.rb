class KablammoServer < Sinatra::Base
  set :views, Proc.new { File.join(root, 'app/views') }

  get '/battles/new' do
    BattlesController.new(self).new
  end

  post '/battles/' do
    BattlesController.new(self).create
  end

  get '/battles/:id' do |id|
    BattlesController.new(self).show id
  end

  post '/battles/:id/turn.json' do |id|
    BattlesController.new(self).turn id, 1
  end

  post '/battles/:id/turn/:count.json' do |id, count|
    BattlesController.new(self).turn id, count.to_i
  end

  #post '/strategies/:id' #  update

  get '/strategies' do
    StrategiesController.new(self).index
  end

  # create
  post '/strategies' do
    StrategiesController.new(self).create
  end

  get '/strategies/new' do
    StrategiesController.new(self).new
  end

  get '/strategies/:id' do |id|
    StrategiesController.new(self).show id
  end

  get '/strategies/:id/pull' do |id|
    StrategiesController.new(self).pull id
  end

  run! if app_file == $0

end
