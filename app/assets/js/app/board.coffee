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
        color: hash % 4
        x: 0
        y: 0
        ammo: 0
        armor: 0
        direction: 0
        bodyRotation: 0
        turretAngle: 0
        turns: _(robot.turns).map @toTurn
      }

  toTurn: (turn) =>
    turn.turretAngle = @convertToRadians(turn.rotation + 90)
    turn

  nextTurn: (turn, last) =>
    str = turn.value
    action = str.slice 0, 1
    value = parseInt str.substr(1) if str.length > 1
    switch action
      when 'f' then @fireTurn last, value, turn.hit
      when 'r' then @rotateTurn last, value
      when 'n' then @moveNorthTurn last
      when 's' then @moveSouthTurn last
      when 'e' then @moveEastTurn last
      when 'w' then @moveWestTurn last
      else @restTurn last

  fireTurn: (last, value, hit) ->
    angle = @convertToRadians(@convertToDegrees(last.turretAngle) + value)
    _.chain(last).clone().extend({ fire: hit, turretAngle: angle }).value()

  rotateTurn: (last, value) ->
    _.chain(last).clone().omit('fire').extend({ turretAngle: @convertToRadians(value + 90) }).value()

  moveNorthTurn: (last) ->
    _.chain(last).clone().omit('fire').extend({ y: last.y + 1, direction: 2 }).value()

  moveSouthTurn: (last) ->
    _.chain(last).clone().omit('fire').extend({ y: last.y - 1, direction: 0 }).value()

  moveEastTurn: (last) ->
    _.chain(last).clone().omit('fire').extend({ x: last.x + 1, direction: 3 }).value()

  moveWestTurn: (last) ->
    _.chain(last).clone().omit('fire').extend({ x: last.x - 1, direction: 1 }).value()

  restTurn: (last) ->
    _.chain(last).clone().omit('fire').value()

  convertToRadians: (degrees) ->
    (degrees * Math.PI) / 180.0

  convertToDegrees: (radians) ->
    (radians * 180.0) / Math.PI
