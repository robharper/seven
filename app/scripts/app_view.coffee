View = require('./lib/view')
ProgressView = require('./progress_view')

class StepView extends View
  elements:
    timeLeft: '#time-left'
    label : '#label'
    svg : 'svg'

  events:
    'click .button-play, .button-pause': 'run'
    'click .button-restart': 'restart'

  constructor: (options) ->
    super(options)
    throw "App view requires a sequence model" unless @sequence?

    @progress = new ProgressView(
      seriesCount: 2
      progressClasses: ['step-progress', 'sequence-progress']
    )

    @sequence.on('started', () => @$().addClass('running'))
    @sequence.on('advanced', @, @stepChanged)
    @sequence.on('stopped', () => 
      @stepChanged(@sequence.currentStep(), null)
      @$().removeClass('running')
    )

  stepChanged: (oldStep, newStep) ->
    oldStep?.off()

    if newStep
      newStep.on('tick', @, @timeChanged)
      newStep.on('paused', () => @$().addClass('paused'))
      newStep.on('resumed', () => @$().removeClass('paused'))
    
    @renderStepChange(oldStep, newStep)

  setElement: (el) ->
    super(el)
    @progress.setElement(@svg)

  renderStepChange: (oldStep, newStep) ->
    @$().removeClass('paused')
    @$().removeClass("step-#{oldStep.type}") if oldStep?
    if newStep?
      @$().addClass("step-#{newStep.type}")
      @label.html( newStep.name )
      @timeChanged( newStep )
    
  timeChanged: (step) ->
    return unless step.duration > 0

    @timeLeft.html( step.timeLeftSeconds?() )

    @progress.update([
      (step.duration-step.remaining)/step.duration
      @sequence.percentComplete()
    ])

  run: ->
    if @sequence.currentStep()?
      @sequence.send('run')
    else
      @sequence.start()

  restart: ->
    @sequence.stop()
    @sequence.start()

module.exports = StepView