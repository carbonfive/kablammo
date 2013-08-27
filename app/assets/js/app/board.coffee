class @kablammo.Board
  constructor: (@args, @fires, @play) ->

  render: ->
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
    el = "#square-#{sq[0]}-#{sq[1]}"
    $(el).addClass 'fire'
    setTimeout =>
      $(el).removeClass 'fire'
      @fire lof, next
    , 100

  turn: ->
    setTimeout ->
      window.location.reload()
    , 250
