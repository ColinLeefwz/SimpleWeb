
social_popup = ->
  $('a[data-popup]').on('click', (e)->
    ratio = if $(this).parent().hasClass("facebook") then "height=560, width=1080" else "height=600, width=600" # if use click on facebook share, open a larger pop-up
    window.open( $(this).attr('href'), "Popup", ratio)
    e.preventDefault()
  )

# count_shares = ->
#   $.getJSON("http://www.linkedin.com/countserv/count/share?url=www.google.com&callback=?", (li_count) ->
#     if $("#li-shares").length
#       $("#li-shares").html(li_count.count)
#   )
#
#   $.getJSON("http://graph.facebook.com/?id=http://www.google.com&callback=?", (fb_count) ->
#     # if $("#fb-shares").length
#     #   $("#fb-shares").html(fb_count.count)
#     alert fb_count.count
#   )
#
#   $.getJSON("http://urls.api.twitter.com/1/urls/count.json?url=www.google.com&callback=?", (tw_count) ->
#     if $("#tw-shares").length
#       $("#tw-shares").html(tw_count.count)
#   )


$(document).ready(social_popup)
$(document).on('page:load', social_popup)
$(document).on('ajax:success', social_popup)

