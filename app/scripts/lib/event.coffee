#
#	A mixin that provides jQuery-like eventing to any object using standard
# APIs of `on`, `off`, and `trigger`
#
Event = 
	on: (eventName, context, handler) ->
		[context, handler] = [null, context] unless handler?
		
		@_handlers ?= {}
		handlers = (@_handlers[eventName] ?= [])
		
		handlers.push
			context: context
			handler: handler

	off: (eventName, context, handler) ->
		[context, handler] = [null, context] unless handler?
		
		return unless @_handlers?

		# If nothing given, off everything
		unless eventName?
			delete @_handlers 
			return

		# If only eventName given, remove all listeners
		unless handler?
			delete @_handlers[eventName]
			return

		handlers = @_handlers[eventName]
		# Nothing to do unless some handlers registered
		return unless handlers?.length > 0
		
		# Find matching context/handler pair
		match = handlers.find (h) -> h.context == context and h.handler == handler
		return unless match?

		# Remove
		handlers.splice(handlers.indexOf(match), 1)

	trigger: (eventName, args...) ->
		handlers = @_handlers?[eventName]
		return unless handlers?.length > 0
		for entry in handlers
			entry.handler.apply(entry.context, args)


module.exports = Event