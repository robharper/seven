View = require('./lib/view')

class StepView extends View
  templateName: 'step'
  
  constructor: (options) ->
    model = options.model
    delete options.model

    super(options)
    @setModel(model) if model?

  setModel: (model) ->
    @model?.off('update:timeLeft')
    @model = model
    @model.on('update:timeLeft', @, @updateTime)

  updateTime: ->
    @$('.time').html( @model.timeLeftSeconds() )

module.exports = StepView