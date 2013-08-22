class BoardsController
  def initialize(app)
    @app = app
  end

  def reset(name)
    board = Board.find_by_name name
    board.destroy if board

    board = Board.create({
      name: name,
      height: 10,
      width: 10
    })

    board.add_wall
    board.add_wall
    board.add_wall

    board.add_tank Tank.new
    board.add_tank Tank.new

    board.save!

    @app.redirect "/boards/#{name}"
  end

  def show(name)
    board = Board.find_by_name name
    return [404, "Unknown board: #{name}"] unless board
    erb :board, locals: { board: board }
  end

  def turn(name)
    board = Board.find_by_name name
    board.turn if board
    show name
  end

  private

  def erb(*args)
    @app.erb(*args)
  end

  def html(str)
    "<html><body>#{str}</body></html>"
  end
end
