class DocsController
  def initialize(app)
    @app = app
  end

  def request
    @app.request
  end

  def index
    @app.erb :'docs/index', locals: { active_nav: 'docs' }
  end

end
