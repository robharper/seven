View = require('./lib/view')

class ProgressView extends View
  arcWidth: 0.1
  transitionLength: 1000

  setElement: (el) ->
    super(el)
    @createVis()
    
    # Quick and dirty rebuild of vis on canvas size change
    $(window).on('resize', () =>
      @$el.empty()
      @createVis()
    )

  createVis: ->
    w = @$().width()
    h = @$().height()
    r = Math.min(w, h)/2

    @lastValues = [1..@seriesCount].map -> 0
 
    svg = d3.select(@$()[0])
      .append('g').attr('transform', "translate(#{w/2},#{h/2})")

    svg.append('g').attr('class', 'progress-base')
      .append('path').attr('d', 
        d3.svg.arc()
          .startAngle(0)
          .endAngle(2*Math.PI)
          .innerRadius((1-@arcWidth*@lastValues.length)*r)
          .outerRadius(r)
      )

    @dataViz = svg.append('g')

    # `seriesCount` series
    g = @dataViz.selectAll('g')
        .data(@lastValues)
      .enter().append('g')
        .attr('class', (d,i) =>
          @progressClasses?[i]
        )

    # ... of arc paths
    @arc = d3.svg.arc()
      .startAngle(0)
      .endAngle((d) -> d * 2 * Math.PI)
      .innerRadius((d,i) => r * (1 - @arcWidth*(i+1)) )
      .outerRadius((d,i) => r * (1 - @arcWidth*i) )

    g.append('path').attr('d', @arc)
     
  update: (progressArray) ->
    startVal = @lastValues.slice(0)
    endVal = progressArray
    arcTween = (v,i) =>
      interp = if startVal[i] <= endVal[i]
        d3.interpolate(startVal[i], endVal[i])
      else
        d3.interpolate(0, endVal[i])
      (v) => 
        @arc(interp(v), i)

    @dataViz.selectAll('g').data(progressArray)
      .select('path').transition()
        .duration(@transitionLength)
        .ease('quad-out')
        .attrTween("d", arcTween)
    @lastValues = progressArray

module.exports = ProgressView