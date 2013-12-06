toggle_hidden = ->
  $(this).find("img").toggleClass "hidden"
  $(this).find("img:nth-of_type(2)").toggleClass "hidden"

hover_effect = ->
  $("#about_us_sidebar li").mouseover(toggle_hidden).mouseout(toggle_hidden)

$(document).ready(hover_effect)
$(document).on 'page:load', hover_effect
