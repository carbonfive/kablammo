class kablammo.Board
  constructor: (@parent, @args) ->
    @el = '.board'
    $(@).on 'rendered', @onRendered

  $el: ->
    @parent.$el().find @el

  onRendered: =>
    @rendered += 1
    if @rendered == @args.squares.length
      $(@parent).trigger 'rendered'

  render: =>
    @rendered = 0
    @squares = ( new kablammo.Square(@, square) for square in @args.squares )
    square.render() for square in @squares

  fire: (lof, next) =>
    if lof.length == 0
      next() if next
      return

    sq = lof.shift()
    square = @squareFor sq[0], sq[1]
    square.fire()
    setTimeout =>
      square.unfire()
      @fire lof, next
    , 100

  alive_robots: ->
    isRobot = (square) -> ( square.args.state == 'robot' )
    toRobot = (square) -> square.robot
    isAlive = (robot) -> robot.alive()
    _.chain(@squares).filter(isRobot).map(toRobot).filter(isAlive).value()

  squareFor: (x, y) ->
    _(@squares).find (s) ->
      s.args.x == x && s.args.y == y
