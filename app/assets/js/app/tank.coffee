class kablammo.Tank
  constructor: (@parent, @args) ->
    @el = 'img'

  $el: ->
    @parent.$el().find @el

  render: ->
    url = "https://identicons.github.com/#{@args.username}.png"
    @$el().attr 'src', url
