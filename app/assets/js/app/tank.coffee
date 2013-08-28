class kablammo.Tank
  constructor: (@parent, @args) ->
    @el = '.tank'

  $el: ->
    @parent.$el().find @el

  render: ->
    img = "<img src='https://identicons.github.com/#{@args.username}.png'/>"
    @$el().append img
