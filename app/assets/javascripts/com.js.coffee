$ ->
  container = $('#content')
  container.imagesLoaded ->
    container.masonry
      itemSelector: '.item'

	$('.video-img').on 'click', ->
		video_source = $(this).data('source')
		video_path = "/assets/#{video_source}"
		$(this).replaceWith("<video src='#{video_path}' controls='controls'>")
