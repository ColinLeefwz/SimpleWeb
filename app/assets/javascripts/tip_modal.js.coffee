openTipbox = ->
  setTimeout ( ->
    $("#tip-trigger").find("a").trigger("click")
  ), 20000
  $.cookie("show_tip_modal", false, { expires: 1 })

$(document).ready( ->
  if sign_in_confirm() == true
    return false
  else if $.cookie("show_tip_modal") isnt "false"
    openTipbox()
)

