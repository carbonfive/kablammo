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
    $('#board').css { height: "#{@args.height * 70}px", width: "#{@args.width * 70}px" }
    kablammo.Visualization 'board', @args.width, @args.height, walls, robots

  createWalls: ->
    walls = []
    for w in @args.walls
      (walls[w.x] ||= [])[w.y] = true
    walls

  createRobots: ->
    _(@args.robots).map (robot) =>
      hash = robot.username.hashCode()
      {
        id: hash
        color: Math.abs(hash % 4)
        turns: _(robot.turns).map @toTurn
      }

  toTurn: (turn) =>
    turn.turretAngle = @convertToRadians(turn.rotation + 90)
    turn

  convertToRadians: (degrees) ->
    (degrees * Math.PI) / 180.0
