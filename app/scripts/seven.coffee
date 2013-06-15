Util = require('./lib/util')
SQ = require('./lib/sequence')
CarouselView = require('./lib/carousel')

StepController = require('./step')



pages = [
  new StepController(name: 'one')
  new StepController(name: 'two')
  new StepController(name: 'three')
]

carousel = new CarouselView
  orientation: 'y'
  pages: pages.map (page) -> page.view

stateMachine = new SQ.Sequence
  steps: pages

stateMachine.on('advanced', (step) ->
  carousel.gotoPage(step.view)
)


$ ->  
  carousel.render()
  stateMachine.start()
  
  setTimeout ->
    stateMachine.send('pause')
  , 4500

  setTimeout ->
    stateMachine.send('resume')
  , 6500

  $('#steps').append(carousel.$el)