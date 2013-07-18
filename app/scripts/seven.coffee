Util = require('./lib/util')
SQ = require('./lib/sequence')
Step = require('./step')
View = require('./app_view')
Sidebar = require('./sidebar_view')

# Define the steps/views in the sequence with a set of controllers
exercises = [
  'jumping jacks'
  'wall sit'
  # 'pushups'
  # 'crunches'
  # 'chair step-up'
  # 'squats'
  # 'tricep dip'
  # 'plank'
  # 'high-knee run'
  # 'lunge'
  # 'pushup rotate'
  # 'side plank'
]

workDuration = 3000
restDuration = 2000

steps = []

for exercise in exercises
  steps.push( new Step(name: 'rest', description: "next: #{exercise}", duration: restDuration, type: 'rest'),
              new Step(name: exercise, description: '', duration: workDuration, type: 'activity') )
  
steps.push( new SQ.Step(
  type: 'done'
  name: 'DONE'
  description: 'tap to restart'
  enter: ->
    @sequence.stop()
))


# Create a sequency of steps to run in order
stateMachine = new SQ.Sequence
  steps: steps

# View
appView = new View(sequence: stateMachine)
sidebarView = new Sidebar(sequence: stateMachine)


$ ->  
  # GO!
  appView.setElement($('#steps'))
  sidebarView.setElement($('#sidebar'))

  # stateMachine.start()