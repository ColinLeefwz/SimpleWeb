
get_cookie = (name) ->
  parts = document.cookie.split(name + "=")
  if parts.length == 2
    return parts.pop().split(";").shift()


detect_login = ->
  signed_in = get_cookie("signed_in")
  if signed_in == "1"
    return true
  else
    alert "not logged in"
    return false


profile_event = ->
  $("#follow").on 'click', ->
    if detect_login()
      $(".follow-link").click()

  $(".follow-link").on "ajax:success", (e, data, status, xhr) ->
    button_text = $("#follow i")
    button_text.html( if button_text.html() is "Follow" then "Unfollow" else "Follow")
    e.preventDefault



$(document).ready(profile_event)
$(document).on 'page:load', profile_event

