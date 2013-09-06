class kablammo.Square
  constructor: (@parent, @args) ->
    @el = ".square-#{@args.x}-#{@args.y}"
    $(@).on 'rendered', @onRendered
    @image = @$el().find('img')

  $el: ->
    @parent.$el().find @el

  onRendered: =>
    @rendered += 1
    if @rendered == 2
      $(@parent).trigger 'rendered'

  render: ->
    @rendered = 0
    @$el().addClass @args.state
    @image.attr 'src', '/images/blank.png'

    if @args.state == 'robot'
      @robot = new kablammo.Robot(@, @args.robot)
      @renderRobot()
    else
      @onRendered()

    if @args.state == 'power_up'
      @powerUp = new kablammo.PowerUp(@, @args.power_up)
      @renderPowerUp()
    else
      @onRendered()

  renderPowerUp: ->
    @powerUp.render()

  renderRobot: ->
    @$el().addClass 'dead' if ! @robot.alive()
    @robot.render()

  fire: ->
    @$el().addClass 'fire'

  unfire: ->
    @$el().removeClass 'fire'
