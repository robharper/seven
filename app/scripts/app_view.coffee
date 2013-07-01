View = require('./lib/view')

class StepView extends View
  elements:
    timeLeft: '#time-left'
    label : '#label'

  events:
    'click .button-run': 'run'

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
    @timeChanged( newStep )
    
  timeChanged: (step) ->
    @timeLeft.html( step.timeLeftSeconds?() )

  run: ->
    @sequence.send('run')

module.exports = StepView