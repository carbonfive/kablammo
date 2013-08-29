class kablammo.Tank
  constructor: (@parent, @args) ->
    @el = 'img'

  $el: ->
    @parent.$el().find @el

  render: ->
    url = "https://identicons.github.com/#{@args.username}.png"
    @$el().attr 'src', url
    stat = $(".stats .tank-#{@args.username}")
    stat.find('.rotation td').html @args.rotation
    stat.find('.armor td').html @args.armor
    stat.find('.ammo td').html @args.ammo
    stat.find('.last-turn td').html @args.last_turn
