Util = require('./lib/util')
SQ = require('./lib/sequence')
CarouselView = require('./lib/carousel')

StepController = require('./step')

# Define the steps/views in the sequence with a set of controllers
pages = [
  new StepController(template: 'start', duration: 0)
  new StepController(name: 'one', duration: 5000)
  new StepController(name: 'two', duration: 5000)
  new StepController(name: 'three', duration: 5000)
  new StepController(name: 'DONE', duration: 0)
]

# Create a carousel using the controller's views
carousel = new CarouselView
  orientation: 'y'
  pages: pages.map (page) -> page.view

# Create a sequency of steps to run in order
stateMachine = new SQ.Sequence
  steps: pages

# On each new step, advance the carousel to the corresponding page
stateMachine.on('advanced', (step) ->
  carousel.gotoPage(step.view)
)


$ ->  
  # GO!
  carousel.render()
  stateMachine.start()
  
  setTimeout ->
    stateMachine.send('pause')
  , 4500

  setTimeout ->
    stateMachine.send('resume')
  , 6500

  $('#steps').append(carousel.$el)