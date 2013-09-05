class @kablammo.Battle
  constructor: (@args) ->
    @el = '.battle'
    @playing = false
    $(@).on 'rendered', @onRendered
    $('.buttons .turn').click @turn
    $('.buttons .play').click @play

  $el: ->
    $(@el)

  onRendered: =>
    setTimeout =>
      @turn() if @playing
    , 50

  render: =>
    @board = new kablammo.Board(@, @args.board)
    @board.render()

  turn: (event) =>
    return unless @board.alive_robots().length >= 2

    done = (data, status, xhr) =>
      @args = $.parseJSON data
      @render()

    fail = (xhr, status, error) ->
      console.log status

    $.post("/battles/#{@args.id}/turn.json")
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
