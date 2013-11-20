
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

  $(".follow-link").on "ajax:success", (e) ->
    text = $("#follow i")
    text.html( if text.html() is "Follow" then "Unfollow" else "Follow")
    e.preventDefault

  $(".follow-link").on "ajax:error", (e) ->
    alert "failed"
    e.preventDefault





$(document).ready(profile_event)
$(document).on 'page:load', profile_event

