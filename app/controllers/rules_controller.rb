class RulesController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def index
    @app.erb :'rules/index', locals: { active_nav: 'rules' }
  end

end
