top = 0
height = 0.0
get_url = ""
@load_more = ->
  if $.cookie("no_more_load") is "false"
    if(top > parseInt(height/3)*2)
      $(".spinner").css({"display": "block"})
      $.get(get_url)
      top = 0
      height = 0
  else
    clearInterval(interval)

scroll_load = ->
  $(document).scroll( ->
    height = $("#content")[0].scrollHeight
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

interval = setInterval("load_more();", 5000)

$(document).ready ->
  scroll_load()
  set_get_url()
  create_spinner()




create_spinner = ->
  opts = 
    lines : 5,
    length : 0,
    width : 18,
    top: 'auto',
    left: 'auto'

  spinner = new Spinner(opts).spin().el
  # $("#content").append(spinner)
  $(spinner).insertBefore($("body footer"))

