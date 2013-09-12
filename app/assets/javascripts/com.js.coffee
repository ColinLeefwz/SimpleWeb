$ ->

	$('.video-img').on 'click', ->
		video_source = $(this).data('source')
		$(this).replaceWith("<video src='#{video_source}' controls='controls'>")
	$container = $('#content')
	$('nav li.category .filters').on 'click', ->
		selector = $(this).data('filter')
		$container.isotope
		  filter: selector
		$(".filters").css('background', 'white')
		$(this).css('background', '#eee')

