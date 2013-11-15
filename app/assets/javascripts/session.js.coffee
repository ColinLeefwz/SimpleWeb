class Session
	constructor: ->
	
	start: ->
		@timezone_toggle()
		@tell_friend()

	timezone_toggle: ->
		$(".timezone-toggle").on("click", =>
			$(".timezone-confirmation").slideToggle()
			$(".content-type, .price").fadeToggle()
		)
		$(".timezone-confirmation").on("change", "select", =>
			$(".simple_form").submit()
			$(".timezone-confirmation").slideUp()
			$(".content-type, .price").fadeIn()
		)

	tell_friend: ->
		$(".tell-friend").on 'mouseenter', =>
			console.log "good"

$(document).ready ->
	(new Session).start()
$(document).on 'page:load', ->
  (new Session).start()
