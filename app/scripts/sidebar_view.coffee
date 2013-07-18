View = require('./lib/view')

class SidebarView extends View
  # elements:

  events:
    'click .button-play': 'run'
    'click .button-restart': 'restart'

  constructor: (options) ->
    super(options)
    throw "Sidbar view requires a sequence model" unless @sequence?

  run: ->
    @sequence.send('run')

  restart: (evt) ->
    @sequence.stop()
    @sequence.start()

module.exports = SidebarView