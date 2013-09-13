class kablammo.Board
  constructor: (@parent, @args) ->
    @el = '.board'
    @viz = @createVisualization()

  $el: ->
    @parent.$el().find @el

  render: ->
    @viz.play()

  play: ->
    @viz.play()

  stop: ->
    @viz.stop()

  createVisualization: ->
    walls = @createWalls()
    robots = @createRobots()
    console.log robots
    board = @firstBoard()
    $('#board').css { height: "#{board.height * 83}px", width: "#{board.width * 83}px" }
    kablammo.Visualization 'board', board.width, board.height, walls, robots

  createWalls: ->
    walls = []
    for w in @firstBoard().walls
      (walls[w.x] ||= [])[w.y] = true
    walls

  createRobots: ->
    robots = @firstBoard().robots
    _(robots).map (robot) =>
      hash = robot.username.hashCode()
      {
        id: hash
        color: Math.abs(hash % 4)
        turns: _(@args).map (turn) =>
          @toTurn turn, robot
      }

  toTurn: (turn, robot) =>
    t = _(turn.board.robots).find (r) -> r.username == robot.username
    t.turretAngle = @convertToRadians(t.rotation + 90)
    t

  firstBoard: =>
    _(@args).first().board

  convertToRadians: (degrees) ->
    (degrees * Math.PI) / 180.0
