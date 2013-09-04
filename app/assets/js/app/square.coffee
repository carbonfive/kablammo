class kablammo.Square
  constructor: (@parent, @args) ->
    @el = ".square-#{@args.x}-#{@args.y}"
    $(@).on 'rendered', @onRendered
    @image = @$el().find('img')

  $el: ->
    @parent.$el().find @el

  onRendered: =>
    $(@parent).trigger 'rendered'

  render: ->
    @$el().addClass @args.state
    @image.attr 'src', '/images/blank.png'

    if @args.state == 'robot'
      @robot = new kablammo.Robot(@, @args.robot)
      @renderRobot()
    else
      @onRendered()

    @renderPowerUp() if @args.power_up

  renderPowerUp: ->
    powerUpIcon = "/images/#{@args.power_up.type}.png"
    @image.attr 'src', powerUpIcon

  renderRobot: ->
    @$el().addClass 'dead' if ! @robot.alive()
    @robot.render()

  fire: ->
    @$el().addClass 'fire'

  unfire: ->
    @$el().removeClass 'fire'
