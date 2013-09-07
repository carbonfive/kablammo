class kablammo.Board
  constructor: (@parent, @args) ->
    @el = '.board'
    @viz = @createVisualization()

  $el: ->
    @parent.$el().find @el

  render: ->
    @viz.draw()

  play: ->
    @viz.play()

  createVisualization: ->
    walls = @createWalls()
    console.log walls
    robots = @createRobots()
    console.log robots
    $('#board').css { height: "#{@args.height * 70}px", width: "#{@args.width * 70}px" }
    kablammo.Visualization 'board', @args.width, @args.height, walls, robots

  createWalls: ->
    walls = []
    for square in @args.walls
      x = square.x
      y = square.y
      walls[x] ||= []
      walls[x][y] = true
    walls

  createRobots: ->
    count = -1
    console.log @args.robots
    _(@args.robots).map (robot) =>
      @last = { x: robot.x, y: robot.y, direction: 0, turretAngle: robot.rotation * Math.PI / 180.0 }
      count += 1
      {
        id: ((1<<30)*Math.random())
        color: count % 4
        x: robot.x
        y: robot.y
        ammo: robot.ammo
        armor: robot.armor
        direction: 0
        bodyRotation: 0
        turretAngle: robot.rotation * Math.PI / 180.0
        turns: _(robot.turns).map @toTurn
      }

  toTurn: (turn) =>
    str = turn.value
    action = str.slice 0, 1
    value = str.substr.to_i 1 if str.length > 1
    t = switch action
      when 'f' then @fireTurn value
      when 'r' then @rotateTurn value
      when 'n' then @moveNorthTurn()
      when 's' then @moveSouthTurn()
      when 'e' then @moveEastTurn()
      when 'w' then @moveWestTurn()
      else @restTurn()

  fireTurn: (value) ->
    _.chain(@last).clone().extend({ fire: true }).value()

  rotateTurn: (value) ->
    _(@last).extend { turretAngle: (value * Math.PI / 180.0) }

  moveNorthTurn: ->
    _(@last).extend { y: @last.y + 1, direction: 0 }

  moveSouthTurn: ->
    _(@last).extend { y: @last.y - 1, direction: 1 }

  moveEastTurn: ->
    _(@last).extend { x: @last.x + 1, direction: 2 }

  moveWestTurn: ->
    _(@last).extend { x: @last.x - 1, direction: 3 }

  restTurn: ->
    @last
