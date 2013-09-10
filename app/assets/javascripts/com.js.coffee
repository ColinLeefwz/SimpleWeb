$ ->
  container = $('#content')
  container.imagesLoaded ->
    container.masonry
      itemSelector: '.item'

	$('.video-img').on 'click', ->
		video_source = $(this).data('source')
		$(this).replaceWith("<video src='#{video_source}' controls='controls'>")
