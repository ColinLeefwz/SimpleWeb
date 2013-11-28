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
  $(".text-page-favorite").on 'click', ->
    if detect_login()
      $("#mark-link").click()
    
  $("#mark-link").on "ajax:success", (e, data, status, xhr) ->
    if $(".text-page-favorite > i").hasClass("fa-star-o")
      $(".text-page-favorite > i").removeClass("fa-star-o").addClass("fa-star")
    else
      $(".text-page-favorite > i").removeClass("fa-star").addClass("fa-star-o")
    e.preventDefault

$(document).ready ->
  favorite_event()

$(document).on 'page:load', ->
  favorite_event()
