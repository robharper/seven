
SM = require('./lib/statemachine')

stateMachine = new SM.StateMachine
  startState: 'one'
  states: [
    new SM.State
      name: 'pause'
      enter: (transitionName, previousState) ->
        console.log('pausing')
        @transitions['resume'] = previousState
      exit: ->
        console.log('resuming')
        delete @transitions['resume']
    
    new SM.State 
      name: 'one'
      transitions:
        pause: 'pause'
        next: 'two'
      enter: ->
        console.log("Entered #{@name}")
      exit: ->
        console.log("Exited #{@name}")
    
    new SM.State
      name: 'two'
      transitions:
        pause: 'pause'
        next: 'three'
      enter: ->
        console.log("Entered #{@name}")
      exit: ->
        console.log("Exited #{@name}")
    
    new SM.State
      name: 'three'
      transitions:
        pause: 'pause'
      enter: ->
        console.log("Entered #{@name}")
      exit: ->
        console.log("Exited #{@name}")
  ]

stateMachine.start()
stateMachine.transition('next')
stateMachine.transition('pause')
stateMachine.transition('resume')
stateMachine.transition('next')