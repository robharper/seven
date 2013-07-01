
Util = require('./util')

uid = 0


module.exports = class View

  constructor: (options = {}) ->
    Util.merge(@, options)
    @id = uid++

  setElement: (el) ->
    @_unbind()
    @$el = $(el)
    @_bind()
    @_connectElements()

  _bind: ->
    for key,value of @events
      ((event, handler) =>
        tokens = event.split(' ')
        event = tokens.shift()
        selector = tokens.join(' ')
        @$el.on(event+".view-#{@id}", selector, (evt) => @[handler](evt))
      )(key, value)

  _unbind: ->
    @$el?.off(".view-#{@id}")

  _connectElements: ->
    for name,selector of @elements
      @[name] = @$(selector)

  _disconnectElements: ->
    for name,selector of @elements
      @[name] = null

  $: (selector) ->
    if selector? then @$el.find(selector) else @$el