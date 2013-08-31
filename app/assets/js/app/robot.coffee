class kablammo.Robot
  constructor: (@parent, @args) ->
    @el = 'img'

  $el: ->
    @parent.$el().find @el

  onRendered: =>
    $(@parent).trigger 'rendered'

  render: ->
    @turns = ( new kablammo.Turn(@, turn) for turn in @args.turns )
    @last_turn = _(@turns).last()

    url = "https://identicons.github.com/#{@args.username}.png"
    @$el().attr 'src', url
    stat = $(@battle).find(".stats .robot-#{@args.username}")
    stat.find('.rotation td').html @args.rotation
    stat.find('.armor td').html @args.armor
    stat.find('.ammo td').html @args.ammo
    stat.find('.last-turn td').html @last_turn?.args.value

    if @alive() && @last_turn? && @last_turn.args.line_of_fire?
      @board().fire @last_turn.args.line_of_fire, @onRendered
    else
      @onRendered()

  alive: ->
    @args.armor >= 0

  board: =>
    @parent.parent

  battle: =>
    @board().parent
