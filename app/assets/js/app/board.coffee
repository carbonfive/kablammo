class @kablammo.Board
  constructor: (@args, @fires, @play) ->
    @el = '.board'
    @squares = ( new kablammo.Square(@, square) for square in @args.squares )

  $el: ->
    $(@el)

  render: ->
    square.render() for square in @squares

    count = 0
    next = =>
      return if ! @play
      count += 1
      @turn() if count == @fires.length

    @turn() if @play && @fires.length == 0
    @fire(lof, next) for lof in @fires

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

  turn: ->
    setTimeout ->
      window.location.reload()
    , 250

  squareFor: (x, y) ->
    _(@squares).find (s) ->
      s.args.x == x && s.args.y == y
