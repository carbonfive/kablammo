class kablammo.Square
  constructor: (@parent, @args) ->
    @el = ".square-#{@args.x}-#{@args.y}"
    if @args.state == 'tank'
      @tank = new kablammo.Tank(@, @args.tank)

  $el: ->
    @parent.$el().find @el

  render: ->
    @$el().addClass @args.state
    @renderTank()

  renderTank: ->
    if @args.state == 'tank'
      @$el().append '<div class="tank"/>'
      @tank.render()
    else
      @$el().empty()

  fire: ->
    @$el().addClass 'fire'

  unfire: ->
    @$el().removeClass 'fire'
