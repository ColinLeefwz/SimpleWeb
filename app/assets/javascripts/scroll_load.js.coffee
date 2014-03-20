top = 0
hgth = 0
@load_more = ->
  # alert "top is #{top}, height is : #{hgth}"
  if(top > parseInt(hgth/3)*2)
    $.get("/welcome/load_more")
    top = 0
    hgth = 0


scroll_load = ->
  $(document).scroll( ->
    hgth = $("#content")[0].scrollHeight
    top = $(document).scrollTop()
  )

setInterval("load_more();", 2000)

$(document).ready ->
  scroll_load()

$(document).on 'page:load', ->
  scroll_load()
