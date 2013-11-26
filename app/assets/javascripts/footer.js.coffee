footer = ->
  $("#footer-select").on "change", ->
    document.location.href = $(this).val()

$(document).ready(footer)
$(document).on 'page:load', footer
