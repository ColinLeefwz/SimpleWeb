header = ->
  nav = $('nav')
  subcategory = $('.subcategory')
  nav.find('.category').each ->
    $(this).on 'click', =>
      $(this).parents('nav').find('a').css('border-bottom', '0')
      $(this).find('a').css('border-bottom', "3px solid #8a2649")
      subcategory.slideUp()
      $(this).find('ul').stop(true, true).slideDown()

  nav.find('#format').each ->
    $(this).on 'mouseenter', =>
      $(this).find('ul').stop(true, true).slideDown()
    $(this).on 'mouseleave', =>
      $(this).find('ul').stop(true, true).slideUp()

$(document).ready(header)
$(document).on 'page:load', header
