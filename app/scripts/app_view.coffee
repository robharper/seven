View = require('./lib/view')
ProgressView = require('./progress_view')

class StepView extends View
  elements:
    timeLeft: '#time-left'
    label : '#label'
    sublabel : '#sub-label'
    svg : 'svg'

  events:
    'click': 'run'

  constructor: (options) ->
    super(options)
    throw "App view requires a sequence model" unless @sequence?

    @progress = new ProgressView(
      seriesCount: 2
      progressClasses: ['step-progress', 'sequence-progress']
    )

    @sequence.on('started', () => 
      @running = true
      @$().addClass('running').removeClass('paused', 'step-done')
    )
    @sequence.on('advanced', @, @renderStepChange)
    @sequence.on('stopped', () => 
      @running = false
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
      @sublabel.html( newStep.description )
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
    if @running
      @sequence.send('run')
    else
      @sequence.start()

module.exports = StepView