#
# A sequence is comprised of steps. Once started it advanced through the
# steps exiting/entering steps as it goes. Also triggers events at each
# advance and at completion of sequence.
#
Util = require('./util')
Event = require('./event')

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

Util.merge(Step::, Event)


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

  stop: ->
    @steps[@currentIndex]?.exit()
    @trigger('stopped')

  send: (eventName, args...) ->
    @steps[@currentIndex]?.send(eventName, args...)

  advance: ->
    @transition( @currentIndex+1 )

  transition: (newIndex) ->
    oldStep = @steps[@currentIndex]
    oldStep?.exit()
    @currentIndex = newIndex
    if @steps[@currentIndex]
      @steps[@currentIndex]?.enter()
      @trigger('advanced', oldStep, @steps[@currentIndex])
    else
      @stop()

  currentStep: ->
    @steps[@currentIndex]

  percentComplete: ->
    @currentIndex / (@steps.length-1)

# Make sequence evented
Util.merge(Sequence::, require('./event'))


module.exports = 
  Sequence: Sequence
  Step: Step