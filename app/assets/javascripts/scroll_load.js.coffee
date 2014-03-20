load_more = ->
  alert "will send request to ask load more"
  $.get("/welcome/load_more")


scroll_load = ->
  $(document).scroll( ->
    hght = $("#content")[0].scrollHeight
    top = $(document).scrollTop()

    if (top > parseInt(hght/3)*2)
      load_more()
  )

$(document).ready ->
  scroll_load()

$(document).on 'page:load', ->
  scroll_load()
