
show_tooltip = ->
  $(".tooltips").tooltip()

$(document).ready(show_tooltip)
$(document).on "page:load", show_tooltip

