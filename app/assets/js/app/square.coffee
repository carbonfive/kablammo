class kablammo.Square
  constructor: (@parent, @args) ->
    @el = ".square-#{@args.x}-#{@args.y}"
    $(@).on 'rendered', @onRendered

  $el: ->
    @parent.$el().find @el

  onRendered: =>
    $(@parent).trigger 'rendered'

  render: ->
    @$el().addClass @args.state
    @$el().find('img').attr 'src', '/images/blank.png'
    if @args.state == 'robot'
      @robot = new kablammo.Robot(@, @args.robot)
      @renderRobot()
    else
      @onRendered()

  renderRobot: ->
    @$el().addClass 'dead' if ! @robot.alive()
    @robot.render()

  fire: ->
    @$el().addClass 'fire'

  unfire: ->
    @$el().removeClass 'fire'
