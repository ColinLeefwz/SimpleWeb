$(document).ready( ->
  if sign_in_confirm() == true
    return false
  else
    openTipbox()
)

openTipbox = ->
  setTimeout (->
    $("#tip-trigger").find("a").trigger("click")), 20000

