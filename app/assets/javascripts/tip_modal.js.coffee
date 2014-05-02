openTipbox = ->
  setTimeout ( ->
    $("#tip-trigger").find("a").trigger("click")
  ), 40000
  $.cookie("show_tip_modal", false, { expires: 1 })

$(document).ready( ->
  if signed_in() == true
    return false
  else if $.cookie("show_tip_modal") isnt "false"
    openTipbox()
)

