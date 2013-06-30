#
# Basic static carousel of a fixed number of views. Once rendered `gotoPage` will
# animate the carousel to the page/index supplied.
#

Util = require('./util')

module.exports = class CarouselView extends require('./view')

  orientation: 'x'

  classes: ['carousel']

  pageStyle:
    position: 'absolute'
    top: 0
    left: 0
    width: '100%'
    height: '100%'

  constructor: (options = {}) ->
    super(options)
    @currentIndex ?= 0

  _offsetForIndex: (index) ->
    if @orientation == 'x' then "translate3d(#{index*100}%,0,0)" else "translate3d(0%,#{index*100}%,0)"

  render: ->
    @ensureElement()
    @$slider = $('<div>').addClass('carousel-slider')
    for page, index in @pages
      page.render()
      page.$el.css Util.merge({'transform': @_offsetForIndex(index)}, @pageStyle)
      @$slider.append(page.$el)
    @$el.html(@$slider)

  gotoPage: (page) ->
    if typeof page == 'number'
      index = page
    else
      index = @pages.indexOf(page)
    return if index < 0 or index >= @pages.length
    @$slider.css('transform': @_offsetForIndex(-index))
