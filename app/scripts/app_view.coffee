View = require('./lib/view')

class StepView extends View
  elements:
    timeLeft: '#time-left'
    label : '#label'
    progress : '#progress'

  events:
    'click .button-play, .button-pause': 'run'
    'click .button-restart': 'restart'

  constructor: (options) ->
    super(options)
    throw "App view requires a sequence model" unless @sequence?
    @sequence.on('advanced', @, @stepChanged)

  stepChanged: ->
    @currentStep?.off()
    oldStep = @currentStep
    @currentStep = @sequence.currentStep()

    @currentStep.on('tick', @, @timeChanged)
    @currentStep.on('paused', () => @$().addClass('paused'))
    @currentStep.on('resumed', () => @$().removeClass('paused'))
    
    @renderStepChange(oldStep, @currentStep)

  renderStepChange: (oldStep, newStep) ->
    @$().removeClass("step-#{oldStep.type}") if oldStep?
    @$().addClass("step-#{newStep.type}")
    
    @label.html( newStep.name )
    @progress.height( "#{@sequence.percentComplete() * 100}%")
    @timeChanged( newStep )
    
  timeChanged: (step) ->
    @timeLeft.html( step.timeLeftSeconds?() )

  run: ->
    @sequence.send('run')
  restart: ->
    @sequence.send('restart')

module.exports = StepView