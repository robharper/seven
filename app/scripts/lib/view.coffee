
Util = require('./util')

uid = 0


module.exports = class View

  tag: 'div'
  classes: []

  constructor: (options = {}) ->
    Util.merge(@, options)
    @id = uid++

  template: (context) ->
    @_template ?= Handlebars.compile($("[data-template-name=#{@templateName}]").html())
    @_template?(context)

  context: ->
    @model || @

  render: () ->
    @ensureElement()
    @$el.html( @template( @context() ) )
    @

  setElement: (el) ->
    @_unbind()
    @$el = $(el)
    @_bind()

  ensureElement: ->
    return if @$el
    @setElement( $("<#{@tag}>").addClass(@classes.join(' ')) )

  _bind: ->
    for event,handler of @events
      @$el.on(event+".view-#{@id}", (evt) => @[handler](evt))

  _unbind: ->
    @$el?.off(".view-#{@id}")

  $: (selector) ->
    if selector? then @$el.find(selector) else @$el