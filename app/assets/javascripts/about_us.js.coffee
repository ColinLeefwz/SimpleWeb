mouse_hover = ->
  $(this).find("img").addClass "hidden"
  $(this).find("img:nth-of-type(2)").removeClass "hidden"

mouse_leave = ->
  $(this).find("img").removeClass "hidden"
  $(this).find("img:nth-of-type(2)").addClass "hidden"

hover_effect = ->
  $("#about-us-sidebar li").mouseover(mouse_hover).mouseout(mouse_leave)

move = ->
  window_top = $(window).scrollTop()
  nav_top = $("#nav-anchor").offset().top
  if(window_top > nav_top - 25)
    $("#about-us-sidebar").addClass("top-fixed")
  else
    if(window_top < nav_top)
      $("#about-us-sidebar").removeClass("top-fixed")

$(window).scroll(move)
$(document).ready(hover_effect)
$(document).on 'page:load', hover_effect
