#
# Base controller object that manages a timed step in the sequence with associated view
#

Util = require('./lib/util')
SQ = require('./lib/sequence')
StepView = require('./step_view')
StepModel = require('./step_model')
Stopwatch = require('./lib/stopwatch')

class StepController extends SQ.Step
  duration: 3000
  template: 'step'

  constructor: (options={}) ->
    Util.merge(@, options)
    @model = new StepModel 
      name: @name
      paused: false

    @view = new StepView(model: @model, templateName:@template, classes: ['step-view', @template])

    @stopwatch = new Stopwatch()
    @stopwatch.on('tick', @, @tick)
    @stopwatch.on('done', @, @done)

    super(options)

  enter: () ->
    @model.setTimeLeft( @duration )
    @stopwatch.start(@duration) if @duration > 0
    
  tick: (remaining) ->
    @model.setTimeLeft(remaining)

  done: ->
    @model.setTimeLeft(0)
    @advance()    

  resume: ->
    @model.paused = false
    @view.render()
    @stopwatch.resume()

  pause: ->
    @model.paused = true
    @view.render()
    @stopwatch.pause()
  
  exit: ->

module.exports = StepController