#
# Base controller object that manages a timed step in the sequence with associated view
#

Util = require('./lib/util')
SQ = require('./lib/sequence')
Stopwatch = require('./lib/stopwatch')

class Step extends SQ.Step
  duration: 3000

  constructor: (options={}) ->
    super(options)

    @stopwatch = new Stopwatch()
    @stopwatch.on('tick', @, @tick)
    @stopwatch.on('done', @, @done)

  enter: () ->
    @remaining = @duration
    @stopwatch.start(@duration) if @duration > 0
    
  tick: (remaining) ->
    @remaining = remaining
    @trigger('tick', remaining)

  done: ->
    @advance()    

  run: ->
    if @stopwatch.running
      @pause()
    else
      @resume()

  resume: ->
    @stopwatch.resume()
    @trigger('resumed')

  pause: ->
    @stopwatch.pause()
    @trigger('paused')
  
  exit: ->
    @stopwatch.stop()

  timeLeftSeconds: ->
    Math.round(@remaining / 1000)


module.exports = Step