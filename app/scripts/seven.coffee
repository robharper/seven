Util = require('./lib/util')
SQ = require('./lib/sequence')
Step = require('./step')
View = require('./app_view')
Sidebar = require('./sidebar_view')

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

# Javascript css-ish calculations:
updateStyle = () ->
  if window.innerWidth/window.innerHeight > 0.7
    $('body').addClass('wide').removeClass('tall')
  else
    $('body').addClass('tall').removeClass('wide')

  $('[data-square]').each (index, el) ->
    el = $(el)
    parent = el.parent()
    size = Math.min(parent.innerWidth(), parent.innerHeight())
    el.css
      'margin-left': -size/2
      'margin-top': -size/2
      'width': size
      'height': size

$(window).on 'resize', updateStyle


$ ->  
  updateStyle()

  # GO!
  appView.setElement($('#steps'))
  sidebarView.setElement($('#sidebar'))

  $('body').addClass('ready')