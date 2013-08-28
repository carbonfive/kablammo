class kablammo.Square
  constructor: (@parent, @args) ->
    @el = ".square-#{@args.x}-#{@args.y}"
    if @args.state == 'tank'
      @tank = new kablammo.Tank(@, @args.tank)

  $el: ->
    @parent.$el().find @el

  render: ->
    @$el().addClass @args.state
    @$el().find('img').attr 'src', '/images/blank.png'
    @renderTank() if @args.state == 'tank'

  renderTank: ->
    @tank.render()

  fire: ->
    @$el().addClass 'fire'

  unfire: ->
    @$el().removeClass 'fire'
