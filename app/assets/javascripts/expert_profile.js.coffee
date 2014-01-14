# get_cookie = (name) ->
#   parts = document.cookie.split(name + "=")
#   if parts.length == 2
#     return parts.pop().split(";").shift()
#
#
# detect_login = ->
#   signed_in = get_cookie("signed_in")
#   if signed_in == "1"
#     return true
#   else
#     alert "not logged in"
#     return false


profile_event = ->
  # $("#follow").on 'click', ->
  #   if detect_login()
  #     $(".follow-link").click()

  $("#follow").on "ajax:success", (e, data, status, xhr) ->
    button_text = $("#follow i")
    follower_num = +$("#follower-count").html()
    # $("#follower-count").html(if button_text.html() is "Follow" then follower_num + 1 else follower_num - 1 )
    # button_text.html( if button_text.html() is "Follow" then "Unfollow" else "Follow")
    $("#follower-count").html(if $("img > .hollow-star").length then follower_num - 1 else follower_num + 1 )
    e.preventDefault


resize_tab = ->
  num_tabs = $(".tab").size()
  proper_width = 100 / num_tabs
  $(".tab").css("width", proper_width + "%")

$(document).ready(resize_tab)
$(document).on 'page:load', resize_tab
$(document).ready(profile_event)
$(document).on 'page:load', profile_event
