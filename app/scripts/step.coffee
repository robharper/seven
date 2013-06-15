Util = require('./lib/util')
SQ = require('./lib/sequence')
View = require('./lib/view')
Stopwatch = require('./lib/stopwatch')

class StepController extends SQ.Step
  duration: 3000

  constructor: (options={}) ->
    Util.merge(@, options)
    @model = 
      name: @name
      timeLeft: 0
      paused: false

    @view = new View(templateName: 'page', model: @model)

    @stopwatch = new Stopwatch()
    @stopwatch.on('tick', @, @tick)
    @stopwatch.on('done', @, @done)

    super(options)

  enter: () ->
    @model.timeLeft = Math.round(@duration/1000)
    @view.render()
    @stopwatch.start(@duration)
    
  tick: (remaining) ->
    console.log('Time left:' + Math.round(remaining/1000))
    @model.timeLeft = Math.round(remaining/1000)
    @view.render()

  done: ->
    @model.timeLeft = 0
    @view.render()
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
    console.log('exiting')

module.exports = StepController