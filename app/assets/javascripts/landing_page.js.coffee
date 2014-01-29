
show_tooltip = ->
  section_titles = $(".section-title")

  # todo: add page specific javascrip for course tooltips
  if section_titles.length > 0
    for title in section_titles
      if $(title).data("available") is false
        $(title).attr("title", "Please Subscribe or Sign in")

  $(".tooltips").tooltip()

$(document).ready(show_tooltip)
$(document).on "page:load", show_tooltip
$(document).on "ajax:success", show_tooltip

