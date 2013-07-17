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

    @sequence.on('started', () => 
      @$().addClass('running').removeClass('paused')
    )
    @sequence.on('advanced', @, @renderStepChange)
    @sequence.on('stopped', () => 
      @renderStepChange(@sequence.currentStep(), null)
      @$().removeClass('running')
    )
    @sequence.on('tick', @, @timeChanged)
    @sequence.on('paused', () => @$().addClass('paused'))
    @sequence.on('resumed', () => @$().removeClass('paused'))

  setElement: (el) ->
    super(el)
    @progress.setElement(@svg)

  renderStepChange: (oldStep, newStep) ->
    @$().removeClass("step-#{oldStep.type}") if oldStep?
    if newStep?
      @$().addClass("step-#{newStep.type}")
      @label.html( newStep.name )
      @timeChanged( newStep )
    
  timeChanged: (step, remaining=step.duration) ->
    return unless step.duration > 0

    @timeLeft.html( step.timeLeftSeconds?() )

    # Update progress -> animate to next step over 1 sec
    @progress.update([
      (step.duration-remaining+1000)/step.duration
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