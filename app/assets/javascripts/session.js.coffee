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
		$(".tell-friend").on 'mouseenter', ->
			$(".share-via").removeClass("hidden")
			$(".share-via").addClass("show")
		$(".tell-friend").on 'mouseleave', ->
			$(".share-via").removeClass("show")
			$(".share-via").addClass("hidden")

$(document).ready ->
	(new Session).start()
$(document).on 'page:load', ->
  (new Session).start()
