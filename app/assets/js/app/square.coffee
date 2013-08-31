class kablammo.Square
  constructor: (@parent, @args) ->
    @el = ".square-#{@args.x}-#{@args.y}"

  $el: ->
    @parent.$el().find @el

  render: ->
    @$el().addClass @args.state
    @$el().find('img').attr 'src', '/images/blank.png'
    if @args.state == 'robot'
      @robot = new kablammo.Robot(@, @args.robot)
      @renderrobot()
    else
      $(@parent).trigger 'rendered', @

  renderrobot: ->
    $(@).on 'rendered', (child) =>
      $(@parent).trigger 'rendered', @

    @$el().addClass 'dead' if @robot.args.armor < 0
    @robot.render()

  fire: ->
    @$el().addClass 'fire'

  unfire: ->
    @$el().removeClass 'fire'
