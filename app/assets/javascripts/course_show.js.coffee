
set_progress = ->
  percentage = $(".percentage").find("span").first().text()
  width = $(".progress").width() * (percentage/100.00)

  $(".progress-bar").width(width)


settings = ->
  set_progress()


$(document).ready settings
$(document).on 'page:load', settings
