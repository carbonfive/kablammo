class kablammo.Board
  constructor: (@parent, @args) ->
    @el = '.board'
    @viz = @createVisualization()
    @viz.addEventListener 'fire', @updateStats
    @viz.addEventListener 'turn', @updateTurns
    @viz.addEventListener 'gameOver', @gameOver

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

  updateStats: (turnIndex) =>
    board = @args[turnIndex].board
    _(board.robots).each (robot, i) ->
      stats = $("#stats-#{robot.identifier}")
      stats.find('.progress-bar').css 'width', "#{robot.armor * 20}%"
      ammos = stats.find('.ammo')
      ammos.find("li:lt(#{robot.ammo})").removeClass('ammo-empty').addClass('ammo-full')
      if robot.ammo == 0
        ammos.find("li").removeClass('ammo-full').addClass('ammo-empty')
      else
        ammos.find("li:gt(#{robot.ammo-1})").removeClass('ammo-full').addClass('ammo-empty')

  updateTurns: (turn) =>
    board = @args[turn.index].board
    _(board.robots).each (robot, i) ->
      turnsLog = $('.turns-log')
      turnsLogContainer = $('.turns-log-container')
      turnsLog.append("<tr><td>#{turn.index}</td><td>#{robot.username}</td><td>#{turn.turns[i].last_turn}</td></tr>")
      turnsLogContainer.scrollTop(turnsLogContainer[0].scrollHeight)

  gameOver: (turnIndex) =>
    robots = @args[turnIndex].board.robots
    dead = []
    alive = []
    _(robots).each (robot) ->
      if robot.armor <= 0
        dead.push robot
      else
        alive.push robot
    resultsBody = $('#results.modal .modal-body')
    if alive.length == 1
      resultsBody.append('<h1>Winner!</h1>')
    else
      resultsBody.append('<h1>Tie!</h1>')
    _(alive).each (robot, i) ->
      gravatar = $('#stats-' + robot.identifier + ' .gravatar')
      resultsBody.append('<h2><img class="gravatar" src="' + gravatar.attr('src') + '"> ' + robot.username + '</h2>')
    $('#results').modal('show')
    if $('body').hasClass('autoplay')
      setTimeout ( ->
        window.location = '/strategies'
      ), 5000

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
