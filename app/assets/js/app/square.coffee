class kablammo.Square
  constructor: (@parent, @args) ->
    @el = ".square-#{@args.x}-#{@args.y}"

  $el: ->
    @parent.$el().find @el

  render: ->
    @$el().addClass @args.state
    @$el().find('img').attr 'src', '/images/blank.png'
    if @args.state == 'tank'
      @tank = new kablammo.Tank(@, @args.tank)
      @renderTank()
    else
      $(@parent).trigger 'rendered', @

  renderTank: ->
    $(@).on 'rendered', (child) =>
      $(@parent).trigger 'rendered', @

    @$el().addClass 'dead' if @tank.args.armor < 0
    @tank.render()

  fire: ->
    @$el().addClass 'fire'

  unfire: ->
    @$el().removeClass 'fire'
