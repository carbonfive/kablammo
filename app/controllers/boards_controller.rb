class BoardsController
  def initialize(app)
    @app = app
  end

  def reset(name)
    board = Board.find_by_name name
    board.destroy if board

    board = Board.create({
      name: name,
      height: 9,
      width: 16
    })

    6.times { board.add_wall }
    board.add_tank( new_tank 'mwynholds', (rand / 2 + 0.5) )
    board.add_tank( new_tank 'dhendee', (rand / 2) )
    board.save!

    @app.redirect "/boards/#{name}"
  end

  def show(name, play = false)
    board = Board.find_by_name name
    fires = board.get_last_fires
    return [404, "Unknown board: #{name}"] unless board
    erb :board, locals: { board: board, fires: fires, play: play }
  end

  def turn(name)
    board = Board.find_by_name name
    board.turn if board
    show name, false
  end

  def play(name)
    board = Board.find_by_name name
    board.turn if board
    show name, true
  end

  private

  def new_tank(name, agg)
    tank = Tank.new
    tank.username = name
    tank.agg = agg
    tank
  end

  def erb(*args)
    @app.erb(*args)
  end

  def html(str)
    "<html><body>#{str}</body></html>"
  end
end
