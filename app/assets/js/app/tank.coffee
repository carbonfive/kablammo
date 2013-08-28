class kablammo.Tank
  constructor: (@parent, @args) ->
    @el = 'img'

  $el: ->
    @parent.$el().find @el

  render: ->
    url = "https://identicons.github.com/#{@args.username}.png"
    console.log @$el
    @$el().attr 'src', url
