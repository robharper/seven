Util = require('./util')

class Step
  constructor: (options={}) ->
    Util.merge(@, options)

  enter: (transitionName) ->

  exit: (transitionName) ->

  isCurrent: ->
    @sequence.currentState() == @

  send: (eventName, args...) ->
    if typeof @[eventName] == 'function'
      @[eventName](args...)
    else
      throw new Error("Unhandled event: #{eventName}")

  advance: ->
    @sequence.advance()



class Sequence
  steps: null
  currentIndex: null

  constructor: (options = {}) ->
    @set(options.steps)

  set: (steps) ->
    (step.sequence = @) for step in steps
    @steps = steps

  start: (startState) ->
    @trigger('started')
    @transition(0)

  send: (eventName, args...) ->
    @steps[@currentIndex]?.send(eventName, args...)

  advance: ->
    @transition( @currentIndex+1 )

  transition: (newIndex) ->
    @steps[@currentIndex]?.exit()
    @currentIndex = newIndex
    if @steps[@currentIndex]
      @steps[@currentIndex]?.enter()
      @trigger('advanced', @steps[@currentIndex])
    else
      @trigger('stopped')

  currentStep: ->
    @steps[@currentIndex]

# Make sequence evented
Util.merge(Sequence::, require('./event'))


module.exports = 
  Sequence: Sequence
  Step: Step