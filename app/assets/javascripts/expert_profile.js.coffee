resize_tab = ->
  num_tabs = $(".tab").size()
  proper_width = 100 / num_tabs
  $(".tab").css("width", proper_width + "%")

$(document).ready ->
  resize_tab()
$(document).on 'page:load', resize_tab
