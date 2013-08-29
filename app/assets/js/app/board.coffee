class @kablammo.Board
  constructor: (@args) ->
    @el = '.board'
    @playing = false
    $('.buttons .turn').click @turn
    $('.buttons .play').click @play

  $el: ->
    $(@el)

  render: =>
    @squares = ( new kablammo.Square(@, square) for square in @args.squares )

    rendered = 0
    $(@).on 'rendered', (child) ->
      rendered += 1
      if rendered == @squares.length
        @turn() if @playing

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

  turn: (event) =>
    alive_tanks = _(@squares).filter (s) ->
      s.args.state == 'tank' && s.tank.args.armor >= 0
    game_on = alive_tanks.length >= 2
    return unless game_on

    done = (data, status, xhr) =>
      @args = $.parseJSON data
      @render()

    fail = (xhr, status, error) ->
      console.log status

    $.post("/boards/#{@args.name}/turn.json")
      .done(done)
      .fail()

  play: =>
    if @playing
      $('.buttons .play').text 'Play'
      @playing = false
    else
      $('.buttons .play').text 'Stop'
      @playing = true
      @turn()

  stop: =>
    @playing = false

  squareFor: (x, y) ->
    _(@squares).find (s) ->
      s.args.x == x && s.args.y == y
