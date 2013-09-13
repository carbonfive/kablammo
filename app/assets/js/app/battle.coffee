@kablammo = {}
class @kablammo.Battle
  constructor: (@args) ->
    @el = '.battle'
    $('.buttons .turn').click @turn
    @$playstop = $('.buttons .playstop')
    @$playstop.click @playstop

  $el: ->
    $(@el)

  render: =>
    @board = new kablammo.Board(@, @args.turns)
    @board.render()

  turn: =>
    @board.turn()

  playstop: =>
    if @$playstop.text() == "Play"
      @play()
    else
      @stop()

  play: =>
    @board.play()
    @$playstop.text 'Stop'

  stop: =>
    @board.stop()
    @$playstop.text 'Play'
