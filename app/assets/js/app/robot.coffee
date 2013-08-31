class kablammo.Robot
  constructor: (@parent, @args) ->
    @el = 'img'

  $el: ->
    @parent.$el().find @el

  render: ->
    @turns = ( new kablammo.Turn(@, turn) for turn in @args.turns )
    @last_turn = _(@turns).last()

    url = "https://identicons.github.com/#{@args.username}.png"
    @$el().attr 'src', url
    stat = $(".stats .robot-#{@args.username}")
    stat.find('.rotation td').html @args.rotation
    stat.find('.armor td').html @args.armor
    stat.find('.ammo td').html @args.ammo
    stat.find('.last-turn td').html @last_turn?.args.value

    if @last_turn? && @last_turn.args.line_of_fire?
      @parent.parent.fire @last_turn.args.line_of_fire, =>
        $(@parent).trigger 'rendered'
    else
      $(@parent).trigger 'rendered'
