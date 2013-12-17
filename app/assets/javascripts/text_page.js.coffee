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

favorite_event = ->
  $(".favorite").on 'click', ->
    if detect_login()
      $("#mark-link").click()
    
  $("#mark-link").on "ajax:success", (e, data, status, xhr) ->
    if $(".solid-star").hasClass("hidden")
      $(".solid-star").removeClass("hidden")
      $(".hollow-star").addClass("hidden")
    else
      $(".solid-star").addClass("hidden")
      $(".hollow-star").removeClass("hidden")
    e.preventDefault

$(document).ready ->
  favorite_event()

$(document).on 'page:load', ->
  favorite_event()

$(document).on 'ajax:success', ->
  favorite_event()

