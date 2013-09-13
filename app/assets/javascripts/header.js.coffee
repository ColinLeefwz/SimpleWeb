$ ->
	nav = $('nav')
	subcategory = $('.subcategory')
	nav.find('li').each ->
		$(this).on 'click', =>
			$(this).parents('nav').find('a').css('border-bottom', '0')
			$(this).find('a').css('border-bottom', "3px solid #8a2649")
			subcategory.slideUp()
			$(this).find('ul').stop(true, true).slideDown()
