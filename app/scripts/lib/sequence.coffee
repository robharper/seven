#
# A sequence is comprised of steps. Once started it advanced through the
# steps exiting/entering steps as it goes. Also triggers events at each
# advance and at completion of sequence.
#
Util = require('./util')
Evented = require('./event')

class Step extends Evented
  constructor: (options={}) ->
    Util.merge(@, options)

  enter: ->

  exit: ->

  isCurrent: ->
    @sequence.currentState() == @

  receive: (eventName, args...) ->
    if typeof @[eventName] == 'function'
      @[eventName](args...)
    else
      throw new Error("Unhandled event: #{eventName}")

  trigger: (args...) ->
    # Dispatch event via parent
    @sequence.dispatch(@, args...)
    # ... and normal trigger via self
    super(args...)

  advance: ->
    @sequence.advance()




class Sequence extends Evented
  steps: null
  currentIndex: null

  constructor: (options = {}) ->
    @set(options.steps)

  set: (steps) ->
    (step.sequence = @) for step in steps
    @steps = steps

  start: (startState) ->
    @running = true
    @trigger('started')
    @transition(0)

  stop: ->
    @steps[@currentIndex]?.exit()
    @trigger('stopped')
    @running = false

  send: (eventName, args...) ->
    @steps[@currentIndex]?.receive(eventName, args...)

  dispatch: (step, eventName, args...) ->
    @trigger(eventName, step, args...)

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


module.exports = 
  Sequence: Sequence
  Step: Step