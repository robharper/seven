View = require('./lib/view')

class ProgressView extends View
  setElement: (el) ->
    super(el)
    @createVis()

  createVis: ->
    w = @$().width()
    h = @$().height()
    r = Math.min(w, h)/2
 
    @svg = d3.select(@$()[0])
      .append('g').attr('transform', "translate(#{w/2},#{h/2})")

    # `seriesCount` series
    g = @svg.selectAll('g')
        .data([1..@seriesCount].map -> 0)
      .enter().append('g')
        .attr('class', (d,i) =>
          @progressClasses?[i]
        )

    # ... of arc paths
    @arc = d3.svg.arc()
      .startAngle(0)
      .endAngle((d) -> d * 2 * Math.PI)
      .innerRadius((d,i) -> r * (1 - 0.1*(i+1)) )
      .outerRadius((d,i) -> r * (1 - 0.1*i) )

    g.append('path').attr('d', @arc)
     
  update: (progressArray) ->
    @svg.selectAll('g').data(progressArray)
      .select('path').attr('d', @arc)

module.exports = ProgressView