#
# Simple class representing a countdown timer that sends events at
# prescribed tick intervals until complete. Also supports pausing
# and resuming
#
Util = require('./util')
Event = require('./event')

class Stopwatch
	tickFrequency: 1000

	start: (duration) ->
		@running = true
		@duration = duration
		@endTime = Date.now() + @duration

		@_ticker = setInterval (=> @_tick()), @tickFrequency
		@_complete = setTimeout (=> @_done()), duration

	_tick: ->
		timeLeft = @endTime - Date.now()
		@trigger('tick', timeLeft)

	_done: ->
		@running = false
		clearInterval(@_ticker)

		@trigger('done')
		
		@_ticker = null
		@_complete = null
		@duration = null
		@endTime = null

	pause: ->
		return unless @_ticker?
		@running = false
		@_pausedTime = Date.now()
		@trigger('paused')
		
		clearInterval(@_ticker)
		@_ticker = null
		clearTimeout(@_complete)
		@_complete = null

	resume: ->
		timeRemaining = @endTime - @_pausedTime
		@endTime = Date.now() + timeRemaining

		@running = true
		@_complete = setTimeout (=> @_done()), timeRemaining

		@trigger('resumed')

		# Send a tick in at the next even tick time (pause likely happened between two ticks)
		tickFraction = timeRemaining % @tickFrequency
		@_ticker = setTimeout( =>
			@_tick()
			# Start regular tick intervals if still running after this fractional tick
			@_ticker = setInterval (=> @_tick()), @tickFrequency	if @running
		, tickFraction)

Util.merge(Stopwatch::, Event)

module.exports = Stopwatch