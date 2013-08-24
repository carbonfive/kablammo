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
    2.times { |i| board.add_tank new_tank("#{i}") }
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

  def new_tank(name)
    tank = Tank.new
    tank.username = name
    tank
  end

  def erb(*args)
    @app.erb(*args)
  end

  def html(str)
    "<html><body>#{str}</body></html>"
  end
end
