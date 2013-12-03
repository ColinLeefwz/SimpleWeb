toggle_hidden = ->
  $(this).find("img").toggleClass "hidden"
  $(this).find("img:nth-of_type(2)").toggleClass "hidden"

$ ->
  $("#about_us_sidebar li").mouseover(toggle_hidden).mouseout(toggle_hidden)

