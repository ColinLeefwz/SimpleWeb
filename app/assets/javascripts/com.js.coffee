$ ->
	$('.video-img').on 'click', ->
		video_source = $(this).data('source')
		$(this).replaceWith("<video src='#{video_source}' controls='controls'>")

	$container = $('#content')
	$('nav li.category .filters').on 'click', ->
		selector = $(this).data('filter')
		$container.isotope {
		  filter: selector
		}
	$('select#collapsed_navbar').on 'change', ->
		option = $(this).find(":selected")
		selector = option.data 'filter'
		if selector != '.format'
			$container.isotope {
				filter: selector
			}
