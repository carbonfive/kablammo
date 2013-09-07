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
      bot =
        id: hash
        color: hash % 4
        x: robot.start_x
        y: robot.start_y
        ammo: robot.ammo
        armor: robot.armor
        direction: 0
        bodyRotation: 0
        turretAngle: robot.rotation * Math.PI / 180.0
        turns: []

      first = { x: robot.start_x, y: robot.start_y, direction: 0, turretAngle: robot.rotation * Math.PI / 180.0 }
      bot.turns.push first
      for t in robot.turns
        last = _(bot.turns).last()
        bot.turns.push @nextTurn(t, last)
      bot

  nextTurn: (turn, last) =>
    str = turn.value
    action = str.slice 0, 1
    value = parseInt str.substr(1) if str.length > 1
    switch action
      when 'f' then @fireTurn last, value
      when 'r' then @rotateTurn last, value
      when 'n' then @moveNorthTurn last
      when 's' then @moveSouthTurn last
      when 'e' then @moveEastTurn last
      when 'w' then @moveWestTurn last
      else @restTurn last

  fireTurn: (last, value) ->
    _.chain(last).clone().extend({ fire: true }).value()

  rotateTurn: (last, value) ->
    _.chain(last).clone().extend({ fire: false, turretAngle: @convertAngle(value) }).value()

  moveNorthTurn: (last) ->
    _.chain(last).clone().extend({ fire: false, y: last.y + 1, direction: 2 }).value()

  moveSouthTurn: (last) ->
    _.chain(last).clone().extend({ fire: false, y: last.y - 1, direction: 0 }).value()

  moveEastTurn: (last) ->
    _.chain(last).clone().extend({ fire: false, x: last.x + 1, direction: 3 }).value()

  moveWestTurn: (last) ->
    _.chain(last).clone().extend({ fire: false, x: last.x - 1, direction: 1 }).value()

  restTurn: (last) ->
    _.chain(last).clone().extend({ fire: false }).value()

  convertAngle: (degrees) ->
    ((degrees + 90) * Math.PI) / 180.0
