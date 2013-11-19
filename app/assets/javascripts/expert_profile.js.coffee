
get_cookie = (name) ->
  parts = document.cookie.split(name + "=")
  if parts.length == 2
    return parts.pop().split(";").shift()


profile_event = ->
  $("#follow").on 'click', ->
    signed_in = get_cookie("signed_in")
    if signed_in == "1"
      alert "logged in"
    else
      alert "not logged in"


$(document).ready(profile_event)
$(document).on 'page:load', profile_event

