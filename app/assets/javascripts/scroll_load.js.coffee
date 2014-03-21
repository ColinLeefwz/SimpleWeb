top = 0
hgth = 0
@load_more = ->
  if $.cookie("no_more_load") is "false"
    if(top > parseInt(hgth/3)*2)
      $.get("/welcome/load_more")
      top = 0
      hgth = 0
  else
    clearInterval(interval)

scroll_load = ->
  $(document).scroll( ->
    hgth = $("#content")[0].scrollHeight
    top = $(document).scrollTop()
  )

interval = setInterval("load_more();", 2000)

$(document).ready ->
  scroll_load()

$(document).on 'page:load', ->
  scroll_load()
