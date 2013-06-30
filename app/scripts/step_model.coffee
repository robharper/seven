Util = require('./lib/util')
Event = require('./lib/event')

class StepModel
  name: null
  timeLeft: 0

  constructor: (options={}) ->
    Util.merge(@, options)

  setTimeLeft: (timeLeft) ->
    @timeLeft = timeLeft
    @trigger('update:timeLeft')

  timeLeftSeconds: ->
    Math.round(@timeLeft / 1000)

Util.merge(StepModel::, Event)

module.exports = StepModel