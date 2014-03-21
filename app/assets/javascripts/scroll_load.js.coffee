top = 0
hgth = 0
get_url = ""
@load_more = ->
  if $.cookie("no_more_load") is "false"
    if(top > parseInt(hgth/3)*2)
      $.get(get_url)
      top = 0
      hgth = 0
  else
    clearInterval(interval)

scroll_load = ->
  $(document).scroll( ->
    hgth = $("#content")[0].scrollHeight
    top = $(document).scrollTop()
  )

set_get_url = ->
  current_url = document.URL
  profile_pattern = new RegExp("profile$")
  if current_url.match(profile_pattern)
    expert_id = $.cookie("expert_id")
    get_url = "/experts/#{expert_id}/load_more"
  else
    get_url = "/welcome/load_more"

interval = setInterval("load_more();", 1000)

$(document).ready ->
  scroll_load()
  set_get_url()

$(document).on 'page:load', ->
  scroll_load()
  set_get_url()
