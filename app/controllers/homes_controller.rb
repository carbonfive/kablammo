class HomesController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def index
    @app.erb :'home/index'
  end

end
