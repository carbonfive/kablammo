class kablammo.PowerUp
  constructor: (@parent, @args) ->
    @el = 'img'

  $el: ->
    @parent.$el().find @el

  onRendered: ->
    $(@parent).trigger 'rendered'

  render: ->
    src = "/images/#{@args.type}.png"
    @$el().attr 'src', src
    @onRendered()
