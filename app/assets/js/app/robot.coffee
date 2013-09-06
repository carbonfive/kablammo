class kablammo.Robot
  constructor: (@parent, @args) ->
    @el = 'img'

  $el: ->
    @parent.$el().find @el

  onRendered: =>
    $(@parent).trigger 'rendered'

  render: ->
    @turns = ( new kablammo.Turn(@, turn) for turn in @args.turns )
    @lastTurn = _(@turns).last()
    @powerUps = ( new kablammo.PowerUp(@, power_up) for power_up in @args.power_ups ) if @args.power_ups?
    @ups = _(@powerUps).map (pu) -> "#{pu.args.name} (#{pu.args.duration})"
    console.log @powerUps

    url = "https://identicons.github.com/#{@args.username}.png"
    @$el().attr 'src', url
    stat = $(@battle).find(".stats .robot-#{@args.username}")
    stat.find('.rotation td').html @args.rotation
    stat.find('.armor td').html @args.armor
    stat.find('.ammo td').html @args.ammo
    stat.find('.power-ups td').html @ups
    stat.find('.last-turn td').html @lastTurn?.args.value

    if @alive() && @lastTurn? && @lastTurn.args.line_of_fire?
      @board().fire @lastTurn.args.line_of_fire, @onRendered
    else
      @onRendered()

  alive: ->
    @args.armor >= 0

  board: =>
    @parent.parent

  battle: =>
    @board().parent
