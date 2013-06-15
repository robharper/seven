merge = require('./util').merge

class State 
  constructor: (options={}) ->
    merge(@, options)
    @transitions ?= {}

  enter: (transitionName) ->

  exit: (transitionName) ->

  isCurrent: ->
    @stateMachine.currentState == @

  trigger: (eventName, args...) ->
    if typeof @[eventName] == 'function'
      @[eventName](args...)
    else
      throw new Error("Unhandled event: #{eventName}")

  transition: (transitionName) ->
    destination = @transitions[transitionName]
    throw new Error("Unknown transition: #{transitionName}") unless destination?
    @stateMachine.applyTransition(destination, transitionName)



class StateMachine
  states: null
  currentState: null

  constructor: (options = {}) ->
    @states = {}
    @addStates(options.states)
    @startState = options.startState

  addStates: (states={}) ->
    if states instanceof Array
      hash = {}
      hash[state.name] = state for state in states
      states = hash

    (state.stateMachine = @) for name,state of states
    merge(@states, states)

  start: (startState) ->
    @applyTransition(startState || @startState)

  trigger: (eventName, args...) ->
    @currentState.trigger(eventName, args...)

  transition: (transitionName) ->
    @currentState.transition(transitionName)

  applyTransition: (newState, transition) ->
    newState = @states[newState] if typeof newState == 'string'
    oldState = @currentState

    @currentState?.exit(transition, newState)
    @currentState = newState
    @currentState?.enter(transition, oldState)



module.exports = 
  State: State
  StateMachine: StateMachine