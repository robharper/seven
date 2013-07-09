Util = require('./lib/util')
SQ = require('./lib/sequence')
Step = require('./step')
View = require('./app_view')

# Define the steps/views in the sequence with a set of controllers
exercises = [
  'jumping jacks'
  'wall sit'
  'pushups'
  'crunches'
  'chair step-up'
  'squats'
  'tricep dip'
  'plank'
  'high-knee run'
  'lunge'
  'pushup rotate'
  'side plank'
]

workDuration = 30000
restDuration = 5000

steps = []

for exercise in exercises
  steps.push( new Step(name: "next: #{exercise}", duration: restDuration, type: 'rest'),
              new Step(name: exercise, duration: workDuration, type: 'activity') )
  
steps.push( new SQ.Step(
  type: 'done'
  name: 'DONE'
  enter: ->
    @sequence.stop()
))


# Create a sequency of steps to run in order
stateMachine = new SQ.Sequence
  steps: steps

# View
appView = new View(sequence: stateMachine)


$ ->  
  # GO!
  appView.setElement($('#steps'))
  # stateMachine.start()